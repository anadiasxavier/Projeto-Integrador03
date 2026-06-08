import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../main.dart';
import '../../models/entidade_dialogo.dart';

// Tela central que exibe os diálogos de qualquer ambiente
// é um "leitor de falas" genérico
// imagem de fundo, imagem do personagem e imagem do guardião
// quem está falando e o que aparece na imagem grande
class PersonagemScreen extends StatefulWidget {
  final Widget? proximaTela;
  final String imagemFundo;
  final String? instrucaoToque;
  final List<String>? falasCustom;
  final List<FalaConfig>? falasConfig;
  final bool exibirReacoes;
  final bool substituirAoAvancarFinal;
  final String? imagemGuardiao;

  const PersonagemScreen({
    super.key,
    this.proximaTela,
    required this.imagemFundo,
    this.instrucaoToque,
    this.falasCustom,
    this.falasConfig,
    this.exibirReacoes = false,
    this.substituirAoAvancarFinal = true,
    this.imagemGuardiao,
  });

  @override
  State<PersonagemScreen> createState() => _PersonagemScreenState();
}

// Para as reações do personagem, a lógica é: as falas do personagem podem ter uma tag no começo como [surpreso]
// A tela separa essa tag do texto real
// A tag vira o nome de uma imagem — por exemplo [surpreso] vira assets/reactions/Masculino_Surpreso.png
// Essa imagem é colocada no canto direito da tela e o texto exibido no balão é o que sobrou depois de remover a tag.
class _PersonagemScreenState extends State<PersonagemScreen> {
  int indice = 0; // começa em 0 e vai avançando conforme o jogador toca na tela

  // 3.traduz a tag para o nome do arquivo:
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
  };

  bool get _showReactions => widget.exibirReacoes;

  List<String> get _falas {
    if (widget.falasConfig != null && widget.falasConfig!.isNotEmpty) {
      return widget.falasConfig!.map((f) => f.texto).toList();
    }

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

  String? _guardiaoImagePath() {
    // MUDANÇA NO MÉTODO DO GURADIÃO
    if (widget.falasConfig == null || widget.falasConfig!.isEmpty) {
      return null;
    }

    if (indice >= widget.falasConfig!.length) {
      return null;
    }

    final config = widget.falasConfig![indice];
    if (config.entidade == TipoEntidade.guardiao) {
      // CORREÇÃO 2: fallback alterado de 'assets/guardiao.png' (arquivo deletado)
      // para null — sem imagem explícita, o personagem padrão é exibido no lugar
      return widget.imagemGuardiao ?? null;
    }

    return null;
  }

  String? _getImagemFundo() {
    if (_falas.isEmpty) {
      return _defaultCharacterImage();
    }

    final guardiaoImage = _guardiaoImagePath();
    if (guardiaoImage != null) {
      return guardiaoImage;
    }

    if (widget.falasConfig != null &&
        widget.falasConfig!.isNotEmpty &&
        indice < widget.falasConfig!.length) {
      final reaction = _reactionForIndex(indice);

      if (_showReactions && reaction.isNotEmpty) {
        return _reactionAssetPath(reaction);
      }
    }

    return null;
  }

  String? _getIconeBalao() {
    if (_falas.isEmpty) {
      return _defaultCharacterImage();
    }

    final guardiaoImage = _guardiaoImagePath();
    if (guardiaoImage != null) {
      return guardiaoImage;
    }

    return _defaultCharacterImage();
  }

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

    return _rotuloPersonagem();
  }

  Color _getCorNome() {
    if (widget.falasConfig != null &&
        widget.falasConfig!.isNotEmpty &&
        indice < widget.falasConfig!.length) {
      final config = widget.falasConfig![indice];

      if (config.entidade == TipoEntidade.guardiao) {
        return Colors.amber;
      }
    }

    return Colors.cyan;
  }

  // 2.Mostra só o texto sem a tag, e a tag vira o nome de um asset de imagem.
  String _dialogText(int index) {
    if (_falas.isEmpty) return '';
    if (!_showReactions) return _falas[index];
    return _parseFala(_falas[index]).key;
  }

  // 1. Usa uma regex para extrair uma tag, se encontrar, separa a reação do texto real
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

  //  monta o caminho completo
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
    final imagemFundo = _getImagemFundo();
    final iconeBalao = _getIconeBalao();

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
            if (imagemFundo != null)
              Positioned(
                bottom: 95,
                right: -95, // lado que o guardião fica na tela
                child: Transform.rotate(
                  angle: -0.04,
                  child: Container(
                    width: 490,
                    height: 490,
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      imagemFundo,
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
                      if (iconeBalao != null)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            iconeBalao,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  _defaultCharacterImage(),
                                  width: 60,
                                  height: 60,
                                ),
                          ),
                        )
                      else
                        const SizedBox(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getNomeFalante(),
                              style: TextStyle(
                                color: _getCorNome(),
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
