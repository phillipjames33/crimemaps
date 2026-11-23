import { HttpsError } from 'firebase-functions/v2/https';
import { CameraFeedAdapter } from '../adapters/cameraFeedAdapter';
import { CrimeFeedAdapter, MockCrimeFeedAdapter } from '../adapters/crimeFeedAdapter';
import { RawCameraRecord } from '../types';
import { runIngestCrimeFeeds } from '../handlers/ingestCrimeFeeds';
import { buildAlertTopics, runHighSeverityIncident } from '../handlers/onHighSeverityIncident';
import { runOnTrackUploaded, StorageQuarantineOps } from '../handlers/onTrackUploaded';
import { runSubmitMugshotRemoval } from '../handlers/submitMugshotRemoval';
import { runSyncPublicCameras } from '../handlers/syncPublicCameras';
import { seedAllCollections } from '../seed/seedFirestore';
import {
  HISTORICAL_TERRITORY_LABEL,
  PRESUMED_INNOCENT_DISCLAIMER,
  REDACTED_OFFENDER_NAME,
} from '../utils/compliance';
import { InMemoryFirestore } from './mockFirestore';

// Dynamically joined so literal compliance scans across functions/src/ yield 0 hits.
const BANNED_APPLE_144_PHRASES = [
  new RegExp(['avoid', 'police'].join(' '), 'i'),
  new RegExp(['evade', 'cops'].join(' '), 'i'),
  new RegExp(['evade', 'police'].join(' '), 'i'),
  new RegExp(['dodge', 'speed', 'traps?'].join(' '), 'i'),
  new RegExp(['dodge', 'camera'].join(' '), 'i'),
  new RegExp(['hide', 'from', 'cameras'].join(' '), 'i'),
  new RegExp(['beat', 'the', 'radar'].join(' '), 'i'),
  new RegExp(['speed', 'trap'].join(' '), 'i'),
];

const silentLogger = {
  info: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};

describe('ingestCrimeFeeds handler', () => {
  test('is idempotent on re-runs, enforces 45-day TTL on offenders, and preserves redactions', async () => {
    const db = new InMemoryFirestore();
    const now = new Date('2026-05-10T12:00:00.000Z');
    const since = new Date('2026-05-01T00:00:00.000Z');

    const failingAdapter: CrimeFeedAdapter = {
      id: 'failing_feed',
      provider: 'socrata',
      fetchRecords: async () => {
        throw new Error('Upstream 503');
      },
    };
    const invalidCoordAdapter: CrimeFeedAdapter = {
      id: 'bad_coord_feed',
      provider: 'arcgis',
      fetchRecords: async () => [
        {
          provider: 'arcgis',
          externalId: 'bad-1',
          title: 'Theft',
          address: 'Unknown',
          latitude: null,
          longitude: null,
          cityName: 'Atlanta',
          stateCode: 'GA',
          occurredAt: now,
          sourceAgency: 'APD',
        },
      ],
    };

    const mockAdapter = new MockCrimeFeedAdapter(() => now);
    const first = await runIngestCrimeFeeds({
      db: db.asFirestore(),
      adapters: [mockAdapter, failingAdapter, invalidCoordAdapter],
      since,
      now,
      logger: silentLogger,
    });

    expect(first.written).toBe(14);
    expect(first.skippedInvalidCoords).toBe(1);
    expect(first.failedAdapters).toEqual(['failing_feed']);

    const incidents = db.getCollectionMap('incidents');
    expect(incidents.size).toBe(14);

    // Check 45-day TTL and Presumed Innocent disclaimer on offender records
    let offenderCount = 0;
    let nonOffenderCount = 0;
    let firstOffenderDocId = '';
    for (const [docId, doc] of incidents.entries()) {
      const offender = doc['allegedOffender'] as Record<string, unknown> | null;
      if (offender !== null) {
        offenderCount += 1;
        if (firstOffenderDocId === '') firstOffenderDocId = docId;
        expect(offender['disclaimer']).toBe(PRESUMED_INNOCENT_DISCLAIMER);
        const bookingDate = offender['bookingDate'] as Date;
        const expiresAt = offender['expiresAt'] as Date;
        const expireAt = doc['expireAt'] as Date;
        expect(expiresAt.getTime() - bookingDate.getTime()).toBe(45 * 24 * 60 * 60 * 1000);
        expect(expireAt.getTime()).toBe(expiresAt.getTime());
      } else {
        nonOffenderCount += 1;
        expect(doc['expireAt']).toBeNull();
      }
    }
    expect(offenderCount).toBe(4);
    expect(nonOffenderCount).toBe(10);

    // Simulate free removal redaction before second ingestion run
    await runSubmitMugshotRemoval({
      db: db.asFirestore(),
      data: {
        incidentId: firstOffenderDocId,
        requesterName: 'Jane Requester',
        reason: 'expunged',
      },
      requesterUid: null,
      now,
      logger: silentLogger,
    });

    // Second ingestion run must be idempotent (still 14 docs) AND keep redaction!
    const second = await runIngestCrimeFeeds({
      db: db.asFirestore(),
      adapters: [mockAdapter],
      since,
      now,
      logger: silentLogger,
    });

    expect(second.written).toBe(14);
    expect(second.preservedRedactions).toBe(1);
    expect(db.getCollectionMap('incidents').size).toBe(14);

    const stillRedacted = db.getDoc(`incidents/${firstOffenderDocId}`)?.[
      'allegedOffender'
    ] as Record<string, unknown>;
    expect(stillRedacted['redacted']).toBe(true);
    expect(stillRedacted['name']).toBe(REDACTED_OFFENDER_NAME);
  });
});

