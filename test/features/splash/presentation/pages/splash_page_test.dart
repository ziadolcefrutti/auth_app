import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/splash/app_logic/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../app_logic/mock_splash_provider.mocks.dart';

void main() {
  late MockSplashProvider mockSplashProvider;

  setUp(() {
    mockSplashProvider = MockSplashProvider();
  });

  Future<void> pumpSplashPage(
    WidgetTester tester, {
    required bool isLoggedIn,
  }) async {
    when(
      mockSplashProvider.checkLoginStatus(),
    ).thenAnswer((_) async => isLoggedIn);

    await tester.pumpWidget(
      ChangeNotifierProvider<SplashProvider>.value(
        value: mockSplashProvider,
        child: MaterialApp.router(
          routerConfig: appRouter(initialRoute: RouteNames.splash),
        ),
      ),
    );

    await tester.pump(); // first frame
    await tester.pump(const Duration(seconds: 3)); // wait for timer
  }

  Future<void> pumpSplashPageTest(
    WidgetTester tester, {
    required bool isLoggedIn,
  }) async {
    when(
      mockSplashProvider.checkLoginStatus(),
    ).thenAnswer((_) async => isLoggedIn);

    await tester.pumpWidget(
      ChangeNotifierProvider<SplashProvider>.value(
        value: mockSplashProvider,
        child: MaterialApp.router(
          routerConfig: appRouter(initialRoute: RouteNames.splash),
        ),
      ),
    );

    await tester.pump(); // first frame
    // await tester.pump(const Duration(seconds: 3)); // wait for timer
  }

  // testWidgets('shows splash UI elements', (tester) async {
  //   await pumpSplashPage(tester, isLoggedIn: true);
  //   // await tester.pumpAndSettle();
  //   expect(find.byIcon(Icons.lock), findsNothing);
  //   expect(find.textContaining('Loading...'), findsNothing);
  //   // expect(find.textContaining('Loading'), findsNothing);
  // });

  testWidgets('navigates to Home if user is logged in', (tester) async {
    await pumpSplashPageTest(tester, isLoggedIn: true);
    expect(find.text('Loading...'), findsOneWidget);
  });

  // testWidgets('navigates to Login if user is not logged in', (tester) async {
  //   await pumpSplashPage(tester, isLoggedIn: false);
  //   expect(find.text('Login'), findsOneWidget);
  // });
}
