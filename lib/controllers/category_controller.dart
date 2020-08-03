import 'dart:convert';
import 'package:get/get.dart';
import '../models/debit.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../utils/session.dart';

class CategoryController extends GetxController {
  static CategoryController get to => Get.find();
  final Session session = Session();
  Rx<List<Debit>> debits = Rx<List<Debit>>();
  Rx<List<Category>> categories = Rx<List<Category>>();

  void clearDebits() {
    this.debits.value = null;
    update();
  }

  void clearCategories() {
    this.categories.value = null;
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
}
