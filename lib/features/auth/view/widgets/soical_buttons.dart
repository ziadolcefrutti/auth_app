import 'package:auth_app/core/utils.dart';
import 'package:auth_app/features/auth/view/widgets/social_button.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoicalButtons extends StatelessWidget {
  final AuthViewModel authViewModel;
  const SoicalButtons({super.key, required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SocialButton(
          isGoogle: true,
          icon: Icons.g_mobiledata,
          label:
              AppLocalizations.of(context)?.google ??
              ''
                  'Google',
          onTap: () async {
            // final authViewModel = context.read<AuthViewModel>();
            if (!authViewModel.isLoading) {
              await authViewModel.signInWithGoogle();
              if (authViewModel.isAuthStatus) {
                context.go('/home');
              } else {
                if (authViewModel.errorMessage.isNotEmpty) {
                  Utils.flushBarErrorMessage(
                    authViewModel.errorMessage,
                    context,
                  );
                }
              }
            }
          },
        ),
        const SizedBox(width: 12),
        SocialButton(
          isGoogle: false,
          icon: Icons.facebook,
          label: AppLocalizations.of(context)?.facebook ?? '',
          onTap: () {
            debugPrint('Facebook');
          },
        ),
      ],
    );
  }
}
