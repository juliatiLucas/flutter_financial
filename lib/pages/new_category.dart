import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../controllers/category_controller.dart';
import '../components/my_input.dart';
import '../components/color_selector.dart';


class NewCategory extends StatelessWidget {
  void colorModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: GetBuilder<CategoryController>(builder: (ctx) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  width: 400,
                  height: 300,
                  child: Column(children: [
                    Text(
                      'Selecione',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                        return true;
                      },
                      child: MaterialColorPicker(
                        onMainColorChange: (Color color) => ctx.setNewCategoryColor(color),
                        allowShades: false,
                        selectedColor: ctx.newCategoryColor.value,
                      ),
                    )),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      FlatButton(
                        child: Text('CONCLUÍDO'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ])
                  ]),
                );
              }),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        height: 320,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: GetBuilder<CategoryController>(
                  init: Get.put(CategoryController()),
                  builder: (ctx) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Nova Categoria',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        MyInput(hintText: "Nome", controller: ctx.newCategoryName),
                        SizedBox(height: 12),
                        ColorSelector(action: () => this.colorModal(context), color: ctx.newCategoryColor.value),
                        SizedBox(height: 25),
                        FlatButton(
                            color: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            onPressed: () async {
                              await ctx.createCategory(context).then((res) {});
                              Navigator.pop(context);
                            },
                            child: Text(
                              'CRIAR',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ))
                      ],
                    );
                  })),
        ),
      ),
    );
  }
}
