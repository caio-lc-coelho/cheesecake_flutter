import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cheesecake/index.dart';

class Api {
  Future buscarArtigos() async {
    var response = await http.get(
      Uri.https('blog.cheesecakelabs.com', 'challenge'),
    );

    if (response.statusCode == 200) {
      App.artigos = List<DadosArtigo>.from(json.decode(response.body).map((i) => DadosArtigo.fromJson(i)));
    } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
      throw json.decode(response.body);
    }
  }
}
