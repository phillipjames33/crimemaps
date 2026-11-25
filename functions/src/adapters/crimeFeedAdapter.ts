/**
 * Pluggable crime feed adapters (Socrata, ArcGIS FeatureServer, SpotCrime)
 * plus a seeded Atlanta / Georgia / multi-state mock adapter.
 *
 * Credentials are NEVER hardcoded: they are injected from Firebase Secret
 * Manager (`defineSecret`) or environment variables at runtime.
 */
import { buildMockCrimeRecords } from '../data/mockSeed';
import { CrimeFeedProvider, RawCrimeRecord } from '../types';
import {
  asArray,
  asRecord,
  defaultFetcher,
  fetchJson,
  HttpFetcher,
  JsonRecord,
  readDate,
  readNumber,
  readString,
} from '../utils/json';

export interface CrimeFeedAdapter {
  /** Stable identifier for logging / deterministic ID namespacing. */
  readonly id: string;
  readonly provider: CrimeFeedProvider;
  fetchRecords(since: Date): Promise<RawCrimeRecord[]>;
}

/** Maps provider-specific field names onto the normalized record. */
export interface FeedFieldMap {
  id: string;
  title: string;
  occurredAt: string;
  latitude?: string;
  longitude?: string;
  address?: string;
  description?: string;
}

interface BaseFeedConfig {
  id: string;
  cityName: string;
  stateCode: string;
  sourceAgency: string;
  fieldMap: FeedFieldMap;
  limit?: number;
}

const DEFAULT_LIMIT = 1000;

function mapRecord(
  provider: CrimeFeedProvider,
  config: BaseFeedConfig,
  row: JsonRecord,
  coords?: { latitude: number | null; longitude: number | null },
): RawCrimeRecord | null {
  const f = config.fieldMap;
  const externalId = readString(row, f.id);
  const title = readString(row, f.title);
  const occurredAt = readDate(row, f.occurredAt);
  if (externalId === null || title === null || occurredAt === null) return null;
  return {
    provider,
    externalId,
    title,
    description: f.description !== undefined ? readString(row, f.description) ?? undefined : undefined,
    address: (f.address !== undefined ? readString(row, f.address) : null) ?? `${config.cityName}, ${config.stateCode}`,
    latitude: coords?.latitude ?? (f.latitude !== undefined ? readNumber(row, f.latitude) : null),
    longitude: coords?.longitude ?? (f.longitude !== undefined ? readNumber(row, f.longitude) : null),
    cityName: config.cityName,
    stateCode: config.stateCode,
    occurredAt,
    sourceAgency: config.sourceAgency,
    booking: null,
  };
}

// ───────────────────────────── Socrata (SODA) ─────────────────────────────

export interface SocrataFeedConfig extends BaseFeedConfig {
  domain: string;
  datasetId: string;
}

export class SocrataCrimeFeedAdapter implements CrimeFeedAdapter {
  readonly provider: CrimeFeedProvider = 'socrata';

  constructor(
    private readonly config: SocrataFeedConfig,
    private readonly appToken: string | undefined,
    private readonly fetcher: HttpFetcher = defaultFetcher,
  ) {}

  get id(): string {
    return this.config.id;
  }

  buildUrl(since: Date): string {
    const dateField = this.config.fieldMap.occurredAt;
    const sinceIso = since.toISOString().replace('Z', '');
    const params = new URLSearchParams({
      $where: `${dateField} > '${sinceIso}'`,
      $order: `${dateField} DESC`,
      $limit: String(this.config.limit ?? DEFAULT_LIMIT),
    });
    return `https://${this.config.domain}/resource/${this.config.datasetId}.json?${params.toString()}`;
  }

  async fetchRecords(since: Date): Promise<RawCrimeRecord[]> {
    const headers: Record<string, string> = { Accept: 'application/json' };
    if (this.appToken !== undefined && this.appToken.length > 0) headers['X-App-Token'] = this.appToken;
    const payload = await fetchJson(this.fetcher, this.buildUrl(since), headers);
    return asArray(payload)
      .map(asRecord)
      .filter((r): r is JsonRecord => r !== null)
      .map((row) => mapRecord('socrata', this.config, row))
      .filter((r): r is RawCrimeRecord => r !== null);
  }
}

// ───────────────────────── ArcGIS FeatureServer ─────────────────────────

