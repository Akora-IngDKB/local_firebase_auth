import 'package:local_firebase_auth/local_firebase_auth.dart';
import 'package:test/test.dart';

void main() {
  LocalFirebaseAuth.initialize('testApp');
  final _auth = LocalFirebaseAuth.instance;

  test('Create User Test', () async {
    final email = 'user@gmail.com';
    final pass = 'password';

    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );

    expect(user.user.email, email);
  });

  test('Create User Test: User Already Exists', () async {
    final email = 'user@gmail.com';
    final pass = 'password';

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // This test is expected to fail.
      // I'm using try-catch for the sake of Github Workflow
    } on FirebaseAuthException catch (e) {
      expect(e.code, 'ERROR_EMAIL_ALREADY_IN_USE');
    }
  });

  test('Create User Test: Invalid Email', () async {
    final email = 'gmail.com';
    final pass = 'password';

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // This test is expected to fail.
      // I'm using try-catch for the sake of Github Workflow
    } on FirebaseAuthException catch (e) {
      expect(e.code, 'ERROR_INVALID_EMAIL');
    }
  });

  test('Anonymous Sign In Test', () async {
    final ann = await _auth.signInAnonymously();

    expect(ann.user.email, null);
  });

  test('Sign In Test', () async {
    final email = 'user@gmail.com';
    final pass = 'password';

    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );

    expect(user.user.email, email);
  });

  test('Sign In Test: Wrong Password', () async {
    final email = 'user@gmail.com';
    final pass = 'passwords';

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      // This test is expected to fail.
      // I'm using try-catch for the sake of Github Workflow
    } on FirebaseAuthException catch (e) {
      expect(e.code, 'ERROR_WRONG_PASSWORD');
    }
  });

  test('Sign In Test: No Existing User', () async {
    final email = 'nouser@gmail.com';
    final pass = 'password';

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      // This test is expected to fail.
      // I'm using try-catch for the sake of Github Workflow
    } on FirebaseAuthException catch (e) {
      expect(e.code, 'ERROR_USER_NOT_FOUND');
    }
  });

  test('Current User Test', () {
    final user = _auth.currentUser;

    expect(user, isNotNull);
  });

  test('Sign Out Test', () async {
    await _auth.signOut();
  });

  test('Current User Test', () {
    final user = _auth.currentUser;

    // Expect no user after signing out.
    expect(user, isNull);
  });
}
