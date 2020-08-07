import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  final TextInputType textInputType;
  final Widget suffixIcon;

  MyInput({this.controller, this.hintText, this.obscure = false, this.textInputType = TextInputType.text, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      obscureText: this.obscure,
      keyboardType: this.textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: this.hintText,
        fillColor: Theme.of(context).secondaryHeaderColor,
        filled: true,
        focusColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none),
      ),
    );
  }
}
