import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import '../controllers/category_controller.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  CategoryTile({this.category});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: GetBuilder<CategoryController>(
            init: Get.put(CategoryController()),
            builder: (ctx) => Material(
                color: category.color,
                child: InkWell(
                  onTap: () => ctx.selectCategory(category),
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
                ))),
      ),
    );
  }
}
