import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crime_maps/app.dart';
import 'package:crime_maps/core/geo/location_service.dart';

class _FakeLocationGateway implements LocationGateway {
  @override
  Future<UserLocationFix> getCurrentLocation() async =>
      UserLocationFix.atlantaDefault;

  @override
  Stream<UserLocationFix> watchLocation() =>
      Stream<UserLocationFix>.value(UserLocationFix.atlantaDefault);
}

void main() {
  testWidgets('CrimeMapsApp boots shell with persistent navigation tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          locationGatewayProvider.overrideWithValue(_FakeLocationGateway()),
        ],
        child: const CrimeMapsApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Geo-Radio'), findsOneWidget);
    expect(find.text('Radar'), findsOneWidget);
    expect(find.text('Creator'), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);
  });
}
