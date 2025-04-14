import 'package:auth_app/core/routers/app_router.dart';
import 'package:auth_app/core/widgets/custom_button.dart';
import 'package:auth_app/core/widgets/custom_text_field.dart';
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
  Widget createTestWidget({
    required String route,
    required String langaugeCode,
  }) {
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
        routerConfig: appRouter(initialRoute: route),
      ),
    );
  }

  group('Sin up Page', () {
    testWidgets('Sign Up Page basic UI elements test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'en'),
      );
      await tester.pumpAndSettle();
      final nameField = find.byType(TextFormField).first;
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);
      final confirmPasswordField = find.byType(TextFormField).at(3);

      await tester.enterText(nameField, 'zia');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'testpassword123');
      await tester.enterText(confirmPasswordField, 'testpassword123');

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(HeaderText), findsOneWidget);
      expect(find.byType(CustomTextField), findsAtLeast(4));
      expect(find.byType(AuthDivider), findsOneWidget);
      expect(find.byType(SoicalButtons), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(
        find.text('Welcome! Please fill in your details.'),
        findsOneWidget,
      );
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text("Or Continue With"), findsOneWidget);
      expect(find.text("Google"), findsOneWidget);
      expect(find.text("Facebook"), findsOneWidget);

      // final signupButton = find.text('Log in');
      // print(signupButton);
      // await tester.tap(signupButton);
      // await tester.pumpAndSettle(Duration(seconds: 1)); // Wait for navigation
      // expect(find.byType(SignUpPage), findsOneWidget);
    });

    // For spanish
    testWidgets('Sign Up Page basic UI elements test in spanish', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'es'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Crear cuenta'), findsOneWidget);
      expect(
        find.text('¡Bienvenido! Por favor, complete sus detalles.'),
        findsOneWidget,
      );
      expect(find.text('Regístrate'), findsOneWidget);
      expect(find.text("O continuar con"), findsOneWidget);
      expect(find.text("Google"), findsOneWidget);
      expect(find.text("Facebook"), findsOneWidget);
    });

    //for Urdu
    testWidgets('Sign Up Page basic UI elements test for Urdu Langauge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'ur'),
      );
      await tester.pumpAndSettle();

      expect(find.text("اکاؤنٹ بنائیں"), findsOneWidget);
      expect(
        find.text("خوش آمدید! براہ کرم اپنے تفصیلات مکمل کریں۔"),
        findsOneWidget,
      );
      expect(find.text("سائن اپ کریں"), findsOneWidget);
      expect(find.text("یا دوسرے طریقوں سے جاری رکھیں"), findsOneWidget);
      expect(find.text("گوگل"), findsOneWidget);
      expect(find.text("فیس بک"), findsOneWidget);
    });

    testWidgets('SignUpRedirect triggers onTap when button is pressed', (
      WidgetTester tester,
    ) async {
      // A flag to check if the callback is called
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignUpRedirect(
              accountTitle: 'Already have an account?',
              buttonTitle: 'Log in',
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the TextButton
      await tester.tap(find.text('Log in'));
      await tester.pump();

      // Expect the onTap was called
      expect(wasTapped, isTrue);
    });

    testWidgets('Empty fields show validation errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'en'),
      );

      // Tap Sign Up Button
      final signUpButton = find.text('Sign Up');
      expect(signUpButton, findsOneWidget);

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('Password mismatch shows error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'en'),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'wrongPassword');

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(2), '123');
    });

    testWidgets('Password length', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'en'),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '123');

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextFormField).at(2), '123');
    });

    testWidgets(' Password Show/Hide functionality', (
      WidgetTester tester,
    ) async {
      // Build the LoginPage widget
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'en'),
      );

      // Find the password field and visibility icon
      final passwordField = find
          .byType(CustomTextField)
          .at(2); // Assuming it's the second CustomTextField
      final visibilityIcon = find.byIcon(Icons.visibility_off).first;

      // Initially, the password field should be obscured
      expect(
        find.byType(TextFormField),
        findsWidgets,
      ); // Ensure there is a TextFormField
      expect(passwordField, findsOneWidget);
      expect(visibilityIcon, findsWidgets);

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
      expect(find.byIcon(Icons.visibility_off).first, findsOneWidget);
    });

    testWidgets('confrim Password Show/Hide functionality', (
      WidgetTester tester,
    ) async {
      // Build the LoginPage widget
      await tester.pumpWidget(
        createTestWidget(route: '/signup', langaugeCode: 'en'),
      );

      // Find the password field and visibility icon
      final passwordField = find
          .byType(CustomTextField)
          .at(3); // Assuming it's the second CustomTextField
      final visibilityIcon = find.byIcon(Icons.visibility_off).last;

      // Initially, the password field should be obscured
      expect(
        find.byType(TextFormField),
        findsWidgets,
      ); // Ensure there is a TextFormField
      expect(passwordField, findsOneWidget);
      expect(visibilityIcon, findsWidgets);

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
      expect(find.byIcon(Icons.visibility_off).last, findsOneWidget);
    });
  });
}
