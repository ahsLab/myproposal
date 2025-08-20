import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firma.dart';

class FirmaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcıya özel firma koleksiyonu
  CollectionReference _getUserFirmaRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('firmalar');
  }

  Future<void> addFirma(String userId, Firma firma) async {
    print('FirmaService: Adding firma for userId: $userId, firma: ${firma.isim}');
    try {
      await _getUserFirmaRef(userId).doc(firma.id).set(firma.toJson());
      print('FirmaService: Firma added successfully to Firestore');
    } catch (e) {
      print('FirmaService: Error adding firma: $e');
      rethrow;
    }
  }

  Future<void> updateFirma(String userId, Firma firma) async {
    await _getUserFirmaRef(userId).doc(firma.id).update(firma.toJson());
  }

  Future<void> deleteFirma(String userId, String id) async {
    await _getUserFirmaRef(userId).doc(id).delete();
  }

  Stream<List<Firma>> getFirmalar(String userId) {
    return _getUserFirmaRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Firma.fromJson(data);
      }).toList();
    });
  }
}
