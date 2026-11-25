/**
 * Pluggable OpenStreetMap (Overpass) & DeFlock ALPR camera feed adapters
 * plus a seeded mock adapter.
 *
 * Anti-doxxing: every record is normalized through `normalizeCameraRecord`,
 * which strictly rejects private residential doorbells / home cameras and
 * restricts exact pins to `alpr_flock`, `traffic`, and `red_light`.
 */
import { MOCK_CAMERA_RECORDS } from '../data/mockSeed';
import {
  CameraFeedProvider,
  PublicCamera,
  PublicCameraType,
  RawCameraRecord,
} from '../types';
import { isPrivateResidentialCamera, validatePublicCameraPin } from '../utils/compliance';
import { deterministicId, encodeGeohash, slugify } from '../utils/geohash';
import {
  asArray,
  asRecord,
  defaultFetcher,
  fetchJson,
  HttpFetcher,
  readNumber,
  readString,
} from '../utils/json';

export interface CameraFeedAdapter {
  readonly id: string;
  readonly provider: CameraFeedProvider;
  fetchCameras(): Promise<RawCameraRecord[]>;
}

export interface MetroBoundingBox {
  citySlug: string;
  stateCode: string;
  south: number;
  west: number;
  north: number;
  east: number;
}

export const DEFAULT_OVERPASS_ENDPOINT = 'https://overpass-api.de/api/interpreter';
const FALLBACK_OVERPASS_ENDPOINTS: readonly string[] = [
  DEFAULT_OVERPASS_ENDPOINT,
  'https://overpass.kumi.systems/api/interpreter',
  'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
];

function extractTags(rawTags: unknown): Record<string, string> {
  const rec = asRecord(rawTags);
  if (rec === null) return {};
  const out: Record<string, string> = {};
  for (const [k, v] of Object.entries(rec)) {
    if (typeof v === 'string') out[k] = v;
    else if (typeof v === 'number' || typeof v === 'boolean') out[k] = String(v);
  }
  return out;
}

function parseDirectionHeading(raw: string | undefined): number | null {
  if (raw === undefined) return null;
  const trimmed = raw.trim().toUpperCase();
  const compass: Record<string, number> = {
    N: 0,
    NE: 45,
    E: 90,
    SE: 135,
    S: 180,
    SW: 225,
    W: 270,
    NW: 315,
  };
  if (trimmed in compass) return compass[trimmed];
  const numeric = Number(trimmed);
  if (!Number.isFinite(numeric)) return null;
  return ((numeric % 360) + 360) % 360;
}

/**
 * Classifies OSM/DeFlock tags into one of the three permitted civic camera
 * types, or returns `null` if unknown / private residential.
 */
export function classifyPublicCameraType(
  tags: Readonly<Record<string, string>>,
): PublicCameraType | null {
  if (isPrivateResidentialCamera(tags)) return null;

  const lower = (key: string): string => (tags[key] ?? '').toLowerCase().trim();
  const survType = lower('surveillance:type');
  const manufacturer = lower('manufacturer');
  const brand = lower('brand');
  const enforcement = lower('enforcement');
  const highway = lower('highway');
  const zone = lower('surveillance:zone');
  const cameraType = lower('camera:type');

  if (
    survType === 'alpr' ||
    survType === 'anpr' ||
    manufacturer.includes('flock') ||
    brand.includes('flock') ||
    cameraType === 'alpr'
  ) {
    return 'alpr_flock';
  }
  if (
    enforcement === 'traffic_signals' ||
    enforcement === 'red_light' ||
    highway === 'traffic_signals' && survType === 'camera'
  ) {
    return 'red_light';
  }
  if (
    highway === 'speed_camera' ||
    zone === 'traffic' ||
    zone === 'road' ||
    zone === 'highway' ||
    survType === 'traffic'
  ) {
    return 'traffic';
  }
  return null;
}

export type CameraNormalizationResult =
  | { accepted: true; camera: PublicCamera }
  | { accepted: false; reason: string };

/**
 * Normalizes and anti-doxxing-validates a raw camera record into a
 * deterministic `PublicCamera` document ready for Firestore.
 */
