import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:auth_app/features/home/view/pages/langauge_selection_page.dart';
import 'package:auth_app/features/home/view/widgets/langauge_selection_tile.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'home_page_test.dart';

void main() {
  group('langauge selection page testing', () {
    testWidgets('langauge selection page English', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(route: '/language', langaugeCode: 'en'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LanguageSelectionTile), findsWidgets);

      expect(find.text('Select Langauge'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('Urdu'), findsOneWidget);
    });

    testWidgets('langauge selection page Spanish', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(route: '/language', langaugeCode: 'es'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Seleccione Idioma'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('Urdu'), findsOneWidget);
    });

    testWidgets('langauge selection page urdu', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(route: '/language', langaugeCode: 'ur'),
      );
      await tester.pumpAndSettle();
      final languageProvider = Provider.of<LanguagesProvider>(
        tester.element(find.byType(LanguageSelectPage)),
        listen: false,
      );

      expect(find.text("زبان منتخب کریں"), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('Urdu'), findsOneWidget);

      await tester.tap(find.text('Spanish'));
      await tester.pumpAndSettle(); // Allow the UI to settle

      // Check if the locale has changed to Spanish
      expect(languageProvider.currentLocale, Locale('es'));
    });
  });
}
