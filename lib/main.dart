import 'package:cheesecake/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    //Trava o app sempre na vertical
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await App.instance.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    App.tema.addListener(() {
      setState(() {});
    });

    if (!App.cache.containsKey('temaAtual'))
      App.cache
          .setString('temaAtual', 'Sistema'); //Por padrão, o tema seguirá o estabelecido nas configurações do sistema

    if (!App.cache.containsKey('artigosLidos'))
      App.cache.setStringList('artigosLidos',
          []); //Criada a lista de artigos lidos, mesmo que vazia, para não ter problemas no carregamentos de telas que dependem dessa variável em cache

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste Cheesecake',
      navigatorKey: App.navigator,
      debugShowCheckedModeBanner: false,
      home: Lista(),
      themeMode: App.tema.currentTheme(),
      theme: ThemeData(
        primaryColor: Color(0xFF673AB7), //Cor roxa, primária
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}
