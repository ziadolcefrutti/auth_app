import 'package:flutter_test/flutter_test.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/core/exceptions/auth_exception.dart';
import 'package:mockito/mockito.dart';

import '../../../mock/mock_usecases.mocks.dart';

void main() {
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late AuthsProvider authsProvider;

  var testUser = UserEntity(uid: '123', email: 'test@example.com');

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();

    authsProvider = AuthsProvider(
      signInUseCase: mockSignInUseCase,
      signUpUseCase: mockSignUpUseCase,
      signOutUseCase: mockSignOutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
    );
  });

  test('signIn success sets user and clears error', () async {
    when(
      mockSignInUseCase.execute('test@example.com', '123456'),
    ).thenAnswer((_) async => testUser);

    await authsProvider.signIn('test@example.com', '123456');

    expect(authsProvider.user, testUser);
    expect(authsProvider.errorMessage, isNull);
    expect(authsProvider.isLoading, isFalse);
  });

  test('signUp success sets user and clears error', () async {
    when(
      mockSignUpUseCase.execute('test@example.com', '123456'),
    ).thenAnswer((_) async => testUser);

    await authsProvider.signUp('test@example.com', '123456');

    expect(authsProvider.user, testUser);
    expect(authsProvider.errorMessage, isNull);
    expect(authsProvider.isLoading, isFalse);
  });

  test('signIn failure sets error message', () async {
    when(
      mockSignInUseCase.execute(any, any),
    ).thenThrow(AuthException('Invalid credentials', 'Invalid credentials'));

    await authsProvider.signIn('wrong', 'wrong');

    expect(authsProvider.user, isNull);
    expect(authsProvider.errorMessage, 'Invalid credentials');
    expect(authsProvider.isLoading, isFalse);
  });

  test('signOut clears user', () async {
    authsProvider.user = testUser;
    await authsProvider.signOut();
    verify(mockSignOutUseCase.execute()).called(1);
    expect(authsProvider.user, isNull);
  });

  test('loadCurrentUser loads user without error', () {
    when(mockGetCurrentUserUseCase.execute()).thenReturn(testUser);
    authsProvider.loadCurrentUser();
    expect(authsProvider.user, testUser);
  });

  test('signInWithGoogle success', () async {
    when(
      mockSignInWithGoogleUseCase.execute(),
    ).thenAnswer((_) async => testUser);
    await authsProvider.signInWithGoogle();
    expect(authsProvider.user, testUser);
    expect(authsProvider.isGoogleLoading, false);
  });

  test('signInWithGoogle failure sets error', () async {
    when(mockSignInWithGoogleUseCase.execute()).thenThrow(
      AuthException('Google sign-in failed', 'Google sign-in failed'),
    );
    await authsProvider.signInWithGoogle();
    expect(authsProvider.user, isNull);
    expect(authsProvider.errorMessage, 'Google sign-in failed');
  });
}
