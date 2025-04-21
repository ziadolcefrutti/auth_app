import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:auth_app/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';

@GenerateMocks([AuthRepository])
import 'sign_out_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late SignOutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignOutUseCaseImpl(mockRepository);
  });

  test('should call repository.signOut()', () async {
    when(mockRepository.signOut()).thenAnswer((_) async => Future.value());

    await useCase.execute();

    verify(mockRepository.signOut()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw if repository.signOut throws', () async {
    when(mockRepository.signOut()).thenThrow(Exception('Sign out failed'));

    expect(() => useCase.execute(), throwsException);
  });
}
