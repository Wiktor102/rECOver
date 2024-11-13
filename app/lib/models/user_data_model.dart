import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recover/models/auth_model.dart';
import 'package:http/http.dart' as http;

class UserDataModel extends ChangeNotifier {
  int mainStreak = 0;
  int points = 0;
  List<String>? tags;

  late Future<void> loadingFuture;

  AuthModel authModel;
  void update(newAuthModel) {
    if (authModel.user?.id == authModel.user?.id) {
      authModel = newAuthModel; // Update this anyway but do not fetch
      return;
    }

    authModel = newAuthModel;
    notifyListeners();
    _init();
  }

  UserDataModel(this.authModel) {
    _init();
  }

  void _init() {
    if (!authModel.initialized || !authModel.loggedIn) {
      loadingFuture = Future.error(false);
      return;
    }

    if (authModel.localAccount) {
      loadingFuture = _loadLocalUserData();
    } else {
      loadingFuture = _fetchUserData();
    }

    notifyListeners();
  }

  Future<void> _fetchUserData() async {
    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/user");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/user");
    }

    try {
      final http.Response response =
          await http.get(uri, headers: {"Authorization": "Bearer ${authModel.user!.accessToken}"});
      if (response.statusCode != 200) throw Exception("${response.statusCode}: ${response.body}");

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      mainStreak = data["mainStreak"];
      points = data["points"];
      tags = data["tags"];

      print(response.body);
    } catch (e) {
      print(e);
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadLocalUserData() async {
    try {} catch (e) {
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }
}