export interface ArcGisFeedConfig extends BaseFeedConfig {
  /** Full layer URL, e.g. https://services.arcgis.com/.../FeatureServer/0 */
  layerUrl: string;
}

export class ArcGisCrimeFeedAdapter implements CrimeFeedAdapter {
  readonly provider: CrimeFeedProvider = 'arcgis';

  constructor(
    private readonly config: ArcGisFeedConfig,
    private readonly token: string | undefined,
    private readonly fetcher: HttpFetcher = defaultFetcher,
  ) {}

  get id(): string {
    return this.config.id;
  }

  buildUrl(since: Date): string {
    const ts = since.toISOString().substring(0, 19).replace('T', ' ');
    const params = new URLSearchParams({
      where: `${this.config.fieldMap.occurredAt} >= TIMESTAMP '${ts}'`,
      outFields: '*',
      outSR: '4326',
      f: 'json',
      resultRecordCount: String(this.config.limit ?? DEFAULT_LIMIT),
    });
    if (this.token !== undefined && this.token.length > 0) params.set('token', this.token);
    return `${this.config.layerUrl.replace(/\/+$/, '')}/query?${params.toString()}`;
  }

  async fetchRecords(since: Date): Promise<RawCrimeRecord[]> {
    const payload = asRecord(await fetchJson(this.fetcher, this.buildUrl(since)));
    if (payload === null) return [];
    const records: RawCrimeRecord[] = [];
    for (const feature of asArray(payload['features'])) {
      const feat = asRecord(feature);
      if (feat === null) continue;
      const attributes = asRecord(feat['attributes']);
      if (attributes === null) continue;
      const geometry = asRecord(feat['geometry']);
      const coords =
        geometry !== null
          ? { latitude: readNumber(geometry, 'y'), longitude: readNumber(geometry, 'x') }
          : undefined;
      const mapped = mapRecord('arcgis', this.config, attributes, coords);
      if (mapped !== null) records.push(mapped);
    }
    return records;
  }
}

// ───────────────────────────── SpotCrime ─────────────────────────────

export interface SpotCrimeFeedConfig {
  id: string;
  /** API endpoint (configurable; defaults to the public SpotCrime JSON API). */
  endpoint?: string;
  latitude: number;
  longitude: number;
  radiusMiles: number;
  cityName: string;
  stateCode: string;
}

const SPOTCRIME_DEFAULT_ENDPOINT = 'https://api.spotcrime.com/crimes.json';

/** Parses SpotCrime "MM/DD/YY hh:mm AM" timestamps (interpreted as UTC). */
export function parseSpotCrimeDate(value: string): Date | null {
  const m = /^(\d{1,2})\/(\d{1,2})\/(\d{2,4})\s+(\d{1,2}):(\d{2})\s*(AM|PM)?$/i.exec(value.trim());
  if (m === null) {
    const d = new Date(value);
    return Number.isNaN(d.getTime()) ? null : d;
  }
  const [, mo, da, yr, hh, mi, ap] = m;
  let year = Number(yr);
  if (year < 100) year += 2000;
  let hour = Number(hh) % 12;
  if (ap !== undefined && ap.toUpperCase() === 'PM') hour += 12;
  if (ap === undefined) hour = Number(hh);
  return new Date(Date.UTC(year, Number(mo) - 1, Number(da), hour, Number(mi)));
}

export class SpotCrimeFeedAdapter implements CrimeFeedAdapter {
  readonly provider: CrimeFeedProvider = 'spotcrime';

  constructor(
    private readonly config: SpotCrimeFeedConfig,
    private readonly apiKey: string,
    private readonly fetcher: HttpFetcher = defaultFetcher,
  ) {
    if (apiKey.trim().length === 0) {
      throw new Error('SpotCrime adapter requires SPOTCRIME_API_KEY from Secret Manager.');
    }
  }

  get id(): string {
    return this.config.id;
  }

  buildUrl(): string {
    const params = new URLSearchParams({
      lat: String(this.config.latitude),
      lon: String(this.config.longitude),
      radius: String(this.config.radiusMiles),
      key: this.apiKey,
    });
    return `${this.config.endpoint ?? SPOTCRIME_DEFAULT_ENDPOINT}?${params.toString()}`;
  }

