import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final bool isGoogle;
  final IconData icon;
  final String label;
  final void Function()? onTap;

  const SocialButton({
    super.key,
    required this.isGoogle,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), //AppColors.lightGrey
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
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
