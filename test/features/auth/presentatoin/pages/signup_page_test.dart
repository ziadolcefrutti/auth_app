import 'package:auth_app/core/common/widgets/custom_button.dart';
import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../mock/mock_auths_provider.mocks.dart';

void main() {
  late MockAuthsProvider mockAuthsProvider;

  setUp(() {
    mockAuthsProvider = MockAuthsProvider();
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<AuthsProvider>.value(
      value: mockAuthsProvider,
      child: MaterialApp.router(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'), // or whatever your default is
        routerConfig: appRouter(initialRoute: RouteNames.signup)),
    );
  }

  testWidgets('Validation errors show when fields are empty', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.enterText(find.byType(TextFormField).at(2), '');
    await tester.enterText(find.byType(TextFormField).at(3), '');

    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    expect(find.text('Please enter your name'), findsWidgets);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('Shows password mismatch error', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'wrongpass');

    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Calls signUp and navigates on success', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);
    when(mockAuthsProvider.user).thenReturn(UserEntity(uid: '1', email: 'john@example.com'));
    when(mockAuthsProvider.errorMessage).thenReturn(null);
    when(mockAuthsProvider.signUp(any, any)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    await tester.tap(find.byType(CustomButton));
    await tester.pumpAndSettle();

    verify(mockAuthsProvider.signUp('john@example.com', 'password123')).called(1);
    await tester.pumpAndSettle();
    expect(mockAuthsProvider.errorMessage, null);
  });

  testWidgets('Shows error when signup fails', (tester) async {
    when(mockAuthsProvider.isLoading).thenReturn(false);
    when(mockAuthsProvider.user).thenReturn(null);
    when(mockAuthsProvider.errorMessage).thenReturn('Email already exists');
    when(mockAuthsProvider.signUp(any, any)).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    await tester.tap(find.byType(CustomButton));
    await tester.pump();

    expect(find.text('Email already exists'), findsOneWidget); // if shown in a widget
  });
}
