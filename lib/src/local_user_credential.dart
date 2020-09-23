part of local_firebase_auth;

/// A UserCredential is returned from authentication requests such as
/// [`createUserWithEmailAndPassword`].
class UserCredential {
  final User _user;

  UserCredential._(this._user);

  /// Returns a [User] containing additional information and user specific
  /// methods.
  User get user {
    return _user;
  }

  @override
  String toString() {
    return 'UserCredential($user)';
  }
}
