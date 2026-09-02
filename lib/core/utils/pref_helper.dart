import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';

  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setUserId(String userId) async {
    debugPrint('Setting user ID in SharedPreferences: $userId');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    debugPrint('Getting user ID from SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    debugPrint('User ID: $userId');
    return userId;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
  }
}
