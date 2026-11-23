/**
 * Deterministic mock / seed data for Atlanta Metro, Georgia, and multi-state
 * US coverage. Used by the mock feed adapters (when no live feed credentials
 * are configured) and by the standalone Firestore seeder.
 *
 * All alleged offender names are FICTIONAL sample placeholders.
 */
import { IndieTrack, RawCameraRecord, RawCrimeRecord, Territory } from '../types';
import { HISTORICAL_TERRITORY_LABEL, RIGHTS_ATTESTATION_VERSION } from '../utils/compliance';

const HOUR = 60 * 60 * 1000;
const DAY = 24 * HOUR;

interface MockIncidentSeed {
  key: string;
  title: string;
  description: string;
  address: string;
  placeName: string;
  placeType: string;
  lat: number;
  lng: number;
  cityName: string;
  stateCode: string;
  sourceAgency: string;
  hoursAgo: number;
  booking?: { name: string; charges: string[]; daysAgo: number; photo?: string };
}

const INCIDENT_SEEDS: readonly MockIncidentSeed[] = [
  {
    key: 'atl-001',
    title: 'Aggravated Assault',
    description: 'Aggravated assault reported near transit station',
    address: '100 Peachtree St NW, Atlanta, GA 30303',
    placeName: 'Five Points Station',
    placeType: 'transit_station',
    lat: 33.7537,
    lng: -84.3915,
    cityName: 'Atlanta',
    stateCode: 'GA',
    sourceAgency: 'Atlanta Police Department \u2014 Zone 5',
    hoursAgo: 2,
    booking: { name: 'Sample Person A (Fictional)', charges: ['Aggravated Assault'], daysAgo: 1 },
  },
  {
    key: 'atl-002',
    title: 'Entering Auto',
    description: 'Vehicle break-in, larceny from auto',
    address: '1000 Piedmont Ave NE, Atlanta, GA 30309',
    placeName: 'Midtown Parking Deck',
    placeType: 'parking',
    lat: 33.7838,
    lng: -84.383,
    cityName: 'Atlanta',
    stateCode: 'GA',
    sourceAgency: 'Atlanta Police Department \u2014 Zone 5',
    hoursAgo: 5,
  },
  {
    key: 'atl-003',
    title: 'Armed Robbery',
    description: 'Armed robbery of pedestrian',
    address: '800 Ralph David Abernathy Blvd SW, Atlanta, GA 30310',
    placeName: 'West End Plaza',
    placeType: 'shopping_center',
    lat: 33.7368,
    lng: -84.4129,
    cityName: 'Atlanta',
    stateCode: 'GA',
    sourceAgency: 'Atlanta Police Department \u2014 Zone 4',
    hoursAgo: 8,
    booking: { name: 'Sample Person B (Fictional)', charges: ['Armed Robbery', 'Possession of Firearm During Felony'], daysAgo: 0 },
  },
  {
    key: 'atl-004',
    title: 'DUI Arrest',
    description: 'Driving under the influence traffic stop',
    address: '3400 Peachtree Rd NE, Atlanta, GA 30326',
    placeName: 'Buckhead Village',
    placeType: 'road',
    lat: 33.8481,
    lng: -84.3672,
    cityName: 'Atlanta',
    stateCode: 'GA',
    sourceAgency: 'Atlanta Police Department \u2014 Zone 2',
    hoursAgo: 11,
    booking: { name: 'Sample Person C (Fictional)', charges: ['DUI - Less Safe'], daysAgo: 0 },
  },
  {
    key: 'atl-005',
    title: 'Residential Burglary',
    description: 'Burglary forced entry residence',
    address: '600 Edgewood Ave SE, Atlanta, GA 30312',
    placeName: 'Old Fourth Ward',
    placeType: 'neighborhood',
    lat: 33.7546,
    lng: -84.3675,
    cityName: 'Atlanta',
    stateCode: 'GA',
    sourceAgency: 'Atlanta Police Department \u2014 Zone 6',
    hoursAgo: 20,
  },
  {
    key: 'dec-001',
    title: 'Shoplifting',
    description: 'Shoplifting larceny at retail store',
    address: '2050 Lawrenceville Hwy, Decatur, GA 30033',
    placeName: 'North DeKalb Retail',
    placeType: 'store',
    lat: 33.8121,
    lng: -84.2847,
    cityName: 'Decatur',
    stateCode: 'GA',
    sourceAgency: 'DeKalb County Police Department',
    hoursAgo: 26,
  },
  {
    key: 'mar-001',
    title: 'Motor Vehicle Theft',
    description: 'Auto theft from apartment parking lot',
    address: '50 Cobb Pkwy S, Marietta, GA 30060',
    placeName: 'Marietta Square',
    placeType: 'parking',
    lat: 33.9526,
    lng: -84.5499,
    cityName: 'Marietta',
    stateCode: 'GA',
    sourceAgency: 'Marietta Police Department',
    hoursAgo: 30,
  },
  {
    key: 'sav-001',
    title: 'Shooting',
    description: 'Shots fired, one person injured',
    address: '300 MLK Jr Blvd, Savannah, GA 31401',
    placeName: 'MLK Corridor',
    placeType: 'road',
    lat: 32.0757,
    lng: -81.0995,
    cityName: 'Savannah',
    stateCode: 'GA',
    sourceAgency: 'Savannah Police Department',
    hoursAgo: 14,
  },
  {
    key: 'mac-001',
    title: 'Vandalism',
    description: 'Criminal damage to property',
    address: '500 Cherry St, Macon, GA 31201',
    placeName: 'Downtown Macon',
    placeType: 'street',
    lat: 32.8365,
    lng: -83.6283,
    cityName: 'Macon',
    stateCode: 'GA',
    sourceAgency: 'Bibb County Sheriff Office',
    hoursAgo: 40,
  },
  {
    key: 'aug-001',
    title: 'Robbery',
    description: 'Commercial robbery at gas station',
    address: '1200 Broad St, Augusta, GA 30901',
    placeName: 'Broad Street Fuel',
    placeType: 'gas_station',
    lat: 33.4735,
    lng: -81.9748,
    cityName: 'Augusta',
    stateCode: 'GA',
    sourceAgency: 'Richmond County Sheriff Office',
    hoursAgo: 36,
  },
  {
    key: 'chi-001',
    title: 'Homicide',
    description: 'Homicide investigation',
    address: '200 S State St, Chicago, IL 60604',
    placeName: 'The Loop',
    placeType: 'street',
    lat: 41.8789,
    lng: -87.6274,
    cityName: 'Chicago',
    stateCode: 'IL',
    sourceAgency: 'Chicago Police Department \u2014 District 1',
    hoursAgo: 6,
  },
  {
    key: 'hou-001',
    title: 'Burglary of Vehicle',
    description: 'Burglary of motor vehicle',
    address: '1500 McKinney St, Houston, TX 77010',
    placeName: 'Downtown Houston',
    placeType: 'parking',
    lat: 29.7522,
    lng: -95.3586,
    cityName: 'Houston',
    stateCode: 'TX',
    sourceAgency: 'Houston Police Department',
    hoursAgo: 9,
  },
  {
    key: 'lax-001',
    title: 'Assault with Deadly Weapon',
    description: 'Assault with a deadly weapon',
    address: '700 S Flower St, Los Angeles, CA 90017',
    placeName: 'Financial District',
    placeType: 'street',
    lat: 34.0488,
    lng: -118.2588,
    cityName: 'Los Angeles',
    stateCode: 'CA',
    sourceAgency: 'Los Angeles Police Department \u2014 Central',
    hoursAgo: 3,
    booking: { name: 'Sample Person D (Fictional)', charges: ['ADW'], daysAgo: 0 },
  },
  {
    key: 'nyc-001',
    title: 'Petit Larceny',
    description: 'Theft of property under $1000',
    address: '1 Times Sq, New York, NY 10036',
    placeName: 'Times Square',
    placeType: 'plaza',
    lat: 40.758,
    lng: -73.9855,
    cityName: 'New York',
    stateCode: 'NY',
    sourceAgency: 'NYPD \u2014 Midtown South Precinct',
    hoursAgo: 12,
  },
];

