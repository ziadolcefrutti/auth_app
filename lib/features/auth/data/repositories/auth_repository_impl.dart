import 'package:auth_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth_app/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/common/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final userCred = await remoteDataSource.signInWithEmail(email, password);
    final user = userCred.user!;
    return UserEntity(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserEntity> signUp(String email, String password) async {
    final userCred = await remoteDataSource.signUpWithEmail(email, password);
    final user = userCred.user!;
    return UserEntity(uid: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> signOut() => remoteDataSource.signOut();

  @override
  UserEntity? getCurrentUser() {
    final user = remoteDataSource.getCurrentUser();
    if (user != null) {
      return UserEntity(uid: user.uid, email: user.email ?? '');
    }
    return null;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final userCred = await remoteDataSource.signInWithGoogle();
    final user = userCred.user!;
    return UserEntity(uid: user.uid, email: user.email ?? '');
  }
}
