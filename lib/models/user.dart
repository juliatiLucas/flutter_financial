import './debit.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  double limit;
  double balance;
  List<Debit> debits;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    limit = json['limit'];
    balance = json['balance'];
    for (Debit debit in json['debits']) {
      debits.add(debit);
    }
  }
}
