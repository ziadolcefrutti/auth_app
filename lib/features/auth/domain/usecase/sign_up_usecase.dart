import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/common/entities/user.dart';

abstract class SignUpUseCase {
  Future<UserEntity> execute(String email, String password);
}

class SignUpUseCaseImpl implements SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCaseImpl(this.repository);

  @override
  Future<UserEntity> execute(String email, String password) {
    return repository.signUp(email, password);
  }
}
