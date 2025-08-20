class Musteri {
  final String id;
  final String ad;
  final String soyad;
  final String? adres;
  final String? telefon;

  Musteri({
    required this.id,
    required this.ad,
    required this.soyad,
    this.adres,
    this.telefon,
  });

  factory Musteri.fromJson(Map<String, dynamic> json) {
    return Musteri(
      id: json['id'],
      ad: json['ad'],
      soyad: json['soyad'],
      adres: json['adres'],
      telefon: json['telefon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'adres': adres,
      'telefon': telefon,
    };
  }
}
