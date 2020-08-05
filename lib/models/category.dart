import 'package:flutter/material.dart';
import './debit.dart';

class Category {
  int id;
  String name;
  Color color;
  List<Debit> debits;
  double totalDebits;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = Color(int.parse("0xff${json['color']}"));

    List<dynamic> jsonDebits = json['debits'];
    if (jsonDebits != null) {
      double total = 0;
      List<Debit> debits = [];
      for (var d in jsonDebits) {
        Debit debit = Debit.fromJson(d);
        total += debit.value;
        debits.add(debit);
      }
      this.totalDebits = total;
      this.debits = debits;
    }
  }
}
