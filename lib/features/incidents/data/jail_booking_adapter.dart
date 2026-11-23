import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/app_env.dart';
import '../../../core/config/compliance_constants.dart';
import '../../../core/mock/seed_data.dart';
import '../domain/incident_model.dart';
import '../domain/incident_repository.dart';

/// Pluggable county jail & public booking aggregator adapter.
///
/// Queries an external booking API when [AppEnv.useMockData] is false and an
/// API key is supplied via `--dart-define=BOOKING_API_KEY=...`. Automatically
/// falls back to deterministic seeded mock data while strictly enforcing the
/// mandatory 45-day TTL (`ComplianceConstants.computeBookingExpiry`) and
/// `ComplianceConstants.presumedInnocentDisclaimer`.
class CountyJailBookingAdapter implements JailBookingAdapter {
  CountyJailBookingAdapter({
    http.Client? httpClient,
    String? apiKey,
    this.baseUrl = 'https://api.publicbookings.example.gov/v1',
  })  : _httpClient = httpClient ?? http.Client(),
        _apiKey = apiKey ?? AppEnv.bookingApiKey;

  final http.Client _httpClient;
  final String _apiKey;
  final String baseUrl;

  bool get _canCallLiveApi =>
      !AppEnv.useMockData &&
      _apiKey.isNotEmpty &&
      !_apiKey.startsWith('your_');

  @override
  Future<AllegedOffender?> lookupBookingForIncident({
    required String incidentId,
    required String citySlug,
    required String stateCode,
  }) async {
    if (_canCallLiveApi) {
      final liveRecord = await _fetchFromLiveApi(
        incidentId: incidentId,
        citySlug: citySlug,
        stateCode: stateCode,
      );
      if (liveRecord != null) {
        return liveRecord;
      }
    }
    return _lookupMockBooking(incidentId);
  }

  Future<AllegedOffender?> _fetchFromLiveApi({
    required String incidentId,
    required String citySlug,
    required String stateCode,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/bookings/$incidentId').replace(
        queryParameters: <String, String>{
          'city': citySlug,
          'state': stateCode,
        },
      );
      final response = await _httpClient.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final name = decoded['name'];
      final bookingDateRaw = decoded['bookingDate'];
      final sourceAgency = decoded['sourceAgency'];
      final chargesRaw = decoded['charges'];

      if (name is! String ||
          bookingDateRaw is! String ||
          sourceAgency is! String) {
        return null;
      }

      final parsedBookingDate =
          DateTime.tryParse(bookingDateRaw)?.toUtc() ?? DateTime.now().toUtc();
      final charges = chargesRaw is List<dynamic>
          ? chargesRaw.whereType<String>().toList()
          : <String>[];
      final photoUrl = decoded['bookingPhotoUrl'];
      final redacted = decoded['redacted'] == true;

      return enforceCompliance(
        AllegedOffender(
          name: name,
          bookingPhotoUrl: photoUrl is String ? photoUrl : null,
          charges: charges,
          bookingDate: parsedBookingDate,
          sourceAgency: sourceAgency,
          disclaimer: ComplianceConstants.presumedInnocentDisclaimer,
          expiresAt: ComplianceConstants.computeBookingExpiry(
            parsedBookingDate,
          ),
          redacted: redacted,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  AllegedOffender? _lookupMockBooking(String incidentId) {
    final seedIncidents = SeedData.buildSeedIncidents();
    for (final incident in seedIncidents) {
      if (incident.id == incidentId && incident.allegedOffender != null) {
        return enforceCompliance(incident.allegedOffender!);
      }
    }
    return null;
  }

  /// Guarantees every returned booking record carries the mandatory
  /// presumed-innocent disclaimer and 45-day automatic TTL expiration.
  AllegedOffender enforceCompliance(AllegedOffender offender) {
    return offender.copyWith(
      disclaimer: ComplianceConstants.presumedInnocentDisclaimer,
      expiresAt: ComplianceConstants.computeBookingExpiry(offender.bookingDate),
    );
  }
}
