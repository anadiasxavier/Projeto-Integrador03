// Executa as buscas no Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Conexão com o firebase
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Salva jogador
  Future<void> savePlayerData(String uid, Map<String, dynamic> data) async {
    await _db.collection('players').doc(uid).set(data);
  }

  // Busca jogador por RA
  Future<Map<String, dynamic>?> getPlayerData(String uid) async {
    DocumentSnapshot doc = await _db.collection('players').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Verifica se RA já existe
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

  // Atualiza dados do jogador
  // Usado para salvar progresso, adicionar chaves e salas concluídas.
  Future<void> updatePlayerData(String uid, Map<String, dynamic> data) async {
    await _db.collection('players').doc(uid).update(data);
  }
}
