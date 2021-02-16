import 'package:cheesecake/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

bool _isOpenDialog = false;

class Dialogs {
  static void close() {
    Navigator.of(App.context, rootNavigator: true).pop();
  }

  static bool isOpen() {
    return _isOpenDialog;
  }

  static Future<Null> showErrorDialog(String message, {String title}) {
    if (_isOpenDialog) {
      close();
    }

    return showDialog<Null>(
      context: App.context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ?? 'Ocorreu um erro'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Fechar'),
            onPressed: () {
              Dialogs.close();
            },
          ),
        ],
      ),
    );
  }

  static void showLoadingDialog() async {
    _isOpenDialog = true;

    await showDialog(
      context: App.context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
            Text('Aguarde...'),
          ],
        ),
      ),
    );

    _isOpenDialog = false;
  }

  static Future<Null> showDialogTema() {
    return showDialog<Null>(
      context: App.context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              dense: true,
              title: Text('Padrão do Sistema'),
              leading: Container(
                height: double.infinity,
                child: Icon(Icons.settings),
              ),
              onTap: () {
                App.tema.setTheme();
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              dense: true,
              title: Text('Claro'),
              leading: Container(
                height: double.infinity,
                child: Icon(Icons.wb_sunny),
              ),
              onTap: () {
                App.tema.setTheme(temaEscuro: false);
                Navigator.pop(context);
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              dense: true,
              title: Text('Escuro'),
              leading: Icon(Icons.nights_stay),
              onTap: () {
                App.tema.setTheme(temaEscuro: true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showCheesecakeAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                onTap: () async => await launch('https://cheesecakelabs.com/br/'),
                child: Card(
                  elevation: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png',
                        width: 75.0,
                        height: 75.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListBody(
                            children: <Widget>[
                              Text('Cheesecake Labs', style: Theme.of(context).textTheme.headline6),
                              Text('App Teste Caio', style: Theme.of(context).textTheme.bodyText2),
                              Container(height: 5.0),
                              Text('www.cheesecakelabs.com', style: Theme.of(context).textTheme.caption),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Fechar'),
            onPressed: () => Dialogs.close(),
          ),
        ],
      ),
    );
  }
}