export function normalizeCameraRecord(
  raw: RawCameraRecord,
  now: Date = new Date(),
): CameraNormalizationResult {
  if (isPrivateResidentialCamera(raw.tags)) {
    return {
      accepted: false,
      reason: `Rejected private residential camera ${raw.externalId} (anti-doxxing).`,
    };
  }

  const cameraType = classifyPublicCameraType(raw.tags);
  const validation = validatePublicCameraPin({
    type: cameraType,
    isPrivateResidence: false,
    tags: raw.tags,
    latitude: raw.latitude,
    longitude: raw.longitude,
  });

  if (!validation.valid || cameraType === null) {
    return {
      accepted: false,
      reason: validation.reasons.join(' ') || `Unsupported camera tags for ${raw.externalId}.`,
    };
  }

  const operatorName =
    raw.tags['operator']?.trim() ||
    raw.tags['manufacturer']?.trim() ||
    'Public Civic Infrastructure';

  const geohash = encodeGeohash(raw.latitude, raw.longitude);
  const id = deterministicId('cam', raw.provider, raw.externalId);
  const citySlug = slugify(raw.citySlug);
  const stateCode = raw.stateCode.trim().toUpperCase();

  return {
    accepted: true,
    camera: {
      id,
      type: cameraType,
      operatorName,
      latitude: raw.latitude,
      longitude: raw.longitude,
      geohash,
      geo: {
        latitude: raw.latitude,
        longitude: raw.longitude,
        geohash,
      },
      directionHeading: parseDirectionHeading(raw.tags['direction'] ?? raw.tags['camera:direction']),
      verified: true,
      source: 'osm_deflock',
      citySlug,
      stateCode,
      updatedAt: now,
      externalRef: {
        provider: raw.provider,
        externalId: raw.externalId,
      },
    },
  };
}

// ───────────────────── OpenStreetMap Overpass Adapter ─────────────────────

export interface OverpassCameraConfig {
  id: string;
  endpoint?: string;
  metro: MetroBoundingBox;
}

export class OverpassCameraFeedAdapter implements CameraFeedAdapter {
  readonly provider: CameraFeedProvider = 'osm';

  constructor(
    private readonly config: OverpassCameraConfig,
    private readonly fetcher: HttpFetcher = defaultFetcher,
  ) {}

  get id(): string {
    return this.config.id;
  }

  buildOverpassQuery(): string {
    const { south, west, north, east } = this.config.metro;
    const bbox = `${south},${west},${north},${east}`;
    return [
      '[out:json][timeout:25];',
      '(',
      `  node["man_made"="surveillance"]["surveillance:type"~"ALPR|ANPR|camera",i](${bbox});`,
      `  node["highway"="speed_camera"](${bbox});`,
      `  node["enforcement"~"traffic_signals|red_light|maxspeed"](${bbox});`,
      ');',
      'out body;',
    ].join('\n');
  }

  async fetchCameras(): Promise<RawCameraRecord[]> {
    const endpoints =
      this.config.endpoint !== undefined
        ? [this.config.endpoint]
        : FALLBACK_OVERPASS_ENDPOINTS;
    const body = `data=${encodeURIComponent(this.buildOverpassQuery())}`;

    let payload: Record<string, unknown> | null = null;
    let lastError: Error | null = null;
    for (const endpoint of endpoints) {
      try {
        const res = await this.fetcher(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            Accept: 'application/json',
            'User-Agent': 'CrimeMapsCivicTransparency/1.0',
          },
          body,
        });
        if (!res.ok) {
          lastError = new Error(`HTTP ${res.status} querying Overpass API`);
          continue;
        }
        payload = asRecord(await res.json());
        if (payload !== null) break;
      } catch (err) {
        lastError = err instanceof Error ? err : new Error(String(err));
      }
    }
    if (payload === null) {
      if (lastError !== null) throw lastError;
      return [];
    }

    const records: RawCameraRecord[] = [];
    for (const el of asArray(payload['elements'])) {
      const node = asRecord(el);
      if (node === null) continue;
      const elType = readString(node, 'type') ?? 'node';
      const elId = readString(node, 'id');
      const center = asRecord(node['center']);
      const lat = readNumber(node, 'lat') ?? (center !== null ? readNumber(center, 'lat') : null);
      const lon = readNumber(node, 'lon') ?? (center !== null ? readNumber(center, 'lon') : null);
      if (elId === null || lat === null || lon === null) continue;

      records.push({
        provider: 'osm',
        externalId: `${elType}/${elId}`,
        latitude: lat,
        longitude: lon,
        tags: extractTags(node['tags']),
        citySlug: this.config.metro.citySlug,
        stateCode: this.config.metro.stateCode,
      });
    }
    return records;
  }
}

// ───────────────────────── DeFlock ALPR Adapter ─────────────────────────

