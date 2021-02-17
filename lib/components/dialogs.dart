import 'package:cheesecake/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

bool _isOpenDialog = false;

class Dialogs {
  static void close() {
    Navigator.of(App.context, rootNavigator: true).pop(); //Função que fecha o Dialog sem necessidade do context atual
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
                Dialogs.close();
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showArticleDialog(BuildContext context, DadosArtigo artigo, List artigosLidos, State parent) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: artigo.imageUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Expanded(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      artigo.website,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      artigo.authors,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.visible,
                    ),
                    Container(height: 5.0),
                    Text(
                      artigo.date,
                      style: Theme.of(context).textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'id: ' + artigo.tags[0]['id'].toString(),
                      style: Theme.of(context).textTheme.overline,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'tag: ' + artigo.tags[0]['label'],
                      style: Theme.of(context).textTheme.overline,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        text: artigo.title,
                      ),
                      TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        text: '\n\n' + artigo.content,
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
              child: Text(
                  artigosLidos.contains(artigo.tags[0]['id'].toString()) ? 'Marcar como não lido' : 'Marcar como lido'),
              onPressed: () {
                if (artigosLidos.contains(artigo.tags[0]['id'].toString())) {
                  artigosLidos.remove(artigo.tags[0]['id'].toString());
                } else {
                  artigosLidos.add(artigo.tags[0]['id'].toString());
                }
                App.cache.setStringList('artigosLidos', artigosLidos);
                App.api.buscarArtigos();
                Dialogs.close();
                parent.setState(
                    () {}); //O state do widget pai é passado ao widget filho para que o mesmo possa recarregar o state do pai quando for selecionada a opção de marcar como lido/não lido
              }),
          FlatButton(
            child: Text('Fechar'),
            onPressed: () => Dialogs.close(),
          ),
        ],
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
                        'assets/logo.png', //Peguei do facebook XD
                        width: 75.0,
                        height: 75.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListBody(
                            children: <Widget>[
                              Text('Cheesecake Labs', style: Theme.of(context).textTheme.headline6),
                              Text('App Challenge Caio', style: Theme.of(context).textTheme.bodyText2),
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
