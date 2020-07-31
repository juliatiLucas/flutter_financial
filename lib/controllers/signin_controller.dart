import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/session.dart';

class SignInController extends GetxController {
  static SignInController get to => Get.find();
  final Session session = Session();
  Rx<bool> obscure = Rx<bool>(true);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  toggleObscure() {
    obscure.value = !obscure.value;
    update();
  }

  void getLastEmail() async {
    this.email.text = await session.getLastEmail() ?? "";
  }

  Future<bool> signIn() async {
    bool result = false;
    Map<String, String> data = {"email": this.email.text, "password": this.password.text};
    await http
        .post("${Config.api}/users/login/", body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
      if (res.statusCode == 200) {
        session.login(json.decode(res.body));
        result = true;
        this.password.text = "";
      }
    });
    return result;
  }
}
