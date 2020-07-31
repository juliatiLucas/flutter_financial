import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../utils/session.dart';
import '../utils/config.dart';

class DebitController extends GetxController {
  static DebitController get to => Get.find();
  final Session session = Session();
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

        if (categories.length > 0) {
          this.setCategory(categories[0]);
        }

        this.categories.value = categories;
        update();
      }
    });
  }

  Future<bool> createDebit() async {
    bool result = false;
    var userInfo = await session.getUserInfo();
    if (description.text.isEmpty || value.text.isEmpty) return result;

    Map<String, String> data = {
      "description": description.text,
      "value": value.text,
      "user": userInfo['id'].toString(),
      "category": selectedCategory.value.id.toString(),
    };

    await http.post("${Config.api}/debits", body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
      if (res.statusCode == 201) result = true;
    });
    return result;
  }
}
