import 'package:auth_app/core/failures/auth_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    group('AuthFailure', () {
    test('returns correct message for invalid-email', () {
      final exception = FirebaseAuthException(code: 'invalid-email');
      final authFailure = AuthFailure.fromFirebaseException(exception);

      expect(authFailure.toString(), 'The email address is badly formatted.');
    });

    test('returns correct message for user-not-found', () {
      final exception = FirebaseAuthException(code: 'user-not-found');
      final authFailure = AuthFailure.fromFirebaseException(exception);

      expect(authFailure.toString(), 'No user found for that email.');
    });

    test('returns correct message for wrong-password', () {
      final exception = FirebaseAuthException(code: 'wrong-password');
      final authFailure = AuthFailure.fromFirebaseException(exception);

      expect(authFailure.toString(), 'Wrong password provided.');
    });

    test('returns correct message for email-already-in-use', () {
      final exception = FirebaseAuthException(code: 'email-already-in-use');
      final authFailure = AuthFailure.fromFirebaseException(exception);

      expect(authFailure.toString(), 'This email is already in use.');
    });

    test('returns correct message for weak-password', () {
      final exception = FirebaseAuthException(code: 'weak-password');
      final authFailure = AuthFailure.fromFirebaseException(exception);

      expect(authFailure.toString(), 'The password is too weak.');
    });

    test('returns default message for unknown error codes', () {
      final exception = FirebaseAuthException(code: 'unknown-error');
      final authFailure = AuthFailure.fromFirebaseException(exception);

      expect(authFailure.toString(), 'Authentication failed. Please try again.');
    });
  });


}