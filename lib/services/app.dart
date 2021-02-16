import 'package:cheesecake/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  static final App instance = App();
  static final Api api = Api();

  static SharedPreferences cache;
  static List<DadosArtigo> artigos = [];
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
  static BuildContext context = navigator.currentState.overlay.context;

  static Tema tema = Tema();

  Future<void> initializeApp() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    cache = await SharedPreferences.getInstance();
    api.buscarArtigos();
  }

  static Future navigate(Widget widget,
      {bool slide = false, bool menu = false}) async {
    if (menu) {
      Dialogs.close();
    }

    if (slide)
      return Navigator.of(App.context).push(CupertinoPageRoute(
        builder: (BuildContext context) => widget,
      ));
    else
      return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ));
  }
}
