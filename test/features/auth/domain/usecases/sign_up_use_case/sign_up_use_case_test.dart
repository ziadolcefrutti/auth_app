// import 'package:auth_app/features/auth/domain/usecase/sign_up_usecase.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
// import 'package:auth_app/core/common/entities/user.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// void main() {
//   late MockAuthRepository mockRepository;
//   late SignUpUseCase signUpUseCase;

//   setUp(() {
//     mockRepository = MockAuthRepository();
//     signUpUseCase = SignUpUseCaseImpl(mockRepository);
//   });

//   test('should call repository.signUp and return UserEntity', () async {
//     // Arrange
//     const email = 'test@example.com';
//     const password = 'superSecret123';
//     final expectedUser = UserEntity(uid: 'abc123', email: email);

//     when(() => mockRepository.signUp(email, password))
//         .thenAnswer((_) async => expectedUser);

//     // Act
//     final result = await signUpUseCase.execute(email, password);

//     // Assert
//     expect(result, equals(expectedUser));
//     verify(() => mockRepository.signUp(email, password)).called(1);
//     verifyNoMoreInteractions(mockRepository);
//   });
// }
// sign_up_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import 'package:auth_app/core/common/entities/user.dart';

@GenerateMocks([AuthRepository])
import 'sign_up_use_case_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignUpUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUpUseCaseImpl(mockRepository);
  });

  test('should call repository.signUp and return UserEntity', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';
    final expectedUser = UserEntity(uid: 'user123', email: email);

    // Mock the signUp method to return the expected user
    when(mockRepository.signUp(email, password)).thenAnswer((_) async => expectedUser);

    // Act
    final result = await useCase.execute(email, password);

    // Assert
    expect(result, equals(expectedUser));
    verify(mockRepository.signUp(email, password)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw if repository.signUp throws an error', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';

    // Mock the signUp method to throw an exception
    when(mockRepository.signUp(email, password)).thenThrow(Exception('Sign up failed'));

    // Act & Assert
    expect(() => useCase.execute(email, password), throwsException);
  });
}
