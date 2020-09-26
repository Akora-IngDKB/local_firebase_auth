part of local_firebase_auth;

/// A user account
// TODO: 2. Implement user delete
class User {
  String _displayName;
  String _email;
  bool _emailVerified;
  bool _isAnonymous;
  String _phoneNumber;
  String _photoURL;
  String _uid;
  String _password;

  /// The users display name.
  ///
  /// Will be `null` if signing in anonymously or via password authentication.
  String get displayName {
    return _displayName;
  }

  /// The users email address.
  ///
  /// Will be `null` if signing in anonymously.
  String get email {
    return _email;
  }

  /// Returns whether the users email address has been verified.
  bool get emailVerified {
    return _emailVerified;
  }

  /// Returns whether the user is a anonymous.
  bool get isAnonymous {
    return _isAnonymous;
  }

  /// Returns the users phone number.
  String get phoneNumber {
    return _phoneNumber;
  }

  /// Returns a photo URL for the user.
  String get photoURL {
    return _photoURL;
  }

  /// The user's unique ID.
  String get uid {
    return _uid;
  }

  User._([Map<String, dynamic> map]) {
    _displayName = map['displayName'];
    _email = map['email'];
    _emailVerified = map['emailVerified'] ?? true;
    _isAnonymous = map['isAnonymous'] ?? false;
    _phoneNumber = map['phoneNumber'];
    _photoURL = map['photoURL'];
    _uid = map['uid'];
    _password = map['password'];
  }

  Map<String, dynamic> _toMap() {
    return {
      'displayName': _displayName,
      'email': _email,
      'emailVerified': _emailVerified,
      'isAnonymous': _isAnonymous,
      'phoneNumber': _phoneNumber,
      'photoURL': _photoURL,
      'uid': _uid,
      'password': _password,
    };
  }

  @override
  String toString() {
    return '$User(displayName: $displayName, email: $email, emailVerified: $emailVerified,'
        ' isAnonymous: $isAnonymous, phoneNumber: $phoneNumber, photoURL: $photoURL, uid: $uid)';
  }
}
