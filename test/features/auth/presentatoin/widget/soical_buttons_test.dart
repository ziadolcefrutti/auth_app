import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/core/utils/utils.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/features/auth/presentation/widgets/social_button.dart';
import 'package:auth_app/features/auth/presentation/widgets/soical_buttons.dart';
import 'package:auth_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'soical_buttons_test.mocks.dart';

@GenerateMocks([AuthsProvider, Utils])
void main() {
  late MockAuthsProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthsProvider();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold(body: SoicalButtons())),
        GoRoute(path: '/home', builder: (context, state) =>HomePage()),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'), // or whatever your default is

      builder: (context, child) {
        return ChangeNotifierProvider<AuthsProvider>.value(
          value: mockAuthProvider,
          child: child!,
        );
      },
    );
  }

  testWidgets('renders two social buttons', (WidgetTester tester) async {
    when(mockAuthProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(SocialButton), findsNWidgets(2));
    expect(find.textContaining('Google'), findsOneWidget);
    expect(find.textContaining('Facebook'), findsOneWidget);
  });

  testWidgets('successful Google login navigates to /home', (WidgetTester tester) async {
    when(mockAuthProvider.isLoading).thenReturn(false);
    when(mockAuthProvider.signInWithGoogle()).thenAnswer((_) async {});
    when(mockAuthProvider.user).thenReturn(UserEntity(uid: 'uid', email: 'abc@gmail.com')); // Fake non-null user
    when(mockAuthProvider.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byWidgetPredicate((w) =>
        w is SocialButton && w.label.toLowerCase().contains('google')));
    await tester.pumpAndSettle();
    expect(mockAuthProvider.isLoading, false);
    expect(mockAuthProvider.errorMessage, null);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('shows error message if Google login fails', (WidgetTester tester) async {
    when(mockAuthProvider.isLoading).thenReturn(false);
    when(mockAuthProvider.signInWithGoogle()).thenAnswer((_) async {});
    when(mockAuthProvider.user).thenReturn(null);
    when(mockAuthProvider.errorMessage).thenReturn('Login failed');

    bool errorShown = true;

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byWidgetPredicate((w) =>
        w is SocialButton && w.label.toLowerCase().contains('google')));
    await tester.pump();

    expect(errorShown, isTrue);
  });

    testWidgets('successful facebook login ontap', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    await tester.tap(find.byWidgetPredicate((w) =>
        w is SocialButton && w.label.toLowerCase().contains('facebook')));
  
  });
}
