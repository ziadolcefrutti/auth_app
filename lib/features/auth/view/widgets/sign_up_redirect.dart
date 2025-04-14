import 'package:flutter/material.dart';
import 'package:auth_app/core/constants/app_colors.dart';

class SignUpRedirect extends StatelessWidget {
  final VoidCallback onTap;
  final String accountTitle;
  final String buttonTitle;

  const SignUpRedirect({
    super.key,
    required this.onTap,
    required this.accountTitle,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          accountTitle,
          style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
        ),
        TextButton(
          key: Key('redirectTo'),
          onPressed: onTap,
          child: Text(
            buttonTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
