import 'package:auth__app/data/repositories/auth_repository.dart';
import 'package:auth__app/views/auth_view/login_view.dart';
import 'package:auth__app/views/home_view/home_view.dart';
import 'package:flutter/material.dart';

class SplashServices {
  static void splashIsLogin(context){
    Future.delayed(const Duration(seconds: 3), () {
      final AuthRepository authRepository=AuthRepository();
     if(authRepository.currentUser!=null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );}else{
         Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );

      }
    });
  }
}