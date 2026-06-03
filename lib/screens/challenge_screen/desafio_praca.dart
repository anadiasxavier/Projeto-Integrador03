// lib/screens/challenge_screen/desafio_praca.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../main.dart';
import '../../services/progress_service.dart';
import '../../widgets/game_timer_widget.dart';

class _RecompensaPracaScreen extends StatefulWidget {
  const _RecompensaPracaScreen();

  @override
  State<_RecompensaPracaScreen> createState() => _RecompensaPracaScreenState();
}

class _RecompensaPracaScreenState extends State<_RecompensaPracaScreen> {
  final ProgressService _progress = ProgressService();
  bool _finalizando = false;

  Future<void> _salvarProgressoERetornar() async {
    if (_finalizando) return;
    setState(() => _finalizando = true);

    try {
      await _progress
          .marcarSalaConcluida(raJogador, 'Praça')
          .timeout(const Duration(seconds: 6));
      print('Progresso da Praça salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar progresso da Praça: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ExplorationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fragmento de Chave'),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
      ),
      body: Background(
        imagem: 'assets/praca.png',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.amber, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.vpn_key, color: Colors.amber, size: 80),
              ),
              const SizedBox(height: 30),
              const Text(
                'FRAGMENTO DE CHAVE OBTIDO!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'A praça volta ao silêncio.\n\n'
                'Você guardou mais uma peça importante.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontFamily: 'PressStart2P',
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _finalizando ? null : _salvarProgressoERetornar,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _finalizando ? 'SALVANDO...' : 'VOLTAR AO CAMPUS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesafioPracaScreen extends StatefulWidget {
  const DesafioPracaScreen({super.key});

  @override
  State<DesafioPracaScreen> createState() => _DesafioPracaScreenState();
}

class _DesafioPracaScreenState extends State<DesafioPracaScreen> {
  // Dicionário para controlar qual lixeira cada item está
  Map<String, String?> _itensNasLixeiras = {};

  // Item selecionado da lista
  String? _itemSelecionado;

  // Contador de tentativas
  int _tentativas = 0;

  final ProgressService _progress = ProgressService();

  // Falas do guardião
  static final List<FalaConfig> _falasGuardiao = [
    FalaConfig.guardiao('...Você limpou a praça.'),
    FalaConfig.guardiao('O meio ambiente agradece.'),
  ];

  // Falas do personagem
  List<FalaConfig> get _falasPersonagem => [
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[feliz]" : "[feliz]"} Consegui! Tudo no lugar certo!',
    ),
    FalaConfig.personagem(
      '${generoJogador == "feminino" ? "[surpresa]" : "[surpreso]"} Um brilho surgiu... achei um fragmento de chave!',
    ),
  ];

  // Mapeamento correto dos itens
  final Map<String, String> _classificacaoCorreta = {
    '🍟 Restos de batata': 'organico',
    '🧃 Caixinha de suco': 'reciclavel',
    '🥤 Copo plástico': 'reciclavel',
    '🍫 Papel de chocolate': 'organico',
    '📦 Embalagem de papel': 'reciclavel',
    '🍎 Maçã mordida': 'organico',
  };

  String _mensagem = "Selecione um item e coloque na lixeira correta!";
  Color _mensagemCor = Colors.white70;
  bool _acertou = false;

  @override
  void initState() {
    super.initState();
    // Inicializa todos os itens como não classificados (null)
    for (String item in _classificacaoCorreta.keys) {
      _itensNasLixeiras[item] = null;
    }
  }

  void _selecionarItem(String item) {
    if (_acertou) return;

    setState(() {
      if (_itensNasLixeiras[item] != null) {
        _itensNasLixeiras[item] = null;
      }
      _itemSelecionado = item;
      _mensagem = "Item selecionado. Escolha a lixeira";
      _mensagemCor = Colors.cyan;
    });
  }

  void _colocarNaLixeira(String tipoLixeira) {
    if (_acertou) return;

    if (_itemSelecionado == null) {
      setState(() {
        _mensagem = "Selecione um item primeiro!";
        _mensagemCor = Colors.orange;
      });
      return;
    }

    setState(() {
      _itensNasLixeiras[_itemSelecionado!] = tipoLixeira;
      _itemSelecionado = null;

      if (tipoLixeira == 'organico') {
        _mensagem = "Item colocado no orgânico! 🌱";
      } else {
        _mensagem = "Item colocado no reciclável! ♻️";
      }
      _mensagemCor = Colors.green;
    });
  }

  void _removerDaLixeira(String item) {
    if (_acertou) return;

    setState(() {
      _itensNasLixeiras[item] = null;
      _itemSelecionado = null;
      _mensagem = "Item removido. Você pode recolocá-lo";
      _mensagemCor = Colors.yellow;
    });
  }

  bool _todosItensClassificados() {
    return !_itensNasLixeiras.values.contains(null);
  }

  List<String> _getItensNaLixeira(String tipoLixeira) {
    return _itensNasLixeiras.entries
        .where((entry) => entry.value == tipoLixeira)
        .map((entry) => entry.key)
        .toList();
  }