/** Builds mock raw crime records relative to `now` (deterministic external IDs). */
export function buildMockCrimeRecords(now: Date): RawCrimeRecord[] {
  return INCIDENT_SEEDS.map((s) => ({
    provider: 'mock' as const,
    externalId: s.key,
    title: s.title,
    description: s.description,
    address: s.address,
    placeName: s.placeName,
    placeType: s.placeType,
    latitude: s.lat,
    longitude: s.lng,
    cityName: s.cityName,
    stateCode: s.stateCode,
    occurredAt: new Date(now.getTime() - s.hoursAgo * HOUR),
    sourceAgency: s.sourceAgency,
    streetViewUrl: null,
    booking:
      s.booking === undefined
        ? null
        : {
            name: s.booking.name,
            charges: s.booking.charges,
            bookingDate: new Date(now.getTime() - s.booking.daysAgo * DAY - s.hoursAgo * HOUR),
            bookingPhotoUrl: s.booking.photo ?? null,
            sourceAgency: s.sourceAgency,
          },
  }));
}

/**
 * Mock OSM / DeFlock style camera records. Includes a private residential
 * doorbell + a home security camera which MUST be rejected by the
 * anti-doxxing normalizer.
 */
export const MOCK_CAMERA_RECORDS: readonly RawCameraRecord[] = [
  {
    provider: 'deflock',
    externalId: 'node/9000000001',
    latitude: 33.7712,
    longitude: -84.3857,
    citySlug: 'atlanta',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'ALPR', surveillance: 'public', manufacturer: 'Flock Safety', operator: 'Atlanta Police Department', direction: '180' },
  },
  {
    provider: 'deflock',
    externalId: 'node/9000000002',
    latitude: 33.7489,
    longitude: -84.388,
    citySlug: 'atlanta',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'ALPR', surveillance: 'public', manufacturer: 'Flock Safety', operator: 'Atlanta Police Department' },
  },
  {
    provider: 'osm',
    externalId: 'node/9000000003',
    latitude: 33.7865,
    longitude: -84.3836,
    citySlug: 'atlanta',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'camera', 'surveillance:zone': 'traffic', surveillance: 'public', operator: 'Georgia DOT', direction: '90' },
  },
  {
    provider: 'osm',
    externalId: 'node/9000000004',
    latitude: 33.7601,
    longitude: -84.3924,
    citySlug: 'atlanta',
    stateCode: 'GA',
    tags: { highway: 'speed_camera', enforcement: 'traffic_signals', 'surveillance:zone': 'traffic', operator: 'City of Atlanta' },
  },
  {
    provider: 'deflock',
    externalId: 'node/9000000005',
    latitude: 33.8121,
    longitude: -84.2847,
    citySlug: 'decatur',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'ALPR', surveillance: 'public', manufacturer: 'Flock Safety', operator: 'DeKalb County Police Department' },
  },
  {
    provider: 'deflock',
    externalId: 'node/9000000006',
    latitude: 32.0809,
    longitude: -81.0912,
    citySlug: 'savannah',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'ALPR', surveillance: 'public', operator: 'Savannah Police Department' },
  },
  {
    provider: 'osm',
    externalId: 'node/9000000007',
    latitude: 41.8781,
    longitude: -87.6298,
    citySlug: 'chicago',
    stateCode: 'IL',
    tags: { man_made: 'surveillance', 'surveillance:type': 'camera', 'surveillance:zone': 'traffic', enforcement: 'red_light', operator: 'Chicago DOT' },
  },
  // ── Must be rejected (anti-doxxing) ──
  {
    provider: 'osm',
    externalId: 'node/9000000098',
    latitude: 33.7701,
    longitude: -84.3601,
    citySlug: 'atlanta',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'camera', 'camera:type': 'doorbell', brand: 'Ring', 'surveillance:zone': 'porch' },
  },
  {
    provider: 'osm',
    externalId: 'node/9000000099',
    latitude: 33.7702,
    longitude: -84.3602,
    citySlug: 'atlanta',
    stateCode: 'GA',
    tags: { man_made: 'surveillance', 'surveillance:type': 'camera', surveillance: 'outdoor', building: 'house', 'operator:type': 'private' },
  },
];

