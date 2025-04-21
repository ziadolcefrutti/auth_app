import 'package:auth_app/core/provider/langauges_provider.dart';
import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/home/presentation/pages/home_page.dart';
import 'package:auth_app/features/localization/presentation/pages/language_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget createWidgetUnderTest({required LanguagesProvider provider}) {
  return MultiProvider(
    providers: [ChangeNotifierProvider.value(value: provider)],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: provider.currentLocale,
      routerConfig: appRouter(initialRoute: RouteNames.localization),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Displays supported languages and selects new one', (
    tester,
  ) async {
    final provider = LanguagesProvider();

    await tester.pumpWidget(createWidgetUnderTest(provider: provider));
    await tester.pumpAndSettle();

    expect(find.textContaining('English'), findsOneWidget);
    expect(find.textContaining('Français'), findsOneWidget);

    await tester.tap(find.textContaining('Français'));
    await tester.pumpAndSettle();

    expect(provider.currentLocale.languageCode, 'fr');

    // print(find.byIcon(Icons.arrow_back));
    // await tester.tap(find.byIcon(Icons.arrow_back));
    // await tester.pumpAndSettle();

    // expect(find.byType(HomePage), findsOneWidget);
  });
}
