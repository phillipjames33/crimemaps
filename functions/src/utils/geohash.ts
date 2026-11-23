/**
 * Pure TypeScript geospatial + idempotency helpers (no SDK imports).
 */
import { createHash } from 'crypto';

const BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';

/** Default precision for stored geohashes (~4.8m x 4.8m cell). */
export const DEFAULT_GEOHASH_PRECISION = 9;

/** Geohash prefix lengths used for `geo_{prefix}` FCM alert topics. */
export const GEO_TOPIC_PRECISIONS: readonly number[] = [4, 5, 6];

export const BOOKING_TTL_DAYS = 45;
const MS_PER_DAY = 24 * 60 * 60 * 1000;

export function isValidCoordinate(latitude: number, longitude: number): boolean {
  return (
    Number.isFinite(latitude) &&
    Number.isFinite(longitude) &&
    latitude >= -90 &&
    latitude <= 90 &&
    longitude >= -180 &&
    longitude <= 180
  );
}

/**
 * Encodes a WGS84 coordinate into a base32 geohash (compatible with
 * geoflutterfire_plus / the Flutter `GeohashUtil.encode`).
 */
export function encodeGeohash(
  latitude: number,
  longitude: number,
  precision: number = DEFAULT_GEOHASH_PRECISION,
): string {
  if (!isValidCoordinate(latitude, longitude)) {
    throw new RangeError(`Invalid coordinate (${latitude}, ${longitude})`);
  }
  if (!Number.isInteger(precision) || precision < 1 || precision > 12) {
    throw new RangeError(`Geohash precision must be an integer 1-12, got ${precision}`);
  }

  let minLat = -90;
  let maxLat = 90;
  let minLng = -180;
  let maxLng = 180;
  let isEven = true;
  let bit = 0;
  let ch = 0;
  let hash = '';

  while (hash.length < precision) {
    if (isEven) {
      const mid = (minLng + maxLng) / 2;
      if (longitude >= mid) {
        ch |= 1 << (4 - bit);
        minLng = mid;
      } else {
        maxLng = mid;
      }
    } else {
      const mid = (minLat + maxLat) / 2;
      if (latitude >= mid) {
        ch |= 1 << (4 - bit);
        minLat = mid;
      } else {
        maxLat = mid;
      }
    }
    isEven = !isEven;
    if (bit < 4) {
      bit += 1;
    } else {
      hash += BASE32.charAt(ch);
      bit = 0;
      ch = 0;
    }
  }
  return hash;
}

export interface GeohashBounds {
  minLat: number;
  maxLat: number;
  minLng: number;
  maxLng: number;
}

/** Decodes a geohash into its bounding box. */
export function decodeGeohashBounds(geohash: string): GeohashBounds {
  let minLat = -90;
  let maxLat = 90;
  let minLng = -180;
  let maxLng = 180;
  let isEven = true;

  for (const char of geohash.toLowerCase()) {
    const idx = BASE32.indexOf(char);
    if (idx < 0) {
      throw new RangeError(`Invalid geohash character "${char}"`);
    }
    for (let n = 4; n >= 0; n -= 1) {
      const bitN = (idx >> n) & 1;
      if (isEven) {
        const mid = (minLng + maxLng) / 2;
        if (bitN === 1) minLng = mid;
        else maxLng = mid;
      } else {
        const mid = (minLat + maxLat) / 2;
        if (bitN === 1) minLat = mid;
        else maxLat = mid;
      }
      isEven = !isEven;
    }
  }
  return { minLat, maxLat, minLng, maxLng };
}

/** Returns the `geo_{prefix}` topic prefixes for a full geohash. */
export function geohashTopicPrefixes(geohash: string): string[] {
  return GEO_TOPIC_PRECISIONS.filter((p) => geohash.length >= p).map((p) =>
    geohash.substring(0, p).toLowerCase(),
  );
}

/**
 * Mandatory alleged-offender TTL: `bookingDate + 45 days` (UTC, exact ms).
 */
export function computeBookingExpiry(bookingDate: Date): Date {
  const time = bookingDate.getTime();
  if (Number.isNaN(time)) {
    throw new RangeError('bookingDate is not a valid Date');
  }
  return new Date(time + BOOKING_TTL_DAYS * MS_PER_DAY);
}

/** True when a booking record is already past its 45-day retention window. */
export function isBookingExpired(bookingDate: Date, now: Date = new Date()): boolean {
  return computeBookingExpiry(bookingDate).getTime() <= now.getTime();
}

/** Lowercase, URL/topic-safe slug (e.g. "Los Angeles" → "los_angeles"). */
export function slugify(value: string): string {
  return value
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/^_+|_+$/g, '');
}

/**
 * Deterministic, idempotent Firestore document ID.
 * The same (namespace, parts) always yields the same ID, so scheduled
 * re-runs overwrite rather than duplicate records.
 */
export function deterministicId(namespace: string, ...parts: ReadonlyArray<string | number>): string {
  const ns = slugify(namespace) || 'doc';
  const normalized = parts.map((p) => String(p).trim().toLowerCase()).join('|');
  const digest = createHash('sha256').update(`${ns}|${normalized}`).digest('hex');
  return `${ns}_${digest.substring(0, 32)}`;
}
