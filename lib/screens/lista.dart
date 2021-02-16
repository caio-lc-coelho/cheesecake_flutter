import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cheesecake/index.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  bool buscando = false;
  String dropdownTema = 'Sistema';

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheesecake News'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 123,
                  child: Text('Working a lot harder'),
                ),
                const PopupMenuItem(
                  value: 456,
                  child: Text('teste 123213'),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  ListTile(
                    dense: true,
                    title: Text('Mudar Tema do sistema'),
                    subtitle: Text('Tema atual: ${App.cache.getString('temaAtual')}'),
                    leading: Container(
                      height: double.infinity,
                      child: Icon(Icons.settings_brightness),
                    ),
                    onTap: () async {
                      await Dialogs.showDialogTema();
                      setState(() {});
                    },
                  ),
                  ListTile(
                    dense: true,
                    title: Text('Cheesecake Labs'),
                    leading: Container(
                      height: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 21.0,
                      ),
                    ),
                    onTap: () => Dialogs.showCheesecakeAboutDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(14.0),
        child: SafeArea(
          child: buildBuscar(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          primaryFocus.unfocus();
        },
        child: Container(
          height: App.artigos.length < 10 ? (App.artigos.length * 100).toDouble() : 900.00,
          width: double.maxFinite,
          child: Scrollbar(
            child: ListView.separated(
              controller: scrollController,
              itemCount: buscando ? 1 : App.artigos.length,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                DadosArtigo carregado = App.artigos[index];
                if (buscando)
                  return Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                else
                  return Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 10.0,
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(left: 1.0, right: 8.0),
                        child: Image.network(
                          carregado.imageUrl,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        carregado.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        carregado.authors,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        Dialogs.showLoadingDialog();
                      },
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBuscar() {
    if (Platform.isAndroid) {
      return RaisedButton(
        child: Builder(
          builder: (context) {
            if (buscando) {
              return Container(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            return Text(
              'Buscar Novamente',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),
        color: Theme.of(context).primaryColor,
        disabledColor: Color(0xFF004097),
        onPressed: !buscando ? buscarDados : null,
      );
    } else {
      return CupertinoButton(
        color: Theme.of(context).primaryColor,
        disabledColor: Color(0xFF004097),
        pressedOpacity: 0.8,
        child: Builder(
          builder: (context) {
            if (buscando) {
              return CupertinoActivityIndicator();
            }
            return Text(
              'Calcular',
              style: TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),
        onPressed: !buscando ? buscarDados : null,
      );
    }
  }

  void loading(bool show) {
    setState(() {
      buscando = show;
    });
  }

  void buscarDados() async {
    try {
      loading(true);
      await App.api.buscarArtigos();
      loading(false);
    } catch (e) {
      loading(false);
      Dialogs.showErrorDialog(e.toString());
    }
  }
}
