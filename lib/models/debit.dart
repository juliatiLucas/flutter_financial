import './category.dart';

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
    createdAt = json['created_at'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
}
