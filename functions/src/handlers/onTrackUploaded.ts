/**
 * Cloud Storage trigger handler (`onTrackUploaded`).
 *
 * Enforces 100% indie music ownership metadata + MIME/size checks on
 * `tracks/{artistId}/{trackId}/{fileName}` uploads, activating valid tracks
 * and quarantining + rejecting non-compliant uploads.
 */
import { UploadedObjectInfo } from '../types';
import {
  isAllowedAudioMime,
  isAllowedImageMime,
  MAX_UPLOAD_BYTES,
  RIGHTS_ATTESTATION_VERSION,
  validateRightsMetadata,
  validateRightsWarranty,
} from '../utils/compliance';
import { asRecord } from '../utils/json';
import { LoggerLike } from './ingestCrimeFeeds';

export interface ParsedTrackPath {
  artistId: string;
  trackId: string;
  fileName: string;
}

const TRACK_PATH_REGEX = /^tracks\/([^/]+)\/([^/]+)\/([^/]+)$/;

export function parseTrackObjectPath(objectName: string): ParsedTrackPath | null {
  const match = TRACK_PATH_REGEX.exec(objectName);
  if (match === null) return null;
  const [, artistId, trackId, fileName] = match;
  return { artistId, trackId, fileName };
}

export function buildPublicMediaUrl(
  bucket: string,
  objectName: string,
  metadata?: Readonly<Record<string, string>>,
): string {
  const encodedPath = encodeURIComponent(objectName);
  const token = metadata?.['firebaseStorageDownloadTokens']?.split(',')[0]?.trim();
  const base = `https://firebasestorage.googleapis.com/v0/b/${bucket}/o/${encodedPath}?alt=media`;
  return token !== undefined && token.length > 0 ? `${base}&token=${encodeURIComponent(token)}` : base;
}

export interface StorageQuarantineOps {
  moveToQuarantine(bucket: string, sourceName: string, destName: string): Promise<void>;
}

export interface OnTrackUploadedDeps {
  object: UploadedObjectInfo;
  db: FirebaseFirestore.Firestore;
  storageOps: StorageQuarantineOps;
  now?: Date;
  logger?: LoggerLike;
}

export type OnTrackUploadedResult =
  | { action: 'ignored'; reason: string }
  | { action: 'cover_updated'; trackId: string; artistId: string; coverArtUrl: string }
  | { action: 'activated'; trackId: string; artistId: string; audioUrl: string }
  | { action: 'rejected'; trackId: string; artistId: string; reasons: string[]; quarantinedPath: string };

async function quarantineFile(
  ops: StorageQuarantineOps,
  bucket: string,
  sourceName: string,
  parsed: ParsedTrackPath,
  logger: LoggerLike,
): Promise<string> {
  const quarantinePath = `quarantine/${parsed.artistId}/${parsed.trackId}/${parsed.fileName}`;
  try {
    await ops.moveToQuarantine(bucket, sourceName, quarantinePath);
  } catch (err) {
    logger.warn('Failed to move rejected upload to quarantine', {
      sourceName,
      quarantinePath,
      error: err instanceof Error ? err.message : String(err),
    });
  }
  return quarantinePath;
}

export async function runOnTrackUploaded(
  deps: OnTrackUploadedDeps,
): Promise<OnTrackUploadedResult> {
  const now = deps.now ?? new Date();
  const log = deps.logger ?? console;
  const { object, db, storageOps } = deps;

  const parsed = parseTrackObjectPath(object.name);
  if (parsed === null) {
    return { action: 'ignored', reason: 'unrelated_path' };
  }

  const { artistId, trackId } = parsed;
  const trackRef = db.collection('tracks').doc(trackId);

  // Cover art uploads only update coverArtUrl when valid.
  if (isAllowedImageMime(object.contentType)) {
    if (object.size <= 0 || object.size > MAX_UPLOAD_BYTES) {
      const quarantinedPath = await quarantineFile(storageOps, object.bucket, object.name, parsed, log);
      return {
        action: 'rejected',
        trackId,
        artistId,
        reasons: [`Cover image exceeds ${MAX_UPLOAD_BYTES} byte limit or is empty.`],
        quarantinedPath,
      };
    }
    const coverArtUrl = buildPublicMediaUrl(object.bucket, object.name, object.metadata);
    await trackRef.set({ coverArtUrl, updatedAt: now }, { merge: true });
    return { action: 'cover_updated', trackId, artistId, coverArtUrl };
  }

  // Audio upload validation
  const reasons: string[] = [];

  if (!isAllowedAudioMime(object.contentType)) {
    reasons.push(`Unsupported audio MIME type "${String(object.contentType)}".`);
  }
  if (!Number.isFinite(object.size) || object.size <= 0 || object.size > MAX_UPLOAD_BYTES) {
    reasons.push(`Audio file size (${object.size} bytes) must be between 1 and ${MAX_UPLOAD_BYTES} bytes.`);
  }

  const metaCheck = validateRightsMetadata(object.metadata);
  if (!metaCheck.valid) {
    reasons.push(...metaCheck.reasons);
  }

  const existingSnap = await trackRef.get();
  const existingData = existingSnap.exists ? asRecord(existingSnap.data()) : null;

  if (existingData !== null) {
    const docArtistId = existingData['artistId'];
    if (typeof docArtistId === 'string' && docArtistId !== artistId) {
      reasons.push('Track document artistId does not match upload path artistId.');
    }
    const docWarranty = asRecord(existingData['rightsWarranty']);
    if (docWarranty !== null) {
      const warrantyCheck = validateRightsWarranty(docWarranty, now);
      if (!warrantyCheck.valid) {
        reasons.push(...warrantyCheck.reasons);
      }
    }
  }

  if (reasons.length > 0) {
    const quarantinedPath = await quarantineFile(storageOps, object.bucket, object.name, parsed, log);
    const rejectionReason = reasons.join(' ');
    await trackRef.set(
      {
        status: 'rejected',
        rejectionReason,
        rejectedAt: now,
      },
      { merge: true },
    );
    log.warn('Rejected track upload', { trackId, artistId, reasons });
    return { action: 'rejected', trackId, artistId, reasons, quarantinedPath };
  }

  const audioUrl = buildPublicMediaUrl(object.bucket, object.name, object.metadata);
  const updatePayload: Record<string, unknown> = {
    artistId,
    status: 'active',
    audioUrl,
    audioMimeType: object.contentType,
    audioSizeBytes: object.size,
    verifiedAt: now,
  };

  if (existingData === null || existingData['rightsWarranty'] === undefined) {
    const signedName = object.metadata?.['signedName']?.trim() ?? '';
    const signedAtRaw = object.metadata?.['signedAt'];
    const signedAtParsed = signedAtRaw !== undefined ? new Date(signedAtRaw) : now;
    const signedAt = Number.isNaN(signedAtParsed.getTime()) ? now : signedAtParsed;
    updatePayload['rightsWarranty'] = {
      owns100Percent: true,
      signedName,
      signedAt,
      version: object.metadata?.['attestationVersion'] ?? RIGHTS_ATTESTATION_VERSION,
    };
  }

  await trackRef.set(updatePayload, { merge: true });
  log.info('Activated indie track upload', { trackId, artistId, audioUrl });

  return { action: 'activated', trackId, artistId, audioUrl };
}
