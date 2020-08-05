import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../controllers/home_controller.dart';
import '../controllers/category_controller.dart';
import '../models/debit.dart';
import '../models/category.dart';
import '../components/components.dart';
import '../components/category_tile.dart';
import '../utils/session.dart';
import '../utils/theme.dart';
import './new_debit.dart';
import './new_category.dart';
import './signin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Session session = Session();
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        print("teste");
      }
      if (_scrollController.offset <= _scrollController.position.minScrollExtent && !_scrollController.position.outOfRange) {
        print("teste");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Debits(),
            )));
  }
}

class Debits extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final Session session = Session();

  onPopupSelect(BuildContext context, String value) {
    switch (value) {
      case 'Definir Limite':
        this.limitModal(context);
        break;
      case 'Sair':
        session.logout().then((value) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => SignIn()), (route) => false);
        });
        break;
      case 'Tema':
        this.themeBottomModal(context);
        break;
    }
  }

  void limitModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => GetBuilder<HomeController>(builder: (ctx) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    height: 190,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 25),
                            child: Text(
                              'Novo limite',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        MyInput(
                          hintText: "",
                          controller: ctx.newLimit,
                          textInputType: TextInputType.number,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                                child: Text('FECHAR'),
                                onPressed: () {
                                  ctx.setNewLimit("");
                                  Navigator.pop(context);
                                }),
                            FlatButton(
                              child: Text('CONCLUÍDO'),
                              onPressed: () async {
                                ctx.updateLimit(context);
                              },
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
              );
            }));
  }

  void themeBottomModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              height: 220,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return true;
                },
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.brightness_5),
                      title: Text('Light'),
                      onTap: () => AppTheme.setTheme('light'),
                    ),
                    ListTile(
                      leading: Icon(Icons.brightness_3),
                      title: Text('Dark'),
                      onTap: () => AppTheme.setTheme('dark'),
                    )
                  ],
                ),
              ),
            ));
  }

  double getPercentage() {
    try {
      return (((_homeController.totalDebits.value / _homeController.limit.value) * 100) / 100);
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        GetBuilder<HomeController>(
          init: Get.put(HomeController()),
          initState: (_) {
            HomeController.to.getLimit();
            HomeController.to.getDebits();
          },
          builder: (ctx) {
            if (ctx.debits.value == null)
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: CircularProgressIndicator(),
                ),
              );
            else
              return Container(
                color: Theme.of(context).accentColor,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
                    child: Container(
                      height: MediaQuery.of(context).size.height + 250,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                        Container(
                            height: 230,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )),
                            child: SafeArea(
                                child: SingleChildScrollView(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    PopupMenuButton<String>(
                                      onSelected: (value) => onPopupSelect(context, value),
                                      icon: Icon(Icons.more_vert, color: Colors.white),
                                      itemBuilder: (context) {
                                        return ['Definir Limite', 'Tema', 'Sair']
                                            .map((e) => PopupMenuItem<String>(child: Text(e), value: e))
                                            .toList();
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                                Text("Limite", style: TextStyle(color: Colors.white, fontSize: 22)),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      ctx.limit.value.toString(),
                                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                                    )),
                              ]),
                            ))),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 45),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                ctx.totalDebits.value != null && ctx.limit.value != null
                                    ? Text(
                                        'Orçamento mensal (${ctx.totalDebits.value.toStringAsFixed(2)}/${ctx.limit.value.toStringAsFixed(2)})')
                                    : Container(),
                                SizedBox(height: 7),
                                LinearPercentIndicator(
                                  animation: true,
                                  lineHeight: 20.0,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  animationDuration: 900,
                                  percent: this.getPercentage(),
                                  center: Text("${(this.getPercentage() * 100).toStringAsFixed(2)}%"),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Colors.teal[400],
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: NotificationListener<OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowGlow();
                                    return true;
                                  },
                                  child: ListView.builder(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      itemCount: ctx.debits.value.length,
                                      itemBuilder: (_, index) {
                                        Debit debit = ctx.debits.value[index];
                                        return DebitTile(debit: debit);
                                      }),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Categories(),
                      ]),
                    ),
                  ),
                ]),
              );
          },
        ),
      ]),
    );
  }
}

class Categories extends StatelessWidget {
  void createCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewCategory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Text('Categorias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => this.createCategory(context),
                ),
              ),
            )
          ]),
        ),
        GetBuilder<CategoryController>(
          init: Get.put(CategoryController()),
          initState: (_) {
            CategoryController.to.getCategories();
          },
          builder: (ctx) {
            return ctx.categories.value != null
                ? Container(
                    height: 110,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: ctx.categories.value.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          Category category = ctx.categories.value[index];
                          return CategoryTile(category: category);
                        }))
                : Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: LinearProgressIndicator());
          },
        ),
        SizedBox(height: 30),
      ]),
    );
  }
}
