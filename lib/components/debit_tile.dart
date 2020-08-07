import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/debit.dart';
import '../controllers/debit_controller.dart';


class DebitTile extends StatelessWidget {
  final Debit debit;
  final String categoryName;
  final DebitController _debitController = Get.put(DebitController());
  DebitTile({this.debit, this.categoryName = ""});

  void delete(BuildContext context) async {
    _debitController.delete(context, debit.id);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(debit.description, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("-${debit.value.toString()}"),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 8.5),
          child: Opacity(
            opacity: 0.8,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 7),
                  child: Text(
                    categoryName.length == 0 ? "Categoria: ${debit.category.name}" : "Categoria: $categoryName",
                  ),
                ),
                Text(debit.createdAt)
              ]),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => this.delete(context),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
