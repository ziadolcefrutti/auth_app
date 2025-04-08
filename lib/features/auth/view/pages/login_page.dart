import 'package:auth_app/core/utils.dart';
import 'package:auth_app/core/widgets/custom_button.dart';
import 'package:auth_app/core/widgets/custom_text_field.dart';
import 'package:auth_app/features/auth/view/widgets/auth_divider.dart';
import 'package:auth_app/features/auth/view/widgets/header_text.dart';
import 'package:auth_app/features/auth/view/widgets/sign_up_redirect.dart';
import 'package:auth_app/features/auth/view/widgets/soical_buttons.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(
      context,
      listen: false,
    );
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
              _buildLoginButton(authViewModel),
              const SizedBox(height: 12),
              const AuthDivider(),
              SoicalButtons(authViewModel: authViewModel),
              const SizedBox(height: 50),
              SignUpRedirect(
                accountTitle:
                    AppLocalizations.of(context)?.dontHaveAccount ?? '',
                buttonTitle: AppLocalizations.of(context)?.signUp ?? '',
                onTap: () {
                  context.push('/signup');
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthViewModel authViewModel) {
    return Consumer<AuthViewModel>(
      builder:
          (context, value, child) => CustomButton(
            title: AppLocalizations.of(context)?.login ?? '',
            isLoading: value.isLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (!authViewModel.isLoading) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  await authViewModel.login(email, password);
                  if (authViewModel.isAuthStatus) {
                    _emailController.clear();
                    _passwordController.clear();
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