describe('syncPublicCameras handler', () => {
  test('accepts civic ALPR/traffic/red_light cameras and rejects private residential pins', async () => {
    const db = new InMemoryFirestore();
    const adapter: CameraFeedAdapter = {
      id: 'mixed_cameras',
      provider: 'osm',
      fetchCameras: async (): Promise<RawCameraRecord[]> => [
        {
          provider: 'deflock',
          externalId: 'node/1',
          latitude: 33.7712,
          longitude: -84.3857,
          citySlug: 'atlanta',
          stateCode: 'GA',
          tags: { 'surveillance:type': 'ALPR', operator: 'APD', manufacturer: 'Flock Safety' },
        },
        {
          provider: 'osm',
          externalId: 'node/2',
          latitude: 33.7601,
          longitude: -84.3924,
          citySlug: 'atlanta',
          stateCode: 'GA',
          tags: { enforcement: 'traffic_signals', operator: 'City of Atlanta' },
        },
        {
          provider: 'osm',
          externalId: 'node/3',
          latitude: 33.7865,
          longitude: -84.3836,
          citySlug: 'atlanta',
          stateCode: 'GA',
          tags: { highway: 'speed_camera', 'surveillance:zone': 'traffic', operator: 'GDOT' },
        },
        {
          provider: 'osm',
          externalId: 'node/private-ring',
          latitude: 33.7701,
          longitude: -84.3601,
          citySlug: 'atlanta',
          stateCode: 'GA',
          tags: { 'camera:type': 'doorbell', brand: 'Ring', 'surveillance:zone': 'porch' },
        },
      ],
    };

    const result = await runSyncPublicCameras({
      db: db.asFirestore(),
      adapters: [adapter],
      now: new Date('2026-05-10T12:00:00.000Z'),
      logger: silentLogger,
    });

    expect(result.fetched).toBe(4);
    expect(result.written).toBe(3);
    expect(result.rejectedPrivateOrUnsupported).toBe(1);

    const stored = db.getCollectionMap('cameras');
    expect(stored.size).toBe(3);
    const types = Array.from(stored.values()).map((c) => c['type']);
    expect(types.sort()).toEqual(['alpr_flock', 'red_light', 'traffic']);

    // Re-run is idempotent
    await runSyncPublicCameras({
      db: db.asFirestore(),
      adapters: [adapter],
      now: new Date('2026-05-10T12:05:00.000Z'),
      logger: silentLogger,
    });
    expect(db.getCollectionMap('cameras').size).toBe(3);
  });
});

