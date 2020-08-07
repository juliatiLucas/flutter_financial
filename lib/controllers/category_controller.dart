import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './home_controller.dart';
import '../models/debit.dart';
import '../models/category.dart';
import '../utils/config.dart';
import '../utils/session.dart';
import '../components/snack.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  final Session _session = Session();
  final HomeController _homeController = Get.put(HomeController());
  TextEditingController newCategoryName = TextEditingController();
  TextEditingController categoryTileName = TextEditingController();
  Rx<Color> newCategoryColor = Rx<Color>(Colors.blue);
  Rx<List<Debit>> debits = Rx<List<Debit>>();
  Rx<Category> selectedCategory = Rx<Category>();
  Rx<List<Category>> categories = Rx<List<Category>>();

  void clearDebits() {
    this.debits.value = null;
    update();
  }

  void selectCategory(Category category) {
    this.selectedCategory.value = category;
    this.setCategoryTileName(category.name);
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
    var userInfo = await _session.getUserInfo();

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

  Future<void> createCategory(BuildContext context) async {
    if (this.newCategoryName.text.isEmpty)
      CustomSnack.showSnack(context, "Erro", "Preencha todos os campos!");
    else {
      String color =
          this.newCategoryColor.value.toString().replaceFirst('MaterialColor(primary value: Color(0xff', '').replaceAll(')', '');
      var userInfo = await _session.getUserInfo();
      Map<String, String> data = {
        "color": color,
        "user": userInfo['id'].toString(),
        "name": this.newCategoryName.text,
      };

      http.post("${Config.api}/users/${userInfo['id']}/categories",
          body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
        if (res.statusCode == 201) {
          this.newCategoryName.text = "";
          this.setNewCategoryColor(Colors.blue);
          this.getCategories();
          _homeController.getDebits();
        }
      });
    }
    await Future.delayed(Duration(milliseconds: 2200), () {});
  }

  void setCategoryTileName(String name) => this.categoryTileName.text = name;

  Future<void> deleteCategory(int categoryId) async {
    var userInfo = await _session.getUserInfo();
    await http.delete("${Config.api}/users/${userInfo['id']}/categories/$categoryId").then((res) {
      if (res.statusCode == 200) {
        this.categoryTileName.text = "";
        this.getCategories();
        _homeController.getDebits();
      }
    });
  }

  Future<void> changeCategoryName(int categoryId) async {
    if (this.categoryTileName.text.isEmpty) return;
    Map<String, String> data = {"name": this.categoryTileName.text};
    var userInfo = await _session.getUserInfo();
    await http.put("${Config.api}/users/${userInfo['id']}/categories/$categoryId",
        body: json.encode(data), headers: {"Content-Type": "application/json"}).then((res) {
      if (res.statusCode == 200) {
        this.categoryTileName.text = "";
        this.getCategories();
        _homeController.getDebits();
      }
    });
  }
}
