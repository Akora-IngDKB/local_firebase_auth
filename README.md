# local_firebase_auth
[![Pub](https://img.shields.io/pub/v/local_firebase_auth.svg?style=flat-square&logo=dart&logoColor=white&color=blue)](https://pub.dev/packages/local_firebase_auth)
[![Github Master Workflow Status](https://img.shields.io/github/workflow/status/Akora-IngDKB/local_firebase_auth/Tests/master?label=Tests&labelColor=333940&logo=github&style=flat-square)](https://github.com/Akora-IngDKB/local_firebase_auth/actions)
![Github Language](https://img.shields.io/github/languages/top/Akora-IngDKB/show_hide_fab?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-purple.svg?style=flat-square&logo=apache)](https://github.com/Akora-IngDKB/local_firebase_auth/blob/master/LICENSE)  

An experimental dart package that mocks (emulates) the [firebase_auth](https://pub.dev/packages/firebase_auth) plugin for quick and offline development.

> ## Intended to be used solely for development.

## Usage
1. Depend on the package by adding it to your pubspec.yaml dependencies.  
`local_firebase_auth: <latest_version>`


2. Import the library.
```dart
import 'package:local_firebase_auth/local_firebase_auth.dart';
```

When using this package alongside the official firebase plugin, it's advisable to import with a prefix to prevent conflict since it has same class names except `LocalFirebaseAuth` (ofc :stuck_out_tongue_winking_eye:). Eg.  

```dart
import 'package:local_firebase_auth/local_firebase_auth.dart' as localAuth;
```


3. Be sure to initialize the package before using. **An exception will be raised if the package is not initialized before usage.**  
```dart
LocalFirebaseAuth.initialize('appName');
```


4. Use it as you would the official plugin.
For instance, you can create a new user as:  
```dart
final UserCredential result = await LocalFirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: pass,
);

final User user = result.user;
print(user.uid);
```

## Supported methods
Since this is a mock and experimental package, it is in no way meant as a replacement for Firebase but for use quick and offline development use-cases.  
The following methods are currently available:  

| Method | Signature | Parameters |
| :--- | :--- | :--- |
| `createUserWithEmailAndPassword` | `Future<UserCredential>` | `String email, String password` |
| `signInAnonymously` | `Future<UserCredential>` | None |
| `signInWithEmailAndPassword` | `Future<UserCredential>` | `String email, String password` |
| `signOut` | `Future<void>` | None |

## Get Current User
```dart
final User user = LocalFirebaseAuth.instance.currentUser;
```

## Contributing
This project is fully open-source. Feel free to open issues when you realize one and PRs are welcome as well.  

## Official Plugins Documentation
For the full documentation of the official Firebase plugins, please [see the documentation](https://firebase.flutter.dev/docs/overview) available at https://firebase.flutter.dev

## License
This project has been licensed under the MIT License. Check the [LICENSE](https://github.com/Akora-IngDKB/local_firebase_auth/blob/master/LICENSE) file for the details.
