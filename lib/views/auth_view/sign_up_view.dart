// ignore_for_file: use_build_context_synchronously

import 'package:auth__app/core/localization.dart';
import 'package:auth__app/res/component/custom_button.dart';
import 'package:auth__app/res/component/custom_text_form_field.dart';
import 'package:auth__app/res/const/app_colors.dart';
import 'package:auth__app/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For ChangeNotifierProvider

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
    final AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    LocalizationService.translate('create_account'),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    LocalizationService.translate('welcome_message'),
                    style: TextStyle(fontSize: 14, color: AppColor.darkGrey),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                      label: LocalizationService.translate('name'),
                      controller: _nameController),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: LocalizationService.translate('email'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationService.translate(
                            'please_enter_email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: _obscurePassword,
                    builder: (context, value, child) {
                      return CustomTextField(
                        label: LocalizationService.translate('password'),
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
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: _obscureConfirmPassword,
                    builder: (context, value, child) {
                      return CustomTextField(
                        label:
                            LocalizationService.translate('confirm_password'),
                        controller: _confirmPasswordController,
                        obscureText: value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            value ? Icons.visibility_off : Icons.visibility,
                            size: 14,
                          ),
                          onPressed: () {
                            _obscureConfirmPassword.value =
                                !_obscureConfirmPassword.value;
                          },
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return LocalizationService.translate(
                                'password_mismatch');
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    title: LocalizationService.translate('sign_up'),
                    isLoading: authViewModel.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!authViewModel.isLoading) {
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          await authViewModel.signUp(email, password);
                          if (authViewModel.isAuthStatus) {
                            _emailController.clear();
                            _passwordController.clear();
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDividerWithText(),
                  _buildSocialButtons(),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocalizationService.translate('already_have_account'),
                        style:
                            TextStyle(fontSize: 14, color: AppColor.darkGrey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          LocalizationService.translate('login'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Text(LocalizationService.translate('or_continue_with_other')),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        _buildSocialButton(
            icon: Icons.g_mobiledata,
            label: LocalizationService.translate('google')),
        const SizedBox(width: 12),
        _buildSocialButton(
            icon: Icons.facebook,
            label: LocalizationService.translate('facebook')),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGrey!),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 10),
            Text(label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
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
