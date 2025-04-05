import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign-in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      return user;
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  // Sign out method
  Future<void> signGoogleOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
