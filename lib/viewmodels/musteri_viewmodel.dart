import 'package:flutter/material.dart';
import '../services/musteri_service.dart';
import '../models/musteri.dart';
import 'package:uuid/uuid.dart';

class MusteriViewModel extends ChangeNotifier {
  final MusteriService _musteriService = MusteriService();
  List<Musteri> _musteriler = [];
  List<Musteri> get musteriler => _musteriler;

  String? _currentUserId;

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    if (userId.isNotEmpty) {
      loadMusteriler();
    }
  }

  void clearCurrentUserId() {
    _currentUserId = null;
    _musteriler.clear();
    notifyListeners();
  }

  Future<void> addMusteri(String ad, String soyad, String? adres, String? telefon) async {
    if (_currentUserId == null) return;
    
    final musteri = Musteri(
      id: const Uuid().v4(),
      ad: ad,
      soyad: soyad,
      adres: adres,
      telefon: telefon,
    );
    
    await _musteriService.addMusteri(_currentUserId!, musteri);
  }

  Future<void> updateMusteri(Musteri musteri) async {
    if (_currentUserId == null) return;
    await _musteriService.updateMusteri(_currentUserId!, musteri);
  }

  Future<void> deleteMusteri(String id) async {
    if (_currentUserId == null) return;
    await _musteriService.deleteMusteri(_currentUserId!, id);
  }

  void loadMusteriler() {
    if (_currentUserId == null) return;
    
    _musteriService.getMusteriler(_currentUserId!).listen((data) {
      _musteriler = data;
      notifyListeners();
    });
  }
}
