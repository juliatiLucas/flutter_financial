import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/components.dart';
import '../controllers/debit_controller.dart';
import '../models/category.dart';

class NewDebit extends StatelessWidget {
  final DebitController _debitController = Get.put(DebitController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 390,
        decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: GetBuilder<DebitController>(
            init: Get.put(DebitController()),
            initState: (_) {
              DebitController.to.getCategories();
            },
            builder: (ctx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      'Novo Débito',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  MyInput(controller: _debitController.description, hintText: "Descrição"),
                  SizedBox(height: 12),
                  MyInput(
                    controller: _debitController.value,
                    hintText: "Valor",
                    textInputType: TextInputType.number,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: DropdownButton<Category>(
                      value: ctx.selectedCategory.value,
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      hint: Text('Categoria'),
                      iconSize: 20,
                      elevation: 1,
                      onChanged: (Category category) => ctx.setCategory(category),
                      underline: Container(),
                      items: ctx.categories.value != null
                          ? ctx.categories.value.map<DropdownMenuItem<Category>>((Category value) {
                              return DropdownMenuItem<Category>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList()
                          : <DropdownMenuItem<Category>>[].toList(),
                    ),
                  ),
                  SizedBox(height: 25),
                  FlatButton(
                      color: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: ctx.createDebit,
                      child: Text(
                        'CRIAR',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ))
                ],
              );
            }),
      ),
    );
  }
}
