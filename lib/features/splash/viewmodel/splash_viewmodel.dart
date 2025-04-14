import 'dart:async';
import 'package:auth_app/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class SplashViewModel with ChangeNotifier {
  final AuthRepository authRepository;

  SplashViewModel({AuthRepository? repository})
    : authRepository = repository ?? AuthRepository();

  void initialize(Function(String route) onNavigate) {
    // final AuthRepository authRepository = AuthRepository();

    Timer(const Duration(seconds: 3), () {
      if (authRepository.currentUser != null) {
        onNavigate('/home');
      } else {
        onNavigate('/login');
      }
    });
  }
}