function territory(
  id: string,
  name: string,
  citySlug: string,
  stateCode: string,
  colorHex: string,
  center: [number, number],
  span: number,
  citationDate: string,
  sourceReference: string,
  historicalNotes: string,
  now: Date,
): Territory {
  const [lat, lng] = center;
  return {
    id,
    name,
    citySlug,
    stateCode,
    colorHex,
    polygonPoints: [
      { latitude: lat + span, longitude: lng - span },
      { latitude: lat + span, longitude: lng + span },
      { latitude: lat - span, longitude: lng + span },
      { latitude: lat - span, longitude: lng - span },
    ],
    citationDate,
    sourceReference,
    contextLabel: HISTORICAL_TERRITORY_LABEL,
    historicalNotes,
    updatedAt: now,
  };
}

export function buildSeedTerritories(now: Date): Territory[] {
  return [
    territory('terr_atl_westside_hist', 'Westside Historical Context Area', 'atlanta', 'GA', '#B23A48', [33.7605, -84.4205], 0.008, '2019-06-01', 'Atlanta Journal-Constitution public archive (2019)', 'Publicly reported historical neighborhood context; not a current-activity claim.', now),
    territory('terr_atl_southside_hist', 'South Atlanta Historical Context Area', 'atlanta', 'GA', '#C77D2E', [33.7155, -84.3905], 0.007, '2018-03-15', 'Fulton County court public records summary (2018)', 'Documented in public court filings; historical reference only.', now),
    territory('terr_sav_eastside_hist', 'Eastside Savannah Historical Context Area', 'savannah', 'GA', '#6C4AB6', [32.0705, -81.0805], 0.006, '2020-09-10', 'Savannah Morning News public archive (2020)', 'Historical public-record context.', now),
    territory('terr_chi_loop_hist', 'Near South Historical Context Area', 'chicago', 'IL', '#2E86AB', [41.8605, -87.6305], 0.008, '2017-11-20', 'City of Chicago public safety report (2017)', 'Historical public-record context.', now),
  ];
}

