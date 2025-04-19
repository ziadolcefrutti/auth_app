import 'package:flutter/material.dart';

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
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ), // AppColors.darkGrey
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            buttonTitle,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
