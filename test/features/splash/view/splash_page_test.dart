import 'package:auth_app/core/constants/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:auth_app/features/splash/view/pages/splash_page.dart';
import 'package:auth_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockSplashViewModel extends Mock implements SplashViewModel {}

void main() {
  testWidgets('SplashPage basic UI test', (WidgetTester tester) async {
    final mockViewModel = MockSplashViewModel();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SplashViewModel>.value(value: mockViewModel),
          ChangeNotifierProvider(create: (_) => LanguagesProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SplashPage(),
        ),
      ),
    );

    // Let post frame callback run
    await tester.pump();

    // Check that icon and texts appear
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(
      find.text('Welcome'),
      findsOneWidget,
    ); // Adjust if your localized text differs
    expect(find.text('Loading...'), findsOneWidget);

    // Find widgets by type
    final scaffoldFinder = find.byType(Scaffold);
    final iconFinder = find.byType(Icon);
    final textFinder = find.byType(Text);

    // Verify if the background color is AppColors.primary
    final scaffoldWidget = tester.widget<Scaffold>(scaffoldFinder);
    expect(scaffoldWidget.backgroundColor, AppColors.primary);

    // Verify if the Icon has the correct color
    final iconWidget = tester.widget<Icon>(iconFinder);
    expect(iconWidget.color, AppColors.white);

    // Verify if the first Text widget (welcome message) has the correct color
    final welcomeTextWidget = tester.widget<Text>(textFinder.first);
    expect(welcomeTextWidget.style?.color, AppColors.white);
  });
}
