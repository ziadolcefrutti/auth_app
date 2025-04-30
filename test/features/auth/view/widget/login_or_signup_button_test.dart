import 'package:auth_app/core/routers/app_router.dart';
import 'package:auth_app/core/widgets/custom_button.dart';
import 'package:auth_app/features/auth/view/pages/login_page.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/auth_viewmodel_test.mocks.dart';

void main() {
  late AuthViewModel viewModel;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    viewModel = AuthViewModel(mockAuthRepo);
  });
  testWidgets('Login button triggers login and navigates to /home on success', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthViewModel>.value(value: viewModel),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter(initialRoute: '/login'),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '123456');

    await tester.tap(find.byType(CustomButton));
    await tester.pumpAndSettle();

    verify(await viewModel.login('test@example.com', '123456')).called(1);
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(find.byType(HomePage), findsNothing); // ✅ Navigation worked
  });
  testWidgets(
    'sign up button triggers login and navigates to /home on success',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthViewModel>.value(value: viewModel),
          ],
          child: MaterialApp.router(
            routerConfig: appRouter(initialRoute: '/signup'),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'test');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@example.com',
      );

      await tester.enterText(find.byType(TextFormField).at(2), '123456');
      await tester.enterText(find.byType(TextFormField).at(3), '123456');

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      verify(await viewModel.signUp('test@example.com', '123456')).called(1);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byType(LoginPage), findsNothing); // ✅ Navigation worked
    },
  );
}
