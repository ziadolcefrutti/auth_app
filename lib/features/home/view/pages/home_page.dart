import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.welcome ?? '',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              context.push('/langauge');
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthViewModel>().logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          '${AppLocalizations.of(context)?.hello ?? ''}, $email',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
