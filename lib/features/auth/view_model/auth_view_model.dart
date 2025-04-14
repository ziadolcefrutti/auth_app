import 'package:auth_app/features/auth/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  // final AuthRepository _authRepo = AuthRepository();
  bool isLoading = false;
  bool isAuthStatus = false;
  String errorMessage = '';
  User? _currentUser;

  final AuthRepository _authRepo;

  AuthViewModel([AuthRepository? repo]) : _authRepo = repo ?? AuthRepository();

  User? get currentUser => _currentUser;

  // Set the authentication status
  void setIsAuthStatus(bool val) {
    isAuthStatus = val;
    notifyListeners();
  }

  void setCurrentUserData() {
    _currentUser = _authRepo.currentUser;
    notifyListeners();
  }

  // Create account with email and password
  Future<void> signUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    setIsAuthStatus(false);

    try {
      final user = await _authRepo.signUp(email, password);
      if (user != null) {
        setIsAuthStatus(true);
        errorMessage = ''; // Reset error message
      } else {
        errorMessage = "Failed to sign up. Please try again.";
        setIsAuthStatus(false);
      }
    } catch (e) {
      errorMessage = e.toString();
      setIsAuthStatus(false);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Login with email and password
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    setIsAuthStatus(false);

    try {
      final user = await _authRepo.login(email, password);
      if (user != null) {
        setIsAuthStatus(true);
        errorMessage = ''; // Reset error message
      } else {
        errorMessage = "Login Failed. Please try again.";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Sign-in with Google
  Future<void> signInWithGoogle() async {
    setIsAuthStatus(false);
    try {
      final user = await _authRepo.signInWithGoogle();
      if (user != null) {
        setIsAuthStatus(true);
        debugPrint("Signed in successfully: ${user.displayName}");
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    await _authRepo.signGoogleOut();
    setIsAuthStatus(false);
    notifyListeners();
  }
}
