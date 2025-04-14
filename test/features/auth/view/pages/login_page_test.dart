import 'package:auth_app/core/routers/app_router.dart';
import 'package:auth_app/core/widgets/custom_button.dart';
import 'package:auth_app/core/widgets/custom_text_field.dart';
import 'package:auth_app/features/auth/view/pages/signup_page.dart';
import 'package:auth_app/features/auth/view/widgets/auth_divider.dart';
import 'package:auth_app/features/auth/view/widgets/header_text.dart';
import 'package:auth_app/features/auth/view/widgets/sign_up_redirect.dart';
import 'package:auth_app/features/auth/view/widgets/soical_buttons.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../home/view/pages/home_page_test.dart';

void main() {
  Widget createTestWidget({required langaugeCode}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => MockAuthViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => LanguagesProvider()),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(langaugeCode), // or whatever your default is
        routerConfig: appRouter(initialRoute: '/login'),
      ),
    );
  }

  testWidgets('Login Page basic UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(langaugeCode: 'en'));
    await tester.pumpAndSettle();
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).at(1);

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'testpassword123');

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(HeaderText), findsOneWidget);
    expect(find.byType(CustomTextField), findsAtLeast(2));
    expect(find.byType(AuthDivider), findsOneWidget);
    expect(find.byType(SoicalButtons), findsOneWidget);
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

  //for spanish
  testWidgets('Login Page basic UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(langaugeCode: 'es'));
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
    await tester.pumpWidget(createTestWidget(langaugeCode: 'ur'));
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

  testWidgets('Email and Password Validators work correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget(langaugeCode: 'en'));

    await tester.pumpAndSettle();

    // Find the email and password fields
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).at(1);

    // Test the email validator when email is empty
    await tester.enterText(emailField, ''); // Empty email
    await tester.tap(find.byType(CustomButton)); // Trigger form submission
    await tester.pump(); // Wait for the UI to update

    // Check if the error message for email is shown
    expect(find.text('Please enter your email'), findsOneWidget);

    // Test the password validator when password is empty
    await tester.enterText(passwordField, ''); // Empty password
    await tester.tap(find.byType(CustomButton)); // Trigger form submission
    await tester.pump(); // Wait for the UI to update

    // // Check if the error message for password is shown
    expect(find.text('Please enter your password'), findsOneWidget);

    // // Test the password validator when password is too short (less than 6 characters)
    await tester.enterText(passwordField, '123'); // Short password
    await tester.tap(find.byType(CustomButton)); // Trigger form submission
    await tester.pump(); // Wait for the UI to update

    // Check if the error message for password length is shown
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('SignUpRedirect triggers onTap when button is pressed', (
    WidgetTester tester,
  ) async {
    // A flag to check if the callback is called
    bool wasTapped = false;

    // Create the widget with a custom onTap callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SignUpRedirect(
            accountTitle: 'Don\'t have an account?',
            buttonTitle: 'Sign Up',
            onTap: () {
              // Update the flag when the button is tapped
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    // Tap the 'Sign Up' button
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle(); // Wait for async operations to complete

    // Check if the onTap was triggered
    expect(wasTapped, isTrue);
  });

  testWidgets('Test Password Show/Hide functionality', (
    WidgetTester tester,
  ) async {
    // Build the LoginPage widget
    await tester.pumpWidget(createTestWidget(langaugeCode: 'en'));

    // Find the password field and visibility icon
    final passwordField = find
        .byType(CustomTextField)
        .at(1); // Assuming it's the second CustomTextField
    final visibilityIcon = find.byIcon(Icons.visibility_off);

    // Initially, the password field should be obscured
    expect(
      find.byType(TextFormField),
      findsWidgets,
    ); // Ensure there is a TextFormField
    expect(passwordField, findsOneWidget);
    expect(visibilityIcon, findsOneWidget);

    // Tap the visibility icon to show password
    await tester.tap(visibilityIcon);
    await tester.pump();

    // Now, the password field should be visible
    final visibilityIconVisible = find.byIcon(Icons.visibility);
    expect(visibilityIconVisible, findsOneWidget);

    // Tap again to hide password
    await tester.tap(visibilityIconVisible);
    await tester.pump();

    // Ensure the visibility icon is back to "off"
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });
}