  async fetchRecords(since: Date): Promise<RawCrimeRecord[]> {
    const payload = asRecord(await fetchJson(this.fetcher, this.buildUrl()));
    if (payload === null) return [];
    const out: RawCrimeRecord[] = [];
    for (const item of asArray(payload['crimes'])) {
      const row = asRecord(item);
      if (row === null) continue;
      const externalId = readString(row, 'cdid');
      const type = readString(row, 'type');
      const dateStr = readString(row, 'date');
      const occurredAt = dateStr === null ? null : parseSpotCrimeDate(dateStr);
      if (externalId === null || type === null || occurredAt === null) continue;
      if (occurredAt.getTime() < since.getTime()) continue;
      out.push({
        provider: 'spotcrime',
        externalId,
        title: type,
        description: readString(row, 'description') ?? type,
        address: readString(row, 'address') ?? `${this.config.cityName}, ${this.config.stateCode}`,
        latitude: readNumber(row, 'lat'),
        longitude: readNumber(row, 'lon'),
        cityName: this.config.cityName,
        stateCode: this.config.stateCode,
        occurredAt,
        sourceAgency: 'SpotCrime aggregated public report',
        streetViewUrl: null,
        booking: null,
      });
    }
    return out;
  }
}

// ───────────────────── INTERPOL U.S. Red Notices (Public API) ─────────────────────

export interface InterpolFeedConfig {
  id: string;
  /** Maximum number of U.S. arrest-warrant notices with photos to inspect. */
  limit?: number;
}

interface UsMetroAnchor {
  citySlug: string;
  cityName: string;
  stateCode: string;
  latitude: number;
  longitude: number;
  pattern: RegExp;
}

const US_METRO_ANCHORS: readonly UsMetroAnchor[] = [
  {
    citySlug: 'atlanta',
    cityName: 'Atlanta',
    stateCode: 'GA',
    latitude: 33.7605,
    longitude: -84.3885,
    pattern: /\b(atlanta|decatur|georgia|fort benning|savannah)\b/i,
  },
  {
    citySlug: 'chicago',
    cityName: 'Chicago',
    stateCode: 'IL',
    latitude: 41.8835,
    longitude: -87.6320,
    pattern: /\b(chicago|illinois)\b/i,
  },
  {
    citySlug: 'houston',
    cityName: 'Houston',
    stateCode: 'TX',
    latitude: 29.7589,
    longitude: -95.3677,
    pattern: /\b(houston)\b/i,
  },
  {
    citySlug: 'dallas',
    cityName: 'Dallas',
    stateCode: 'TX',
    latitude: 32.7767,
    longitude: -96.7970,
    pattern: /\b(dallas|fort worth|el paso|del rio|texas)\b/i,
  },
  {
    citySlug: 'los_angeles',
    cityName: 'Los Angeles',
    stateCode: 'CA',
    latitude: 34.0522,
    longitude: -118.2437,
    pattern: /\b(los angeles|pasadena|hollywood|compton|long beach)\b/i,
  },
  {
    citySlug: 'san_francisco',
    cityName: 'San Francisco',
    stateCode: 'CA',
    latitude: 37.7749,
    longitude: -122.4194,
    pattern: /\b(san francisco|oakland|sacramento|california)\b/i,
  },
  {
    citySlug: 'new_york',
    cityName: 'New York',
    stateCode: 'NY',
    latitude: 40.7128,
    longitude: -74.0060,
    pattern: /\b(new york|brooklyn|bronx|queens|manhattan|rochester)\b/i,
  },
];

function resolveUsMetroAnchor(placeOfBirth: string): UsMetroAnchor | null {
  for (const anchor of US_METRO_ANCHORS) {
    if (anchor.pattern.test(placeOfBirth)) return anchor;
  }
  return null;
}

function deterministicCoordOffset(seed: string): { dLat: number; dLng: number } {
  let hash = 0;
  for (let i = 0; i < seed.length; i++) {
    hash = (hash * 31 + seed.charCodeAt(i)) | 0;
  }
  const normA = ((hash & 0xff) / 255 - 0.5) * 0.028;
  const normB = (((hash >> 8) & 0xff) / 255 - 0.5) * 0.028;
  return { dLat: normA, dLng: normB };
}

