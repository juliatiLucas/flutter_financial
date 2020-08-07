import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/session.dart';
import '../pages/home_page.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();
  final Session _session = Session();
  Rx<bool> obscure = Rx<bool>(true);
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  toggleObscure() {
    obscure.value = !obscure.value;
    update();
  }

  void showSnack(BuildContext context, String title, String message) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        message,
        duration: Duration(milliseconds: 2700),
        isDismissible: true,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
        messageText: Text(message),
        snackPosition: SnackPosition.BOTTOM,
        boxShadows: [BoxShadow(offset: Offset(0, 2), blurRadius: 2.2, color: Colors.black.withOpacity(0.24))],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        margin: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        animationDuration: Duration(milliseconds: 150),
      );
    }
  }

  bool validate(BuildContext context) {
    if (this.name.text.length < 3) {
      this.showSnack(context, "Erro", "Nome muito curto!");
      return false;
    } else if (this.email.text.length < 5 || !this.email.text.contains('@')) {
      this.showSnack(context, "Erro", "E-mail inválido!");
      return false;
    } else if (this.password.text.length < 5) {
      this.showSnack(context, "Erro", "Senha muito curta!");
      return false;
    } else
      return true;
  }

  Future<void> signUp(BuildContext context) async {
    if (this.validate(context)) {
      Map<String, String> data = {
        "name": this.name.text,
        "email": this.email.text,
        "password": this.password.text,
      };
      await http.post("${Config.api}/users", body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
        if (json.decode(res.body)['message'] != null &&
            json.decode(res.body)['message'].contains('duplicate key value violates unique constraint')) {
          this.showSnack(context, "Erro", "E-mail já cadastrado");
        }
        if (res.statusCode == 201) {
          this.password.text = "";
          this.name.text = "";
          this.email.text = "";
          _session.login(json.decode(res.body));
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
        }
      });
    }
  }
}
