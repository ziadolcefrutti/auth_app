import 'package:flutter/material.dart';
import 'package:auth__app/res/const/app_colors.dart';

class SocialButton extends StatelessWidget {
  final bool isGoogle;
  final IconData icon;
  final String label;
  final void Function()? onTap;

  const SocialButton({
    Key? key,
    required this.isGoogle,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.lightGrey!),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isGoogle
                  ? Image.asset(
                      'assets/images/google.png',
                      width: 20,
                      height: 20,
                    )
                  : Icon(
                      icon,
                      size: 28,
                      color: AppColor.blueColor,
                    ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
