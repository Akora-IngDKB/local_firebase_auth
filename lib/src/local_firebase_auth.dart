part of local_firebase_auth;

/// An entry point of the [LocalFirebaseAuth] package.
class LocalFirebaseAuth {
  static final LocalFirebaseAuth _instance = LocalFirebaseAuth._internal();
  LocalFirebaseAuth._internal();
  factory LocalFirebaseAuth() => _instance;

  /// Returns an instance of the [LocalFirebaseAuth].
  static LocalFirebaseAuth get instance => _instance;

  static Box _box;
  static String _appName;

  static final String _CURRENT_USER_KEY = 'currentUserId';

  LocalFirebaseAuth.initialize(String appName) {
    _appName = appName;
    Hive.init(appName);
    Hive.openBox(appName).then((box) => _box = box);
  }

  /// Returns the current [User] if they are currently signed-in, or `null` if
  /// not.
  User get currentUser => _getUser(currentUser: true);

  /// Tries to create a new user account with the given email address and
  /// password.
  ///
  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  Future<UserCredential> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    _checkInitialization();

    assert(email != null, '[email] cannot be null');
    assert(password != null, '[password] cannot be null');

    if (!_EmailValidator._validate(email)) {
      throw FirebaseAuthException(
        code: 'ERROR_INVALID_EMAIL',
        message: 'The given email address is invalid.',
        email: email,
      );
    }

    await Future.delayed(Duration(milliseconds: 1000));

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
      'password': password,
    });

    await _box.put(uid, _user._toMap());

    // Automatically sign out all users and sign in this one.
    await _box.put(_CURRENT_USER_KEY, uid);

    return UserCredential._(_user);
  }

  /// Asynchronously creates and becomes an anonymous user.
  ///
  /// If there is already an anonymous user signed in, that user will be
  /// returned instead. If there is any other existing user signed in, that
  /// user will be signed out.
  Future<UserCredential> signInAnonymously() async {
    _checkInitialization();

    await Future.delayed(Duration(milliseconds: 1000));

    final _user = _getUser(currentUser: true);

    // Return current user if it is anonymous.
    if (_user != null && _user.isAnonymous) {
      await _box.put(_CURRENT_USER_KEY, _user.uid);

      return UserCredential._(_user);
    }

    final uid = randomAlphaNumeric(28);

    final _newAnnUser = User._({
      'isAnonymous': true,
      'emailVerified': false,
      'uid': uid,
    });

    await _box.put(uid, _newAnnUser._toMap());

    // Automatically sign out all users and sign in this one.
    await _box.put(_CURRENT_USER_KEY, uid);

    return UserCredential._(_newAnnUser);
  }

  /// Attempts to sign in a user with the given email address and password.
  ///
  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **user-not-found**:
  ///  - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
  ///  - Thrown if the password is invalid for the given email, or the account
  ///    corresponding to the email does not have a password set.
  Future<UserCredential> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    _checkInitialization();

    assert(email != null, '[email] cannot be null');
    assert(password != null, '[password] cannot be null');

    if (!_EmailValidator._validate(email)) {
      throw FirebaseAuthException(
        code: 'ERROR_INVALID_EMAIL',
        message: 'The given email address is invalid.',
        email: email,
      );
    }

    await Future.delayed(Duration(milliseconds: 1000));

    if (!_userExists(email)) {
      throw FirebaseAuthException(
        code: 'ERROR_USER_NOT_FOUND',
        message: 'No account found with the given email address.',
        email: email,
      );
    }

    final _user = _getUser(email: email);

    if (_user._password != password) {
      throw FirebaseAuthException(
        code: 'ERROR_WRONG_PASSWORD',
        message:
            'Password does not match the account associated with the email address.',
        email: email,
      );
    }

    // Automatically sign out all users and sign in this one.
    await _box.put(_CURRENT_USER_KEY, _user.uid);

    return UserCredential._(_user);
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    _checkInitialization();

    await Future.delayed(Duration(milliseconds: 500));

    // Remove current user uid
    await _box.put(_CURRENT_USER_KEY, null);
  }

  static void _checkInitialization() {
    if (_appName == null) {
      throw Exception(
        'LocalFirebaseAuth has not been initialized.\n'
        "Please call LocalFirebaseAuth.initialize('appName') before using any of the methods",
      );
    }
  }

  static bool _userExists(String email) {
    var values = _box.values;
    final userList = values.toList();
    userList.retainWhere((element) => element is Map<String, dynamic>);

    return userList.any((e) => e['email'] == email);
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
