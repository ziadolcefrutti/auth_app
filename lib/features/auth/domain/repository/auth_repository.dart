import 'package:auth_app/core/common/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  UserEntity? getCurrentUser();
}
