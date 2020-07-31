import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Session {
  Future<Map<String, dynamic>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData = await json.decode(prefs.getString('userData'));
    return userData;
  }

  Future<void> login(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthenticated', true);
    prefs.setString('userData', json.encode(userData));
    prefs.setString('lastEmail', userData['email']);
  }

  Future<String> getLastEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastEmail');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', '{}');
    prefs.setBool('isAuthenticated', false);
  }

  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> setTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }

  Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme');
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated');
  }
}
