import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:io';

const secureStorage = FlutterSecureStorage();

class AuthModel extends ChangeNotifier {
  bool localAccount = false;
  bool initialized = false;

  String username = "";
  String? accessToken;

  bool get loggedIn => accessToken != null || localAccount;

  Future<void> init() async {
    if (initialized) throw Exception("AuthModel is already initialized");
    // TODO: check for a local account

    String? refreshToken = await _getRefreshToken();
    if (refreshToken != null) {
      await refreshAccessToken(refreshToken);
      initialized = true;
      notifyListeners();
    }
  }

  Future<String?> login(String username, String password) async {
    Stopwatch stopwatch = Stopwatch()..start();
    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/auth/login");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/auth/login");
    }

    final String body = json.encode({
      "username": username,
      "password": password,
    });

    String? popupText;

    try {
      final http.Response response =
          await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
      if (![404, 200].contains(response.statusCode)) throw Exception(response.statusCode);

      if (response.statusCode == 404) {
        popupText = "Błędny e-mail lub hasło";
      }

      if (response.statusCode == 200) {
        dynamic decodedResponse;

        try {
          decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        } catch (e) {
          throw Exception(response.body);
        }

        String newAccessToken = decodedResponse["accessToken"]["token"];
        String refreshToken = decodedResponse["refreshToken"];

        final Map<String, dynamic> decodedJWT = Jwt.parseJwt(newAccessToken);
        username = decodedJWT["preferred_username"];
        accessToken = newAccessToken;

        await _saveRefreshToken(refreshToken);
      }
    } catch (e) {
      print(e);
      popupText = "Wystąpił nieznany błąd! Proszę spróbować później";
    } finally {
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds < 2000) {
        await Future.delayed(Duration(milliseconds: 2000 - stopwatch.elapsedMilliseconds));
      }

      notifyListeners();
    }

    return popupText;
  }

  void logout() {
    accessToken = null;
    notifyListeners();
  }

  void useLocalAccount() {
    logout();
    localAccount = true;
    notifyListeners();
  }

  // tokens handling
  Future<void> _saveRefreshToken(String jwt) async {
    await secureStorage.write(key: 'RT', value: jwt);
  }

  Future<String?> _getRefreshToken() async {
    var jwt = await secureStorage.read(key: 'RT');
    return jwt;
  }

  Future<void> refreshAccessToken(String? refreshToken) async {
    refreshToken ??= await _getRefreshToken();

    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/auth/refreshToken");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/auth/refreshToken");
    }

    try {
      final http.Response response = await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $refreshToken',
        },
      );

      if (response.statusCode != 200) throw Exception(response.statusCode);
      dynamic decodedResponse;

      try {
        decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      } catch (e) {
        throw Exception(response.body);
      }

      if (response.statusCode != 200) {
        throw Exception("#${response.statusCode}: $decodedResponse");
      }

      if (decodedResponse["token"] != null) {
        final Map<String, dynamic> decodedJWT = Jwt.parseJwt(decodedResponse["token"]);
        accessToken = decodedResponse["token"];
        username = decodedJWT["preferred_username"];
        notifyListeners();
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
