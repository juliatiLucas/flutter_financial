import 'package:flutter/material.dart';
import '../models/category.dart';
// import '../controllers/category_controller.dart';
import './components.dart';
import '../models/debit.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  CategoryTile({this.category});

  void onPopupSelect(BuildContext context, String value) {}

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
                      color: Theme.of(context).dialogBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: 400,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Opacity(
                              opacity: 0.82,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    category.name,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
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
                    ],
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Material(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue,
          child: InkWell(
            onTap: () => showDebits(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    category.name,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
