/**
 * Crime Maps — strict backend domain types.
 *
 * Field names mirror the Flutter `freezed` domain models in
 * `lib/features/<feature>/domain/` so Firestore documents round-trip cleanly.
 * Date fields are JS `Date` values in code; the Admin SDK persists them as
 * Firestore `Timestamp`s (required for the `expireAt` TTL policy).
 */

// ───────────────────────────── Incidents ─────────────────────────────

export type IncidentCategory = 'violent' | 'property' | 'trafficDui' | 'other';
export type IncidentSeverity = 'low' | 'medium' | 'high' | 'critical';

export const HIGH_SEVERITY_LEVELS: readonly IncidentSeverity[] = ['high', 'critical'];

export interface LatLng {
  latitude: number;
  longitude: number;
}

export interface GeoCoordinate extends LatLng {
  geohash: string;
}

export interface AllegedOffender {
  name: string;
  bookingPhotoUrl: string | null;
  charges: string[];
  bookingDate: Date;
  sourceAgency: string;
  disclaimer: string;
  /** Mirrors the top-level `expireAt` TTL (bookingDate + 45 days). */
  expiresAt: Date;
  redacted: boolean;
  redactionRequestId?: string | null;
  redactedAt?: Date | null;
}

export type CrimeFeedProvider = 'socrata' | 'arcgis' | 'spotcrime' | 'interpol' | 'mock';

export interface IncidentSourceRef {
  provider: CrimeFeedProvider;
  externalId: string;
}

export interface Incident {
  id: string;
  title: string;
  category: IncidentCategory;
  severity: IncidentSeverity;
  address: string;
  placeName: string;
  placeType: string;
  geo: GeoCoordinate;
  citySlug: string;
  cityName: string;
  stateCode: string;
  occurredAt: Date;
  streetViewUrl: string | null;
  sourceAgency: string;
  allegedOffender: AllegedOffender | null;
  /** Firestore TTL field. Set ONLY when `allegedOffender` is present. */
  expireAt: Date | null;
  source: IncidentSourceRef;
  ingestedAt: Date;
}

/** Booking data as delivered by a jail / booking feed, before compliance processing. */
export interface RawBookingRecord {
  name: string;
  bookingPhotoUrl?: string | null;
  charges: string[];
  bookingDate: Date;
  sourceAgency: string;
}

/** Normalized-but-unvalidated record emitted by every crime feed adapter. */
export interface RawCrimeRecord {
  provider: CrimeFeedProvider;
  externalId: string;
  title: string;
  description?: string;
  category?: IncidentCategory;
  severity?: IncidentSeverity;
  address: string;
  placeName?: string;
  placeType?: string;
  latitude: number | null;
  longitude: number | null;
  cityName: string;
  citySlug?: string;
  stateCode: string;
  occurredAt: Date;
  sourceAgency: string;
  streetViewUrl?: string | null;
  booking?: RawBookingRecord | null;
}

// ───────────────────────────── Cameras ─────────────────────────────

export type PublicCameraType = 'alpr_flock' | 'traffic' | 'red_light';
export type CameraSource = 'osm_deflock' | 'community';
export type CameraFeedProvider = 'osm' | 'deflock' | 'mock';

export interface PublicCamera {
  id: string;
  type: PublicCameraType;
  operatorName: string;
  latitude: number;
  longitude: number;
  geohash: string;
  geo: GeoCoordinate;
  directionHeading: number | null;
  verified: boolean;
  source: CameraSource;
  citySlug: string;
  stateCode: string;
  updatedAt: Date;
  externalRef: { provider: CameraFeedProvider; externalId: string };
}

/** Raw camera record emitted by OSM / DeFlock adapters (OSM tag semantics). */
export interface RawCameraRecord {
  provider: CameraFeedProvider;
  externalId: string;
  latitude: number;
  longitude: number;
  tags: Readonly<Record<string, string>>;
  citySlug: string;
  stateCode: string;
}

// ───────────────────────────── Territories ─────────────────────────────

export type TerritoryVertex = LatLng;

export interface Territory {
  id: string;
  name: string;
  citySlug: string;
  stateCode: string;
  colorHex: string;
  polygonPoints: TerritoryVertex[];
  citationDate: string;
  sourceReference: string;
  contextLabel: string;
  historicalNotes: string | null;
  updatedAt: Date;
}

export type ModerationStatus = 'pending_review' | 'approved' | 'rejected';

export interface TerritorySubmission {
  id: string;
  territoryId: string | null;
  proposedName: string;
  citySlug: string;
  stateCode: string;
  sourceCitation: string;
  notes: string;
  submittedByUserId: string;
  submittedAt: Date;
  moderationStatus: ModerationStatus;
}

// ───────────────────────────── Tracks ─────────────────────────────

export type TrackStatus = 'processing' | 'active' | 'flagged_dmca' | 'rejected';

export interface RightsWarranty {
  owns100Percent: boolean;
  signedName: string;
  signedAt: Date | string;
  version: string;
}

export interface IndieTrack {
  id: string;
  artistId: string;
  artistName: string;
  title: string;
  genre: string;
  audioUrl: string;
  coverArtUrl: string;
  durationSec: number;
  citySlug: string;
  cityName: string;
  stateCode: string;
  zipCode: string;
  boostedUntil: Date | null;
  boostTargetZip: string | null;
  rightsWarranty: RightsWarranty;
  status: TrackStatus;
  playCount: number;
  likeCount: number;
}

/** Subset of Cloud Storage object metadata used by `onTrackUploaded`. */
export interface UploadedObjectInfo {
  bucket: string;
  name: string;
  contentType: string | undefined;
  size: number;
  metadata: Readonly<Record<string, string>> | undefined;
}

// ───────────────────────────── Compliance ─────────────────────────────

export type RemovalReason =
  | 'expunged'
  | 'dismissedOrAcquitted'
  | 'sealedRecord'
  | 'mistakenIdentity'
  | 'privacyRequest';

export const REMOVAL_REASONS: readonly RemovalReason[] = [
  'expunged',
  'dismissedOrAcquitted',
  'sealedRecord',
  'mistakenIdentity',
  'privacyRequest',
];

export interface MugshotRemovalInput {
  incidentId: string;
  requesterName: string;
  requesterEmail: string;
  reason: RemovalReason;
  caseNumber?: string | null;
  additionalNotes?: string | null;
}

export interface MugshotRemovalRequest extends MugshotRemovalInput {
  id: string;
  submittedAt: Date;
  status: 'redacted_pending_verification';
  requesterUid: string | null;
  feeCharged: 0;
}

export interface MugshotRemovalResult {
  requestId: string;
  incidentId: string;
  status: 'redacted_pending_verification';
  redacted: boolean;
  feeCharged: 0;
}

export interface DmcaClaim {
  id: string;
  trackId: string;
  trackTitle: string;
  claimantName: string;
  claimantEmail: string;
  copyrightedWorkDescription: string;
  goodFaithBeliefConfirmed: boolean;
  perjuryStatementConfirmed: boolean;
  electronicSignature: string;
  submittedAt: Date;
  status: string;
}

export interface ValidationResult {
  valid: boolean;
  reasons: string[];
}