  void _verificarResolucao() async {
    bool acertou = true;

    for (var entry in _itensNasLixeiras.entries) {
      if (entry.value != _classificacaoCorreta[entry.key]) {
        acertou = false;
        break;
      }
    }

    setState(() {
      _tentativas++;

      if (acertou) {
        // VENCEU!
        _acertou = true;
      } else {
        // ERROU - Reseta os itens
        _mensagem = "❌ Não foi dessa vez! Tente novamente...";
        _mensagemCor = Colors.red;

        _itensNasLixeiras = {};
        for (String item in _classificacaoCorreta.keys) {
          _itensNasLixeiras[item] = null;
        }
        _itemSelecionado = null;

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_acertou) {
            setState(() {
              _mensagem = "Selecione um item e coloque na lixeira correta!";
              _mensagemCor = Colors.white70;
            });
          }
        });
      }
    });

    if (acertou) {
      await _vitoria();
    }
  }

  Future<void> _vitoria() async {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PersonagemScreen(
          imagemFundo: "assets/praca.png",
          falasConfig: _falasGuardiao,
          exibirReacoes: false,
          instrucaoToque: 'Toque para continuar',
          substituirAoAvancarFinal: true,
          proximaTela: PersonagemScreen(
            imagemFundo: "assets/praca.png",
            falasConfig: _falasPersonagem,
            exibirReacoes: true,
            instrucaoToque: 'Toque para continuar',
            substituirAoAvancarFinal: true,
            proximaTela: const _RecompensaPracaScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coleta Seletiva na Praça"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: const GameTimerWidget()),
          ),
        ],
      ),
      body: Background(
        imagem: "assets/praca.png",
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Mensagem
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _acertou
                        ? Colors.green.withValues(alpha: 0.5)
                        : Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _mensagem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _mensagemCor,
                    fontSize: 11,
                    fontFamily: 'PressStart2P',
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Área das lixeiras
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    // Lixeira de Orgânico
                    Expanded(
                      child: _buildLixeira(
                        "ORGÂNICO",
                        "organico",
                        Colors.green,
                        "🗑️🌱",
                        _getItensNaLixeira("organico"),
                        "Restos de comida,\ncascas, folhas",
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Lixeira de Reciclável
                    Expanded(
                      child: _buildLixeira(
                        "RECICLÁVEL",
                        "reciclavel",
                        Colors.blue,
                        "♻️",
                        _getItensNaLixeira("reciclavel"),
                        "Plástico, papel,\nmetal, vidro",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Título dos itens
              const Text(
                "ITENS ENCONTRADOS NA PRAÇA:",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 10,
                  fontFamily: 'PressStart2P',
                ),
              ),

              const SizedBox(height: 8),

              // Lista de itens para classificar
              Expanded(
                flex: 2,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: _classificacaoCorreta.length,
                  itemBuilder: (context, index) {
                    String item = _classificacaoCorreta.keys.elementAt(index);
                    bool estaEmUso = _itensNasLixeiras[item] != null;
                    bool estaSelecionado = _itemSelecionado == item;

                    return GestureDetector(
                      onTap: (estaEmUso || _acertou)
                          ? null
                          : () => _selecionarItem(item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: estaSelecionado
                              ? Colors.cyan.withValues(alpha: 0.3)
                              : estaEmUso
                              ? Colors.grey.withValues(alpha: 0.2)
                              : Colors.cyan.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: estaSelecionado
                                ? Colors.cyan
                                : estaEmUso
                                ? Colors.grey
                                : Colors.cyan.withValues(alpha: 0.3),
                            width: estaSelecionado ? 2 : 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.split(' ').first,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: estaEmUso ? Colors.grey : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  item.substring(item.indexOf(' ') + 1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: estaEmUso
                                        ? Colors.grey
                                        : Colors.white,
                                    fontSize: 8,
                                    fontFamily: 'PressStart2P',
                                    decoration: estaEmUso
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Botão verificar
              GestureDetector(
                onTap: (_todosItensClassificados() && !_acertou)
                    ? _verificarResolucao
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: (_todosItensClassificados() && !_acertou)
                        ? Colors.orange.withValues(alpha: 0.8)
                        : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: (_todosItensClassificados() && !_acertou)
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _acertou ? Icons.check_circle : Icons.recycling,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _acertou
                              ? "CLASSIFICAÇÃO CORRETA!"
                              : _todosItensClassificados()
                              ? "VERIFICAR CLASSIFICAÇÃO"
                              : "CLASSIFIQUE TODOS OS ITENS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'PressStart2P',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLixeira(
    String titulo,
    String tipoLixeira,
    Color cor,
    String icone,
    List<String> itens,
    String descricao,
  ) {
    bool isSelected =
        _itemSelecionado != null &&
        _itensNasLixeiras[_itemSelecionado!] == null &&
        !_acertou;

    return GestureDetector(
      onTap: isSelected ? () => _colocarNaLixeira(tipoLixeira) : null,
      child: Container(
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? cor : cor.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(icone, style: const TextStyle(fontSize: 32)),
            Text(
              titulo,
              style: TextStyle(
                color: cor,
                fontSize: 11,
                fontFamily: 'PressStart2P',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cor.withValues(alpha: 0.7),
                fontSize: 7,
                fontFamily: 'PressStart2P',
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: cor.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: itens.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.white.withValues(alpha: 0.2),
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Toque aqui\npara descartar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.3),
                              fontSize: 8,
                              fontFamily: 'PressStart2P',
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: _acertou
                              ? null
                              : () => _removerDaLixeira(itens[index]),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: cor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: cor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  itens[index].split(' ').first,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    itens[index].substring(
                                      itens[index].indexOf(' ') + 1,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontFamily: 'PressStart2P',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!_acertou)
                                  const Icon(
                                    Icons.close,
                                    color: Colors.white38,
                                    size: 14,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
