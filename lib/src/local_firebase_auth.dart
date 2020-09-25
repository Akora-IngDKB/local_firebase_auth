part of local_firebase_auth;

class LocalFirebaseAuth {
  static final LocalFirebaseAuth _instance = LocalFirebaseAuth._internal();
  LocalFirebaseAuth._internal();
  factory LocalFirebaseAuth() => _instance;

  static LocalFirebaseAuth get instance => _instance;

  static Box _box;
  static String _appName;

  static final String CURRENT_USER_KEY = 'currentUserId';

  LocalFirebaseAuth.initialize(String appName) {
    _appName = appName;
    Hive.init(appName);
    Hive.openBox(appName).then((box) => _box = box);
  }

  User get currentUser => _getUser(currentUser: true);

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

    if (_userExists(email)) {
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

    _box.put(uid, _user._toMap());

    // Automatically sign out all users and sign in this one.
    _box.put(CURRENT_USER_KEY, uid);

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

    _box.put(uid, _user._toMap());

    // Automatically sign out all users and sign in this one.
    _box.put(CURRENT_USER_KEY, uid);

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

    if (!_userExists(email)) {
      throw FirebaseAuthException(
        code: 'ERROR_USER_NOT_FOUND',
        message: 'No account found with the given email address.',
        email: email,
      );
    }

    final _user = _getUser(email: email);

    // Automatically sign out all users and sign in this one.
    _box.put(CURRENT_USER_KEY, _user.uid);

    return UserCredential._(_user);
  }

  Future<void> signOut() async {
    _checkInitialization();

    await Future.delayed(Duration(milliseconds: 500));

    // Remove current user uid
    _box.put(CURRENT_USER_KEY, null);
  }

  static void _checkInitialization() {
    if (_appName == null) {
      throw Exception(
        "LocalFirebaseAuth has not been initialized.\n"
        "Please call LocalFirebaseAuth.initialize('appName') before using any of the methods",
      );
    }
  }

  static bool _userExists(String email) {
    for (var value in _box.values) {
      if (value is Map<String, dynamic>) {
        final _userMap = Map<String, dynamic>.from(value);

        return _userMap.containsValue(email);
      }
    }

    return false;
  }

  static User _getUser({String email, bool currentUser = false}) {
    var values = _box.values;
    final userList = values.toList();
    userList.retainWhere((element) => element is Map<String, dynamic>);

    for (var value in userList) {
      if (currentUser) {
        final _cUid = _box.get('currentUserId');

        if (_cUid == null) return null;

        return User._(userList.firstWhere((e) => e['uid'] == _cUid));
      } else {
        final _userMap = Map<String, dynamic>.from(value);

        if (_userMap['email'] == email) {
          return User._(_userMap);
        }
      }
    }

    return null;
  }
}
