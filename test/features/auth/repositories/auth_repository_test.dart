import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auth_app/features/auth/repositories/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  UserCredential,
  User,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
])
void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthRepository repository;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    repository = AuthRepository(auth: mockAuth, googleSignIn: mockGoogleSignIn);
  });

  group('AuthRepository', () {
    // signUp - success
    test('signUp returns User on success', () async {
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);

      final user = await repository.signUp('test@example.com', 'password123');

      expect(user, equals(mockUser));
      verify(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
    });

    //  signUp - FirebaseAuthException
    test('signUp throws Exception on FirebaseAuthException', () async {
      final exception = FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'The email is already in use by another account.',
      );

      when(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenThrow(exception);

      expect(
        () => repository.signUp('test@example.com', 'password123'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Sign Up Failed'),
          ),
        ),
      );
    });

    //  signUp - generic error
    test('signUp throws Exception on generic error', () async {
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenThrow(Exception('Some generic error'));

      expect(
        () => repository.signUp('test@example.com', 'password123'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Sign Up Failed'),
          ),
        ),
      );
    });

    //  login - success
    test('login returns User on success', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockUser);

      final user = await repository.login('test@example.com', 'password123');

      expect(user, equals(mockUser));
    });

    //  login - FirebaseAuthException
    test('login throws Exception on FirebaseAuthException', () async {
      final exception = FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for that email.',
      );

      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrongpass',
        ),
      ).thenThrow(exception);

      expect(
        () => repository.login('test@example.com', 'wrongpass'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Log in Failed'),
          ),
        ),
      );
    });

    //  login - generic error
    test('login throws Exception on generic error', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrongpass',
        ),
      ).thenThrow(Exception('Unexpected error'));

      expect(
        () => repository.login('test@example.com', 'wrongpass'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Login Failed'),
          ),
        ),
      );
    });

    //  signOut
    test('signOut calls FirebaseAuth.signOut', () async {
      when(mockAuth.signOut()).thenAnswer((_) async {});
      await repository.signOut();
      verify(mockAuth.signOut()).called(1);
    });

    //  currentUser
    test('currentUser returns FirebaseAuth.currentUser', () {
      when(mockAuth.currentUser).thenReturn(mockUser);
      final user = repository.currentUser;
      expect(user, equals(mockUser));
    });

    //  signInWithGoogle
    test('signInWithGoogle returns User on success', () async {
      final mockGoogleAccount = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();

      when(
        mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockGoogleAccount);
      when(
        mockGoogleAccount.authentication,
      ).thenAnswer((_) async => mockGoogleAuth);
      when(mockGoogleAuth.accessToken).thenReturn('access-token');
      when(mockGoogleAuth.idToken).thenReturn('id-token');

      when(
        mockAuth.signInWithCredential(any),
      ).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final user = await repository.signInWithGoogle();

      expect(user, equals(mockUser));
      verify(mockGoogleSignIn.signIn()).called(1);
      verify(mockAuth.signInWithCredential(any)).called(1);
    });

    //  signGoogleOut
    test('signGoogleOut signs out of Firebase and Google', () async {
      when(mockAuth.signOut()).thenAnswer((_) async {});
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      await repository.signGoogleOut();
      verify(mockAuth.signOut()).called(1);
      verify(mockGoogleSignIn.signOut()).called(1);
    });

    test(
      'signInWithGoogle throws Exception if authentication step fails',
      () async {
        final mockGoogleAccount = MockGoogleSignInAccount();

        when(
          mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockGoogleAccount);
        when(
          mockGoogleAccount.authentication,
        ).thenThrow(Exception('Auth failed'));

        expect(
          () => repository.signInWithGoogle(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Google Sign-In Failed'),
            ),
          ),
        );
      },
    );
  });
}
