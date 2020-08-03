import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './home_controller.dart';
import '../models/debit.dart';
import '../models/category.dart';
import '../utils/config.dart';
import '../utils/session.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  final Session session = Session();
  final HomeController _homeController = Get.put(HomeController());
  TextEditingController newCategoryName = TextEditingController();
  Rx<List<Debit>> debits = Rx<List<Debit>>();
  Rx<List<Category>> categories = Rx<List<Category>>();
  Rx<Color> newCategoryColor = Rx<Color>(Colors.blue);

  void clearDebits() {
    this.debits.value = null;
    update();
  }

  void clearCategories() {
    this.categories.value = null;
    update();
  }

  void setNewCategoryColor(Color color) {
    this.newCategoryColor.value = color;
    update();
  }

  void getCategories() async {
    var userInfo = await session.getUserInfo();
    this.clearCategories();
    List<Category> categories = [];
    http.get("${Config.api}/users/${userInfo['id']}/categories").then((res) {
      if (res.statusCode == 200) {
        for (var d in json.decode(res.body)) {
          Category category = Category.fromJson(d);
          categories.add(category);
        }

        this.categories.value = categories;
        update();
      }
    });
  }

  void showSnack(BuildContext context, String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: Duration(milliseconds: 2500),
      messageText: Text(message),
      boxShadows: [BoxShadow(offset: Offset(0, 2), blurRadius: 2.2, color: Colors.black.withOpacity(0.24))],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      margin: EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      animationDuration: Duration(milliseconds: 150),
    );
  }

  void createCategory(BuildContext context) async {
    if (this.newCategoryName.text.isEmpty)
      this.showSnack(context, "Erro", "Preencha todos os campos!");
    else {
      String color =
          this.newCategoryColor.value.toString().replaceFirst('MaterialColor(primary value: Color(0xff', '').replaceAll(')', '');
      var userInfo = await session.getUserInfo();
      Map<String, String> data = {
        "color": color,
        "user": userInfo['id'].toString(),
        "name": this.newCategoryName.text,
      };

      await http.post("${Config.api}/users/${userInfo['id']}/categories",
          body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
        print(res.body);
        print(res.statusCode);
        if (res.statusCode == 201) {
          this.newCategoryName.text = "";
          this.setNewCategoryColor(Colors.blue);
          this.getCategories();
          _homeController.getDebits();
        }
      });
    }
  }
}
