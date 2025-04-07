import 'package:flutter/material.dart';
import 'package:auth_app/core/constants/app_colors.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
        ),
      ],
    );
  }
}
