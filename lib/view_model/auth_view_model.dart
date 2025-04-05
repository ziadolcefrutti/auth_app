import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  String? verificationId;
  bool isLoading = false;
  bool isAuthStatus = false;
  String errorMessage = '';

  void setIsAuthStatus(val) {
    isAuthStatus = val;
    notifyListeners();
  }

  // Verify phone number with error handling
  void verifyPhoneNumber(String phone, Function() onCodeSent) {
    try {
      isLoading = true;
      notifyListeners();

      _authRepo.verifyPhoneNumber(phone, (verificationId) {
        this.verificationId = verificationId;
        isLoading = false;
        notifyListeners();
        onCodeSent();
      });
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error during phone number verification: $e');
      }
      // Optionally, you can show an error dialog or message here
    } finally {
      if (isLoading) {
        isLoading =
            false; // Ensure loading state is stopped if an exception occurs
        notifyListeners();
      }
    }
  }

  // Sign in with OTP with error handling
  Future<void> signInWithOTP(
      String otp, Function() onSuccess, Function(String) onError) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authRepo.signInWithOTP(otp, verificationId!);

      isLoading = false;
      notifyListeners();
      onSuccess(); // Trigger success callback on successful sign-in
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error during OTP sign-in: $e');
      }
      onError(
          'Sign-in failed. Please try again.'); // Pass error message to error callback
    }
  }

  //create account email and password
  Future<void> signUp(String email, String password) async {
    isLoading = true;
    notifyListeners();
    setIsAuthStatus(false);

    final user = await _authRepo.signUp(email, password);

    if (user != null) {
      setIsAuthStatus(true);
      Fluttertoast.showToast(msg: "Sign Up Successful!");
      errorMessage = ''; // Reset error message
    } else {
      errorMessage = "Failed to sign up. Please try again.";
      setIsAuthStatus(false);
    }
    isLoading = false;
    notifyListeners();
  }

  // Login with email password
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    setIsAuthStatus(false);

    final user = await _authRepo.login(email, password);

    if (user != null) {
      setIsAuthStatus(true);

      Fluttertoast.showToast(msg: "Login Successful!");
      errorMessage = ''; // Reset error message
    } else {
      errorMessage = "Login Failed. Please try again.";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    setIsAuthStatus(false);
    try {
      final user = await _authRepo.signInWithGoogle();
      if (user != null) {
        // Handle success (you can navigate to a new screen, etc.)
        setIsAuthStatus(true);
        print("Signed in successfully: ${user.displayName}");
      }
    } catch (e) {
      errorMessage = e.toString();
      print("Error: $e");
    } finally {}
  }

  // Logout method
  Future<void> logout() async {
    await _authRepo.signGoogleOut();
    notifyListeners();
  }
}
