// Salva progresso do jogador

// SharedPreferences → salva no próprio celular, funciona sem internet
// Firestore → salva na nuvem, sincroniza entre dispositivos

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class ProgressService {
  // Garante que toda vez que qualquer tela chamar ProgressService(), recebe o mesmo objeto
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  final FirestoreService _firestore = FirestoreService();

  // Prefixo por RA para evitar conflito entre usuários no mesmo dispositivo
  String _keyChaves(String ra) => 'progress_${ra}_chaves';
  String _keySalas(String ra) => 'progress_${ra}_salas';

  // ---------------------------------------------------------------------------
  // Carrega o progresso do cache local (instantâneo, funciona offline)
  // ---------------------------------------------------------------------------
  Future<Map<String, List<String>>> carregarLocal(String ra) async {
    final prefs = await SharedPreferences.getInstance();
    final chavesJson = prefs.getString(_keyChaves(ra));
    final salasJson = prefs.getString(_keySalas(ra));
    return {
      // Se não tiver nada salvo, retorna lista vazia
      'chaves':
          chavesJson != null ? List<String>.from(jsonDecode(chavesJson)) : [],
      'salasConcluidas':
          salasJson != null ? List<String>.from(jsonDecode(salasJson)) : [],
    };
  }

  // ---------------------------------------------------------------------------
  // Salva o progresso no cache local
  // ---------------------------------------------------------------------------
  Future<void> salvarLocal(
    String ra,
    List<String> chaves,
    List<String> salasConcluidas,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // Converte as listas para JSON e salva no celular.
    await prefs.setString(_keyChaves(ra), jsonEncode(chaves));
    await prefs.setString(_keySalas(ra), jsonEncode(salasConcluidas));
  }

  // ---------------------------------------------------------------------------
  // Sincroniza com o Firestore e atualiza o cache local.
  // Retorna os dados do Firestore ou null em caso de falha.
  // ---------------------------------------------------------------------------
  Future<Map<String, List<String>>?> sincronizarFirestore(String ra) async {
    try {
      final dados = await _firestore.getPlayerData(ra);
      if (dados != null) {
        final chaves = List<String>.from(dados['chaves'] ?? []);
        final salas = List<String>.from(dados['salasConcluidas'] ?? []);
        await salvarLocal(ra, chaves, salas);
        return {'chaves': chaves, 'salasConcluidas': salas};
      }
    } catch (e) {
      // Falha silenciosa: o cache local já foi carregado antes
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Marca uma sala como concluída:
  //  1. Atualiza o cache local imediatamente
  //  2. Envia para o Firestore
  // ---------------------------------------------------------------------------
  Future<void> marcarSalaConcluida(
    String ra,
    String sala, {
    List<String> novasChaves = const [],
  }) async {
    // Atualiza cache local
    final local = await carregarLocal(ra);
    final chaves = local['chaves']!;
    final salas = local['salasConcluidas']!;

    if (!salas.contains(sala)) salas.add(sala);
    for (final chave in novasChaves) {
      if (!chaves.contains(chave)) chaves.add(chave);
    }
    await salvarLocal(ra, chaves, salas);

    // Envia para Firestore
    final Map<String, dynamic> dados = {
      'salasConcluidas': FieldValue.arrayUnion([sala]),
    };
    if (novasChaves.isNotEmpty) {
      dados['chaves'] = FieldValue.arrayUnion(novasChaves);
    }
    await _firestore.updatePlayerData(ra, dados);
  }

  // ---------------------------------------------------------------------------
  // Verifica se o jogador já tem progresso salvo localmente
  // ---------------------------------------------------------------------------
  Future<bool> temProgressoLocal(String ra) async {
    final local = await carregarLocal(ra);
    // Retorna true se o jogador já completou alguma sala ou tem alguma chave
    return local['salasConcluidas']!.isNotEmpty ||
        local['chaves']!.isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // Limpa o cache local (usado no logout ou reset)
  // ---------------------------------------------------------------------------
  Future<void> limparLocal(String ra) async {
    // Usado no logout ou reset — apaga só o cache local, não o Firebase
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyChaves(ra));
    await prefs.remove(_keySalas(ra));
  }
}
