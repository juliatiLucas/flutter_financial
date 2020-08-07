import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import './new_category.dart';
import '../components/category_tile.dart';
import '../components/debit_tile.dart';
import '../models/category.dart';
import '../models/debit.dart';

class Categories extends StatelessWidget {
  final FocusNode _nameTileFocus = FocusNode();
  final CategoryController _categoryController = Get.put(CategoryController());

  void createCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewCategory(),
    );
  }

  void onPopupSelect(BuildContext context, String value) {
    switch (value) {
      case 'Excluir':
        _categoryController.selectedCategory.value.debits.length == 0
            ? showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('Você tem certeza que deseja excluir ${_categoryController.selectedCategory.value.name}?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('CANCELAR'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text('SIM'),
                          onPressed: () {
                            _categoryController.deleteCategory(_categoryController.selectedCategory.value.id);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ))
            : showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('Alerta'),
                      content: Text(
                          'Você deve excluir todos os débitos da categoria "${_categoryController.selectedCategory.value.name}" antes.'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ));
        break;
      case 'Renomear':
        _nameTileFocus.requestFocus();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        title: Text('Categorias', style: TextStyle(color: Colors.white)),
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.add, color: Colors.white), onPressed: () => this.createCategory(context)),
        ],
      ),
      body: GetBuilder<CategoryController>(
          init: Get.put(CategoryController()),
          initState: (_) {
            CategoryController.to.getCategories();
          },
          builder: (ctx) {
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              ctx.categories.value != null
                  ? ctx.categories.value.length > 0
                      ? Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: ctx.categories.value.length,
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    Category category = ctx.categories.value[index];
                                    return CategoryTile(category: category);
                                  })),
                        )
                      : Center(child: Text('Nenhuma categoria'))
                  : Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: LinearProgressIndicator()),
              Expanded(
                  flex: 6,
                  child: ctx.selectedCategory.value != null
                      ? Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              )),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Opacity(
                                      opacity: 0.82,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            TextFormField(
                                              onFieldSubmitted: (String value) {
                                                ctx.changeCategoryName(_categoryController.selectedCategory.value.id).then((res) {
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
                                            ),
                                            ctx.selectedCategory.value.debits.length > 0
                                                ? Padding(
                                                    padding: EdgeInsets.only(left: 16),
                                                    child: Text("Total: ${ctx.selectedCategory.value.totalDebits}"))
                                                : SizedBox()
                                          ])),
                                          PopupMenuButton<String>(
                                            onSelected: (value) => onPopupSelect(context, value),
                                            icon: Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                              return ['Renomear', 'Excluir']
                                                  .map((e) => PopupMenuItem<String>(child: Text(e), value: e))
                                                  .toList();
                                            },
                                          )
                                        ],
                                      ))),
                              ctx.selectedCategory.value.debits.length > 0
                                  ? Expanded(
                                      child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: ctx.selectedCategory.value.debits.length,
                                      itemBuilder: (_, index) {
                                        Debit debit = ctx.selectedCategory.value.debits[index];
                                        return DebitTile(debit: debit, categoryName: ctx.selectedCategory.value.name);
                                      },
                                    ))
                                  : Container(
                                      padding: EdgeInsets.only(top: 25),
                                      child: Opacity(
                                        opacity: 0.8,
                                        child: Text('Sem débitos nessa categoria.'),
                                      )),
                            ],
                          ),
                        )
                      : SizedBox())
            ]);
          }),
    );
  }
}
