import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/debit.dart';
import '../utils/config.dart';
import '../utils/session.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final Session session = Session();
  TextEditingController newLimit = TextEditingController();
  Rx<double> limit = Rx<double>();
  Rx<double> totalDebits = Rx<double>();
  Rx<int> screen = Rx<int>(0);
  Rx<List<Debit>> debits = Rx<List<Debit>>();

  void setScreen(int index) {
    screen.value = index;
    update();
  }

  void getLimit() async {
    var userInfo = await session.getUserInfo();
    double limit = 0;
    await http.get("${Config.api}/users/${userInfo['id']}").then((res) {
      if (res.statusCode == 200) {
        limit = double.parse(json.decode(res.body)['limit']);
        update();
      }
    });
    this.limit.value = limit;
    this.newLimit.text = limit.toString();
  }

  void getDebits() async {
    var userInfo = await session.getUserInfo();
    List<Debit> debits = [];
    http.get("${Config.api}/users/${userInfo['id']}/debits").then((res) {
      if (res.statusCode == 200) {
        for (var d in json.decode(res.body)) {
          Debit debit = Debit.fromJson(d);
          debits.add(debit);
        }
        double totalDebits = 0;
        this.debits.value = debits;
        for (int i = 0; i < debits.length; i++) totalDebits += debits[i].value;

        this.totalDebits.value = totalDebits;
        update();
      }
    });
  }

  Future<void> updateLimit(BuildContext context) async {
    if (this.newLimit.text.isNotEmpty) {
      try {
        double newLimit = double.parse(this.newLimit.text.replaceAll(',', '.'));
        if (this.totalDebits.value > newLimit)
          showSnack(context, "Erro", "A soma total dos débitos é maior que o novo limite!");
        else {
          var userInfo = await session.getUserInfo();
          Map<String, String> data = {"limit": newLimit.toString()};

          await http.put("${Config.api}/users/${userInfo['id']}",
              body: json.encode(data), headers: {"Content-Type": "application/json"});
          showSnack(context, "Sucesso", "Limite atualizado.");
          this.getLimit();
        }
      } catch (e) {
        showSnack(context, "Erro", "Valor inválido!");
      }
    } else
      showSnack(context, "Erro", "Campo não pode ser nulo!");
  }

  void setNewLimit(String value) => this.newLimit.text = value;

  void showSnack(BuildContext context, String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: Duration(milliseconds: 2700),
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
