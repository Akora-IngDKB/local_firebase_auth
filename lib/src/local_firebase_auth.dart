part of local_firebase_auth;

class LocalFirebaseAuth {
  static final LocalFirebaseAuth _instance = LocalFirebaseAuth._internal();
  LocalFirebaseAuth._internal();
  factory LocalFirebaseAuth() => _instance;

  static LocalFirebaseAuth get instance => _instance;

  static Box _box;
  static String _appName;

  LocalFirebaseAuth.initialize(String appName) {
    _appName = appName;
    Hive.init(appName);
    Hive.openBox(appName).then((box) => _box = box);
  }

  User get currentUser {
    return _users[_currentUserId];
  }

  // TODO: 1. Validate email (RegEx)
  // TODO: 2. Throw appropriate exceptions
  Future<UserCredential> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    _checkInitialization();
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
    _box.put(uid, _user._toMap());

    // Automatically sign out all users and sign in this one.
    _currentUserId = uid;

    return UserCredential._(_user);
  }

  Future<UserCredential> signInAnonymously() async {
    _checkInitialization();
    await Future.delayed(Duration(milliseconds: 1000));

    final uid = randomAlphaNumeric(28);

    final _user = User._({
      'isAnonymous': true,
      'uid': uid,
    });

    // Using [putIfAbsent] for the sake of sanity
    _users.putIfAbsent(uid, () => _user);
    _box.put(uid, _user._toMap());

    // Automatically sign out all users and sign in this one.
    _currentUserId = uid;

    return UserCredential._(_user);
  }

  // TODO: 1. Validate Email (RegEx)
  // TODO: 2. Validate password
  Future<UserCredential> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    _checkInitialization();

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
    _checkInitialization();

    await Future.delayed(Duration(milliseconds: 500));

    // Remove current user email
    _currentUserId = null;
  }

  static Map<String, User> _users = {};
  static String _currentUserId;

  static void _checkInitialization() {
    if (_appName == null) {
      throw Exception(
        "LocalFirebaseAuth has not been initialized.\n"
        "Please call LocalFirebaseAuth.initialize('appName') before using any of the methods",
      );
    }
  }
}
