import 'package:auth_app/core/utils/utils.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/features/auth/presentation/widgets/social_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SoicalButtons extends StatelessWidget {
  const SoicalButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SocialButton(
          isGoogle: true,
          icon: Icons.g_mobiledata,
          label: AppLocalizations.of(context)?.google ?? '',
          onTap: () async {
            final authProvider = context.read<AuthsProvider>();
            if (!authProvider.isLoading) {
              await authProvider.signInWithGoogle();
              if (authProvider.user != null &&
                  authProvider.errorMessage == null) {
                context.go('/home');
              } else {
                if (authProvider.errorMessage != null) {
                  Utils.flushBarErrorMessage(
                    authProvider.errorMessage,
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
