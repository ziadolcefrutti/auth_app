import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth_app/features/localization/presentation/widgets/langauge_selection_tile.dart';

void main() {
  testWidgets('LanguageSelectionTile displays language name and selects on tap', (WidgetTester tester) async {
    // Arrange
    const testLocale = Locale('en');
    const currentLocale = Locale('en');
    const languageName = 'English 🇺🇸';

    Locale? selectedLocale;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelectionTile(
            languageName: languageName,
            locale: testLocale,
            currentLocale: currentLocale,
            onLanguageSelected: (locale) {
              selectedLocale = locale;
            },
          ),
        ),
      ),
    );

    // Assert text is shown
    expect(find.text(languageName), findsOneWidget);

    // Tap the tile and verify callback is triggered
    await tester.tap(find.byType(ListTile));
    expect(selectedLocale, testLocale);
  });


  testWidgets('LanguageSelectionTile Radio is selected if currentLocale matches', (WidgetTester tester) async {
  // Arrange
  const locale = Locale('es');
  const currentLocale = Locale('es');

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LanguageSelectionTile(
          languageName: 'Español 🇪🇸',
          locale: locale,
          currentLocale: currentLocale,
          onLanguageSelected: (_) {},
        ),
      ),
    ),
  );

  // ✅ Make sure the Radio widget exists before accessing it
  final radioFinder = find.byType(Radio<Locale>);
  expect(radioFinder, findsOneWidget); // Will catch missing widgets gracefully

  final Radio<Locale> radio = tester.widget(radioFinder);
  expect(radio.groupValue, equals(currentLocale));
  expect(radio.value, equals(locale));
  expect(radio.groupValue == radio.value, isTrue);
});

  testWidgets('LanguageSelectionTile Radio is selected if currentLocale matches', (WidgetTester tester) async {
    // Arrange
    const locale = Locale('es');
    const currentLocale = Locale('es');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LanguageSelectionTile(
            languageName: 'Español 🇪🇸',
            locale: locale,
            currentLocale: currentLocale,
            onLanguageSelected: (_) {},
          ),
        ),
      ),
    );

    final Radio radio = tester.widget(find.byType(Radio<Locale>));
    print(radio);
    expect(radio.groupValue, equals(currentLocale));
    expect(radio.value, equals(locale));
    expect(radio.groupValue == radio.value, isTrue);
  });
}
