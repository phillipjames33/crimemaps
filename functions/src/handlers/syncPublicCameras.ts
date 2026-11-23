/**
 * Scheduled civic infrastructure camera sync (`syncPublicCameras`).
 *
 * Normalizes OpenStreetMap / DeFlock ALPR, traffic, and red-light cameras
 * while strictly rejecting private residential cameras (anti-doxxing).
 */
import { GeoPoint } from 'firebase-admin/firestore';
import { CameraFeedAdapter, normalizeCameraRecord } from '../adapters/cameraFeedAdapter';
import { PublicCamera } from '../types';
import { LoggerLike } from './ingestCrimeFeeds';

export interface NormalizedCameraDoc extends Omit<PublicCamera, 'geo'> {
  geo: PublicCamera['geo'] & { geopoint: GeoPoint };
}

export interface SyncPublicCamerasDeps {
  db: FirebaseFirestore.Firestore;
  adapters: readonly CameraFeedAdapter[];
  now?: Date;
  logger?: LoggerLike;
}

export interface SyncPublicCamerasResult {
  fetched: number;
  written: number;
  rejectedPrivateOrUnsupported: number;
  failedAdapters: string[];
}

const FIRESTORE_BATCH_LIMIT = 400;

export async function runSyncPublicCameras(
  deps: SyncPublicCamerasDeps,
): Promise<SyncPublicCamerasResult> {
  const now = deps.now ?? new Date();
  const log = deps.logger ?? console;

  const settled = await Promise.allSettled(
    deps.adapters.map(async (adapter) => ({
      adapterId: adapter.id,
      records: await adapter.fetchCameras(),
    })),
  );

  const byId = new Map<string, NormalizedCameraDoc>();
  const failedAdapters: string[] = [];
  let fetched = 0;
  let rejectedPrivateOrUnsupported = 0;

  settled.forEach((result, index) => {
    const adapter = deps.adapters[index];
    if (result.status === 'rejected') {
      failedAdapters.push(adapter.id);
      log.error('Camera feed adapter failed', {
        adapterId: adapter.id,
        error: result.reason instanceof Error ? result.reason.message : String(result.reason),
      });
      return;
    }

    for (const raw of result.value.records) {
      fetched += 1;
      const normalized = normalizeCameraRecord(raw, now);
      if (!normalized.accepted) {
        rejectedPrivateOrUnsupported += 1;
        log.warn('Rejected non-civic or private residential camera', {
          externalId: raw.externalId,
          reason: normalized.reason,
        });
        continue;
      }

      const cam = normalized.camera;
      byId.set(cam.id, {
        ...cam,
        geo: {
          ...cam.geo,
          geopoint: new GeoPoint(cam.latitude, cam.longitude),
        },
      });
    }
  });

  const docs = Array.from(byId.values());
  for (let i = 0; i < docs.length; i += FIRESTORE_BATCH_LIMIT) {
    const chunk = docs.slice(i, i + FIRESTORE_BATCH_LIMIT);
    const batch = deps.db.batch();
    for (const cam of chunk) {
      const ref = deps.db.collection('cameras').doc(cam.id);
      batch.set(ref, cam, { merge: true });
    }
    await batch.commit();
  }

  log.info('syncPublicCameras completed', {
    fetched,
    written: docs.length,
    rejectedPrivateOrUnsupported,
    failedAdapters,
  });

  return {
    fetched,
    written: docs.length,
    rejectedPrivateOrUnsupported,
    failedAdapters,
  };
}
