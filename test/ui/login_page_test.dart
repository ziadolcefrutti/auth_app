import 'package:auth_app/features/auth/view/pages/login_page.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
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
  bool get isAuthStatus => false;

  @override
  String get errorMessage => '';

  @override
  Future<void> login(String email, String password) async {}

  @override
  User? currentUser;

  @override
  set isAuthStatus(bool _isAuthStatus) {
  }

  @override
  set isLoading(bool _isLoading) {
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  void setCurrentUserData() {
  }

  @override
  void setIsAuthStatus(bool val) {
  }

  @override
  Future<void> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(String email, String password) {
    throw UnimplementedError();
  }

  @override
  set errorMessage(String _errorMessage) {
  }
}

void main() {
  Widget createTestWidget({required Widget child, required langaugeCode}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => MockAuthViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => LanguagesProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(langaugeCode), // or whatever your default is
        home: child,
      ),
    );
  }

  testWidgets('Login Page basic UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(child: const LoginPage(), langaugeCode: 'en'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login In Account'), findsOneWidget);
    expect(find.text('Hello! Welcome back to your account!'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.text("Or Continue With"), findsOneWidget);
    expect(find.text("Google"), findsOneWidget);
    expect(find.text("Facebook"), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  //for spanish
  testWidgets('Login Page basic UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(child: const LoginPage(), langaugeCode: 'es'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión en cuenta'), findsOneWidget);
    expect(
      find.text('¡Hola! ¡Bienvenido de nuevo a tu cuenta!'),
      findsOneWidget,
    );
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text("¿No tienes una cuenta?"), findsOneWidget);
    expect(find.text("O continuar con"), findsOneWidget);
    expect(find.text("Google"), findsOneWidget);
    expect(find.text("Facebook"), findsOneWidget);
    expect(find.text('¿Has olvidado tu contraseña?'), findsOneWidget);
  });

  //for Urdu langauge
  testWidgets('Login Page basic UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(child: const LoginPage(), langaugeCode: 'ur'),
    );
    await tester.pumpAndSettle();

    expect(find.text("اکاؤنٹ میں لاگ ان کریں"), findsOneWidget);
    expect(
      find.text("ہیلو! آپ کے اکاؤنٹ میں دوبارہ خوش آمدید!"),
      findsOneWidget,
    );
    expect(find.text("لاگ ان کریں"), findsOneWidget);
    expect(find.text("کیا آپ کے پاس اکاؤنٹ نہیں ہے؟"), findsOneWidget);
    expect(find.text("یا دوسرے طریقوں سے جاری رکھیں"), findsOneWidget);
    expect(find.text("گوگل"), findsOneWidget);
    expect(find.text("فیس بک"), findsOneWidget);
    expect(find.text("کیا آپ نے اپنا پاسورڈ بھول لیا؟"), findsOneWidget);
  });
}