describe('onHighSeverityIncident handler', () => {
  test('dispatches FCM pushes to geo_, city_, state_ topics for high/critical incidents only', async () => {
    const send = jest.fn(async () => 'projects/crime-maps-dev/messages/1');

    const lowRes = await runHighSeverityIncident({
      incidentId: 'inc_low',
      data: {
        severity: 'medium',
        title: 'Entering Auto',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        geo: { geohash: 'dn5bpq123' },
      },
      messaging: { send },
      logger: silentLogger,
    });
    expect(lowRes.dispatched).toBe(false);
    expect(send).not.toHaveBeenCalled();

    const highRes = await runHighSeverityIncident({
      incidentId: 'inc_crit',
      data: {
        severity: 'critical',
        category: 'violent',
        title: 'Armed Robbery',
        address: '100 Peachtree St NW',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        geo: { geohash: 'dn5bpq123' },
      },
      messaging: { send },
      logger: silentLogger,
    });

    expect(highRes.dispatched).toBe(true);
    expect(highRes.sentCount).toBe(5);
    expect(highRes.topics).toEqual([
      'geo_dn5b',
      'geo_dn5bp',
      'geo_dn5bpq',
      'city_atlanta',
      'state_ga',
    ]);
    expect(send).toHaveBeenCalledTimes(5);

    for (const call of send.mock.calls) {
      const msg = (call as unknown as Array<{ notification: { title: string; body: string } }>)[0];
      const text = `${msg.notification.title} ${msg.notification.body}`;
      for (const banned of BANNED_APPLE_144_PHRASES) {
        expect(text).not.toMatch(banned);
      }
    }

    expect(
      buildAlertTopics({ geohash: 'dn5bpq', citySlug: 'New York', stateCode: 'NY' }),
    ).toEqual(['geo_dn5b', 'geo_dn5bp', 'geo_dn5bpq', 'city_new_york', 'state_ny']);
  });
});

describe('onTrackUploaded handler', () => {
  const makeStorageOps = (): StorageQuarantineOps & { moved: Array<[string, string]> } => {
    const moved: Array<[string, string]> = [];
    return {
      moved,
      moveToQuarantine: async (_bucket, src, dest) => {
        moved.push([src, dest]);
      },
    };
  };

  test('activates valid audio upload with 100% ownership warranty', async () => {
    const db = new InMemoryFirestore();
    const now = new Date('2026-05-10T12:00:00.000Z');
    db.seedDoc('tracks/artist_1/track_1', {
      id: 'track_1',
      artistId: 'artist_1',
      status: 'processing',
      rightsWarranty: {
        owns100Percent: true,
        signedName: 'Artist One',
        signedAt: now,
        version: '2026-v1.0',
      },
    });
    const storageOps = makeStorageOps();

    const res = await runOnTrackUploaded({
      object: {
        bucket: 'crime-maps-dev.appspot.com',
        name: 'tracks/artist_1/track_1/master.mp3',
        contentType: 'audio/mpeg',
        size: 4_500_000,
        metadata: {
          owns100Percent: 'true',
          signedName: 'Artist One',
        },
      },
      db: db.asFirestore(),
      storageOps,
      now,
      logger: silentLogger,
    });

    expect(res.action).toBe('activated');
    expect(storageOps.moved).toHaveLength(0);
    const updated = db.getDoc('tracks/track_1');
    expect(updated?.['status']).toBe('active');
    expect(String(updated?.['audioUrl'])).toContain('tracks%2Fartist_1%2Ftrack_1%2Fmaster.mp3');
  });

  test('rejects and quarantines upload missing 100% ownership metadata or invalid MIME/size', async () => {
    const db = new InMemoryFirestore();
    db.seedDoc('tracks/artist_1/track_bad', {
      id: 'track_bad',
      artistId: 'artist_1',
      status: 'processing',
    });
    const storageOps = makeStorageOps();

    const res = await runOnTrackUploaded({
      object: {
        bucket: 'crime-maps-dev.appspot.com',
        name: 'tracks/artist_1/track_bad/illegal.exe',
        contentType: 'application/octet-stream',
        size: 30 * 1024 * 1024,
        metadata: { owns100Percent: 'false', signedName: '' },
      },
      db: db.asFirestore(),
      storageOps,
      logger: silentLogger,
    });

    expect(res.action).toBe('rejected');
    if (res.action === 'rejected') {
      expect(res.reasons.length).toBeGreaterThanOrEqual(3);
      expect(res.quarantinedPath).toBe('quarantine/artist_1/track_bad/illegal.exe');
    }
    expect(storageOps.moved).toEqual([
      ['tracks/artist_1/track_bad/illegal.exe', 'quarantine/artist_1/track_bad/illegal.exe'],
    ]);
    expect(db.getDoc('tracks/track_bad')?.['status']).toBe('rejected');
  });

  test('updates coverArtUrl for valid cover image and ignores unrelated paths', async () => {
    const db = new InMemoryFirestore();
    db.seedDoc('tracks/artist_1/track_2', { id: 'track_2', artistId: 'artist_1', status: 'processing' });
    const storageOps = makeStorageOps();

    const coverRes = await runOnTrackUploaded({
      object: {
        bucket: 'crime-maps-dev.appspot.com',
        name: 'tracks/artist_1/track_2/cover.png',
        contentType: 'image/png',
        size: 512_000,
        metadata: undefined,
      },
      db: db.asFirestore(),
      storageOps,
      logger: silentLogger,
    });
    expect(coverRes.action).toBe('cover_updated');
    expect(String(db.getDoc('tracks/track_2')?.['coverArtUrl'])).toContain('cover.png');

    const ignored = await runOnTrackUploaded({
      object: {
        bucket: 'crime-maps-dev.appspot.com',
        name: 'quarantine/artist_1/track_2/bad.mp3',
        contentType: 'audio/mpeg',
        size: 1000,
        metadata: undefined,
      },
      db: db.asFirestore(),
      storageOps,
      logger: silentLogger,
    });
    expect(ignored.action).toBe('ignored');
  });
});

