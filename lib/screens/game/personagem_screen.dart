// lib/screens/game/personagem_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';

class PersonagemScreen extends StatefulWidget {
  final Widget? proximaTela;
  final String imagemFundo;
  final String? instrucaoToque;
  final List<String>? falasCustom; // Mantido para compatibilidade
  final List<FalaConfig>? falasConfig; // NOVO
  final bool exibirReacoes;
  final bool substituirAoAvancarFinal;

  const PersonagemScreen({
    super.key,
    this.proximaTela,
    required this.imagemFundo,
    this.instrucaoToque,
    this.falasCustom,
    this.falasConfig, //NOVO
    this.exibirReacoes = false,
    this.substituirAoAvancarFinal = true,
  });

  @override
  State<PersonagemScreen> createState() => _PersonagemScreenState();
}

class _PersonagemScreenState extends State<PersonagemScreen> {
  int indice = 0;

  static const Map<String, String> _reactionAssetNames = {
    'confuso': 'Confuso',
    'confusa': 'Confusa',
    'inquieto': 'Inquieto',
    'inquieta': 'Inquieta',
    'surpreso': 'Surpreso',
    'surpresa': 'Surpresa',
    'feliz': 'Feliz',
    'felizM': 'Masculino_Feliz',
    'triste': 'Triste',
    'tristeM': 'Masculino_Triste',
    'guardiao_mescla_neutro': 'Guardiao_Mescla_Neutro',
    'guardiao_mescla_expressao': 'Guardiao_Mescla_Expressao',
  };

  bool get _showReactions => widget.exibirReacoes;

  // Retorna as falas (considerando os 2 formatos)
  List<String> get _falas {
    // Prioriza o novo formato
    if (widget.falasConfig != null && widget.falasConfig!.isNotEmpty) {
      return widget.falasConfig!.map((f) => f.texto).toList();
    }

    // Fallback para formato antigo
    if (widget.falasCustom != null && widget.falasCustom!.isNotEmpty) {
      return widget.falasCustom!;
    }

    return [];
  }

  bool get _ultimaFala => _falas.isEmpty || indice >= _falas.length - 1;

  String _defaultCharacterImage() {
    return generoJogador == 'feminino'
        ? 'assets/personagemfeminina.png'
        : 'assets/personagem.png';
  }

  // NOVO: Determina qual ícone mostrar
  String _getIconePath() {
    if (_falas.isEmpty) return _defaultCharacterImage();

    if (widget.falasConfig != null &&
        widget.falasConfig!.isNotEmpty &&
        indice < widget.falasConfig!.length) {
      final config = widget.falasConfig![indice];

      if (config.entidade == TipoEntidade.guardiao) {
        return 'assets/guardiao.png';
      }
    }

    // Padrão: personagem
    return _defaultCharacterImage();
  }

  // NOVO: Determina qual nome mostrar
  String _getNomeFalante() {
    if (_falas.isEmpty) return _rotuloPersonagem();

    if (widget.falasConfig != null &&
        widget.falasConfig!.isNotEmpty &&
        indice < widget.falasConfig!.length) {
      final config = widget.falasConfig![indice];

      if (config.entidade == TipoEntidade.guardiao) {
        return 'Guardião';
      }
    }

    // Padrão: nome do personagem
    return _rotuloPersonagem();
  }

  // NOVO: Cor do nome baseado em quem fala
  Color _getCorNome() {
    if (widget.falasConfig != null &&
        widget.falasConfig!.isNotEmpty &&
        indice < widget.falasConfig!.length) {
      final config = widget.falasConfig![indice];

      if (config.entidade == TipoEntidade.guardiao) {
        return Colors.amber; // Dourado para o guardião
      }
    }

    return Colors.cyan; // Ciano para o personagem
  }

  String _dialogText(int index) {
    if (_falas.isEmpty) return '';
    if (!_showReactions) return _falas[index];
    return _parseFala(_falas[index]).key;
  }

