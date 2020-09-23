import 'package:flutter_test/flutter_test.dart';
import 'package:local_firebase_auth/local_firebase_auth.dart';

void main() {
  final _auth = LocalFirebaseAuth.instance;
  test('User creation test', () async {
    final user1 = await _auth.createUserWithEmailAndPassword(
        email: 'user1@gmail.com', password: 'password');

    final user3 = await _auth.signInAnonymously();

    print("User 1: ${user1.user}");
    print("User 3: ${user3.user}");
  });

  test('User sign in test', () async {
    final user1 = await _auth.signInWithEmailAndPassword(
        email: 'user1@gmail.com', password: 'password');

    try {
      final noUser = await _auth.signInWithEmailAndPassword(
          email: 'nouser@gmail.com', password: 'password');

      print("Sign In No User: ${noUser.user}");
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {}

    print("Sign In User 1: ${user1.user}");
  });

  test('Current user test', () {
    final currentUser = _auth.currentUser;

    print("Current User: $currentUser");
  });

  test('Sign Out test', () async {
    await _auth.signOut();
  });

  test('Current user test 2', () {
    final currentUser = _auth.currentUser;

    print("Current User: $currentUser");
  });
}
