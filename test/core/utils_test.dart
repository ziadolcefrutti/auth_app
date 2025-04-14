

import 'package:auth_app/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// class MockFlutterToast extends Mock implements FlutterToast {}

void main() {
   testWidgets('Flushbar shows up with error message with utils', (WidgetTester tester) async {
    const testMessage = 'Error occurred';
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            // Trigger flushbar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utils.flushBarErrorMessage(testMessage, context);
            });
            return Scaffold(body: Container());
          },
        ),
      ),
    );

    // Allow animation/frame to build
 await tester.pump(const Duration(seconds: 1)); 

    // Verify if flushbar is shown with expected message
    expect(find.byKey(const Key('flushbar')), findsOneWidget);
    expect(find.text(testMessage), findsOneWidget);
    expect(find.byIcon(Icons.error), findsOneWidget);
  });
}
