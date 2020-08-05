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
              child: Material(
                color: Colors.transparent,
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
                  Row(children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => this.delete(context),
                    ),
                  ])
                ]),
              )),
        ),
      ],
    );
  }
}

class MyInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final TextInputType textInputType;

  MyInput({this.controller, this.hintText, this.obscure = false, this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      obscureText: this.obscure,
      keyboardType: this.textInputType,
      decoration: InputDecoration(
        hintText: this.hintText,
        fillColor: Theme.of(context).secondaryHeaderColor,
        filled: true,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
      ),
    );
  }
}

class ColorSelector extends StatelessWidget {
  final Function action;
  final Color color;
  ColorSelector({this.action, this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Material(
        color: Theme.of(context).secondaryHeaderColor,
        child: InkWell(
            onTap: this.action,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [
                  Text('Color: '),
                  Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: this.color,
                        borderRadius: BorderRadius.circular(40),
                      )),
                ]))),
      ),
    );
  }
}
