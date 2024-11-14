import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:recover/models/auth_model.dart';
import 'package:http/http.dart' as http;

abstract class UserDataModel extends ChangeNotifier {
  late String username;
  int mainStreak = 0;
  int points = 0;
  List<String>? tags;

  _Records todayRecords = _Records();

  late Future<void> loadingFuture;

  AuthModel authModel;
  void update(newAuthModel) {
    if (authModel.accessToken == authModel.accessToken) {
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

    loadingFuture = Future.wait([_loadUserData(), _loadTodayRecords()]);
    notifyListeners();
  }

  Future<void> _loadUserData();
  Future<void> updateTags(List<String> newTags);

  Future<void> saveRecords(List<String>? usedTransport, List<int>? otherRecords);
  Future<void> _loadTodayRecords();

  factory UserDataModel.create(AuthModel authModel) {
    if (authModel.localAccount) {
      return LocalUserDataModel._(authModel);
    } else {
      return OnlineUserDataModel._(authModel);
    }
  }
}

class OnlineUserDataModel extends UserDataModel {
  OnlineUserDataModel._(super.authModel);

  @override
  Future<void> _loadUserData() async {
    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/user");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/user");
    }

    try {
      final http.Response response =
          await http.get(uri, headers: {"Authorization": "Bearer ${authModel.accessToken}"});
      if (response.statusCode != 200) throw Exception("${response.statusCode}: ${response.body}");

      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      username = data["nick"];
      mainStreak = data["mainStreak"];
      points = data["points"];

      tags = List<String>.from(data["tags"]);

      print(response.body);
    } catch (e) {
      print(e);
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> updateTags(List<String> newTags) async {
    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/user");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/user");
    }

    final String body = json.encode({
      "tags": newTags,
    });

    try {
      final http.Response response = await http.patch(uri, body: body, headers: {
        "Authorization": "Bearer ${authModel.accessToken}",
        "Content-Type": "application/json",
      });
      print(response.body);
      if (response.statusCode != 200) throw Exception("${response.statusCode}: ${response.body}");

      tags = newTags;
    } catch (e) {
      print(e);
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> saveRecords(List<String>? usedTransport, List<int>? otherRecords) async {
    usedTransport ??= todayRecords.usedTransport;
    otherRecords ??= todayRecords.achievements;

    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/records");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/records");
    }

    final String body = json.encode({
      "usedTransport": usedTransport,
      "achievements": otherRecords,
    });

    try {
      final http.Response response = await http.put(uri, body: body, headers: {
        "Authorization": "Bearer ${authModel.accessToken}",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 403) {
        await authModel.refreshAccessToken(null);
        saveRecords(usedTransport, otherRecords);
      }

      if (response.statusCode != 200) throw Exception("${response.statusCode}: ${response.body}");
      todayRecords.usedTransport = usedTransport;
      todayRecords.achievements = otherRecords;
    } catch (e) {
      print(e);
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> _loadTodayRecords() async {
    Uri uri = Uri.parse("http://api.recover.wiktorgolicz.pl/index.php/records?date=today");
    if (!kReleaseMode) {
      uri = Uri.parse("http://10.0.2.2:3001/recover/index.php/records?date=today");
    }

    try {
      final http.Response response =
          await http.get(uri, headers: {"Authorization": "Bearer ${authModel.accessToken}"});

      if (response.statusCode == 403) {
        await authModel.refreshAccessToken(null);
        _loadTodayRecords();
      }

      if (response.statusCode != 200) throw Exception("${response.statusCode}: ${response.body}");

      var data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      todayRecords = _Records(
        usedTransport: List<String>.from(data[0]["usedTransport"]),
        achievements: List<int>.from(data[0]["achievements"]),
      );
    } catch (e) {
      print(e);
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }
}

class LocalUserDataModel extends UserDataModel {
  LocalUserDataModel._(super.authModel);

  @override
  Future<void> _loadUserData() async {
    try {} catch (e) {
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> updateTags(List<String> newTags) {
    // TODO: implement updateTags
    throw UnimplementedError();
  }

  @override
  Future<void> saveRecords(List<String>? usedTransport, List<int>? otherRecords) {
    // TODO: implement saveRecords
    throw UnimplementedError();
  }

  @override
  Future<_Records> _loadTodayRecords() {
    // TODO: implement _loadTodayRecords
    throw UnimplementedError();
  }
}

class _Records {
  List<String> usedTransport = [];
  List<int> achievements = [];

  _Records({
    this.usedTransport = const [],
    this.achievements = const [],
  });
}
