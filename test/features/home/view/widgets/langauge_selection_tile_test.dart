import 'package:auth_app/features/home/view/widgets/langauge_selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LanguageSelectionTile triggers onLanguageSelected when tapped', (
    WidgetTester tester,
  ) async {
    // Arrange
    Locale selectedLocale = const Locale('en');
    Locale tappedLocale = const Locale('fr');

    Locale? callbackValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelectionTile(
            languageName: 'French',
            locale: tappedLocale,
            currentLocale: selectedLocale,
            onLanguageSelected: (Locale value) {
              callbackValue = value;
            },
          ),
        ),
      ),
    );

    // Act: tap the tile
    await tester.tap(find.byType(ListTile));
    await tester.pump();

    // Assert: callback should be called with tappedLocale
    expect(callbackValue, equals(tappedLocale));
  });

  testWidgets(
    'LanguageSelectionTile triggers onLanguageSelected when radio is changed',
    (WidgetTester tester) async {
      // Arrange
      Locale selectedLocale = const Locale('en');
      Locale tappedLocale = const Locale('fr');

      Locale? callbackValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LanguageSelectionTile(
              languageName: 'French',
              locale: tappedLocale,
              currentLocale: selectedLocale,
              onLanguageSelected: (Locale value) {
                callbackValue = value;
              },
            ),
          ),
        ),
      );

      // Act: tap the radio button
      await tester.tap(find.byType(Radio<Locale>));
      await tester.pump();

      // Assert: callback should be called with tappedLocale
      expect(callbackValue, equals(tappedLocale));
    },
  );
}
