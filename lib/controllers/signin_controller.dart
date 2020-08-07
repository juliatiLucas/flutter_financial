import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/session.dart';
import '../pages/home_page.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();
  final Session _session = Session();
  Rx<bool> obscure = Rx<bool>(true);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  toggleObscure() {
    obscure.value = !obscure.value;
    update();
  }

  void getLastEmail() async {
    this.email.text = await _session.getLastEmail() ?? "";
  }

  void showSnack(BuildContext context, String title, String message) {
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

  void signIn(BuildContext context) async {
    Map<String, String> data = {"email": this.email.text, "password": this.password.text};
    await http
        .post("${Config.api}/users/login/", body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
      print(res.statusCode);
      if (res.statusCode == 200) {
        _session.login(json.decode(res.body));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
        this.password.text = "";
      } else if (res.statusCode == 400) this.showSnack(context, "Erro", "E-mail ou senha incorretos!");
    });
  }
}
