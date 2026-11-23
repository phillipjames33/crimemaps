/**
 * Standalone CLI seeder for Crime Maps Firestore (production or local Emulator).
 *
 * Usage:
 *   npm run seed:emulator            # targets localhost:8080 emulator
 *   npm run seed -- --project=id     # targets configured Firebase project
 */
import { getApp, getApps, initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { MockCameraFeedAdapter } from '../adapters/cameraFeedAdapter';
import { MockCrimeFeedAdapter } from '../adapters/crimeFeedAdapter';
import { buildSeedTerritories, buildSeedTracks } from '../data/mockSeed';
import { runIngestCrimeFeeds } from '../handlers/ingestCrimeFeeds';
import { runSyncPublicCameras } from '../handlers/syncPublicCameras';

export interface SeedSummary {
  incidentsWritten: number;
  camerasWritten: number;
  camerasRejected: number;
  territoriesWritten: number;
  tracksWritten: number;
}

export async function seedAllCollections(
  db: FirebaseFirestore.Firestore,
  now: Date = new Date(),
): Promise<SeedSummary> {
  const since = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

  const incidentResult = await runIngestCrimeFeeds({
    db,
    adapters: [new MockCrimeFeedAdapter(() => now)],
    since,
    now,
  });

  const cameraResult = await runSyncPublicCameras({
    db,
    adapters: [new MockCameraFeedAdapter()],
    now,
  });

  const territories = buildSeedTerritories(now);
  const territoryBatch = db.batch();
  for (const territory of territories) {
    territoryBatch.set(db.collection('territories').doc(territory.id), territory, {
      merge: true,
    });
  }
  await territoryBatch.commit();

  const tracks = buildSeedTracks(now);
  const trackBatch = db.batch();
  for (const track of tracks) {
    trackBatch.set(db.collection('tracks').doc(track.id), track, { merge: true });
  }
  await trackBatch.commit();

  return {
    incidentsWritten: incidentResult.written,
    camerasWritten: cameraResult.written,
    camerasRejected: cameraResult.rejectedPrivateOrUnsupported,
    territoriesWritten: territories.length,
    tracksWritten: tracks.length,
  };
}

function parseProjectId(argv: readonly string[]): string {
  const arg = argv.find((a) => a.startsWith('--project='));
  if (arg !== undefined) return arg.split('=')[1] ?? 'crime-maps-dev';
  return process.env['GCLOUD_PROJECT'] ?? process.env['GOOGLE_CLOUD_PROJECT'] ?? 'crime-maps-dev';
}

async function main(): Promise<void> {
  const argv = process.argv.slice(2);
  if (argv.includes('--emulator') && process.env['FIRESTORE_EMULATOR_HOST'] === undefined) {
    process.env['FIRESTORE_EMULATOR_HOST'] = '127.0.0.1:8080';
  }

  const projectId = parseProjectId(argv);
  const app = getApps().length === 0 ? initializeApp({ projectId }) : getApp();
  const db = getFirestore(app);

  const summary = await seedAllCollections(db);
  console.log('Crime Maps Firestore seed complete:', summary);
}

if (require.main === module) {
  main().catch((err) => {
    console.error('Seed failed:', err);
    process.exitCode = 1;
  });
}
