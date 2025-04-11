import 'package:auth_app/features/auth/view/pages/signup_page.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

//  A simple mock of AuthViewModel for UI testing
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
    // TODO: implement isLoading
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
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
  Widget createTestWidget({
    required Widget child,
    required String langaugeCode,
  }) {
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

  testWidgets('Sign Up Page basic UI elements test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(child: const SignUpPage(), langaugeCode: 'en'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Welcome! Please fill in your details.'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text("Or Continue With"), findsOneWidget);
    expect(find.text("Google"), findsOneWidget);
    expect(find.text("Facebook"), findsOneWidget);
  });

  // For spanish
   testWidgets('Sign Up Page basic UI elements test in spanish', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(child:  const SignUpPage(),langaugeCode: 'es'));
    await tester.pumpAndSettle();

    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.text('¡Bienvenido! Por favor, complete sus detalles.'), findsOneWidget);
    expect(find.text('Regístrate'), findsOneWidget);
    expect(find.text("O continuar con"), findsOneWidget);
    expect(find.text("Google"), findsOneWidget);
    expect(find.text("Facebook"), findsOneWidget);
  });

  //for Urdu
   testWidgets('Sign Up Page basic UI elements test for Urdu Langauge', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(child:  const SignUpPage(),langaugeCode: 'ur'));
    await tester.pumpAndSettle();

    expect(find.text( "اکاؤنٹ بنائیں"), findsOneWidget);
    expect(find.text("خوش آمدید! براہ کرم اپنے تفصیلات مکمل کریں۔"), findsOneWidget);
    expect(find.text("سائن اپ کریں"), findsOneWidget);
    expect(find.text("یا دوسرے طریقوں سے جاری رکھیں"), findsOneWidget);
    expect(find.text("گوگل"), findsOneWidget);
    expect(find.text("فیس بک"), findsOneWidget);
  });
}
