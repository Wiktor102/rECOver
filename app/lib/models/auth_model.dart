import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool loggedIn = false;
  bool localAccount = false;

  Future<String?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 3));

    if (username == 'admin' && password == 'admin') {
      loggedIn = true;
      localAccount = false;
      notifyListeners();
      return null;
    }

    return "Nieprawidłowa nazwa użytkownika lub hasło";
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void useLocalAccount() {
    logout();
    localAccount = true;
    notifyListeners();
  }
}
