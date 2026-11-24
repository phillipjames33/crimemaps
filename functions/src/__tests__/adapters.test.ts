import {
  classifyPublicCameraType,
  createCameraFeedAdapters,
  DeFlockCameraFeedAdapter,
  MockCameraFeedAdapter,
  normalizeCameraRecord,
  OverpassCameraFeedAdapter,
} from '../adapters/cameraFeedAdapter';
import {
  ArcGisCrimeFeedAdapter,
  createCrimeFeedAdapters,
  MockCrimeFeedAdapter,
  parseSpotCrimeDate,
  SocrataCrimeFeedAdapter,
  SpotCrimeFeedAdapter,
} from '../adapters/crimeFeedAdapter';
import { HttpFetcher } from '../utils/json';

function mockJsonFetcher(responseBody: unknown, status = 200): HttpFetcher {
  return async () => ({
    ok: status >= 200 && status < 300,
    status,
    json: async () => responseBody,
  });
}

describe('crime feed adapters', () => {
  test('SocrataCrimeFeedAdapter builds query and maps rows', async () => {
    const fetcher = jest.fn(
      mockJsonFetcher([
        {
          offense_id: 'SOC-100',
          ibr_category: 'Aggravated Assault',
          occur_date: '2026-05-01T10:00:00.000',
          location: '100 Peachtree St',
          lat: '33.7537',
          long: '-84.3915',
        },
      ]),
    );

    const adapter = new SocrataCrimeFeedAdapter(
      {
        id: 'atl_socrata',
        domain: 'data.atlantaga.gov',
        datasetId: 'abcd-1234',
        cityName: 'Atlanta',
        stateCode: 'GA',
        sourceAgency: 'Atlanta PD',
        fieldMap: {
          id: 'offense_id',
          title: 'ibr_category',
          occurredAt: 'occur_date',
          address: 'location',
          latitude: 'lat',
          longitude: 'long',
        },
      },
      'secret-app-token',
      fetcher,
    );

    const records = await adapter.fetchRecords(new Date('2026-05-01T00:00:00.000Z'));
    expect(records).toHaveLength(1);
    expect(records[0].provider).toBe('socrata');
    expect(records[0].externalId).toBe('SOC-100');
    expect(records[0].latitude).toBeCloseTo(33.7537);
    expect(fetcher).toHaveBeenCalledWith(
      expect.stringContaining('https://data.atlantaga.gov/resource/abcd-1234.json'),
      expect.objectContaining({
        headers: expect.objectContaining({ 'X-App-Token': 'secret-app-token' }),
      }),
    );
  });

  test('SocrataCrimeFeedAdapter reads nested dot-path coordinates (e.g. Dallas PD geocoded_column)', async () => {
    const fetcher = mockJsonFetcher([
      {
        servnumid: '172814-2026-01',
        offincident: 'BMV',
        mo: 'Vehicle break-in on Main St',
        incident_address: '1500 MAIN ST',
        edate: '2026-11-23 21:51:11.0000000',
        geocoded_column: {
          latitude: '32.7805',
          longitude: '-96.7987',
        },
      },
    ]);

    const adapter = new SocrataCrimeFeedAdapter(
      {
        id: 'dallas_pd_socrata',
        domain: 'www.dallasopendata.com',
        datasetId: 'qv6i-rri7',
        cityName: 'Dallas',
        stateCode: 'TX',
        sourceAgency: 'Dallas Police Department Open Data',
        fieldMap: {
          id: 'servnumid',
          title: 'offincident',
          description: 'mo',
          address: 'incident_address',
          occurredAt: 'edate',
          latitude: 'geocoded_column.latitude',
          longitude: 'geocoded_column.longitude',
        },
      },
      undefined,
      fetcher,
    );

    const records = await adapter.fetchRecords(new Date('2026-11-10T00:00:00.000Z'));
    expect(records).toHaveLength(1);
    expect(records[0].externalId).toBe('172814-2026-01');
    expect(records[0].latitude).toBeCloseTo(32.7805);
    expect(records[0].longitude).toBeCloseTo(-96.7987);
  });

  test('ArcGisCrimeFeedAdapter maps FeatureServer attributes + geometry', async () => {
    const fetcher = mockJsonFetcher({
      features: [
        {
          attributes: {
            OBJECTID: 42,
            OFFENSE: 'Motor Vehicle Theft',
            REPORT_DATE: 1777636800000,
            BLOCK_ADDR: '500 Cherry St',
          },
          geometry: { x: -83.6283, y: 32.8365 },
        },
      ],
    });

    const adapter = new ArcGisCrimeFeedAdapter(
      {
        id: 'macon_arcgis',
        layerUrl: 'https://services.arcgis.com/org/arcgis/rest/services/Crime/FeatureServer/0',
        cityName: 'Macon',
        stateCode: 'GA',
        sourceAgency: 'Bibb County Sheriff',
        fieldMap: {
          id: 'OBJECTID',
          title: 'OFFENSE',
          occurredAt: 'REPORT_DATE',
          address: 'BLOCK_ADDR',
        },
      },
      undefined,
      fetcher,
    );

    const records = await adapter.fetchRecords(new Date('2026-04-01T00:00:00.000Z'));
    expect(records).toHaveLength(1);
    expect(records[0].provider).toBe('arcgis');
    expect(records[0].latitude).toBeCloseTo(32.8365);
    expect(records[0].longitude).toBeCloseTo(-83.6283);
  });

  test('SpotCrimeFeedAdapter requires API key and filters by since date', async () => {
    expect(() => {
      new SpotCrimeFeedAdapter(
        { id: 'sc', latitude: 33.75, longitude: -84.39, radiusMiles: 5, cityName: 'Atlanta', stateCode: 'GA' },
        '',
      );
    }).toThrow();

    const parsedDate = parseSpotCrimeDate('05/01/26 02:30 PM');
    expect(parsedDate?.toISOString()).toBe('2026-05-01T14:30:00.000Z');

    const fetcher = mockJsonFetcher({
      crimes: [
        { cdid: '1', type: 'Robbery', date: '05/01/26 02:30 PM', address: '100 Main St', lat: 33.75, lon: -84.39 },
        { cdid: '2', type: 'Theft', date: '04/01/26 09:00 AM', address: '200 Old St', lat: 33.76, lon: -84.38 },
      ],
    });

    const adapter = new SpotCrimeFeedAdapter(
      { id: 'sc_atl', latitude: 33.75, longitude: -84.39, radiusMiles: 5, cityName: 'Atlanta', stateCode: 'GA' },
      'test-runtime-key',
      fetcher,
    );

    const records = await adapter.fetchRecords(new Date('2026-04-15T00:00:00.000Z'));
    expect(records).toHaveLength(1);
    expect(records[0].externalId).toBe('1');
  });

  test('createCrimeFeedAdapters falls back to MockCrimeFeedAdapter in mock mode', async () => {
    const adapters = createCrimeFeedAdapters({
      useMockData: true,
      secrets: {},
    });
    expect(adapters).toHaveLength(1);
    expect(adapters[0]).toBeInstanceOf(MockCrimeFeedAdapter);
  });
});

