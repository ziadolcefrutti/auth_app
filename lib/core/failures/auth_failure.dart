import 'package:firebase_auth/firebase_auth.dart';

class AuthFailure {
  final String message;

  AuthFailure(this.message);

  static AuthFailure fromFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthFailure('The email address is badly formatted.');
      case 'user-not-found':
        return AuthFailure('No user found for that email.');
      case 'wrong-password':
        return AuthFailure('Wrong password provided.');
      case 'email-already-in-use':
        return AuthFailure('This email is already in use.');
      case 'weak-password':
        return AuthFailure('The password is too weak.');
      default:
        return AuthFailure('Authentication failed. Please try again.');
    }
  }

  @override
  String toString() => message;
}
