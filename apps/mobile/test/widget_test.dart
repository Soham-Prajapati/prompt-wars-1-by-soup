import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stadium_iq/main.dart';

void main() {
  testWidgets('StadiumIQ app boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StadiumIQApp(),
      ),
    );

    // App builds and initial frame renders.
    expect(find.byType(StadiumIQApp), findsOneWidget);
  });
}
