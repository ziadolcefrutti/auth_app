import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import 'get_current_user_usecase_test.mocks.dart';
import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late GetCurrentUserUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCaseimpl(mockRepository);
  });

  test('should return current user from repository', () {
    final expectedUser = UserEntity(uid: '123', email: 'test@example.com');

    when(mockRepository.getCurrentUser()).thenReturn(expectedUser);

    final result = useCase.execute();

    expect(result, equals(expectedUser));
    verify(mockRepository.getCurrentUser()).called(1);
  });

  test('should return null if no user is signed in', () {
    when(mockRepository.getCurrentUser()).thenReturn(null);

    final result = useCase.execute();

    expect(result, isNull);
    verify(mockRepository.getCurrentUser()).called(1);
  });
}



// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:auth_app/core/common/entities/user.dart';
// import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
// import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// void main() {
//   late MockAuthRepository mockRepository;
//   late GetCurrentUserUseCase useCase;

//   setUp(() {
//     mockRepository = MockAuthRepository();
//     useCase = GetCurrentUserUseCaseimpl(mockRepository);
//   });

//   test('should return current user from repository', () {
//     // Arrange
//     final expectedUser = UserEntity(uid: '123', email: 'test@example.com');
//     when(() => mockRepository.getCurrentUser())
//         .thenReturn(expectedUser);

//     // Act
//     final result = useCase.execute();

//     // Assert
//     expect(result, equals(expectedUser));
//     verify(() => mockRepository.getCurrentUser()).called(1);
//     verifyNoMoreInteractions(mockRepository);
//   });

//   test('should return null if no user is signed in', () {
//     // Arrange
//     when(() => mockRepository.getCurrentUser())
//         .thenReturn(null);

//     // Act
//     final result = useCase.execute();

//     // Assert
//     expect(result, isNull);
//     verify(() => mockRepository.getCurrentUser()).called(1);
//   });
// }
