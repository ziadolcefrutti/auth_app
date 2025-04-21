import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import 'package:auth_app/core/common/entities/user.dart';
import 'sign_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late SignInUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCaseImpl(mockRepository);
  });

  test('should call repository.signIn and return UserEntity', () async {
    const email = 'test@example.com';
    const password = 'pass123';
    final expectedUser = UserEntity(uid: 'user123', email: email);

    when(mockRepository.signIn(email, password))
        .thenAnswer((_) async => expectedUser);

    final result = await useCase.execute(email, password);

    expect(result, equals(expectedUser));
    verify(mockRepository.signIn(email, password)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}


// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:auth_app/features/auth/domain/usecase/sign_in_usecase.dart';
// import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
// import 'package:auth_app/core/common/entities/user.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// void main() {
//   late MockAuthRepository mockRepository;
//   late SignInUseCase useCase;

//   setUpAll(() {
//     registerFallbackValue(''); // required for mocktail if needed
//   });

//   setUp(() {
//     mockRepository = MockAuthRepository();
//     useCase = SignInUseCaseImpl(mockRepository);
//   });

//   test('should call repository.signIn and return UserEntity', () async {
//     const email = 'test@example.com';
//     const password = 'pass123';
//     final expectedUser = UserEntity(uid: 'user123', email: email);

//     when(() => mockRepository.signIn(email, password))
//         .thenAnswer((_) async => expectedUser);

//     final result = await useCase.execute(email, password);

//     expect(result, equals(expectedUser));
//     verify(() => mockRepository.signIn(email, password)).called(1);
//     verifyNoMoreInteractions(mockRepository);
//   });
// }