  MapEntry<String, String> _parseFala(String fala) {
    final match = RegExp(r'^\s*\[([^\]]+)\]\s*(.*)').firstMatch(fala);
    if (match != null) {
      final type = match.group(1)!.toLowerCase().trim();
      final text = match.group(2) ?? '';
      if (_reactionAssetNames.containsKey(type)) {
        return MapEntry(text.isEmpty ? fala : text, type);
      }
    }
    return MapEntry(fala, '');
  }

  String _reactionForIndex(int index) {
    if (_falas.isEmpty) return '';
    final parsed = _parseFala(_falas[index]);
    return parsed.value;
  }

  String _reactionAssetPath(String reaction) {
    if (reaction.isEmpty || !_reactionAssetNames.containsKey(reaction)) {
      return _defaultCharacterImage();
    }

    final assetName = _reactionAssetNames[reaction]!;
    if (reaction.startsWith('guardiao_')) {
      return 'assets/reactions/$assetName.png';
    }

    final prefix = generoJogador == 'feminino' ? 'Feminino' : 'Masculino';
    return 'assets/reactions/${prefix}_$assetName.png';
  }

  void proximaFala() {
    if (_falas.isEmpty) {
      if (widget.proximaTela != null) {
        final rota = MaterialPageRoute(
          builder: (context) => widget.proximaTela!,
        );
        if (widget.substituirAoAvancarFinal) {
          Navigator.pushReplacement(context, rota);
        } else {
          Navigator.push(context, rota);
        }
      }
      return;
    }

    if (!_ultimaFala) {
      setState(() => indice++);
      return;
    }

    if (widget.proximaTela != null) {
      final rota = MaterialPageRoute(builder: (context) => widget.proximaTela!);
      if (widget.substituirAoAvancarFinal) {
        Navigator.pushReplacement(context, rota);
      } else {
        Navigator.push(context, rota);
      }
    }
  }

  void _voltarUmaEtapa() {
    if (indice > 0) {
      setState(() => indice--);
    } else {
      Navigator.pop(context);
    }
  }

  String? _textoDicaToque() {
    if (widget.instrucaoToque == null) return null;
    if (widget.proximaTela == null && _ultimaFala) {
      return 'Fim desta parte. Use o botão Voltar acima para retornar à narração.';
    }
    return widget.instrucaoToque;
  }

  String _rotuloPersonagem() {
    final nome = nomeJogador.trim();
    if (nome.isNotEmpty) return nome;
    return generoJogador == "feminino" ? "Você (Ela)" : "Você (Ele)";
  }

  @override
  Widget build(BuildContext context) {
    final reactionImage = _showReactions && _falas.isNotEmpty
        ? _reactionAssetPath(_reactionForIndex(indice))
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.88),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back),
          ),
          tooltip: 'Voltar uma etapa',
          onPressed: _voltarUmaEtapa,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Background(
        imagem: widget.imagemFundo,
        child: Stack(
          children: [
           if (reactionImage != null &&
            widget.imagemFundo != "assets/arena.png")
              Positioned(
                bottom: 95, // altura do personagem
                left: -95,
                child: Transform.rotate(
                  angle: -0.04,
                  child: Container(
                    width: 450,
                    height: 450,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      reactionImage,
                      width: 210,
                      height: 210,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        _defaultCharacterImage(),
                        width: 210,
                        height: 210,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: proximaFala,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          _getIconePath(), // AGORA USA O MÉTODO
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                _defaultCharacterImage(),
                                width: 60,
                                height: 60,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getNomeFalante(), // 👈 AGORA USA O MÉTODO
                              style: TextStyle(
                                color: _getCorNome(), // 👈 AGORA USA O MÉTODO
                                fontSize: 12,
                                fontFamily: 'PressStart2P',
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (_falas.isNotEmpty)
                              Text(
                                _dialogText(indice),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                            if (_textoDicaToque() != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.touch_app,
                                    color: Colors.white54,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _textoDicaToque()!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
