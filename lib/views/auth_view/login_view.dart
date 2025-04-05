// ignore_for_file: use_build_context_synchronously

import 'package:auth__app/data/repositories/auth_repository.dart';
import 'package:auth__app/res/component/custom_button.dart';
import 'package:auth__app/res/component/custom_text_form_field.dart';
import 'package:auth__app/res/component/social_button.dart';
import 'package:auth__app/res/const/app_colors.dart';
import 'package:auth__app/view_model/auth_view_model.dart';
import 'package:auth__app/views/auth_view/sign_up_view.dart';
import 'package:auth__app/views/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:auth__app/core/localization.dart';
import 'package:provider/provider.dart'; // Assuming this is where the LocalizationService is

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel =
        Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Localized text for login title
              Text(
                LocalizationService.translate('login_title'),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              // Localized text for welcome message
              Text(
                LocalizationService.translate('login_message'),
                style: TextStyle(fontSize: 14, color: AppColor.darkGrey),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: LocalizationService.translate(
                    'email'), // Localized label for email
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocalizationService.translate(
                        'enter_email'); // Localized error message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              ValueListenableBuilder(
                valueListenable: _obscurePassword,
                builder: (context, value, child) {
                  return CustomTextField(
                    label: LocalizationService.translate(
                        'password'), // Localized label for password
                    controller: _passwordController,
                    obscureText: value,
                    suffixIcon: IconButton(
                      icon: Icon(
                          value ? Icons.visibility_off : Icons.visibility,
                          size: 14),
                      onPressed: () {
                        _obscurePassword.value = !_obscurePassword.value;
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocalizationService.translate(
                            'enter_password'); // Localized error message
                      } else if (value.length < 6) {
                        return LocalizationService.translate(
                            'password_length'); // Localized error message
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    LocalizationService.translate(
                        'forgot_password'), // Localized text
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Consumer<AuthViewModel>(builder: (context, value, child) => 
                 CustomButton(
                  title: LocalizationService.translate(
                      'login'), // Localized button text
                  isLoading: value.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Handle login
                
                      if (!authViewModel.isLoading) {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        await authViewModel.login(email, password);
                        if (authViewModel.isAuthStatus) {
                          _emailController.clear();
                          _passwordController.clear();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              _buildDividerWithText(),
              _buildSocialButtons(),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocalizationService.translate(
                        'dont_have_account'), // Localized text
                    style: TextStyle(fontSize: 14, color: AppColor.darkGrey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()));
                    },
                    child: Text(
                      LocalizationService.translate(
                          'sign_up'), // Localized text
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
    );
  }

  Widget _buildDividerWithText() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Text(LocalizationService.translate(
              'or_continue_with_other')), // You can localize this string too
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        SocialButton(
            isGoogle: true,
            icon: Icons.g_mobiledata,
            label: LocalizationService.translate('google'),
            onTap: () async {
              final authViewModel= context.read<AuthViewModel>();

              if (!authViewModel.isLoading) {
                      await authViewModel.signInWithGoogle();
                      if(authViewModel.isAuthStatus){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                      }
                    }

              debugPrint('google');
            }),
        const SizedBox(width: 12),
        SocialButton(
            isGoogle: false,
            icon: Icons.facebook,
            label: LocalizationService.translate('facebook'),
            onTap: () {
              debugPrint('facebook');
            }),
      ],
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
