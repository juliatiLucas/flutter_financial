import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/debit.dart';
import '../utils/config.dart';
import '../utils/session.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final Session session = Session();
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

    await http.get("${Config.api}/users/${userInfo['id']}").then((res) {
      if (res.statusCode == 200) {
        limit.value = double.parse(json.decode(res.body)['limit']);
        update();
      }
    });
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
}
