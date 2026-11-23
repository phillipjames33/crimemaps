/**
 * Mandatory legal & App Store compliance guardrails for the backend.
 *
 * - Alleged offender protection (Presumed Innocent disclaimer + 45-day TTL)
 * - Anti-doxxing: private residential cameras are never exact-pinned
 * - 100% indie music rights warranty validation
 */
import {
  AllegedOffender,
  PublicCameraType,
  RawBookingRecord,
  RightsWarranty,
  ValidationResult,
} from '../types';
import { computeBookingExpiry } from './geohash';

// ───────────────────────────── Constants ─────────────────────────────

/** Required disclaimer on every alleged offender / booking record. */
export const PRESUMED_INNOCENT_DISCLAIMER =
  'Alleged / Public Arrest Record \u2014 All individuals are presumed innocent until proven guilty.';

/** Mandatory label for historical territory overlays. */
export const HISTORICAL_TERRITORY_LABEL = 'Historical / Publicly Documented Neighborhood Context';

/** Record removal / expungement is always free. */
export const REMOVAL_REQUEST_FEE = 0 as const;

export const REDACTED_OFFENDER_NAME = 'Redacted \u2014 Removal Request Pending Verification';

/** Only public civic infrastructure may be pinned at an exact location. */
export const PUBLIC_CAMERA_TYPES: readonly PublicCameraType[] = ['alpr_flock', 'traffic', 'red_light'];

export const MAX_UPLOAD_BYTES = 25 * 1024 * 1024;

export const ALLOWED_AUDIO_MIME_TYPES: readonly string[] = [
  'audio/mpeg',
  'audio/wav',
  'audio/x-wav',
  'audio/mp4',
];

export const ALLOWED_IMAGE_MIME_TYPES: readonly string[] = ['image/jpeg', 'image/png', 'image/webp'];

export const RIGHTS_ATTESTATION_VERSION = '2026-v1.0';

// ───────────────────── Alleged offender protection ─────────────────────

/**
 * Converts a raw booking record into a compliant `AllegedOffender`:
 * attaches the Presumed Innocent disclaimer and the 45-day expiry.
 */
export function buildCompliantOffender(booking: RawBookingRecord): AllegedOffender {
  return {
    name: booking.name.trim(),
    bookingPhotoUrl: booking.bookingPhotoUrl ?? null,
    charges: booking.charges.map((c) => c.trim()).filter((c) => c.length > 0),
    bookingDate: booking.bookingDate,
    sourceAgency: booking.sourceAgency,
    disclaimer: PRESUMED_INNOCENT_DISCLAIMER,
    expiresAt: computeBookingExpiry(booking.bookingDate),
    redacted: false,
    redactionRequestId: null,
    redactedAt: null,
  };
}

/**
 * Returns a redacted copy of an offender record. Personally identifying
 * fields (name, photo, charges) are removed; the disclaimer and TTL remain.
 */
export function redactOffender(
  offender: AllegedOffender,
  requestId: string,
  redactedAt: Date,
): AllegedOffender {
  return {
    ...offender,
    name: REDACTED_OFFENDER_NAME,
    bookingPhotoUrl: null,
    charges: [],
    disclaimer: PRESUMED_INNOCENT_DISCLAIMER,
    redacted: true,
    redactionRequestId: requestId,
    redactedAt,
  };
}

// ─────────────────────────── Anti-doxxing ───────────────────────────

export function isPublicCameraType(value: unknown): value is PublicCameraType {
  return typeof value === 'string' && (PUBLIC_CAMERA_TYPES as readonly string[]).includes(value);
}

const RESIDENTIAL_ZONES = new Set([
  'home',
  'house',
  'residential',
  'residence',
  'apartment',
  'apartments',
  'porch',
  'driveway',
  'garden',
  'yard',
  'private',
]);
const RESIDENTIAL_BUILDINGS = new Set([
  'house',
  'residential',
  'detached',
  'semidetached_house',
  'terrace',
  'apartments',
  'bungalow',
  'cabin',
]);
const DOORBELL_BRANDS = /\b(ring|nest|arlo|eufy|wyze|simplisafe|blink)\b/i;
const PRIVATE_OPERATOR_TYPES = new Set(['private', 'individual', 'private_individual', 'resident']);

/**
 * Heuristic detector for private residential cameras (doorbells, home
 * security cameras). Such cameras must NEVER be exact-pinned; they are only
 * allowed in anonymized neighborhood density aggregates.
 */
