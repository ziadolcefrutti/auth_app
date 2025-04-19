import 'package:auth_app/core/common/widgets/custom_button.dart';
import 'package:auth_app/core/common/widgets/custom_text_field.dart';
import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/core/utils/utils.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/features/auth/presentation/widgets/auth_divider.dart';
import 'package:auth_app/features/auth/presentation/widgets/header_text.dart';
import 'package:auth_app/features/auth/presentation/widgets/sign_up_redirect.dart';
import 'package:auth_app/features/auth/presentation/widgets/soical_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              HeaderText(
                title: AppLocalizations.of(context)?.loginTitle ?? '',
                subtitle: AppLocalizations.of(context)?.loginMessage ?? '',
              ),
              const SizedBox(height: 24),
              _buildEmailField(),
              const SizedBox(height: 12),
              _buildPasswordField(),
              const SizedBox(height: 6),
              _buildForgotPasswordButton(),
              const SizedBox(height: 12),
              _buildLoginButton(),
              const SizedBox(height: 12),
              const AuthDivider(),
              SoicalButtons(),
              const SizedBox(height: 50),
              SignUpRedirect(
                accountTitle:
                    AppLocalizations.of(context)?.dontHaveAccount ?? '',
                buttonTitle: AppLocalizations.of(context)?.signUp ?? '',
                onTap: () {
                  context.push(RouteNames.signup);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: AppLocalizations.of(context)?.email ?? '',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)?.enterEmail ?? '';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return ValueListenableBuilder(
      valueListenable: _obscurePassword,
      builder: (context, value, child) {
        return CustomTextField(
          label: AppLocalizations.of(context)?.password ?? '',
          controller: _passwordController,
          obscureText: value,
          suffixIcon: IconButton(
            icon: Icon(
              value ? Icons.visibility_off : Icons.visibility,
              size: 14,
            ),
            onPressed: () {
              _obscurePassword.value = !_obscurePassword.value;
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)?.enterPassword ?? '';
            } else if (value.length < 6) {
              return AppLocalizations.of(context)?.passwordLength ?? '';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          AppLocalizations.of(context)?.forgotPassword ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthsProvider>(
      builder:
          (context, value, child) => CustomButton(
            title: AppLocalizations.of(context)?.login ?? '',
            isLoading: value.isLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final authProvider = context.read<AuthsProvider>();

                if (!authProvider.isLoading) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  await authProvider.signIn(email, password);
                  if (value.user != null && value.errorMessage == null) {
                    _emailController.clear();
                    _passwordController.clear();
                    // ignore: use_build_context_synchronously
                    context.go(RouteNames.home);
                  } else if (value.errorMessage != null) {
                    // ignore: use_build_context_synchronously
                    Utils.flushBarErrorMessage(value.errorMessage, context);
                  }
                }
              }
            },
          ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }
}
