import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './utils/session.dart';
import './utils/theme.dart';
import './pages/home_page.dart';
import './pages/signin.dart';

void main() {
  runApp(GetMaterialApp(
    title: 'Financial App',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: Wrapper(),
  ));
}

class Wrapper extends StatelessWidget {
  final Session session = Session();
  Future<bool> isAuthenticated() async {
    bool isAuth = false;
    ThemeData currentTheme = AppTheme.light;
    String theme = await session.getTheme();
    if (theme == null || theme == 'light')
      currentTheme = AppTheme.light;
    else
      currentTheme = AppTheme.dark;

    Get.changeTheme(currentTheme);

    isAuth = await session.isAuthenticated();
    if (isAuth == null) isAuth = false;
    await Future.delayed(Duration(milliseconds: 2000), () {});
    return isAuth;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isAuthenticated(),
        builder: (_, snapshot) {
          Widget ret;
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              break;
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              ret = SplashScreen();
              break;
            case ConnectionState.done:
              ret = Container(
                child: snapshot.data ? HomePage() : SignIn(),
              );
              break;
          }
          return ret;
        });
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Center(
            child: Container(
          height: 150,
          width: 120,
          child: Column(children: [
            Image.asset('assets/piggybank_outline.png'),
            SizedBox(height: 15),
            LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.76),
              valueColor: AlwaysStoppedAnimation(Color(0xff109c8b)),
            ),
          ]),
        )));
  }
}
