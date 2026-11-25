/**
 * Crime Maps — Firebase Cloud Functions v2 Entrypoint.
 *
 * Exports:
 *  - ingestCrimeFeeds       (onSchedule)
 *  - syncPublicCameras      (onSchedule)
 *  - onHighSeverityIncident (onDocumentCreated)
 *  - onTrackUploaded        (onObjectFinalized)
 *  - submitMugshotRemoval   (onCall — 100% free)
 */
import { getApp, getApps, initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { getStorage } from 'firebase-admin/storage';
import * as logger from 'firebase-functions/logger';
import { defineBoolean, defineSecret, defineString } from 'firebase-functions/params';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { onObjectFinalized } from 'firebase-functions/v2/storage';
import { createCameraFeedAdapters } from './adapters/cameraFeedAdapter';
import { createCrimeFeedAdapters } from './adapters/crimeFeedAdapter';
import { buildSeedTerritories, buildSeedTracks } from './data/mockSeed';
import { runIngestCrimeFeeds } from './handlers/ingestCrimeFeeds';
import { runHighSeverityIncident } from './handlers/onHighSeverityIncident';
import { runOnTrackUploaded, StorageQuarantineOps } from './handlers/onTrackUploaded';
import { runSubmitMugshotRemoval } from './handlers/submitMugshotRemoval';
import { runSyncPublicCameras } from './handlers/syncPublicCameras';

function ensureAdminApp() {
  return getApps().length === 0 ? initializeApp() : getApp();
}

// ───────────── Runtime Params & Secret Manager Bindings ─────────────
const useMockDataParam = defineBoolean('USE_MOCK_DATA', { default: true });
const crimeFeedSourcesParam = defineString('CRIME_FEED_SOURCES', { default: '' });
const cameraFeedSourcesParam = defineString('CAMERA_FEED_SOURCES', { default: '' });

const spotCrimeApiKeySecret = defineSecret('SPOTCRIME_API_KEY');
const socrataAppTokenSecret = defineSecret('SOCRATA_APP_TOKEN');
const arcgisTokenSecret = defineSecret('ARCGIS_TOKEN');
const deflockApiKeySecret = defineSecret('DEFLOCK_API_KEY');

function isUsableSecret(val: unknown): val is string {
  if (typeof val !== 'string') return false;
  const trimmed = val.trim();
  return trimmed.length > 0 && !trimmed.toLowerCase().startsWith('placeholder');
}

function readSecretOrEnv(
  secret: ReturnType<typeof defineSecret>,
  envKey: string,
): string | undefined {
  try {
    const val = secret.value();
    if (isUsableSecret(val)) return val.trim();
  } catch {
    // Fallback to process.env in local emulator / test environments.
  }
  const envVal = process.env[envKey];
  return isUsableSecret(envVal) ? envVal.trim() : undefined;
}

const gcsQuarantineOps: StorageQuarantineOps = {
  async moveToQuarantine(bucketName: string, sourceName: string, destName: string): Promise<void> {
    const bucket = getStorage(ensureAdminApp()).bucket(bucketName);
    const sourceFile = bucket.file(sourceName);
    await sourceFile.copy(bucket.file(destName));
    await sourceFile.delete();
  },
};

// ───────────── 1. Scheduled Crime Feed Ingestion ─────────────
export const ingestCrimeFeeds = onSchedule(
  {
    schedule: 'every 15 minutes',
    region: 'us-central1',
    timeoutSeconds: 300,
    memory: '512MiB',
    secrets: [spotCrimeApiKeySecret, socrataAppTokenSecret, arcgisTokenSecret],
  },
  async () => {
    const app = ensureAdminApp();
    const db = getFirestore(app);
    const now = new Date();
    // 14-day lookback captures municipal Socrata/ArcGIS portals with 3-10 day reporting lags;
    // deterministic IDs guarantee zero duplicates across overlapping runs.
    const since = new Date(now.getTime() - 14 * 24 * 60 * 60 * 1000);

    const adapters = createCrimeFeedAdapters({
      useMockData: useMockDataParam.value(),
      sourcesJson: crimeFeedSourcesParam.value(),
      secrets: {
        spotCrimeApiKey: readSecretOrEnv(spotCrimeApiKeySecret, 'SPOTCRIME_API_KEY'),
        socrataAppToken: readSecretOrEnv(socrataAppTokenSecret, 'SOCRATA_APP_TOKEN'),
        arcgisToken: readSecretOrEnv(arcgisTokenSecret, 'ARCGIS_TOKEN'),
      },
      clock: () => now,
    });

    await runIngestCrimeFeeds({ db, adapters, since, now, logger });

    // Idempotent first-run bootstrap: ensure historical territories and baseline
    // royalty-free indie tracks exist in Firestore if those collections are empty.
    const [terrSnap, trackSnap] = await Promise.all([
      db.collection('territories').limit(1).get(),
      db.collection('tracks').limit(1).get(),
    ]);
    if (terrSnap.empty) {
      const batch = db.batch();
      for (const territory of buildSeedTerritories(now)) {
        batch.set(db.collection('territories').doc(territory.id), territory, { merge: true });
      }
      await batch.commit();
      logger.info('Bootstrapped baseline historical territories collection.');
    }
    if (trackSnap.empty) {
      const batch = db.batch();
      for (const track of buildSeedTracks(now)) {
        batch.set(db.collection('tracks').doc(track.id), track, { merge: true });
      }
      await batch.commit();
      logger.info('Bootstrapped baseline royalty-free indie tracks collection.');
    }
  },
);

// ───────────── 2. Scheduled Public Civic Camera Sync ─────────────
export const syncPublicCameras = onSchedule(
  {
    schedule: 'every 6 hours',
    region: 'us-central1',
    timeoutSeconds: 300,
    memory: '512MiB',
    secrets: [deflockApiKeySecret],
  },
  async () => {
    const app = ensureAdminApp();
    const db = getFirestore(app);
    const now = new Date();

    const adapters = createCameraFeedAdapters({
      useMockData: useMockDataParam.value(),
      sourcesJson: cameraFeedSourcesParam.value(),
      deflockApiKey: readSecretOrEnv(deflockApiKeySecret, 'DEFLOCK_API_KEY'),
    });

    await runSyncPublicCameras({ db, adapters, now, logger, interAdapterDelayMs: 2500 });
  },
);

// ───────────── 3. High-Severity Incident FCM Alerts ─────────────
export const onHighSeverityIncident = onDocumentCreated(
  {
    document: 'incidents/{incidentId}',
    region: 'us-central1',
  },
  async (event) => {
    const app = ensureAdminApp();
    const messaging = getMessaging(app);
    const incidentId = event.params.incidentId;
    const data = event.data?.data() as Record<string, unknown> | undefined;

    await runHighSeverityIncident({ incidentId, data, messaging, logger });
  },
);

// ───────────── 4. Indie Track Storage Validation ─────────────
export const onTrackUploaded = onObjectFinalized(
  {
    region: 'us-east1',
    memory: '256MiB',
  },
  async (event) => {
    const app = ensureAdminApp();
    const db = getFirestore(app);
    const data = event.data;

    await runOnTrackUploaded({
      object: {
        bucket: data.bucket,
        name: data.name,
        contentType: data.contentType,
        size: Number(data.size ?? 0),
        metadata: data.metadata,
      },
      db,
      storageOps: gcsQuarantineOps,
      now: new Date(),
      logger,
    });
  },
);

// ───────────── 5. Free Mugshot / Record Removal ─────────────
export const submitMugshotRemoval = onCall(
  {
    region: 'us-central1',
    cors: true,
  },
  async (request) => {
    const app = ensureAdminApp();
    const db = getFirestore(app);
    return runSubmitMugshotRemoval({
      db,
      data: request.data,
      requesterUid: request.auth?.uid ?? null,
      now: new Date(),
      logger,
    });
  },
);
