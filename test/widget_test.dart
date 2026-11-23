import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crime_maps/main.dart';

void main() {
  testWidgets('CrimeMapsBootstrapApp renders title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CrimeMapsBootstrapApp()),
    );
    expect(find.text('Crime Maps'), findsOneWidget);
  });
}
