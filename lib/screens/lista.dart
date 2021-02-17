import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cheesecake/index.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  bool buscando = true;

  String dropdownTema = 'Sistema'; //Por padrão, o tema seguirá o estabelecido nas configurações do sistema
  String filtroArtigos = '';

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    App.api.buscarArtigos().then((value) => setState(() {
          loading(false);
        }));
  }

  @override
  Widget build(BuildContext context) {
    List artigosLidos = App.cache.getStringList('artigosLidos'); //Carrega os artigos lidos do cache

    return Scaffold(
      appBar: AppBar(
        title: Text('Cheesecake News'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            itemBuilder: (BuildContext context) {
              //Seleciona o filtro e salva na variável enviada para a chamada da API
              return [
                PopupMenuItem(
                  child: GestureDetector(
                    child: Text('Data'),
                    onTap: () {
                      setState(() {
                        filtroArtigos = 'date';
                      });

                      buscarDados();
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  child: GestureDetector(
                    child: Text('Título'),
                    onTap: () {
                      setState(() {
                        filtroArtigos = 'title';
                      });

                      buscarDados();
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  child: GestureDetector(
                    child: Text('Autor'),
                    onTap: () {
                      setState(() {
                        filtroArtigos = 'authors';
                      });

                      buscarDados();
                      Navigator.pop(context);
                    },
                  ),
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
                      setState(() {}); //Recarrega a tela para aplicar o novo tema
                    },
                  ),
                  ListTile(
                    dense: true,
                    title: Text('Cheesecake Labs'),
                    leading: Container(
                      height: double.infinity,
                      child: Icon(Icons.science_outlined),
                    ),
                    onTap: () => Dialogs.showCheesecakeAboutDialog(context),
                  ),
                ],
              ),
            ),
          ],
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
              itemCount: buscando ? 1 : App.artigos.length, //Evita repetição do Widget CircularProgressIndicator
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                DadosArtigo carregado = App.artigos[index]; //Dados caregados pela API

                if (buscando)
                  return Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
                    child: Center(child: CircularProgressIndicator()),
                  );
                else
                  return Container(
                    child: ListTile(
                      isThreeLine: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 10.0,
                      ),
                      leading: CachedNetworkImage(
                        imageUrl: carregado.imageUrl,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(
                        carregado.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: !artigosLidos.contains(carregado.tags[0]['id'].toString())
                            ? Theme.of(context).textTheme.subtitle2
                            : Theme.of(context).textTheme.bodyText2,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                carregado.authors,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            Text(
                              carregado.date,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async => Dialogs.showArticleDialog(context, carregado, artigosLidos,
                          this), //O state do widget pai é passado ao widget filho para que o mesmo possa recarregar o state do pai quando for selecionada a opção de marcar como lido/não lido
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  void loading(bool show) {
    setState(() {
      buscando = show;
    });
  }

  void buscarDados() async {
    try {
      loading(true);
      await App.api.buscarArtigos(filtro: filtroArtigos);
      loading(false);
    } catch (e) {
      loading(false);
      Dialogs.showErrorDialog(e.toString());
    }
  }
}
