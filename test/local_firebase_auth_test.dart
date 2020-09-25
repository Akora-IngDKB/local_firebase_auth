import 'package:local_firebase_auth/local_firebase_auth.dart';
import 'package:test/test.dart';

void main() {
  LocalFirebaseAuth.initialize('testApp');
  final _auth = LocalFirebaseAuth.instance;

  test('User creation test', () async {
    final email = 'user@gmail.com';
    final pass = 'password';
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);

    expect(user.user.email, email);
  });

  test('Anonymous Sign In Test', () async {
    final ann = await _auth.signInAnonymously();

    expect(ann.user.email, null);
  });

  // test('User sign in test', () async {
  //   final user1 = await _auth.signInWithEmailAndPassword(
  //       email: 'user1@gmail.com', password: 'password');

  //   try {
  //     final noUser = await _auth.signInWithEmailAndPassword(
  //         email: 'nouser@gmail.com', password: 'password');

  //     print("Sign In No User: ${noUser.user}");
  //   } on FirebaseAuthException catch (e) {
  //     print(e.toString());
  //   } catch (e) {}

  //   print("Sign In User 1: ${user1.user}");
  // });

  // test('Current user test', () {
  //   final currentUser = _auth.currentUser;

  //   print("Current User: $currentUser");
  // });

  // test('Sign Out test', () async {
  //   await _auth.signOut();
  // });

  // test('Current user test 2', () {
  //   final currentUser = _auth.currentUser;

  //   print("Current User: $currentUser");
  // });
}