function parseWarrantCharges(detail: JsonRecord): string[] {
  const warrants = asArray(detail['arrest_warrants'])
    .map(asRecord)
    .filter((w): w is JsonRecord => w !== null);
  const charges: string[] = [];
  for (const w of warrants) {
    const raw = readString(w, 'charge');
    if (raw === null) continue;
    const parts = raw
      .split(/\r?\n|(?=\d+\)\s+)/)
      .map((s) => s.replace(/^\d+\)\s*/, '').trim())
      .filter((s) => s.length > 0);
    for (const p of parts) {
      if (charges.length < 5) charges.push(p);
    }
  }
  return charges.length > 0 ? charges : ['U.S. Arrest Warrant Notice (Alleged)'];
}

/**
 * Fetches official public U.S. Arrest Warrant Red Notices from the open
 * INTERPOL REST API (`ws-public.interpol.int`) including CORS-enabled public
 * photographs (`Access-Control-Allow-Origin: *`).
 */
export class InterpolRedNoticeAdapter implements CrimeFeedAdapter {
  readonly provider: CrimeFeedProvider = 'interpol';
  private static readonly BASE_URL =
    'https://ws-public.interpol.int/notices/v1/red?arrestWarrantCountryId=US&nationality=US&resultPerPage=80';
  private static readonly HEADERS: Record<string, string> = {
    Accept: 'application/json',
    'User-Agent': 'CrimeMapsCivicSafety/1.0',
  };

  constructor(
    private readonly config: InterpolFeedConfig,
    private readonly fetcher: HttpFetcher = defaultFetcher,
    private readonly clock: () => Date = () => new Date(),
  ) {}

  get id(): string {
    return this.config.id;
  }

  async fetchRecords(_since: Date): Promise<RawCrimeRecord[]> {
    const payload = asRecord(
      await fetchJson(this.fetcher, InterpolRedNoticeAdapter.BASE_URL, InterpolRedNoticeAdapter.HEADERS),
    );
    if (payload === null) return [];
    const embedded = asRecord(payload['_embedded']);
    const notices = asArray(embedded?.['notices'])
      .map(asRecord)
      .filter((n): n is JsonRecord => n !== null);

    const maxToInspect = Math.min(this.config.limit ?? 60, notices.length);
    const candidates = notices.slice(0, maxToInspect);
    const now = this.clock();
    // Mark historical warrant occurrence >24h ago so onHighSeverityIncident does not spam push alerts.
    const occurredAt = new Date(now.getTime() - 48 * 60 * 60 * 1000);

    const records: RawCrimeRecord[] = [];
    const BATCH_SIZE = 6;
    for (let i = 0; i < candidates.length; i += BATCH_SIZE) {
      const slice = candidates.slice(i, i + BATCH_SIZE);
      const batchResults = await Promise.all(
        slice.map(async (notice): Promise<RawCrimeRecord | null> => {
          const entityId = readString(notice, 'entity_id');
          const links = asRecord(notice['_links']);
          const thumbHref = readString(asRecord(links?.['thumbnail']) ?? {}, 'href');
          const selfHref = readString(asRecord(links?.['self']) ?? {}, 'href');
          if (entityId === null || thumbHref === null || selfHref === null) return null;

          let detail: JsonRecord = notice;
          try {
            const det = asRecord(
              await fetchJson(this.fetcher, selfHref, InterpolRedNoticeAdapter.HEADERS),
            );
            if (det !== null) detail = det;
          } catch {
            // Fall back to list summary if detail request fails.
          }

          const pob = readString(detail, 'place_of_birth') ?? '';
          const anchor = resolveUsMetroAnchor(pob);
          if (anchor === null) return null;

          const forename = readString(detail, 'forename') ?? '';
          const surname = readString(detail, 'name') ?? '';
          const fullName = `${forename} ${surname}`.trim();
          if (fullName.length === 0) return null;

          const charges = parseWarrantCharges(detail);
          const primaryCharge = charges[0].slice(0, 72);
          const { dLat, dLng } = deterministicCoordOffset(entityId);

          return {
            provider: 'interpol',
            externalId: entityId.replace(/[^a-zA-Z0-9_-]/g, '_'),
            title: `U.S. Warrant Notice: ${primaryCharge}`,
            description: charges.join(' • '),
            address: `Public Warrant Record • ${pob}`,
            placeName: `${anchor.cityName} Metro • Public Warrant Notice`,
            placeType: 'public_warrant',
            latitude: anchor.latitude + dLat,
            longitude: anchor.longitude + dLng,
            cityName: anchor.cityName,
            citySlug: anchor.citySlug,
            stateCode: anchor.stateCode,
            occurredAt,
            sourceAgency: 'INTERPOL / U.S. Arrest Warrant Notice (interpol.int)',
            booking: {
              name: fullName,
              bookingPhotoUrl: thumbHref,
              charges,
              bookingDate: now,
              sourceAgency: 'INTERPOL / U.S. Arrest Warrant Notice (interpol.int)',
            },
          };
        }),
      );
      for (const rec of batchResults) {
        if (rec !== null) records.push(rec);
      }
    }

    return records;
  }
}

