import 'package:auth_app/core/exceptions/auth_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthException should store code and message correctly', () {
    const code = 'auth/user-not-found';
    const message = 'The user does not exist';
    
    final exception = AuthException(code, message);

    expect(exception.code, equals(code));
    expect(exception.message, equals(message));
  });

  test('AuthException toString should return formatted string', () {
    const code = 'auth/invalid-email';
    const message = 'The email address is badly formatted';
    final exception = AuthException(code, message);

    final result = exception.toString();

    expect(result, equals('AuthException(auth/invalid-email): The email address is badly formatted'));
  });

  test('AuthException should handle null message gracefully', () {
    const code = 'auth/unknown-error';

    final exception = AuthException(code);

    expect(exception.code, equals(code));
    expect(exception.message, isNull);

    expect(exception.toString(), equals('AuthException(auth/unknown-error): null'));
  });
}
