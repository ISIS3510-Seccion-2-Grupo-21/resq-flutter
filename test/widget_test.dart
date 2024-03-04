import 'package:flutter_test/flutter_test.dart';

import 'package:resq/main.dart';

void main() {
  testWidgets('App displays "Hello World!"', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that the text "Hello World!" is displayed.
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
