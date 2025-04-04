import 'package:auth__app/views/home_view/localization_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:auth__app/view_model/langauge_view_model.dart';
import 'package:auth__app/core/localization.dart';
import 'package:auth__app/main.dart'; // Replace with the correct import path for your app

void main() {
  testWidgets('AppBar Localization Test', (WidgetTester tester) async {
    // Create a mock LocalizationViewModel
    final localizationViewModel = LocalizationViewModel();

    // Build the widget with the LocalizationViewModel provided via ChangeNotifierProvider.
    await tester.pumpWidget(
      ChangeNotifierProvider<LocalizationViewModel>(
        create: (_) => localizationViewModel,
        child: MaterialApp(
          home: LocalizationView(),
        ),
      ),
    );

    // Wait for the widget tree to settle
    await tester.pumpAndSettle();

    // Verify the initial AppBar title based on the default locale (likely English).
    expect(find.text('Welcome'), findsOneWidget);  // Assuming 'welcome' translates to 'Welcome' in English.

    // Change locale to Spanish (es)
    localizationViewModel.changeLanguage(Locale('es'));
    await tester.pumpAndSettle();

    // Verify the AppBar title changes to Spanish (assuming translation exists for 'welcome' in Spanish)
    expect(find.text('Bienvenido'), findsOneWidget); // Assuming 'welcome' translates to 'Bienvenido' in Spanish.

    // Change locale to Urdu (ur)
    localizationViewModel.changeLanguage(Locale('ur'));
    await tester.pumpAndSettle();

    // Verify the AppBar title changes to Urdu (assuming translation exists for 'welcome' in Urdu)
    expect(find.text('خوش آمدید'), findsOneWidget); // Assuming 'welcome' translates to 'خوش آمدید' in Urdu.
  });
}
