import 'package:local_firebase_auth/local_firebase_auth.dart';

void main(List<String> arguments) async {
  // Initialize package
  LocalFirebaseAuth.initialize('exampleApp');

  final _auth = LocalFirebaseAuth.instance;

  final email = 'user@gmail.com';
  final pass = 'password';

  // Create a new user
  final result = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: pass,
  );

  print('New User ID: ${result.user.uid}');

  // Sign in
  final result2 = await _auth.signInWithEmailAndPassword(
    email: email,
    password: pass,
  );

  print('Is Same User: ${result.user.uid == result2.user.uid}');

  // Get current user
  final user = _auth.currentUser;
  print('Current User: ${user!.email}');

  // Sign out
  await _auth.signOut().then((value) => print('Signed Out'));

  // Get current user
  final user2 = _auth.currentUser;
  print('Current User: $user2');
}
