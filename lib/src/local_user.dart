part of local_firebase_auth;

/// A user account
// TODO: 1. Add passwords
// TODO: 2. Implement user delete
class User {
  String _displayName;
  String _email;
  bool _emailVerified;
  bool _isAnonymous;
  String _phoneNumber;
  String _photoURL;
  String _uid;

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
  }

  Map<String, dynamic> _toMap() {
    return {
      'displayName': this._displayName,
      'email': this.email,
      'emailVerified': this._emailVerified,
      'isAnonymous': this._isAnonymous,
      'phoneNumber': this._phoneNumber,
      'photoURL': this._photoURL,
      'uid': this._uid,
    };
  }

  @override
  String toString() {
    return '$User(displayName: $displayName, email: $email, emailVerified: $emailVerified,'
        ' isAnonymous: $isAnonymous, phoneNumber: $phoneNumber, photoURL: $photoURL, uid: $uid)';
  }
}
