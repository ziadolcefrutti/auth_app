import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthsProvider>().loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? helloText = AppLocalizations.of(context)?.hello;
    final String? welcomeText = AppLocalizations.of(context)?.welcome;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          welcomeText ?? '',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              context.push(RouteNames.localization);
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<AuthsProvider>(
          builder:
              (context, value, child) =>
                  value.user == null
                      ? const CircularProgressIndicator()
                      : Text(
                        '$helloText,${value.user?.email ?? ''} ',
                        style: const TextStyle(fontSize: 18),
                      ),
        ),
      ),
    );
  }

  // Show a logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.logout ?? 'Logout'),
            content: Text(
              AppLocalizations.of(context)?.areYouSureLogout ??
                  'Are you sure you want to log out?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthsProvider>().signOut();
                  context.go('/login');
                },
                child: Text(AppLocalizations.of(context)?.confrim ?? 'Confirm'),
              ),
            ],
          ),
    );
  }
}
