import 'package:flutter/material.dart';
import '../models/debit.dart';

class DebitTile extends StatelessWidget {
  final Debit debit;
  DebitTile({this.debit});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).secondaryHeaderColor))),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            debit.category != null
                ? Padding(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      debit.category.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : Container(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text(debit.description), Text("-${debit.value.toString()}")])
          ]),
        ));
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
