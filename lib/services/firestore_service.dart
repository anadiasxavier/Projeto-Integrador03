import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> savePlayerData(String uid, Map<String, dynamic> data) async {
    await _db.collection('players').doc(uid).set(data);
  }

  Future<Map<String, dynamic>?> getPlayerData(String uid) async {
    DocumentSnapshot doc = await _db.collection('players').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>?> getPlayerByRA(String ra) async {
    QuerySnapshot query = await _db
        .collection('players')
        .where('ra', isEqualTo: ra)
        .get();
    if (query.docs.isNotEmpty) {
      return query.docs.first.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> updatePlayerData(String uid, Map<String, dynamic> data) async {
    await _db.collection('players').doc(uid).update(data);
  }
}
