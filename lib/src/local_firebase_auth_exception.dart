part of local_firebase_auth;

/// Generic exception related to Firebase Authentication. Check the error code
/// and message for more details.
class FirebaseAuthException implements Exception {
  /// Unique error code
  final String code;

  /// Complete error message.
  final String message;

  /// The email of the user's account used for sign-in/creation.
  final String email;

  FirebaseAuthException({
    @required this.message,
    this.code,
    this.email,
  });

  @override
  String toString() {
    return "$FirebaseAuthException(message: $message, code: $code, email: $email)";
  }
}
