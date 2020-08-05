import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import '../controllers/category_controller.dart';
import './components.dart';
import '../models/debit.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  CategoryTile({this.category});
  final FocusNode _nameTileFocus = FocusNode();
  final CategoryController _categoryController = Get.put(CategoryController());

  void onPopupSelect(BuildContext context, String value) {
    switch (value) {
      case 'Excluir':
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Você tem certeza que deseja excluir ${category.name}?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('CANCELAR'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text('SIM'),
                      onPressed: () async {
                        await _categoryController.deleteCategory(category.id).then((value) => Navigator.pop(context));
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
        break;
      case 'Editar':
        _nameTileFocus.requestFocus();
        break;
    }
  }

  void showDebits(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: 400,
                  child: GetBuilder<CategoryController>(
                    init: Get.put(CategoryController()),
                    initState: (_) {
                      CategoryController.to.setCategoryTileName(category.name);
                    },
                    builder: (ctx) => Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Opacity(
                                opacity: 0.82,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                        child: TextFormField(
                                      onFieldSubmitted: (String value) {
                                        ctx.changeCategoryName(category.id).then((res) {
                                          Navigator.pop(context);
                                        });
                                      },
                                      focusNode: this._nameTileFocus,
                                      controller: ctx.categoryTileName,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(left: 10)),
                                    )),
                                    PopupMenuButton<String>(
                                      onSelected: (value) => onPopupSelect(context, value),
                                      icon: Icon(Icons.more_vert),
                                      itemBuilder: (context) {
                                        return ['Editar', 'Excluir']
                                            .map((e) => PopupMenuItem<String>(child: Text(e), value: e))
                                            .toList();
                                      },
                                    )
                                  ],
                                ))),
                        category.debits.length > 0
                            ? Expanded(
                                child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: category.debits.length,
                                itemBuilder: (_, index) {
                                  Debit debit = category.debits[index];
                                  return DebitTile(debit: debit, categoryName: category.name);
                                },
                              ))
                            : Container(
                                padding: EdgeInsets.only(top: 25),
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Text('Sem débitos nessa categoria.'),
                                )),
                        category.debits.length > 0 ? Text("Total: ${category.totalDebits}") : SizedBox()
                      ],
                    ),
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Material(
            color: category.color,
            child: InkWell(
              onTap: () => showDebits(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.name,
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text("Total: ${category.totalDebits.toString()}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