export interface DeFlockFeedConfig {
  id: string;
  endpoint: string;
  citySlug: string;
  stateCode: string;
}

export class DeFlockCameraFeedAdapter implements CameraFeedAdapter {
  readonly provider: CameraFeedProvider = 'deflock';

  constructor(
    private readonly config: DeFlockFeedConfig,
    private readonly apiKey: string | undefined,
    private readonly fetcher: HttpFetcher = defaultFetcher,
  ) {}

  get id(): string {
    return this.config.id;
  }

  async fetchCameras(): Promise<RawCameraRecord[]> {
    const headers: Record<string, string> = { Accept: 'application/json' };
    if (this.apiKey !== undefined && this.apiKey.trim().length > 0) {
      headers['Authorization'] = `Bearer ${this.apiKey}`;
    }
    const payload = await fetchJson(this.fetcher, this.config.endpoint, headers);
    const root = asRecord(payload);

    // Support both GeoJSON FeatureCollection and Overpass-style elements arrays.
    const features = root !== null ? asArray(root['features']) : asArray(payload);
    const records: RawCameraRecord[] = [];

    for (const entry of features) {
      const feature = asRecord(entry);
      if (feature === null) continue;

      const geometry = asRecord(feature['geometry']);
      const props = asRecord(feature['properties']) ?? feature;
      const coords = geometry !== null ? asArray(geometry['coordinates']) : [];

      const lon =
        coords.length >= 2 && typeof coords[0] === 'number'
          ? coords[0]
          : readNumber(props, 'lon') ?? readNumber(props, 'longitude');
      const lat =
        coords.length >= 2 && typeof coords[1] === 'number'
          ? coords[1]
          : readNumber(props, 'lat') ?? readNumber(props, 'latitude');
      const externalId =
        readString(feature, 'id') ?? readString(props, 'id') ?? readString(props, 'osm_id');

      if (externalId === null || lat === null || lon === null) continue;

      const tags = extractTags(props['tags'] ?? props);
      if (tags['surveillance:type'] === undefined) {
        tags['surveillance:type'] = 'ALPR';
      }
      records.push({
        provider: 'deflock',
        externalId,
        latitude: lat,
        longitude: lon,
        tags,
        citySlug: readString(props, 'citySlug') ?? this.config.citySlug,
        stateCode: readString(props, 'stateCode') ?? this.config.stateCode,
      });
    }
    return records;
  }
}

// ───────────────────────────── Mock Adapter ─────────────────────────────

export class MockCameraFeedAdapter implements CameraFeedAdapter {
  readonly id = 'mock_osm_deflock';
  readonly provider: CameraFeedProvider = 'mock';

  async fetchCameras(): Promise<RawCameraRecord[]> {
    return [...MOCK_CAMERA_RECORDS];
  }
}

// ───────────────────────────── Factory ─────────────────────────────

export type CameraFeedSourceConfig =
  | ({ type: 'osm' } & OverpassCameraConfig)
  | ({ type: 'deflock' } & DeFlockFeedConfig);

export interface CameraFeedFactoryOptions {
  useMockData: boolean;
  sourcesJson?: string;
  deflockApiKey?: string;
  fetcher?: HttpFetcher;
}

function isCameraSourceConfig(value: unknown): value is CameraFeedSourceConfig {
  const r = asRecord(value);
  if (r === null) return false;
  const type = r['type'];
  return (type === 'osm' || type === 'deflock') && typeof r['id'] === 'string';
}

export function createCameraFeedAdapters(options: CameraFeedFactoryOptions): CameraFeedAdapter[] {
  if (options.useMockData) return [new MockCameraFeedAdapter()];

  const fetcher = options.fetcher ?? defaultFetcher;
  if (options.sourcesJson === undefined || options.sourcesJson.trim().length === 0) {
    return [new MockCameraFeedAdapter()];
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(options.sourcesJson);
  } catch {
    throw new Error('CAMERA_FEED_SOURCES is not valid JSON.');
  }

  const adapters: CameraFeedAdapter[] = [];
  for (const cfg of asArray(parsed).filter(isCameraSourceConfig)) {
    if (cfg.type === 'osm') {
      adapters.push(new OverpassCameraFeedAdapter(cfg, fetcher));
    } else {
      adapters.push(new DeFlockCameraFeedAdapter(cfg, options.deflockApiKey, fetcher));
    }
  }
  return adapters.length > 0 ? adapters : [new MockCameraFeedAdapter()];
}
