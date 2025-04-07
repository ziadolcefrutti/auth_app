import 'dart:async';
import 'package:auth_app/features/auth/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashViewModel with ChangeNotifier {
  void initialize(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    Timer(const Duration(seconds: 3), () {
      if (authRepository.currentUser != null) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }
}
