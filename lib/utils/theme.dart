import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './session.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primarySwatch: Colors.teal,
    accentColor: Color(0xff0bbaba),
    primaryColor: Color(0xff0bbaba),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    secondaryHeaderColor: Colors.grey[200],
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    accentColor: Color(0xff0bbaba),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    secondaryHeaderColor: Color(0xff242424)
  );

  static void setTheme(String theme) async {
    theme == 'light' ? Get.changeTheme(light) : Get.changeTheme(dark);
    Session session = Session();
    await session.setTheme(theme);
  }
}
