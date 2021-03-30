/// An experimental dart package that mocks (emulates) the [firebase_auth](https://pub.dev/packages/firebase_auth)
/// plugin for quick and offline development.
///
/// This is intended to be used solely for development and not as a replacement
/// for Firebase.
library local_firebase_auth;

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:random_string/random_string.dart';

part 'src/local_user.dart';
part 'src/local_user_credential.dart';
part 'src/local_firebase_auth.dart';
part 'src/local_firebase_auth_exception.dart';
part 'src/email_validator.dart';
