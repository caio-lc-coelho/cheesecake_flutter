import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cheesecake/index.dart';

class Api {
  Future buscarArtigos({String filtro = ''}) async {
    var response = await http.get(
      Uri.https('blog.cheesecakelabs.com', 'challenge'),
    );

    if (response.statusCode == 200) {
      List<DadosArtigo> artigos =
          List<DadosArtigo>.from(json.decode(response.body).map((i) => DadosArtigo.fromJson(i)));
      switch (filtro) {
        case 'date':
          artigos.sort((a, b) => a.date.compareTo(b.date));
          break;
        case 'title':
          artigos.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'authors':
          artigos.sort((a, b) => a.authors.compareTo(b.authors));
          break;
      }
      App.artigos = artigos;
    } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
      throw json.decode(response.body);
    }
  }
}
