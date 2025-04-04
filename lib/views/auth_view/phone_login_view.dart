import 'package:auth__app/res/component/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/auth_view_model.dart';
import 'otp_view.dart';

class PhoneLoginView extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  PhoneLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: 'Verify',
              isLoading: authVM.isLoading,
              onPressed: () {
                authVM.verifyPhoneNumber(phoneController.text, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OtpView()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
