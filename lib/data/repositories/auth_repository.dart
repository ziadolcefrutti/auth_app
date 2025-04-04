import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sign Up Failed: $e");
      return null;
    }
  }

  // Login with email and password
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      Fluttertoast.showToast(msg: "Login Failed: $e");
      return null;
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Method to verify the phone number
  Future<void> verifyPhoneNumber(
      String phone, Function(String) codeSentCallback) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
          } catch (e) {
            throw Exception('Error during sign-in with credentials: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            throw Exception('The provided phone number is invalid.');
          } else if (e.code == 'too-many-requests') {
            throw Exception('Too many requests. Please try again later.');
          } else {
            throw Exception('Verification failed: ${e.message}');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw Exception('Error occurred during phone number verification: $e');
    }
  }

  // Method to sign in with OTP
  Future<UserCredential> signInWithOTP(
      String otp, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Catch errors
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          throw Exception('Invalid OTP. Please try again.');
        } else {
          throw Exception('Error during sign-in with OTP: ${e.message}');
        }
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }
}
