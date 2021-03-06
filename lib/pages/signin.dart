import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signin_controller.dart';
import '../components/my_input.dart';
import './signup.dart';

class SignIn extends StatelessWidget {
  final SignInController _signInController = Get.put(SignInController());

  void signIn(BuildContext context) {
    _signInController.signIn(context);
  }

  bool validate() {
    return _signInController.email.text.length >= 5 &&
        _signInController.email.text.contains('@') &&
        _signInController.password.text.length > 3;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(children: [
        GetBuilder<SignInController>(
            init: Get.put(SignInController()),
            initState: (_) {
              SignInController.to.getLastEmail();
            },
            builder: (ctx) {
              return Expanded(
                child: Stack(children: <Widget>[
                  Container(
                    height: size.height * 0.6,
                    child: Image.asset(
                      "assets/finances.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: size.height * 0.55,
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Login',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: MyInput(
                              hintText: "E-mail",
                              controller: _signInController.email,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: MyInput(
                                controller: _signInController.password,
                                hintText: "Senha",
                                obscure: ctx.obscure.value,
                                suffixIcon: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () => ctx.toggleObscure(),
                                      color: ctx.obscure.value ? Colors.grey[600] : Theme.of(context).textTheme.headline1.color),
                                ),
                              )),
                          Row(
                            children: <Widget>[
                              Opacity(
                                opacity: 0.8,
                                child: FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  child: Text('Cadastrar',
                                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 18, color: Colors.teal)),
                                  onPressed: () => Get.to(SignUp()),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 30,
                    child: FloatingActionButton(
                      elevation: 0,
                      tooltip: "Entrar",
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                      backgroundColor: this.validate() ? Colors.teal : Colors.grey,
                      onPressed: () => this.validate() ? this.signIn(context) : null,
                    ),
                  ),
                ]),
              );
            })
      ]),
    );
  }
}
