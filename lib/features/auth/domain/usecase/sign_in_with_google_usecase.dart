import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/common/entities/user.dart';

abstract class SignInWithGoogleUseCase {
  Future<UserEntity> execute();
}

class SignInWithGoogleUseCaseImpl implements SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCaseImpl(this.repository);

  @override
  Future<UserEntity> execute() async {
    return await repository.signInWithGoogle();
  }
}
