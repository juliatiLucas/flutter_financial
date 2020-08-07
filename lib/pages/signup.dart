import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/my_input.dart';
import '../controllers/signup_controller.dart';

class SignUp extends StatelessWidget {
  final SignUpController _signUpController = Get.put(SignUpController());

  bool validate() {
    return _signUpController.name.text.length > 3 &&
        _signUpController.email.text.length >= 5 &&
        _signUpController.email.text.contains('@') &&
        _signUpController.password.text.length > 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Cadastro'),
        elevation: 0,
      ),
      body: GetBuilder<SignUpController>(
          init: Get.put(SignUpController()),
          builder: (ctx) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: MyInput(
                          controller: _signUpController.name,
                          hintText: "Nome",
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: MyInput(
                          controller: _signUpController.email,
                          hintText: "E-mail",
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: MyInput(
                          controller: _signUpController.password,
                          hintText: "Senha",
                          obscure: ctx.obscure.value,
                          suffixIcon: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () => ctx.toggleObscure(),
                              color: ctx.obscure.value ? Colors.grey[700] : Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                        )),
                    SizedBox(height: 20),
                    FlatButton(
                        color: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () => ctx.signUp(context),
                        child: Text('CADASTRAR', style: TextStyle(color: Colors.white, fontSize: 16)))
                  ],
                ));
          }),
    );
  }
}
