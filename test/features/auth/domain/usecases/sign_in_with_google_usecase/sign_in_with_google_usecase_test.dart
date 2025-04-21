// sign_in_with_google_usecase_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:auth_app/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import 'package:auth_app/core/common/entities/user.dart';

@GenerateMocks([AuthRepository])
import 'sign_in_with_google_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignInWithGoogleUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInWithGoogleUseCaseImpl(mockRepository);
  });

  test('should return UserEntity when signInWithGoogle is successful', () async {
    final expectedUser = UserEntity(uid: 'google123', email: 'google@example.com');

    when(mockRepository.signInWithGoogle())
        .thenAnswer((_) async => expectedUser);

    final result = await useCase.execute();

    expect(result, equals(expectedUser));
    verify(mockRepository.signInWithGoogle()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
