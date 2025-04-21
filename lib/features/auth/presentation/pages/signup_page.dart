import 'package:auth_app/core/common/widgets/custom_button.dart';
import 'package:auth_app/core/common/widgets/custom_text_field.dart';
import 'package:auth_app/core/utils/utils.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/features/auth/presentation/widgets/auth_divider.dart';
import 'package:auth_app/features/auth/presentation/widgets/header_text.dart';
import 'package:auth_app/features/auth/presentation/widgets/sign_up_redirect.dart';
import 'package:auth_app/features/auth/presentation/widgets/soical_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);

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
                title: AppLocalizations.of(context)?.createAccount ?? '',
                subtitle: AppLocalizations.of(context)?.welcomeMessage ?? '',
              ),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 12),
              _buildEmailField(),
              const SizedBox(height: 12),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildConfirmPasswordField(),
              const SizedBox(height: 12),
              _buildSignUpButton(),
              const SizedBox(height: 12),
              const AuthDivider(),
              SoicalButtons(),
              const SizedBox(height: 50),
              SignUpRedirect(
                // key: const Key('loginRedirect'),
                accountTitle:
                    AppLocalizations.of(context)?.alreadyHaveAccount ?? '',
                buttonTitle: AppLocalizations.of(context)?.login ?? '',
                onTap: () {
                  context.pop();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: AppLocalizations.of(context)?.name ?? '',
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)?.enterName ?? '';
        }
        return null;
      },
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

  Widget _buildConfirmPasswordField() {
    return ValueListenableBuilder(
      valueListenable: _obscureConfirmPassword,
      builder: (context, value, child) {
        return CustomTextField(
          label: AppLocalizations.of(context)?.confirmPassword ?? '',
          controller: _confirmPasswordController,
          obscureText: value,
          suffixIcon: IconButton(
            icon: Icon(
              value ? Icons.visibility_off : Icons.visibility,
              size: 14,
            ),
            onPressed: () {
              _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)?.enterConfirmPassword ?? '';
            } else if (value != _passwordController.text) {
              return AppLocalizations.of(context)?.passwordMismatch ?? '';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return Consumer<AuthsProvider>(
      builder:
          (context, value, child) => CustomButton(
            title: AppLocalizations.of(context)?.signUp ?? '',
            isLoading: value.isLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final authProvider = context.read<AuthsProvider>();

                if (!authProvider.isLoading) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  await authProvider.signUp(email, password);
                  if (value.user != null && value.errorMessage == null) {
                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    if (GoRouter.of(context).canPop()) {
                      context.pop();
                    }
                  } else if (value.errorMessage != null) {
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }
}
