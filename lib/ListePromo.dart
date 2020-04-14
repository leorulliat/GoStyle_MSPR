class ListePromo {
  final String titre;

  ListePromo({
    this.titre,
  });

  factory ListePromo.fromJson(Map<String, dynamic> json) {
    return ListePromo(
      titre: json['titre']
    );
  }
}