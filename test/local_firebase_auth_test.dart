import 'package:local_firebase_auth/local_firebase_auth.dart';
import 'package:test/test.dart';

void main() {
  LocalFirebaseAuth.initialize('testApp');
  final _auth = LocalFirebaseAuth.instance;

  group('User Creation Tests:', () {
    test('Create User Test', () async {
      final email = 'user@gmail.com';
      final pass = 'password';

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      expect(credential.user.email, email);
    });

    test('Create User Test: User Already Exists', () {
      final email = 'user@gmail.com';
      final pass = 'password';

      expect(
        _auth.createUserWithEmailAndPassword(email: email, password: pass),
        throwsException,
      );
    });

    test('Create User Test: Invalid Email', () {
      final email = 'gmail.com';
      final pass = 'password';

      expect(
        _auth.createUserWithEmailAndPassword(email: email, password: pass),
        throwsException,
      );
    });
  });

  group('Anonymous User Tests:', () {
    User ann1;
    test('Sign In Test', () async {
      final ann = await _auth.signInAnonymously();

      ann1 = ann.user;
      expect(ann.user.email, isNull);
    });

    test('', () async {
      final ann2 = await _auth.signInAnonymously();

      // Currently logged in user is anonymous.
      // We expect the same user to be returned.
      expect(ann2.user.uid, ann1.uid);
    });
  });

  group('Sign In Tests:', () {
    test('Sign In Test', () async {
      final email = 'user@gmail.com';
      final pass = 'password';

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      expect(credential.user.email, email);
    });

    test('Sign In Test: Wrong Password', () {
      final email = 'user@gmail.com';
      final pass = 'passwords';

      expect(
        _auth.signInWithEmailAndPassword(email: email, password: pass),
        throwsException,
      );
    });

    test('Sign In Test: No Existing User', () {
      final email = 'nouser@gmail.com';
      final pass = 'password';

      expect(
        _auth.signInWithEmailAndPassword(email: email, password: pass),
        throwsException,
      );
    });
  });

  group('Current User/Sign Out Tests:', () {
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
  });

  group('User Deletion Tests:', () {
    User user;

    test('Delete Anonymous User', () async {
      final ann = await _auth.signInAnonymously();

      // This test will fail when there's an exception.
      await ann.user.delete();

      expect(_auth.currentUser, isNull);
    });

    test('Delete Non-anonymous User', () async {
      final email = 'user@gmail.com';
      final pass = 'password';

      // Sign in again. Previous test signed out current user.
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      user = credential.user;

      // This test will fail when there's an exception.
      await credential.user.delete();
    });

    test('Delete Non-Signed-In Non-anonymous User', () async {
      // This test is expected to fail.
      // I'm using try-catch for the sake of Github Workflow.
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        expect(e.code, 'ERROR_REQUIRES_RECENT_LOGIN');
      }
    });
  });
}
