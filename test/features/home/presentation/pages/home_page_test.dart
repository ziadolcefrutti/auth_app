import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/core/provider/langauges_provider.dart';
import 'package:auth_app/features/auth/presentation/pages/login_page.dart';
import 'package:auth_app/features/home/presentation/pages/home_page.dart';
import 'package:auth_app/features/localization/presentation/pages/language_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/core/routes/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../mock/mock_auths_provider.mocks.dart';

// Mock Auth Provider

Widget createWidgetUnderTest(MockAuthsProvider mockAuthsProvider) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthsProvider>.value(value: mockAuthsProvider),
      ChangeNotifierProvider<LanguagesProvider>(
        create: (_) => LanguagesProvider(),
      ),
    ],
    child: MaterialApp.router(
      routerConfig: appRouter(initialRoute: RouteNames.home),
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('Displays user email when loaded', (tester) async {
      final mockProvider = MockAuthsProvider();
      when(
        mockProvider.user,
      ).thenReturn(UserEntity(uid: '1', email: 'john@example.com'));

      await tester.pumpWidget(createWidgetUnderTest(mockProvider));
      await tester.pump(); // for postFrameCallback + Consumer

      expect(find.textContaining('john@example.com'), findsOneWidget);
    });

    testWidgets('Shows loading indicator if user is null', (tester) async {
      final mockProvider = MockAuthsProvider();
      when(mockProvider.user).thenReturn(null);

      await tester.pumpWidget(createWidgetUnderTest(mockProvider));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Navigates to Language page on language icon tap', (
      tester,
    ) async {
      final mockProvider = MockAuthsProvider();
      when(
        mockProvider.user,
      ).thenReturn(UserEntity(uid: '1', email: 'test@test.com'));

      await tester.pumpWidget(createWidgetUnderTest(mockProvider));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      expect(find.byType(LanguageSelectPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Shows logout dialog on logout icon tap', (tester) async {
      final mockProvider = MockAuthsProvider();
      when(
        mockProvider.user,
      ).thenReturn(UserEntity(uid: '1', email: 'test@test.com'));

      await tester.pumpWidget(createWidgetUnderTest(mockProvider));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump(); // for dialog

      expect(find.text('Are you sure you want to log out?'), findsOneWidget);
    });

    testWidgets('Dismisses logout dialog on cancel', (tester) async {
      final mockProvider = MockAuthsProvider();
      when(
        mockProvider.user,
      ).thenReturn(UserEntity(uid: '1', email: 'test@test.com'));

      await tester.pumpWidget(createWidgetUnderTest(mockProvider));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Calls signOut and navigates to login on confirm', (
      tester,
    ) async {
      final mockProvider = MockAuthsProvider();

      when(
        mockProvider.user,
      ).thenReturn(UserEntity(uid: '1', email: 'test@test.com'));
      when(mockProvider.isLoading).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest(mockProvider));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      verify(mockProvider.signOut()).called(1);
      expect(
        find.byType(LoginPage),
        findsOneWidget,
      ); // ✔ You're now on login page
    });
  });
}
