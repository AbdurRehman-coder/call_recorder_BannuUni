import 'dart:convert';


import 'package:call_recorder/model/local_user.dart';
import 'package:call_recorder/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefStorage implements IStorage {
  static final PrefStorage _instance = PrefStorage._internal();

  static PrefStorage get instance => _instance;

  factory PrefStorage() {
    return _instance;
  }
  PrefStorage._internal();

  static late SharedPreferences _prefs;

  static const _keyUser = 'userData';
  static const _userToken = 'token';

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }





  @override
  Future<void> setUserToken(String token) =>
      _prefs.setString(_userToken, token);

  @override
  Future<void> allClear() => _prefs.clear();


  @override
  Future<bool> setUser(LocalUser user) =>
      _prefs.setString(_keyUser, jsonEncode(user.toJson()));

  @override
  LocalUser? get user {
    final userString = _prefs.getString(_keyUser);
    if (userString != null) {
      final userJson = jsonDecode(userString);
      return LocalUser.fromJson(userJson);
    }
    return null;
  }
  @override
  Future<bool> removeUser() => _prefs.remove(_keyUser);

}
