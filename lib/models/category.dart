import './debit.dart';

class Category {
  int id;
  String name;
  String color;
  List<Debit> debits;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    List<dynamic> jsonDebits = json['debits'];
    if (jsonDebits != null) {
      List<Debit> debits = [];
      for (var d in jsonDebits) {
        Debit debit = Debit.fromJson(d);
        debits.add(debit);
      }
      this.debits = debits;
    }
  }
}