describe('camera feed adapters & anti-doxxing normalization', () => {
  test('OverpassCameraFeedAdapter parses OSM nodes and DeFlock parses GeoJSON', async () => {
    const osmFetcher = mockJsonFetcher({
      elements: [
        {
          type: 'node',
          id: 555111,
          lat: 33.771,
          lon: -84.385,
          tags: {
            man_made: 'surveillance',
            'surveillance:type': 'ALPR',
            manufacturer: 'Flock Safety',
            operator: 'Atlanta PD',
            direction: 'N',
          },
        },
      ],
    });
    const osm = new OverpassCameraFeedAdapter(
      {
        id: 'osm_atl',
        metro: { citySlug: 'atlanta', stateCode: 'GA', south: 33.6, west: -84.55, north: 33.9, east: -84.25 },
      },
      osmFetcher,
    );
    const osmRaw = await osm.fetchCameras();
    expect(osmRaw).toHaveLength(1);
    const osmNorm = normalizeCameraRecord(osmRaw[0]);
    expect(osmNorm.accepted).toBe(true);
    if (osmNorm.accepted) {
      expect(osmNorm.camera.type).toBe('alpr_flock');
      expect(osmNorm.camera.directionHeading).toBe(0);
    }

    const deflockFetcher = mockJsonFetcher({
      type: 'FeatureCollection',
      features: [
        {
          type: 'Feature',
          id: 'df-900',
          geometry: { type: 'Point', coordinates: [-84.388, 33.7489] },
          properties: { operator: 'Atlanta PD', manufacturer: 'Flock Safety' },
        },
      ],
    });
    const deflock = new DeFlockCameraFeedAdapter(
      { id: 'df_atl', endpoint: 'https://example.org/alpr.geojson', citySlug: 'atlanta', stateCode: 'GA' },
      undefined,
      deflockFetcher,
    );
    const dfRaw = await deflock.fetchCameras();
    expect(dfRaw).toHaveLength(1);
    expect(classifyPublicCameraType(dfRaw[0].tags)).toBe('alpr_flock');
  });

  test('MockCameraFeedAdapter includes residential doorbells that normalizeCameraRecord rejects', async () => {
    const [adapter] = createCameraFeedAdapters({ useMockData: true });
    expect(adapter).toBeInstanceOf(MockCameraFeedAdapter);

    const raw = await adapter.fetchCameras();
    const results = raw.map((r) => normalizeCameraRecord(r));
    const accepted = results.filter((r) => r.accepted);
    const rejected = results.filter((r) => !r.accepted);

    expect(accepted.length).toBeGreaterThanOrEqual(7);
    expect(rejected).toHaveLength(2);
  });
});
