import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teklif.dart';

class TeklifService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcıya özel teklif koleksiyonu
  CollectionReference _getUserTeklifRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('teklifler');
  }

  Future<void> saveTeklif(String userId, Teklif teklif) async {
    await _getUserTeklifRef(userId).doc(teklif.id).set(teklif.toJson());
  }

  Stream<List<Teklif>> getTeklifler(String userId) {
    return _getUserTeklifRef(userId).orderBy('tarih', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Teklif.fromJson(data);
      }).toList();
    });
  }
}
