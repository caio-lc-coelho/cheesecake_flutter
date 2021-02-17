class DadosArtigo {
  String title;
  String website;
  String authors;
  String date;
  String content;
  List tags;
  String imageUrl;

  DadosArtigo({
    this.title,
    this.website,
    this.authors,
    this.date,
    this.content,
    this.tags = const [],
    this.imageUrl,
  });

  factory DadosArtigo.from(DadosArtigo artigo) {
    return DadosArtigo(
      title: artigo.title,
      website: artigo.website,
      authors: artigo.authors,
      date: artigo.date,
      content: artigo.content,
      tags: artigo.tags,
      imageUrl: artigo.imageUrl,
    );
  }

  factory DadosArtigo.fromJson(Map<String, dynamic> json) {
    return DadosArtigo(
      title: json['title'],
      website: json['website'],
      authors: json['authors'],
      date: json['date'],
      content: json['content'],
      tags: json['tags'],
      imageUrl: json['image_url'],
    );
  }
}