export function buildSeedTracks(now: Date): IndieTrack[] {
  const base = (
    id: string,
    artistId: string,
    artistName: string,
    title: string,
    genre: string,
    citySlug: string,
    cityName: string,
    stateCode: string,
    zipCode: string,
    playCount: number,
    boosted: boolean,
  ): IndieTrack => ({
    id,
    artistId,
    artistName,
    title,
    genre,
    audioUrl: `https://storage.googleapis.com/crime-maps-dev-sample-audio/${id}.mp3`,
    coverArtUrl: `https://storage.googleapis.com/crime-maps-dev-sample-audio/${id}.jpg`,
    durationSec: 180 + playCount % 60,
    citySlug,
    cityName,
    stateCode,
    zipCode,
    boostedUntil: boosted ? new Date(now.getTime() + 7 * DAY) : null,
    boostTargetZip: boosted ? zipCode : null,
    rightsWarranty: {
      owns100Percent: true,
      signedName: artistName,
      signedAt: new Date(now.getTime() - 30 * DAY),
      version: RIGHTS_ATTESTATION_VERSION,
    },
    status: 'active',
    playCount,
    likeCount: Math.floor(playCount / 10),
  });

  return [
    base('track_atl_peachtree_nights', 'artist_seed_001', 'Midtown Lo-Fi Collective', 'Peachtree Nights', 'Lo-Fi', 'atlanta', 'Atlanta', 'GA', '30309', 4210, true),
    base('track_atl_westend_soul', 'artist_seed_002', 'West End Soul Sessions', 'Abernathy Sunrise', 'R&B', 'atlanta', 'Atlanta', 'GA', '30310', 2875, false),
    base('track_atl_beltline_drift', 'artist_seed_003', 'BeltLine Drift', 'Eastside Trail', 'Indie Electronic', 'atlanta', 'Atlanta', 'GA', '30312', 1960, false),
    base('track_sav_river_street', 'artist_seed_004', 'Coastal Static', 'River Street Fog', 'Indie Rock', 'savannah', 'Savannah', 'GA', '31401', 980, false),
    base('track_chi_loop_jazz', 'artist_seed_005', 'Loop Line Quartet', 'Elevated', 'Jazz', 'chicago', 'Chicago', 'IL', '60604', 3320, true),
    base('track_hou_bayou_bounce', 'artist_seed_006', 'Bayou Bounce', 'Third Coast Glide', 'Hip-Hop', 'houston', 'Houston', 'TX', '77010', 2440, false),
  ];
}
