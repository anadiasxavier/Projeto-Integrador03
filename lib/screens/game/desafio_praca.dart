// arquivo: desafio_praca.dart
import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import 'praca_screen.dart';

class DesafioPracaScreen extends StatefulWidget {
  const DesafioPracaScreen({super.key});

  @override
  State<DesafioPracaScreen> createState() => _DesafioPracaScreenState();
}

class _DesafioPracaScreenState extends State<DesafioPracaScreen> {
  // Os 6 slots - cada um deve receber um item específico
  // null = vazio
  List<String?> _slots = List.filled(6, null);
  
  // Item selecionado da lista
  String? _itemSelecionado;
  
  // Ordem correta para vencer
  final List<String> _ordemCorreta = [
    '🍔 Embalagem',
    '🧃 Suco derramado',
    '🥤 Copo vazio',
    '🍟 Batatas frias',
    '🍫 Chocolate',
    '🍎 Maçã mordida',
  ];
  
  String _mensagem = "Selecione um item e depois toque no slot";
  Color _mensagemCor = Colors.white70;

  void _selecionarItem(String item) {
    setState(() {
      // Se o item já está em algum slot, remove de lá
      for (int i = 0; i < _slots.length; i++) {
        if (_slots[i] == item) {
          _slots[i] = null;
          break;
        }
      }
      _itemSelecionado = item;
      _mensagem = "Item '$item' selecionado. Toque em um slot";
      _mensagemCor = Colors.cyan;
    });
  }

  void _colocarNoSlot(int slotIndex) {
    if (_itemSelecionado == null) {
      setState(() {
        _mensagem = "Selecione um item primeiro!";
        _mensagemCor = Colors.orange;
      });
      return;
    }

    setState(() {
      // Se já tem outro item neste slot, libera ele
      String? itemAtual = _slots[slotIndex];
      
      // Coloca o item selecionado no slot
      _slots[slotIndex] = _itemSelecionado;
      _itemSelecionado = null;
      _mensagem = "Item colocado! Selecione outro ou verifique";
      _mensagemCor = Colors.white70;
    });
  }

  void _removerDoSlot(int slotIndex) {
    setState(() {
      _slots[slotIndex] = null;
      _mensagem = "Item removido. Você pode recolocá-lo";
      _mensagemCor = Colors.yellow;
    });
  }

  bool _todosSlotsPreenchidos() {
    return !_slots.contains(null);
  }

  void _verificarResolucao() {
    bool acertou = true;
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] != _ordemCorreta[i]) {
        acertou = false;
        break;
      }
    }

    if (acertou) {
      // VENCEU!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PracaAlimentacaoScreen.telaAcerto(),
        ),
      );
    } else {
      // ERROU
      setState(() {
        _mensagem = "❌ Ordem errada! Tente novamente...";
        _mensagemCor = Colors.red;
        _slots = List.filled(6, null);
        _itemSelecionado = null;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PracaAlimentacaoScreen.telaErro(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Desafio dos Restos"),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
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
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
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
              
              // Título da área de slots
              const Text(
                "MESA PARA ORGANIZAR:",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontFamily: 'PressStart2P',
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Grid de slots
              Expanded(
                flex: 3,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    bool preenchido = _slots[index] != null;
                    bool selecionado = _itemSelecionado != null;
                    
                    return GestureDetector(
                      onTap: () {
                        if (preenchido) {
                          _removerDoSlot(index);
                        } else {
                          _colocarNoSlot(index);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: preenchido
                              ? Colors.orange.withValues(alpha: 0.3)
                              : selecionado
                                  ? Colors.cyan.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: preenchido
                                ? Colors.orange
                                : selecionado
                                    ? Colors.cyan.withValues(alpha: 0.6)
                                    : Colors.grey.withValues(alpha: 0.4),
                            width: selecionado && !preenchido ? 2 : 1,
                          ),
                        ),
                        child: preenchido
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _slots[index]!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: 'PressStart2P',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '(toque para remover)',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '?',
                                    style: TextStyle(
                                      color: Colors.white24,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    'Slot ${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white24,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Título dos itens
              const Text(
                "ITENS ENCONTRADOS:",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 10,
                  fontFamily: 'PressStart2P',
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Lista de itens
              Expanded(
                flex: 2,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _ordemCorreta.length,
                  itemBuilder: (context, index) {
                    String item = _ordemCorreta[index];
                    bool estaEmUso = _slots.contains(item);
                    bool estaSelecionado = _itemSelecionado == item;
                    
                    return GestureDetector(
                      onTap: estaEmUso ? null : () => _selecionarItem(item),
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
                        child: Center(
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: estaEmUso ? Colors.grey : Colors.white,
                              fontSize: 9,
                              fontFamily: 'PressStart2P',
                              decoration: estaEmUso
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
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
                onTap: _todosSlotsPreenchidos() ? _verificarResolucao : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _todosSlotsPreenchidos()
                        ? Colors.orange.withValues(alpha: 0.8)
                        : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _todosSlotsPreenchidos()
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "VERIFICAR ORDEM",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'PressStart2P',
                        fontWeight: FontWeight.bold,
                      ),
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
}