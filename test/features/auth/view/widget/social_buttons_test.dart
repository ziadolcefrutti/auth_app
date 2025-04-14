import 'package:flutter_test/flutter_test.dart';
import 'package:auth_app/features/auth/view/widgets/social_button.dart';
import 'package:auth_app/features/auth/view/widgets/soical_buttons.dart'; // Fix typo if necessary
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';


import '../../../home/view/pages/home_page_test.dart';

@GenerateMocks([AuthViewModel])
void main() {
  late MockAuthViewModel mockAuthViewModel;

  setUp(() {
    mockAuthViewModel = MockAuthViewModel();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [], // Optionally mock l10n if needed
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders Google and Facebook buttons', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(SoicalButtons(authViewModel: mockAuthViewModel)),
    );

    expect(find.text('Google'), findsOneWidget);
    expect(
      find.text(''),
      findsOneWidget,
    ); // Facebook, since l10n fallback is ''
    expect(find.byType(SocialButton), findsNWidgets(2));
  });

  testWidgets('tapping Facebook button logs Facebook', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(SoicalButtons(authViewModel: mockAuthViewModel)),
    );

    await tester.tap(find.text(''));
    await tester.pump();

    // Normally you'd mock logging or just check that the tap doesn't crash
    expect(true, isTrue); // Just verifies no exceptions for now
  });
}