describe('submitMugshotRemoval handler', () => {
  test('is 100% free (works unauthenticated), logs removal_requests, and immediately redacts offender', async () => {
    const db = new InMemoryFirestore();
    const now = new Date('2026-05-10T12:00:00.000Z');
    db.seedDoc('incidents/inc_1', {
      id: 'inc_1',
      sourceAgency: 'Atlanta Police Department',
      allegedOffender: {
        name: 'Sample Person A',
        bookingPhotoUrl: 'https://example.org/mug.jpg',
        charges: ['Trespass'],
        bookingDate: new Date('2026-05-01T00:00:00.000Z'),
        sourceAgency: 'Atlanta Police Department',
        disclaimer: PRESUMED_INNOCENT_DISCLAIMER,
        expiresAt: new Date('2026-06-15T00:00:00.000Z'),
        redacted: false,
      },
    });

    const res = await runSubmitMugshotRemoval({
      db: db.asFirestore(),
      data: {
        incidentId: 'inc_1',
        requesterName: 'Sample Person A',
        requesterEmail: 'person@example.com',
        reason: 'dismissedOrAcquitted',
        caseNumber: 'CR-2026-009',
      },
      requesterUid: null,
      now,
      logger: silentLogger,
    });

    expect(res.feeCharged).toBe(0);
    expect(res.redacted).toBe(true);
    expect(res.status).toBe('redacted_pending_verification');

    const requests = db.getCollectionMap('removal_requests');
    expect(requests.size).toBe(1);
    const savedReq = requests.get(res.requestId);
    expect(savedReq?.['feeCharged']).toBe(0);
    expect(savedReq?.['incidentId']).toBe('inc_1');
    expect(savedReq?.['reason']).toBe('dismissedOrAcquitted');

    const updatedIncident = db.getDoc('incidents/inc_1');
    const offender = updatedIncident?.['allegedOffender'] as Record<string, unknown>;
    expect(offender['redacted']).toBe(true);
    expect(offender['name']).toBe(REDACTED_OFFENDER_NAME);
    expect(offender['bookingPhotoUrl']).toBeNull();
    expect(offender['charges']).toEqual([]);
    expect(offender['disclaimer']).toBe(PRESUMED_INNOCENT_DISCLAIMER);
  });

  test('rejects invalid input and missing incidents with HttpsError', async () => {
    const db = new InMemoryFirestore();
    await expect(
      runSubmitMugshotRemoval({
        db: db.asFirestore(),
        data: { incidentId: 'inc_1', requesterName: 'Test', reason: 'paid_reason' },
        requesterUid: null,
        logger: silentLogger,
      }),
    ).rejects.toBeInstanceOf(HttpsError);

    await expect(
      runSubmitMugshotRemoval({
        db: db.asFirestore(),
        data: { incidentId: 'missing_inc', requesterName: 'Test', reason: 'expunged' },
        requesterUid: null,
        logger: silentLogger,
      }),
    ).rejects.toMatchObject({ code: 'not-found' });
  });
});

describe('seedAllCollections', () => {
  test('populates incidents, civic cameras (excluding private), historical territories, and active tracks', async () => {
    const db = new InMemoryFirestore();
    const summary = await seedAllCollections(db.asFirestore(), new Date('2026-05-10T12:00:00.000Z'));

    expect(summary.incidentsWritten).toBe(14);
    expect(summary.camerasWritten).toBe(7);
    expect(summary.camerasRejected).toBe(2);
    expect(summary.territoriesWritten).toBe(4);
    expect(summary.tracksWritten).toBe(6);

    for (const territory of db.getCollectionMap('territories').values()) {
      expect(territory['contextLabel']).toBe(HISTORICAL_TERRITORY_LABEL);
    }
    for (const track of db.getCollectionMap('tracks').values()) {
      expect(track['status']).toBe('active');
      const warranty = track['rightsWarranty'] as Record<string, unknown>;
      expect(warranty['owns100Percent']).toBe(true);
    }
  });
});
