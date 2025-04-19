import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';

abstract class SignOutUseCase {
  Future<void> execute();
}

class SignOutUseCaseImpl implements SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCaseImpl(this.repository);

  @override
  Future<void> execute() {
    return repository.signOut();
  }
}
