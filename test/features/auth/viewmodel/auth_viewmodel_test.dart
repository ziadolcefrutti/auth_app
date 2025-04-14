import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth_app/features/auth/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepository, User])
void main() {
  group('AuthViewModel Tests', () {
    late AuthViewModel viewModel;
    late MockAuthRepository mockAuthRepo;
    late MockUser mockUser;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      viewModel = AuthViewModel(mockAuthRepo);
      mockUser = MockUser();
    });

    test('signUp sets isAuthStatus to true on success', () async {
      when(mockAuthRepo.signUp(any, any)).thenAnswer((_) async => mockUser);

      await viewModel.signUp('test@example.com', 'password123');

      expect(viewModel.isAuthStatus, true);
      expect(viewModel.errorMessage, '');
      expect(viewModel.isLoading, false);
    });

    test('signUp sets errorMessage on failure', () async {
      when(
        mockAuthRepo.signUp(any, any),
      ).thenThrow(Exception('Sign Up Failed'));

      await viewModel.signUp('fail@example.com', 'password123');

      expect(viewModel.isAuthStatus, false);
      expect(viewModel.errorMessage, contains('Sign Up Failed'));
      expect(viewModel.isLoading, false);
    });

    test('login sets isAuthStatus to true on success', () async {
      when(mockAuthRepo.login(any, any)).thenAnswer((_) async => mockUser);

      await viewModel.login('test@example.com', 'password123');

      expect(viewModel.isAuthStatus, true);
      expect(viewModel.errorMessage, '');
      expect(viewModel.isLoading, false);
    });

    test('login sets errorMessage on failure', () async {
      when(mockAuthRepo.login(any, any)).thenThrow(Exception('Login Failed'));

      await viewModel.login('fail@example.com', 'password123');

      expect(viewModel.isAuthStatus, false);
      expect(viewModel.errorMessage, contains('Login Failed'));
      expect(viewModel.isLoading, false);
    });

    test('signInWithGoogle sets isAuthStatus to true on success', () async {
      when(mockUser.displayName).thenReturn('Test User');
      when(mockAuthRepo.signInWithGoogle()).thenAnswer((_) async => mockUser);

      await viewModel.signInWithGoogle();

      expect(viewModel.isAuthStatus, true);
      expect(viewModel.errorMessage, '');
    });

    test('signInWithGoogle sets errorMessage on failure', () async {
      when(
        mockAuthRepo.signInWithGoogle(),
      ).thenThrow(Exception('Google Sign-In Failed'));

      await viewModel.signInWithGoogle();

      expect(viewModel.isAuthStatus, false);
      expect(viewModel.errorMessage, contains('Google Sign-In Failed'));
    });

    test('logout sets isAuthStatus to false and calls signGoogleOut', () async {
      when(mockAuthRepo.signGoogleOut()).thenAnswer((_) async {});

      await viewModel.logout();

      verify(mockAuthRepo.signGoogleOut()).called(1);
      expect(viewModel.isAuthStatus, false);
    });

    test('setCurrentUserData updates currentUser', () {
      when(mockAuthRepo.currentUser).thenReturn(mockUser);

      viewModel.setCurrentUserData();

      expect(viewModel.currentUser, mockUser);
    });
  });
}
