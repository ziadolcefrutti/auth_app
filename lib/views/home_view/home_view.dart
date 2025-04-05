import 'package:auth__app/core/localization.dart';
import 'package:auth__app/data/repositories/auth_repository.dart';
import 'package:auth__app/res/const/app_colors.dart';
import 'package:auth__app/view_model/auth_view_model.dart';
import 'package:auth__app/views/auth_view/login_view.dart';
import 'package:auth__app/views/home_view/localization_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    final authRepository = AuthRepository();
    return Scaffold(
        appBar: AppBar(
          title: Text(LocalizationService.translate('welcome'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          backgroundColor: AppColor.primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocalizationView(),
                    ));
                // Handle logout
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authViewModel.logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ));
                // Handle logout
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
              '${LocalizationService.translate('hello')} , ${authRepository.currentUser?.email ?? ''}',
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ));
  }
}
