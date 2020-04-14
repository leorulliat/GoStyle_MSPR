class Promo{
  final String titre;

  Promo({
    this.titre
  }) ;

  factory Promo.fromJson(Map<String, dynamic> json){
    return new Promo(
      titre: json['titre'],
    );
  }

}

class ListePromos {
  final List<Promo> promos;

  ListePromos({
    this.promos,
  });

  factory ListePromos.fromJson(List<dynamic> parsedJson) {

    List<Promo> promos = new List<Promo>();
    promos = parsedJson.map((i)=>Promo.fromJson(i)).toList();

    return new ListePromos(
        promos: promos
    );
  }
}