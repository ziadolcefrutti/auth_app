import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/common/entities/user.dart';

abstract class SignInUseCase {
  Future<UserEntity> execute(String email, String password);
}

class SignInUseCaseImpl implements SignInUseCase {
  final AuthRepository repository;

  SignInUseCaseImpl(this.repository);

  @override
  Future<UserEntity> execute(String email, String password) {
    return repository.signIn(email, password);
  }
}
