import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load current user data once after the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().setCurrentUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final String? helloText = AppLocalizations.of(context)?.hello;
    final String? welcomeText = AppLocalizations.of(context)?.welcome;
    final String? currentUserEmail = authViewModel.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          welcomeText ?? '',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              context.push('/language');
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child:
            authViewModel.currentUser == null
                ? const CircularProgressIndicator()
                : Text(
                  '$helloText, $currentUserEmail',
                  style: const TextStyle(fontSize: 18),
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
                  context.read<AuthViewModel>().logout();
                  context.go('/login');
                },
                child: Text(AppLocalizations.of(context)?.confrim ?? 'Confirm'),
              ),
            ],
          ),
    );
  }
}
