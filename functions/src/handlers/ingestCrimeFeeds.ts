/**
 * Scheduled crime feed ingestion logic (`ingestCrimeFeeds`).
 */
import { GeoPoint } from 'firebase-admin/firestore';
import { CrimeFeedAdapter } from '../adapters/crimeFeedAdapter';
import {
  Incident,
  IncidentCategory,
  IncidentSeverity,
  RawCrimeRecord,
} from '../types';
import { buildCompliantOffender } from '../utils/compliance';
import { computeBookingExpiry, deterministicId, encodeGeohash, isValidCoordinate, slugify } from '../utils/geohash';

export interface LoggerLike {
  info(message: string, meta?: Record<string, unknown>): void;
  warn(message: string, meta?: Record<string, unknown>): void;
  error(message: string, meta?: Record<string, unknown>): void;
}

export function classifyIncidentCategory(title: string, description?: string): IncidentCategory {
  const text = `${title} ${description ?? ''}`.toLowerCase();
  if (/(homicide|murder|shooting|assault|robbery|battery|kidnap|arson|weapon|stabbing|rape|carjack)/.test(text)) {
    return 'violent';
  }
  if (/(dui|dwi|traffic|hit and run|reckless driving|speeding|suspended license)/.test(text)) {
    return 'trafficDui';
  }
  if (/(burglary|theft|larceny|shoplifting|entering auto|vandalism|trespass|fraud|stolen)/.test(text)) {
    return 'property';
  }
  return 'other';
}

export function classifyIncidentSeverity(
  title: string,
  category: IncidentCategory,
  description?: string,
): IncidentSeverity {
  const text = `${title} ${description ?? ''}`.toLowerCase();
  if (/(homicide|murder|shooting|fatal|kidnap|armed robbery|deadly weapon)/.test(text)) {
    return 'critical';
  }
  if (category === 'violent' || /(aggravated|arson|carjack|felony|burglary)/.test(text)) {
    return 'high';
  }
  if (category === 'property' || category === 'trafficDui') {
    return 'medium';
  }
  return 'low';
}

export interface NormalizedIncidentDoc extends Omit<Incident, 'geo'> {
  geo: Incident['geo'] & { geopoint: GeoPoint };
}

/**
 * Normalizes a raw crime record into a compliance-enforced Incident document.
 * Returns `null` if coordinates are missing or invalid.
 */
export function normalizeCrimeRecord(
  raw: RawCrimeRecord,
  now: Date = new Date(),
): NormalizedIncidentDoc | null {
  if (
    raw.latitude === null ||
    raw.longitude === null ||
    !isValidCoordinate(raw.latitude, raw.longitude)
  ) {
    return null;
  }

  const category = raw.category ?? classifyIncidentCategory(raw.title, raw.description);
  const severity = raw.severity ?? classifyIncidentSeverity(raw.title, category, raw.description);
  const geohash = encodeGeohash(raw.latitude, raw.longitude);
  const citySlug = slugify(raw.citySlug ?? raw.cityName);
  const stateCode = raw.stateCode.trim().toUpperCase();
  const id = deterministicId('inc', raw.provider, raw.externalId);

  const allegedOffender =
    raw.booking !== undefined && raw.booking !== null
      ? buildCompliantOffender(raw.booking)
      : null;

  const expireAt =
    raw.booking !== undefined && raw.booking !== null
      ? computeBookingExpiry(raw.booking.bookingDate)
      : null;

  return {
    id,
    title: raw.title.trim(),
    category,
    severity,
    address: raw.address.trim(),
    placeName: (raw.placeName ?? raw.address).trim(),
    placeType: (raw.placeType ?? 'street').trim(),
    geo: {
      latitude: raw.latitude,
      longitude: raw.longitude,
      geohash,
      geopoint: new GeoPoint(raw.latitude, raw.longitude),
    },
    citySlug,
    cityName: raw.cityName.trim(),
    stateCode,
    occurredAt: raw.occurredAt,
    streetViewUrl: raw.streetViewUrl ?? null,
    sourceAgency: raw.sourceAgency.trim(),
    allegedOffender,
    expireAt,
    source: {
      provider: raw.provider,
      externalId: raw.externalId,
    },
    ingestedAt: now,
  };
}

export interface IngestCrimeFeedsDeps {
  db: FirebaseFirestore.Firestore;
  adapters: readonly CrimeFeedAdapter[];
  since: Date;
  now?: Date;
  logger?: LoggerLike;
}

export interface IngestCrimeFeedsResult {
  fetched: number;
  written: number;
  skippedInvalidCoords: number;
  preservedRedactions: number;
  failedAdapters: string[];
}

const FIRESTORE_BATCH_LIMIT = 400;

export async function runIngestCrimeFeeds(
  deps: IngestCrimeFeedsDeps,
): Promise<IngestCrimeFeedsResult> {
  const now = deps.now ?? new Date();
  const log = deps.logger ?? console;

  const settled = await Promise.allSettled(
    deps.adapters.map(async (adapter) => ({
      adapterId: adapter.id,
      records: await adapter.fetchRecords(deps.since),
    })),
  );

  const byId = new Map<string, NormalizedIncidentDoc>();
  const failedAdapters: string[] = [];
  let fetched = 0;
  let skippedInvalidCoords = 0;

  settled.forEach((result, index) => {
    const adapter = deps.adapters[index];
    if (result.status === 'rejected') {
      failedAdapters.push(adapter.id);
      log.error('Crime feed adapter failed', {
        adapterId: adapter.id,
        error: result.reason instanceof Error ? result.reason.message : String(result.reason),
      });
      return;
    }

    for (const raw of result.value.records) {
      fetched += 1;
      const normalized = normalizeCrimeRecord(raw, now);
      if (normalized === null) {
        skippedInvalidCoords += 1;
        continue;
      }
      byId.set(normalized.id, normalized);
    }
  });

  const docs = Array.from(byId.values());
  let preservedRedactions = 0;

  for (let i = 0; i < docs.length; i += FIRESTORE_BATCH_LIMIT) {
    const chunk = docs.slice(i, i + FIRESTORE_BATCH_LIMIT);
    const refs = chunk.map((doc) => deps.db.collection('incidents').doc(doc.id));

    // Never undo an active mugshot/record redaction when re-ingesting feeds.
    const existingSnaps = refs.length > 0 ? await deps.db.getAll(...refs) : [];
    const existingById = new Map<string, FirebaseFirestore.DocumentData>();
    for (const snap of existingSnaps) {
      if (snap.exists) {
        const data = snap.data();
        if (data !== undefined) existingById.set(snap.id, data);
      }
    }

    const batch = deps.db.batch();
    for (let idx = 0; idx < chunk.length; idx += 1) {
      const incident = chunk[idx];
      const existing = existingById.get(incident.id);
      const existingOffender = existing?.['allegedOffender'] as
        | { redacted?: boolean }
        | null
        | undefined;

      if (existingOffender?.redacted === true) {
        preservedRedactions += 1;
        const { allegedOffender: _omit, ...withoutOffender } = incident;
        batch.set(refs[idx], withoutOffender, { merge: true });
      } else {
        batch.set(refs[idx], incident, { merge: true });
      }
    }
    await batch.commit();
  }

  log.info('ingestCrimeFeeds completed', {
    fetched,
    written: docs.length,
    skippedInvalidCoords,
    preservedRedactions,
    failedAdapters,
  });

  return {
    fetched,
    written: docs.length,
    skippedInvalidCoords,
    preservedRedactions,
    failedAdapters,
  };
}
