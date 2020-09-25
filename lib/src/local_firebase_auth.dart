part of local_firebase_auth;

class LocalFirebaseAuth {
  static final LocalFirebaseAuth _instance = LocalFirebaseAuth._internal();
  LocalFirebaseAuth._internal();
  factory LocalFirebaseAuth() => _instance;

  static LocalFirebaseAuth get instance => _instance;

  User get currentUser {
    return _users[_currentUserId];
  }

  // TODO: 1. Validate email (RegEx)
  // TODO: 2. Throw appropriate exceptions
  Future<UserCredential> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null, "[email] cannot be null");
    assert(password != null, "[password] cannot be null");

    await Future.delayed(Duration(milliseconds: 1500));

    if (_users.containsKey(email)) {
      throw FirebaseAuthException(
        code: 'ERROR_EMAIL_ALREADY_IN_USE',
        message:
            'There already exists an account with the given email address.',
        email: email,
      );
    }

    final uid = randomAlphaNumeric(28);

    final _user = User._({
      'email': email,
      'isAnonymous': false,
      'uid': uid,
    });

    // Using [putIfAbsent] for the sake of sanity
    _users.putIfAbsent(uid, () => _user);

    // Automatically sign out all users and sign in this one.
    _currentUserId = uid;

    return UserCredential._(_user);
  }

  Future<UserCredential> signInAnonymously() async {
    await Future.delayed(Duration(milliseconds: 1000));

    return UserCredential._(
      User._({
        'isAnonymous': true,
        'uid': randomAlphaNumeric(40),
      }),
    );
  }

  // TODO: 1. Validate Email (RegEx)
  // TODO: 2. Validate password
  Future<UserCredential> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null, "[email] cannot be null");
    assert(password != null, "[password] cannot be null");

    await Future.delayed(Duration(milliseconds: 1000));

    if (!_users.values.any((u) => u.email == email)) {
      throw FirebaseAuthException(
        code: 'ERROR_USER_NOT_FOUND',
        message: 'No account found with the given email address.',
        email: email,
      );
    }

    final _user = _users.values.firstWhere((u) => u.email == email);

    // Automatically sign out all users and sign in this one.
    _currentUserId = _user.uid;

    return UserCredential._(_user);
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 500));

    // Remove current user email
    _currentUserId = null;
  }

  static Map<String, User> _users = {};
  static String _currentUserId;
}
