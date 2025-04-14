import 'package:auth_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTextField Tests', () {
    testWidgets('renders CustomTextField with label and text input', (tester) async {
      final controller = TextEditingController();
      final label = 'Enter your name';

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: label,
              controller: controller,
            ),
          ),
        ),
      );

      // Ensure label is rendered
      expect(find.text(label), findsOneWidget);

      // Ensure TextFormField is rendered
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('text input is stored in controller', (tester) async {
      final controller = TextEditingController();
      final label = 'Enter your name';

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: label,
              controller: controller,
            ),
          ),
        ),
      );

      // Enter text into the TextField
      await tester.enterText(find.byType(TextFormField), 'John Doe');
      await tester.pump();

      // Verify that the controller's text has been updated
      expect(controller.text, 'John Doe');
    });


    testWidgets('CustomTextField with suffixIcon shows the icon', (tester) async {
      final controller = TextEditingController();
      final label = 'Search';
      final suffixIcon = Icon(Icons.search);

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: label,
              controller: controller,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      );

      // Ensure that the suffix icon is displayed
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    
testWidgets('CustomTextField validation works', (tester) async {
  final controller = TextEditingController();
  final label = 'Email';
  final formKey = GlobalKey<FormState>();
  final validator = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  };

  // Build the widget inside a Form
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: CustomTextField(
            label: label,
            controller: controller,
            validator: validator,
          ),
        ),
      ),
    ),
  );

  // Enter invalid input
  await tester.enterText(find.byType(TextFormField), '');
  await tester.pump();

  // Trigger validation by tapping on the field to make it lose focus
  await tester.tap(find.byType(TextFormField));
  await tester.pump();

  // Trigger form validation explicitly
  formKey.currentState?.validate();
  await tester.pump();

  // Ensure that the validation message is displayed
  expect(find.text('Field cannot be empty'), findsOneWidget);
});

   

    
  });
}
