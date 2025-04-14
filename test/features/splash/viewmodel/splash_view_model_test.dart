import 'package:auth_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth_app/features/auth/repositories/auth_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';

import '../../auth/viewmodel/auth_viewmodel_test.mocks.dart';

@GenerateMocks([AuthRepository, User])
void main() {
  group('SplashViewModel', () {
    late MockAuthRepository mockAuthRepository;
    late SplashViewModel splashViewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    test('uses injected AuthRepository', () {
      final mockRepo = MockAuthRepository();
      final viewModel = SplashViewModel(repository: mockRepo);

      expect(viewModel.authRepository, equals(mockRepo));
    });

    test('SplashViewModel uses provided AuthRepository when passed', () {
      // Create a mock AuthRepository
      final mockAuthRepository = MockAuthRepository();

      // Create SplashViewModel with a custom AuthRepository
      final splashViewModel = SplashViewModel(repository: mockAuthRepository);

      // Verify that the custom AuthRepository is used
      expect(splashViewModel.authRepository, mockAuthRepository);
    });

    test('navigates to /home if user is signed in', () async {
      final mockUser = MockUser();
      when(mockAuthRepository.currentUser).thenReturn(mockUser);

      splashViewModel = SplashViewModel(repository: mockAuthRepository);

      String? navigatedTo;
      splashViewModel.initialize((route) {
        navigatedTo = route;
      });

      // wait for timer to complete
      await Future.delayed(Duration(seconds: 3));

      expect(navigatedTo, '/home');
    });

    test('navigates to /login if user is not signed in', () async {
      when(mockAuthRepository.currentUser).thenReturn(null);

      splashViewModel = SplashViewModel(repository: mockAuthRepository);

      String? navigatedTo;
      splashViewModel.initialize((route) {
        navigatedTo = route;
      });

      await Future.delayed(Duration(seconds: 3));

      expect(navigatedTo, '/login');
    });
  });
}
