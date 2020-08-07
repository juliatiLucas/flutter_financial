import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../utils/session.dart';
import './new_debit.dart';
import './categories.dart';
import './debits.dart';

class HomePage extends StatelessWidget {
  final Session session = Session();

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [Debits(), Categories()];

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: FloatingActionButton(
            tooltip: "Novo Débito",
            elevation: 0,
            hoverElevation: 0,
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => NewDebit(),
              );
            },
          ),
        ),
        bottomNavigationBar: GetBuilder<HomeController>(
            init: Get.put(HomeController()),
            builder: (ctx) => BottomNavigationBar(
                  currentIndex: ctx.screen.value,
                  onTap: (index) => ctx.setScreen(index),
                  items: [
                    BottomNavigationBarItem(title: Text('Debitos'), icon: Icon(Icons.category)),
                    BottomNavigationBarItem(title: Text('Categorias'), icon: Icon(Icons.dashboard)),
                  ],
                )),
        body: SingleChildScrollView(
            child: GetBuilder<HomeController>(
          builder: (ctx) => Container(height: MediaQuery.of(context).size.height, child: screens[ctx.screen.value]),
        )));
  }
}
