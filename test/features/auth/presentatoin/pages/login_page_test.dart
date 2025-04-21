import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/core/common/widgets/custom_button.dart';
import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../../../mock/mock_auths_provider.mocks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  late MockAuthsProvider mockAuthsProvider;

  setUp(() {
    mockAuthsProvider = MockAuthsProvider();
  });

  Widget createWidgetUnderTest({required String langaugeCode}) {
    return ChangeNotifierProvider<AuthsProvider>.value(
      value: mockAuthsProvider,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(langaugeCode), // or whatever your default is
        routerConfig: appRouter(initialRoute: RouteNames.login),
      ),
    );
  }

  testWidgets('Simple ui components', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest(langaugeCode: 'en'));

    expect(find.byType(CustomButton), findsOneWidget);
    expect(find.text('Login In Account'), findsOneWidget);
    expect(find.text('Hello! Welcome back to your account!'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.text("Or Continue With"), findsOneWidget);
    expect(find.text("Google"), findsOneWidget);
    expect(find.text("Facebook"), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    final forgotPassword = find.text('Forgot Password?');
    await tester.tap(forgotPassword);

    final signupButton = find.text('Sign Up');
    await tester.tap(signupButton);
    await tester.pumpAndSettle(Duration(seconds: 1)); // Wait for navigation
    expect(find.byType(SignUpPage), findsOneWidget); // ✅ Match actual text
  });

  testWidgets('Shows validation error when fields are empty', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest(langaugeCode: 'en'));

    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Login Page basic UI elements test spanish', (
    WidgetTester tester,
  ) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest(langaugeCode: 'es'));

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
  testWidgets('Login Page basic UI elements test urdu', (
    WidgetTester tester,
  ) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest(langaugeCode: 'ur'));

    expect(find.text("اکاؤنٹ میں لاگ ان کریں"), findsOneWidget);
    expect(find.text("لاگ ان کریں"), findsOneWidget);
    expect(find.text("کیا آپ کے پاس اکاؤنٹ نہیں ہے؟"), findsOneWidget);
    expect(find.text("یا دوسرے طریقوں سے جاری رکھیں"), findsOneWidget);
    expect(find.text("گوگل"), findsOneWidget);
    expect(find.text("فیس بک"), findsOneWidget);
    expect(find.text("کیا آپ نے اپنا پاسورڈ بھول لیا؟"), findsOneWidget);
  });

  testWidgets('Calls signIn on valid input', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);
    when(
      mockAuthsProvider.user,
    ).thenReturn(UserEntity(uid: '1', email: 'test@example.com'));
    when(mockAuthsProvider.errorMessage).thenReturn(null);
    when(mockAuthsProvider.signIn(any, any)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest(langaugeCode: 'en'));

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '123456');

    await tester.tap(find.byType(CustomButton));
    await tester.pumpAndSettle();

    verify(mockAuthsProvider.signIn('test@example.com', '123456')).called(1);
  });

  testWidgets('Shows error message on login failure', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);
    when(mockAuthsProvider.user).thenReturn(null);
    when(mockAuthsProvider.errorMessage).thenReturn('Invalid credentials');
    when(mockAuthsProvider.signIn(any, any)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest(langaugeCode: 'en'));

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'fail@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');

    await tester.tap(find.byType(CustomButton));

    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
