import 'package:auth_app/features/splash/app_logic/splash_provider.dart';
import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late SplashProvider splashProvider;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    splashProvider = SplashProvider(getCurrentUserUseCase: mockGetCurrentUserUseCase);
  });

  test('returns true when user is logged in', () async {
    when(mockGetCurrentUserUseCase.execute())
        .thenReturn(UserEntity(uid: '123', email: 'test@example.com'));

    final result = await splashProvider.checkLoginStatus();

    expect(result, true);
  });

  test('returns false when user is not logged in', () async {
    when(mockGetCurrentUserUseCase.execute()).thenReturn(null);

    final result = await splashProvider.checkLoginStatus();

    expect(result, false);
  });
}
