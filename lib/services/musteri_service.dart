import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/musteri.dart';

class MusteriService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcıya özel müşteri koleksiyonu
  CollectionReference _getUserMusteriRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('musteriler');
  }

  Future<void> addMusteri(String userId, Musteri musteri) async {
    await _getUserMusteriRef(userId).doc(musteri.id).set(musteri.toJson());
  }

  Future<void> updateMusteri(String userId, Musteri musteri) async {
    await _getUserMusteriRef(userId).doc(musteri.id).update(musteri.toJson());
  }

  Future<void> deleteMusteri(String userId, String id) async {
    await _getUserMusteriRef(userId).doc(id).delete();
  }

  Stream<List<Musteri>> getMusteriler(String userId) {
    return _getUserMusteriRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Musteri.fromJson(data);
      }).toList();
    });
  }
}
