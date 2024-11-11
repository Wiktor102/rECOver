import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

const secureStorage = FlutterSecureStorage();

class AuthModel extends ChangeNotifier {
  bool loggedIn = false;
  bool localAccount = false;
  bool initialized = false;

  Future<void> init() async {
    if (initialized) throw Exception("AuthModel is already initialized");
    // TODO: check for a local account

    if (await refreshJWT()) {
      loggedIn = true;
    }

    initialized = true;
    notifyListeners();
  }

  Future<bool> refreshJWT() async {
    var refreshToken = await secureStorage.read(key: 'RT');
    var jwt = "admin";

    secureStorage.write(key: 'JWT', value: jwt);
    return true;
  }

  Future<String?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 3));

    if (username == 'admin' && password == 'admin') {
      loggedIn = true;
      localAccount = false;
      var jwt = "admin";

      secureStorage.write(key: 'JWT', value: jwt);
      secureStorage.write(key: 'RT', value: jwt); // Refresh token
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
