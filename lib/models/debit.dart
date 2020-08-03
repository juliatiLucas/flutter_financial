import './category.dart';
import 'package:intl/intl.dart';

class Debit {
  int id;
  String description;
  double value;
  String createdAt;
  Category category;

  Debit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    value = double.parse(json['value']);
    createdAt = DateFormat('dd/MM HH:mm').format(DateTime.parse(json['created_at']).subtract(Duration(hours: 3)));
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
}
