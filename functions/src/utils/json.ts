/**
 * Shared, dependency-free helpers for safely reading untyped JSON payloads
 * from third-party feeds without resorting to `any`.
 */

export type JsonRecord = Record<string, unknown>;

export function asRecord(value: unknown): JsonRecord | null {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
    ? (value as JsonRecord)
    : null;
}

export function asArray(value: unknown): unknown[] {
  return Array.isArray(value) ? value : [];
}

export function readString(obj: JsonRecord, key: string): string | null {
  const v = obj[key];
  if (typeof v === 'string') return v.trim().length > 0 ? v.trim() : null;
  if (typeof v === 'number' && Number.isFinite(v)) return String(v);
  return null;
}

export function readNumber(obj: JsonRecord, key: string): number | null {
  const v = obj[key];
  if (typeof v === 'number' && Number.isFinite(v)) return v;
  if (typeof v === 'string' && v.trim().length > 0) {
    const n = Number(v);
    return Number.isFinite(n) ? n : null;
  }
  return null;
}

export function readDate(obj: JsonRecord, key: string): Date | null {
  const v = obj[key];
  if (typeof v === 'number' && Number.isFinite(v)) return new Date(v);
  if (typeof v === 'string' && v.trim().length > 0) {
    const d = new Date(v);
    return Number.isNaN(d.getTime()) ? null : d;
  }
  return null;
}

/** Minimal fetch abstraction so adapters are unit-testable without network. */
export interface HttpResponseLike {
  ok: boolean;
  status: number;
  json(): Promise<unknown>;
}

export type HttpFetcher = (
  url: string,
  init?: { method?: string; headers?: Record<string, string>; body?: string },
) => Promise<HttpResponseLike>;

/** Default fetcher backed by the Node 22 global `fetch`. */
export const defaultFetcher: HttpFetcher = async (url, init) => {
  const res = await fetch(url, init);
  return { ok: res.ok, status: res.status, json: () => res.json() as Promise<unknown> };
};

export async function fetchJson(fetcher: HttpFetcher, url: string, headers?: Record<string, string>): Promise<unknown> {
  const res = await fetcher(url, headers === undefined ? undefined : { headers });
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} fetching ${redactUrlSecrets(url)}`);
  }
  return res.json();
}

/** Strips credential query params from URLs before logging. */
export function redactUrlSecrets(url: string): string {
  return url.replace(/([?&](?:key|token|api_key|apikey|\$\$app_token)=)[^&]*/gi, '$1REDACTED');
}
