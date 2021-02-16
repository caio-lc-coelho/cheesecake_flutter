import 'package:cheesecake/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
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
    App.api.buscarArtigos();
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
      theme: ThemeData(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        toggleableActiveColor: Colors.lightBlueAccent[200],
        accentColor: Colors.lightBlueAccent[200],
        textSelectionTheme: TextSelectionThemeData(selectionHandleColor: Colors.lightBlueAccent[400]),
      ),
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
