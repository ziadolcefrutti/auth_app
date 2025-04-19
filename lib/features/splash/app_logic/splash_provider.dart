import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  SplashProvider({required this.getCurrentUserUseCase});

  Future<bool> checkLoginStatus() async {
    UserEntity? user = getCurrentUserUseCase.execute();
    return user != null;
  }
}