// ───────────────────────────── Mock (seeded) ─────────────────────────────

export class MockCrimeFeedAdapter implements CrimeFeedAdapter {
  readonly id = 'mock_atlanta_ga_us';
  readonly provider: CrimeFeedProvider = 'mock';

  constructor(private readonly clock: () => Date = () => new Date()) {}

  async fetchRecords(since: Date): Promise<RawCrimeRecord[]> {
    return buildMockCrimeRecords(this.clock()).filter((r) => r.occurredAt.getTime() >= since.getTime());
  }
}

// ───────────────────────────── Factory ─────────────────────────────

export type CrimeFeedSourceConfig =
  | ({ type: 'socrata' } & SocrataFeedConfig)
  | ({ type: 'arcgis' } & ArcGisFeedConfig)
  | ({ type: 'spotcrime' } & SpotCrimeFeedConfig)
  | ({ type: 'interpol' } & InterpolFeedConfig);

export interface CrimeFeedSecrets {
  spotCrimeApiKey?: string;
  socrataAppToken?: string;
  arcgisToken?: string;
}

export interface CrimeFeedFactoryOptions {
  useMockData: boolean;
  /** JSON array of `CrimeFeedSourceConfig` (env `CRIME_FEED_SOURCES`). */
  sourcesJson?: string;
  secrets: CrimeFeedSecrets;
  fetcher?: HttpFetcher;
  clock?: () => Date;
}

function isSourceConfig(value: unknown): value is CrimeFeedSourceConfig {
  const r = asRecord(value);
  if (r === null) return false;
  const type = r['type'];
  return (
    (type === 'socrata' || type === 'arcgis' || type === 'spotcrime' || type === 'interpol') &&
    typeof r['id'] === 'string'
  );
}

export function parseFeedSources(json: string | undefined): CrimeFeedSourceConfig[] {
  if (json === undefined || json.trim().length === 0) return [];
  let parsed: unknown;
  try {
    parsed = JSON.parse(json);
  } catch {
    throw new Error('CRIME_FEED_SOURCES is not valid JSON.');
  }
  return asArray(parsed).filter(isSourceConfig);
}

/**
 * Builds the active adapter set. Falls back to the seeded mock adapter when
 * mock mode is on or no live feeds/credentials are configured.
 */
export function createCrimeFeedAdapters(options: CrimeFeedFactoryOptions): CrimeFeedAdapter[] {
  const fetcher = options.fetcher ?? defaultFetcher;
  if (options.useMockData) return [new MockCrimeFeedAdapter(options.clock)];

  const adapters: CrimeFeedAdapter[] = [];
  for (const source of parseFeedSources(options.sourcesJson)) {
    switch (source.type) {
      case 'socrata':
        adapters.push(new SocrataCrimeFeedAdapter(source, options.secrets.socrataAppToken, fetcher));
        break;
      case 'arcgis':
        adapters.push(new ArcGisCrimeFeedAdapter(source, options.secrets.arcgisToken, fetcher));
        break;
      case 'spotcrime': {
        const key = options.secrets.spotCrimeApiKey;
        if (key !== undefined && key.trim().length > 0) {
          adapters.push(new SpotCrimeFeedAdapter(source, key, fetcher));
        }
        break;
      }
      case 'interpol':
        adapters.push(new InterpolRedNoticeAdapter(source, fetcher, options.clock));
        break;
    }
  }
  return adapters.length > 0 ? adapters : [new MockCrimeFeedAdapter(options.clock)];
}
