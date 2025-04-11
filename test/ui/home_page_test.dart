import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:auth_app/features/home/view/pages/home_page.dart';
import 'package:auth_app/features/home/view/pages/langauge_selection_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
Widget createTestWidget({required Widget child, required String langaugeCode}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthViewModel>(create: (_) => MockAuthViewModel()),
      ChangeNotifierProvider(create: (_) => LanguagesProvider()),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(langaugeCode),
      home: child,
    ),
  );
}

void main() {
  group('Home page testing', () {
    testWidgets('HomePage displays localized hello message in English', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: const HomePage(), langaugeCode: 'en'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget); // AppBar title
      expect(find.text('Hello, test@example.com'), findsOneWidget); // Body text
    });

    testWidgets('HomePage displays localized hello message in Spanish', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: const HomePage(), langaugeCode: 'es'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Hola, test@example.com'), findsOneWidget);
    });

    testWidgets('HomePage displays localized hello message in Urdu', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: const HomePage(), langaugeCode: 'ur'),
      );
      await tester.pumpAndSettle();

      expect(find.text('خوش آمدید'), findsOneWidget);
      expect(find.text('ہیلو, test@example.com'), findsOneWidget);
    });
  });


  //langauge selection page
  group('langauge selection page testing', () {
    testWidgets('langauge selection page English', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSelectPage(), langaugeCode: 'en'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select Langauge'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('Urdu'), findsOneWidget);
    });

    testWidgets('langauge selection page Spanish', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSelectPage(), langaugeCode: 'es'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Seleccione Idioma'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('Urdu'), findsOneWidget);
    });

    testWidgets('langauge selection page urdu', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSelectPage(), langaugeCode: 'ur'),
      );
      await tester.pumpAndSettle();

      expect(find.text("زبان منتخب کریں"), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
      expect(find.text('Urdu'), findsOneWidget);
    });
  });
}
