import 'package:flutter/material.dart';
import '../services/firma_service.dart';
import '../models/firma.dart';
import 'package:uuid/uuid.dart';

class FirmaViewModel extends ChangeNotifier {
  final FirmaService _firmaService = FirmaService();
  List<Firma> _firmalar = [];
  List<Firma> get firmalar => _firmalar;

  String? _currentUserId;

  void setCurrentUserId(String userId) {
    print('FirmaViewModel: setCurrentUserId called with: $userId');
    _currentUserId = userId;
    if (userId.isNotEmpty) {
      loadFirmalar();
    }
  }

  void clearCurrentUserId() {
    _currentUserId = null;
    _firmalar.clear();
    notifyListeners();
  }

  Future<void> addFirma(String isim, String? adres, String? telefon, String? logoUrl) async {
    print('FirmaViewModel: addFirma called with userId: $_currentUserId');
    if (_currentUserId == null) {
      print('FirmaViewModel: currentUserId is null, cannot add firma');
      return;
    }
    
    final firma = Firma(
      id: const Uuid().v4(),
      isim: isim,
      adres: adres,
      telefon: telefon,
      logoUrl: logoUrl,
    );
    
    print('FirmaViewModel: Adding firma: ${firma.isim}');
    await _firmaService.addFirma(_currentUserId!, firma);
    print('FirmaViewModel: Firma added successfully');
  }

  Future<void> updateFirma(Firma firma) async {
    if (_currentUserId == null) return;
    await _firmaService.updateFirma(_currentUserId!, firma);
  }

  Future<void> deleteFirma(String id) async {
    if (_currentUserId == null) return;
    await _firmaService.deleteFirma(_currentUserId!, id);
  }

  void loadFirmalar() {
    if (_currentUserId == null) return;
    
    _firmaService.getFirmalar(_currentUserId!).listen((data) {
      _firmalar = data;
      notifyListeners();
    });
  }
}
