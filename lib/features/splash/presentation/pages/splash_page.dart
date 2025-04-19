import 'dart:async';

import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/core/theme/app_pallete.dart';
import 'package:auth_app/features/splash/app_logic/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final isLoggedIn = await context.read<SplashProvider>().checkLoginStatus();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (isLoggedIn) {
        context.go(RouteNames.home);
      } else {
        context.go(RouteNames.login);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 80,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)?.welcome ?? '',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppPallete.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
