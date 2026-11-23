import {
  buildCompliantOffender,
  isPrivateResidentialCamera,
  PRESUMED_INNOCENT_DISCLAIMER,
  REDACTED_OFFENDER_NAME,
  redactOffender,
  validatePublicCameraPin,
  validateRightsMetadata,
  validateRightsWarranty,
} from '../utils/compliance';
import {
  BOOKING_TTL_DAYS,
  computeBookingExpiry,
  decodeGeohashBounds,
  deterministicId,
  encodeGeohash,
  geohashTopicPrefixes,
  isBookingExpired,
  slugify,
} from '../utils/geohash';

describe('geohash & TTL utilities', () => {
  test('encodes Atlanta Five Points into a valid geohash whose bounds contain original lat/lng', () => {
    const lat = 33.7537;
    const lng = -84.3915;
    const hash = encodeGeohash(lat, lng, 9);

    expect(hash).toHaveLength(9);
    expect(hash.startsWith('dn5bp')).toBe(true);

    const bounds = decodeGeohashBounds(hash);
    expect(lat).toBeGreaterThanOrEqual(bounds.minLat);
    expect(lat).toBeLessThanOrEqual(bounds.maxLat);
    expect(lng).toBeGreaterThanOrEqual(bounds.minLng);
    expect(lng).toBeLessThanOrEqual(bounds.maxLng);
  });

  test('rejects invalid coordinates and precision', () => {
    expect(() => encodeGeohash(91, 0)).toThrow(RangeError);
    expect(() => encodeGeohash(0, -181)).toThrow(RangeError);
    expect(() => encodeGeohash(33.75, -84.39, 0)).toThrow(RangeError);
    expect(() => decodeGeohashBounds('invalid!')).toThrow(RangeError);
  });

  test('computes geohash topic prefixes at 4, 5, 6 characters', () => {
    expect(geohashTopicPrefixes('dn5bpk123')).toEqual(['dn5b', 'dn5bp', 'dn5bpk']);
  });

  test('computeBookingExpiry adds exactly 45 days (UTC) to bookingDate', () => {
    const bookingDate = new Date('2026-01-01T12:30:00.000Z');
    const expiry = computeBookingExpiry(bookingDate);

    expect(BOOKING_TTL_DAYS).toBe(45);
    expect(expiry.toISOString()).toBe('2026-02-15T12:30:00.000Z');
    expect(isBookingExpired(bookingDate, new Date('2026-02-15T12:29:59.000Z'))).toBe(false);
    expect(isBookingExpired(bookingDate, new Date('2026-02-15T12:30:00.000Z'))).toBe(true);
  });

  test('deterministicId is idempotent across casing/whitespace and distinct for different inputs', () => {
    const id1 = deterministicId('inc', 'Socrata', 'APD-2026-001');
    const id2 = deterministicId('inc', ' socrata ', 'apd-2026-001 ');
    const id3 = deterministicId('inc', 'socrata', 'APD-2026-002');

    expect(id1).toBe(id2);
    expect(id1).not.toBe(id3);
    expect(id1).toMatch(/^inc_[0-9a-f]{32}$/);
    expect(slugify('Los Angeles')).toBe('los_angeles');
  });
});

describe('compliance & anti-doxxing guardrails', () => {
  test('buildCompliantOffender attaches Presumed Innocent disclaimer and 45-day TTL', () => {
    const bookingDate = new Date('2026-03-01T00:00:00.000Z');
    const offender = buildCompliantOffender({
      name: '  John Doe  ',
      charges: [' Theft ', ''],
      bookingDate,
      sourceAgency: 'Fulton County Sheriff',
    });

    expect(offender.name).toBe('John Doe');
    expect(offender.charges).toEqual(['Theft']);
    expect(offender.disclaimer).toBe(PRESUMED_INNOCENT_DISCLAIMER);
    expect(offender.disclaimer.toLowerCase()).toContain('presumed innocent');
    expect(offender.expiresAt.toISOString()).toBe('2026-04-15T00:00:00.000Z');
    expect(offender.redacted).toBe(false);

    const redactedAt = new Date('2026-03-02T00:00:00.000Z');
    const redacted = redactOffender(offender, 'req_123', redactedAt);
    expect(redacted.name).toBe(REDACTED_OFFENDER_NAME);
    expect(redacted.bookingPhotoUrl).toBeNull();
    expect(redacted.charges).toEqual([]);
    expect(redacted.redacted).toBe(true);
    expect(redacted.redactionRequestId).toBe('req_123');
    expect(redacted.disclaimer).toBe(PRESUMED_INNOCENT_DISCLAIMER);
  });

  test('anti-doxxing rejects private residential doorbells and houses', () => {
    expect(
      isPrivateResidentialCamera({
        'camera:type': 'doorbell',
        brand: 'Ring',
        'surveillance:zone': 'porch',
      }),
    ).toBe(true);

    expect(
      isPrivateResidentialCamera({
        building: 'house',
        'operator:type': 'private',
      }),
    ).toBe(true);

    const rejectedPin = validatePublicCameraPin({
      type: 'traffic',
      isPrivateResidence: true,
      latitude: 33.75,
      longitude: -84.39,
    });
    expect(rejectedPin.valid).toBe(false);

    const rejectedType = validatePublicCameraPin({
      type: 'ring_doorbell',
      isPrivateResidence: false,
      latitude: 33.75,
      longitude: -84.39,
    });
    expect(rejectedType.valid).toBe(false);
  });

  test('anti-doxxing accepts verified civic ALPR, traffic, and red-light infrastructure', () => {
    for (const type of ['alpr_flock', 'traffic', 'red_light'] as const) {
      const result = validatePublicCameraPin({
        type,
        isPrivateResidence: false,
        tags: {
          'surveillance:type': type === 'alpr_flock' ? 'ALPR' : 'camera',
          surveillance: 'public',
          operator: 'City DOT',
        },
        latitude: 33.77,
        longitude: -84.38,
      });
      expect(result.valid).toBe(true);
    }
  });

  test('validateRightsWarranty enforces 100% ownership, signedName, and valid signedAt', () => {
    const now = new Date('2026-05-01T12:00:00.000Z');
    expect(
      validateRightsWarranty(
        {
          owns100Percent: true,
          signedName: 'Artist Legal Name',
          signedAt: new Date('2026-05-01T11:55:00.000Z'),
        },
        now,
      ).valid,
    ).toBe(true);

    expect(
      validateRightsWarranty(
        {
          owns100Percent: false,
          signedName: 'Artist',
          signedAt: now,
        },
        now,
      ).valid,
    ).toBe(false);

    expect(
      validateRightsWarranty(
        {
          owns100Percent: true,
          signedName: '   ',
          signedAt: now,
        },
        now,
      ).valid,
    ).toBe(false);

    expect(
      validateRightsWarranty(
        {
          owns100Percent: true,
          signedName: 'Artist',
          signedAt: new Date('2026-05-01T13:00:00.000Z'),
        },
        now,
      ).valid,
    ).toBe(false);
  });

  test('validateRightsMetadata requires owns100Percent == "true" and non-empty signedName', () => {
    expect(validateRightsMetadata({ owns100Percent: 'true', signedName: 'Indie Artist' }).valid).toBe(
      true,
    );
    expect(validateRightsMetadata({ owns100Percent: 'false', signedName: 'Indie Artist' }).valid).toBe(
      false,
    );
    expect(validateRightsMetadata({ owns100Percent: 'true', signedName: '' }).valid).toBe(false);
    expect(validateRightsMetadata(undefined).valid).toBe(false);
  });
});
