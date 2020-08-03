import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../utils/session.dart';
import '../utils/config.dart';
import './home_controller.dart';
import './category_controller.dart';

class DebitController extends GetxController {
  static DebitController get to => Get.find();
  final Session session = Session();
  final HomeController _homeController = Get.put(HomeController());
  final CategoryController _categoryController = Get.put(CategoryController());
  TextEditingController description = TextEditingController();
  TextEditingController value = TextEditingController();
  Rx<List<Category>> categories = Rx<List<Category>>();
  Rx<Category> selectedCategory = Rx<Category>();

  void setCategory(Category category) {
    this.selectedCategory.value = category;
    update();
  }

  void getCategories() async {
    var userInfo = await session.getUserInfo();
    List<Category> categories = [];
    http.get("${Config.api}/users/${userInfo['id']}/categories").then((res) {
      if (res.statusCode == 200) {
        for (var d in json.decode(res.body)) {
          Category category = Category.fromJson(d);
          categories.add(category);
        }

        if (categories.length > 0) this.setCategory(categories[0]);

        this.categories.value = categories;
        update();
      }
    });
  }

  void delete(BuildContext context, int debitId) async {
    await http.delete("${Config.api}/debits/$debitId/").then((res) {
      _categoryController.getCategories();
      _homeController.getDebits();
    });
  }

  bool checkLimit() {
    print(this.value.text);
    return double.parse(this.value.text) + _homeController.totalDebits.value < _homeController.limit.value;
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

  Future<void> createDebit(BuildContext context) async {
    bool error = false;
    String title;
    String message;
    var userInfo = await session.getUserInfo();
    if (description.text.isEmpty || value.text.isEmpty || selectedCategory.value == null) {
      print('if 1');
      error = true;
      title = "Erro";
      message = "Preencha todos os campos!";
    } else if (!this.checkLimit()) {
      print('if 2');
      error = true;
      title = "Erro";
      message = "Limite insuficiente!";
    } else {
      Map<String, String> data = {
        "description": description.text,
        "value": value.text,
        "user": userInfo['id'].toString(),
        "category": selectedCategory.value.id.toString(),
      };

      await http.post("${Config.api}/debits", body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
        if (res.statusCode == 201) {
          this.description.text = "";
          this.value.text = "";
          this.setCategory(null);
        }
        _homeController.getDebits();
      });
    }

    if (error) {
      this.showSnack(context, title, message);
    }
    await Future.delayed(Duration(milliseconds: 2000), () {});
  }
}
