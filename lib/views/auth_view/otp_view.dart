import 'package:auth__app/res/component/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/auth_view_model.dart';

class OtpView extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Login',
              isLoading: authVM.isLoading,
              onPressed: () {
                authVM.signInWithOTP(otpController.text, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Successful")));
                }, (onerror) {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
