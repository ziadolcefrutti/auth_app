import 'package:auth_app/core/routers/app_router.dart';
import 'package:auth_app/features/auth/view/pages/login_page.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:auth_app/features/home/view/pages/home_page.dart';
import 'package:auth_app/features/home/view/pages/langauge_selection_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// A simple mock of AuthViewModel for UI testing
class MockAuthViewModel extends ChangeNotifier implements AuthViewModel {
  @override
  bool get isLoading => false;

  @override
  bool get isAuthStatus => true;

  @override
  String get errorMessage => '';

  @override
  Future<void> login(String email, String password) async {}

  @override
  User? currentUser = _FakeUser();

  @override
  set isAuthStatus(bool _isAuthStatus) {}

  @override
  set isLoading(bool _isLoading) {}

  @override
  Future<void> logout() async {}

  @override
  void setCurrentUserData() {}

  @override
  void setIsAuthStatus(bool val) {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signUp(String email, String password) async {}

  @override
  set errorMessage(String _errorMessage) {}
}

// Fake User implementation
class _FakeUser extends Fake implements User {
  @override
  String get email => 'test@example.com';
}

// Reusable test widget wrapper with localization and providers
Widget createTestWidget({required String route, required String langaugeCode}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthViewModel>(create: (_) => MockAuthViewModel()),
      ChangeNotifierProvider(create: (_) => LanguagesProvider()),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(langaugeCode),
      routerConfig: appRouter(initialRoute: route),
    ),
  );
}

void main() {
  group('Home page testing', () {
    testWidgets('HomePage displays localized hello message in English', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/home', langaugeCode: 'en'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget); // AppBar title
      expect(find.text('Hello, test@example.com'), findsOneWidget); // Body text

      final languageButton = find.byIcon(Icons.language);
      await tester.tap(languageButton);
      await tester.pumpAndSettle(); // Wait for navigation

      // Check if navigation happened (assuming '/language' is a route in your app)
      expect(
        find.byType(LanguageSelectPage),
        findsOneWidget,
      ); // Replace SomeLanguagePage with your language page widget

      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle(); // Wait for navigation

      // Check if navigation happened (assuming '/language' is a route in your app)
      expect(find.byType(HomePage), findsOneWidget);

      // Now check for the logout IconButton and tap it
      final logoutButton = find.byIcon(Icons.logout);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle(); // Allow the dialog to appear

      // // Verify that the logout confirmation dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);

      // // // Find the "Confirm" button and tap it
      final cancelButton = find.text('Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle(); // Wait for navigation

      // // Verify that the user is logged out and redirected to the login page (or whatever route '/login' leads to)
      expect(find.byType(HomePage), findsOneWidget);

      await tester.tap(logoutButton);
      await tester.pumpAndSettle(); // Allow the dialog to appear

      // // Verify that the logout confirmation dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);

      final confirmButton = find.text('Confirm');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle(); // Wait for navigation

      // Verify that the user is logged out and redirected to the login page (or whatever route '/login' leads to)
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('HomePage displays localized hello message in Spanish', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/home', langaugeCode: 'es'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Hola, test@example.com'), findsOneWidget);
    });

    testWidgets('HomePage displays localized hello message in Urdu', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/home', langaugeCode: 'ur'),
      );
      await tester.pumpAndSettle();

      expect(find.text('خوش آمدید'), findsOneWidget);
      expect(find.text('ہیلو, test@example.com'), findsOneWidget);
    });
  });
}

