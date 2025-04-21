import 'package:auth_app/core/exceptions/auth_exception.dart';
import 'package:auth_app/core/common/entities/user.dart';
import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:flutter/material.dart';

class AuthsProvider with ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  AuthsProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.signInWithGoogleUseCase,
  });

  UserEntity? user;
  String? errorMessage;
  bool isLoading = false;
  bool isGoogleLoading = false;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      user = await signInUseCase.execute(email, password);
      errorMessage = null;
    } catch (e) {
      errorMessage = _handleError(e);
    }
    _setLoading(false);
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    try {
      user = await signUpUseCase.execute(email, password);
      errorMessage = null;
    } catch (e) {
      errorMessage = _handleError(e);
    }
    _setLoading(false);
  }

  Future<void> signInWithGoogle() async {
    _setGoogleLoading(true);
    try {
      user = await signInWithGoogleUseCase.execute();
      errorMessage = null;
    } catch (e) {
      errorMessage = _handleError(e);
    }
    _setGoogleLoading(false);
  }

  Future<void> signOut() async {
    await signOutUseCase.execute();
    user = null;
  }

  void loadCurrentUser() {
    user = getCurrentUserUseCase.execute();
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setGoogleLoading(bool value) {
    isGoogleLoading = value;
    notifyListeners();
  }

  String _handleError(Object e) {
    if (e is AuthException) return e.message ?? "Unknown Firebase error";
    return "An unexpected error occurred";
  }
}
