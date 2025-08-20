class TeklifSatir {
  final String islemAdi;
  final int adet;
  final double birimFiyat;

  TeklifSatir({
    required this.islemAdi,
    required this.adet,
    required this.birimFiyat,
  });

  double get toplam => adet * birimFiyat;

  factory TeklifSatir.fromJson(Map<String, dynamic> json) {
    return TeklifSatir(
      islemAdi: json['islemAdi'],
      adet: json['adet'],
      birimFiyat: json['birimFiyat'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'islemAdi': islemAdi,
      'adet': adet,
      'birimFiyat': birimFiyat,
    };
  }
}

class Teklif {
  final String id;
  final String firmaId;
  final String musteriId;
  final DateTime tarih;
  final List<TeklifSatir> satirlar;
  final double toplam;
  final double? indirim;
  final String? not;

  Teklif({
    required this.id,
    required this.firmaId,
    required this.musteriId,
    required this.tarih,
    required this.satirlar,
    required this.toplam,
    this.indirim,
    this.not,
  });

  factory Teklif.fromJson(Map<String, dynamic> json) {
    return Teklif(
      id: json['id'],
      firmaId: json['firmaId'],
      musteriId: json['musteriId'],
      tarih: DateTime.parse(json['tarih']),
      satirlar: (json['satirlar'] as List)
          .map((e) => TeklifSatir.fromJson(e))
          .toList(),
      toplam: json['toplam'].toDouble(),
      indirim: json['indirim'] != null ? json['indirim'].toDouble() : null,
      not: json['not'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firmaId': firmaId,
      'musteriId': musteriId,
      'tarih': tarih.toIso8601String(),
      'satirlar': satirlar.map((e) => e.toJson()).toList(),
      'toplam': toplam,
      'indirim': indirim,
      'not': not,
    };
  }
}
