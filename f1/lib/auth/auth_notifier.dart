import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;

  AuthNotifier(this._auth) {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _user != null;
  User? get user => _user;
}
