import 'package:auth_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomButton renders with title and is not loading', (tester) async {
    // Arrange: Create the widget with a title and isLoading as false
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            title: 'Submit',
            onPressed: () {},
            isLoading: false,
          ),
        ),
      ),
    );

    // Assert: Ensure that the button displays the correct title
    expect(find.text('Submit'), findsOneWidget);

    // Assert: Ensure that the loading indicator is not displayed
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Assert: Ensure that the button is enabled and can be tapped
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();

    // Check if onPressed callback is called, we expect no errors (as onPressed does nothing)
  });

  testWidgets('CustomButton shows loading indicator when isLoading is true', (tester) async {
    // Arrange: Create the widget with isLoading as true
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            title: 'Submit',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    // Assert: Ensure that the CircularProgressIndicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Assert: Ensure that the button text is not displayed
    expect(find.text('Submit'), findsNothing);
  });

  testWidgets('CustomButton is disabled when isLoading is true', (tester) async {
    // Arrange: Create the widget with isLoading as true
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            title: 'Submit',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    // Assert: Ensure that the button is disabled and cannot be tapped
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
    final ElevatedButton elevatedButton = tester.widget(button) as ElevatedButton;
    expect(elevatedButton.onPressed, isNull); // Button should be disabled
  });

  testWidgets('CustomButton triggers onPressed when tapped and not loading', (tester) async {
    bool pressed = false;

    // Arrange: Create the widget with isLoading as false and a callback that updates `pressed`
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            title: 'Submit',
            onPressed: () {
              pressed = true;
            },
            isLoading: false,
          ),
        ),
      ),
    );

    // Assert: Ensure that the button is enabled
    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);

    // Act: Tap the button
    await tester.tap(button);
    await tester.pump();

    // Assert: Verify that the onPressed callback was triggered
    expect(pressed, isTrue);
  });
}
