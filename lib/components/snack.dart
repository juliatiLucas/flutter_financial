import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnack {
  static void showSnack(BuildContext context, String title, String message) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        message,
        duration: Duration(milliseconds: 2500),
        isDismissible: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        messageText: Text(message),
        boxShadows: [BoxShadow(offset: Offset(0, 2), blurRadius: 2.2, color: Colors.black.withOpacity(0.24))],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        margin: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        animationDuration: Duration(milliseconds: 150),
      );
    }
  }
}