export function isPrivateResidentialCamera(tags: Readonly<Record<string, string>>): boolean {
  const lower = (key: string): string => (tags[key] ?? '').toLowerCase().trim();

  const cameraType = lower('camera:type');
  const survType = lower('surveillance:type');
  if (cameraType === 'doorbell' || survType === 'doorbell') return true;
  if (lower('surveillance') === 'indoor') return true;
  if (RESIDENTIAL_ZONES.has(lower('surveillance:zone'))) return true;
  if (RESIDENTIAL_BUILDINGS.has(lower('building'))) return true;
  if (lower('private_residence') === 'yes' || lower('residential') === 'yes') return true;

  const brandText = `${lower('brand')} ${lower('manufacturer')} ${lower('camera:mount')}`;
  if (DOORBELL_BRANDS.test(brandText) && survType !== 'alpr') return true;

  const operatorType = lower('operator:type');
  if (PRIVATE_OPERATOR_TYPES.has(operatorType) && lower('surveillance') !== 'public') return true;

  return false;
}

export interface CameraPinCandidate {
  type: unknown;
  isPrivateResidence?: boolean | null;
  tags?: Readonly<Record<string, string>>;
  latitude: number;
  longitude: number;
}

/** Validates that a camera may be published as an exact public pin. */
export function validatePublicCameraPin(candidate: CameraPinCandidate): ValidationResult {
  const reasons: string[] = [];
  if (!isPublicCameraType(candidate.type)) {
    reasons.push(
      `Camera type "${String(candidate.type)}" is not public infrastructure (allowed: ${PUBLIC_CAMERA_TYPES.join(', ')}).`,
    );
  }
  if (candidate.isPrivateResidence === true) {
    reasons.push('Private residential cameras cannot be pinned at an exact location (anti-doxxing).');
  }
  if (candidate.tags !== undefined && isPrivateResidentialCamera(candidate.tags)) {
    reasons.push('Camera tags indicate a private residence (anti-doxxing).');
  }
  if (
    !Number.isFinite(candidate.latitude) ||
    !Number.isFinite(candidate.longitude) ||
    Math.abs(candidate.latitude) > 90 ||
    Math.abs(candidate.longitude) > 180
  ) {
    reasons.push('Camera coordinates are invalid.');
  }
  return { valid: reasons.length === 0, reasons };
}

// ─────────────────────── 100% indie rights warranty ───────────────────────

const MAX_SIGNATURE_CLOCK_SKEW_MS = 10 * 60 * 1000;

function parseSignedAt(value: unknown): Date | null {
  if (value instanceof Date) return Number.isNaN(value.getTime()) ? null : value;
  if (typeof value === 'string' && value.trim().length > 0) {
    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }
  // Firestore Timestamp-like objects expose toDate().
  if (typeof value === 'object' && value !== null && 'toDate' in value) {
    const maybe = (value as { toDate: unknown }).toDate;
    if (typeof maybe === 'function') {
      const d: unknown = maybe.call(value);
      if (d instanceof Date && !Number.isNaN(d.getTime())) return d;
    }
  }
  return null;
}

/** Validates a Firestore `rightsWarranty` map (mirrors firestore.rules). */
export function validateRightsWarranty(
  warranty: Partial<Record<keyof RightsWarranty, unknown>> | null | undefined,
  now: Date = new Date(),
): ValidationResult {
  const reasons: string[] = [];
  if (warranty === null || warranty === undefined) {
    return { valid: false, reasons: ['Rights warranty is missing.'] };
  }
  if (warranty.owns100Percent !== true) {
    reasons.push('Artist must warrant 100% ownership of master and publishing rights.');
  }
  if (typeof warranty.signedName !== 'string' || warranty.signedName.trim().length === 0) {
    reasons.push('A typed legal signature (signedName) is required.');
  }
  const signedAt = parseSignedAt(warranty.signedAt);
  if (signedAt === null) {
    reasons.push('Signature timestamp (signedAt) is required.');
  } else if (signedAt.getTime() - now.getTime() > MAX_SIGNATURE_CLOCK_SKEW_MS) {
    reasons.push('Signature timestamp (signedAt) cannot be in the future.');
  }
  return { valid: reasons.length === 0, reasons };
}

/** Validates Storage customMetadata on audio uploads (mirrors storage.rules). */
export function validateRightsMetadata(
  metadata: Readonly<Record<string, string>> | undefined,
): ValidationResult {
  const reasons: string[] = [];
  if (metadata === undefined) {
    return { valid: false, reasons: ['Upload is missing rights warranty metadata.'] };
  }
  if (metadata['owns100Percent'] !== 'true') {
    reasons.push('customMetadata.owns100Percent must be "true".');
  }
  const signedName = metadata['signedName'];
  if (typeof signedName !== 'string' || signedName.trim().length === 0) {
    reasons.push('customMetadata.signedName must be a non-empty signature.');
  }
  return { valid: reasons.length === 0, reasons };
}

export function isAllowedAudioMime(contentType: string | undefined): boolean {
  return contentType !== undefined && ALLOWED_AUDIO_MIME_TYPES.includes(contentType.toLowerCase());
}

export function isAllowedImageMime(contentType: string | undefined): boolean {
  return contentType !== undefined && ALLOWED_IMAGE_MIME_TYPES.includes(contentType.toLowerCase());
}
