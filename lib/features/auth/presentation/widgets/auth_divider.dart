import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Text(AppLocalizations.of(context)?.orContinueWithOther ?? ''),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
