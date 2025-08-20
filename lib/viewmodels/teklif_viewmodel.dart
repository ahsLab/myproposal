import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/teklif.dart';
import '../services/teklif_service.dart';

class TeklifViewModel extends ChangeNotifier {
  final TeklifService _teklifService = TeklifService();

  // Geçici satır listesi
  List<TeklifSatir> _satirlar = [];
  List<TeklifSatir> get satirlar => _satirlar;

  // Tüm teklifler
  List<Teklif> _teklifler = [];
  List<Teklif> get teklifler => _teklifler;

  String? _currentUserId;

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    if (userId.isNotEmpty) {
      loadTeklifler();
    }
  }

  void clearCurrentUserId() {
    _currentUserId = null;
    _teklifler.clear();
    notifyListeners();
  }

  // Satır işlemleri
  void addSatir(String islemAdi, int adet, double birimFiyat) {
    _satirlar.add(TeklifSatir(islemAdi: islemAdi, adet: adet, birimFiyat: birimFiyat));
    notifyListeners();
  }

  void removeSatir(int index) {
    _satirlar.removeAt(index);
    notifyListeners();
  }

  void clearSatirlar() {
    _satirlar.clear();
    notifyListeners();
  }

  double get toplam => _satirlar.fold(0.0, (sum, item) => sum + item.toplam);

  Teklif buildTeklif({
    required String firmaId,
    required String musteriId,
    double? indirim,
    String? not,
  }) {
    return Teklif(
      id: const Uuid().v4(),
      firmaId: firmaId,
      musteriId: musteriId,
      tarih: DateTime.now(),
      satirlar: List.from(_satirlar),
      toplam: toplam,
      indirim: indirim,
      not: not,
    );
  }

  // Firestore işlemleri
  Future<void> saveTeklif(Teklif teklif) async {
    if (_currentUserId == null) return;
    await _teklifService.saveTeklif(_currentUserId!, teklif);
  }

  void loadTeklifler() {
    if (_currentUserId == null) return;
    
    _teklifService.getTeklifler(_currentUserId!).listen((data) {
      _teklifler = data;
      notifyListeners();
    });
  }
}
