class Firma {
  final String id;
  final String isim;
  final String? logoUrl;
  final String? adres;
  final String? telefon;

  Firma({
    required this.id,
    required this.isim,
    this.logoUrl,
    this.adres,
    this.telefon,
  });

  factory Firma.fromJson(Map<String, dynamic> json) {
    return Firma(
      id: json['id'],
      isim: json['isim'],
      logoUrl: json['logoUrl'],
      adres: json['adres'],
      telefon: json['telefon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isim': isim,
      'logoUrl': logoUrl,
      'adres': adres,
      'telefon': telefon,
    };
  }
}
