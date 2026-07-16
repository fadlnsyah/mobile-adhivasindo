import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

class AuthStorage {
  static const _tokenKey = 'access_token';
  static const _userKey = 'auth_user';

  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
  }

  Future<void> saveUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final userJson = preferences.getString(_userKey);

    if (userJson == null) {
      return null;
    }

    final decodedUser = jsonDecode(userJson);

    if (decodedUser is Map<String, dynamic>) {
      return UserModel.fromJson(decodedUser);
    }

    return null;
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_userKey);
  }
}
