import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/debit.dart';
import '../components/my_input.dart';
import '../utils/theme.dart';
import '../components/debit_tile.dart';
import '../utils/session.dart';
import './signin.dart';

class Debits extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final Session session = Session();

  onPopupSelect(BuildContext context, String value) {
    switch (value) {
      case 'Definir Limite':
        this.limitModal(context);
        break;
      case 'Sair':
        this.logout(context);
        break;
      case 'Tema':
        this.themeBottomModal(context);
        break;
    }
  }

  void logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(title: Text('Você tem certeza que deseja sair?'), actions: [
              FlatButton(onPressed: () => Navigator.pop(context), child: Text('CANCELAR')),
              FlatButton(
                  onPressed: () => {
                        session.logout().then((value) {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => SignIn()), (route) => false);
                        })
                      },
                  child: Text('SIM')),
            ]));
  }

  void limitModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => GetBuilder<HomeController>(builder: (ctx) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
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
    if (_homeController.totalDebits.value == 0 && _homeController.limit.value == 0)
      return 0;
    else {
      try {
        return (((_homeController.totalDebits.value / _homeController.limit.value) * 100) / 100);
      } catch (e) {
        return 0;
      }
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
              return SafeArea(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            else
              return Container(
                color: Theme.of(context).accentColor,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
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
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 45),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                ctx.totalDebits.value != null && ctx.limit.value != null
                                    ? Text(
                                        'Orçamento total (${ctx.totalDebits.value.toStringAsFixed(2)}/${ctx.limit.value.toStringAsFixed(2)})')
                                    : Container(),
                                SizedBox(height: 7),
                                LinearPercentIndicator(
                                  animation: true,
                                  lineHeight: 20.0,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  animationDuration: 900,
                                  percent: this.getPercentage(),
                                  center: Text("${(this.getPercentage() * 100).toStringAsFixed(2)}%",
                                      style: TextStyle(color: Colors.white)),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Colors.teal[400],
                                ),
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16, bottom: 15),
                              child: Text('Débitos',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            ctx.debits.value.length > 0
                                ? Expanded(
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
                                  )
                                : Container(),
                          ]),
                        ),
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
