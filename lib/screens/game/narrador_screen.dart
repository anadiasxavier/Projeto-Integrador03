import 'package:flutter/material.dart';
import '../../widgets/background.dart';

// Tela do narrador - conta a história entre os diálogos
class NarradorScreen extends StatelessWidget {
  final Widget proximaTela; // Para onde vai depois de clicar em Continuar
  final String imagemFundo; // Imagem de fundo da cena
  final String tituloAppBar; // Título que aparece na barra superior
  final String? corpoNarracao; // Texto da história (se for vazio, pula a tela)
  final String? dica; // Texto de dica para o jogador
  final bool exibirNarracaoEmCaixa; // Se coloca o texto dentro de uma caixa escura

  const NarradorScreen({
    super.key,
    required this.proximaTela, // Obrigatório: sempre precisa de uma próxima tela
    required this.imagemFundo, // Obrigatório: sempre precisa de uma imagem
    String? tituloAppBar, // Se não informar, usa "Narrador" como padrão
    this.corpoNarracao, // Texto pode ser vazio
    this.dica, // Dica pode ser vazia
    this.exibirNarracaoEmCaixa = false, // Por padrão, não mostra caixa
  }) : tituloAppBar = tituloAppBar ?? 'Narrador'; // Se título for vazio, usa "Narrador"

  // Formata o texto quebrando em linhas para melhor leitura
  String _formatarTexto(String texto) {
    const marcador = '__ELLIPSIS__'; // Marcador temporário para "..."
    return texto
        .replaceAll('...', marcador) // Guarda as reticências
        .replaceAll('. ', '.\n') // Quebra linha após ponto seguido de espaço
        .replaceAll('.', '.\n') // Quebra linha após ponto
        .replaceAll('$marcador\n', '...') // Restaura reticências sem quebrar
        .replaceAll(marcador, '...') // Restaura reticências
        .replaceAll('\n\n\n', '\n\n') // Remove linhas vazias extras
        .trim(); // Remove espaços no início e fim
  }

  // Constrói a tela do narrador
  @override
  Widget build(BuildContext context) {
    // Se não tem texto, pula direto para a próxima tela
    if (corpoNarracao == null || corpoNarracao!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => proximaTela),
        );
      });
      return const SizedBox.shrink(); // Retorna um widget invisível
    }

    return Scaffold(
      // Barra superior azul com título e botão de voltar
      appBar: AppBar(
        title: Text(tituloAppBar),
        backgroundColor: const Color.fromARGB(255, 0, 19, 48),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => Navigator.maybePop(context),
        ),
      ),

      // Fundo com a imagem do local
      body: Background(
        imagem: imagemFundo,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            // Ajusta o layout conforme o tamanho da tela
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Verifica se a tela é pequena (menos de 700 pixels de altura)
                final telaPequena = constraints.maxHeight < 700;
                
                // Tamanhos de fonte ajustados para cada tipo de tela
                final tituloFont = telaPequena ? 15.0 : 18.0;
                final textoFont = telaPequena ? 11.0 : 13.0;
                final dicaFont = telaPequena ? 10.0 : 12.0;
                
                // Espaçamentos ajustados para cada tipo de tela
                final espacamentoTitulo = telaPequena ? 16.0 : 30.0;
                final espacamentoDica = telaPequena ? 20.0 : 10.0;
                final espacamentoBotao = telaPequena ? 26.0 : 10.0;
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título da cena (amarelo)
                    Text(
                      tituloAppBar,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 213, 0),
                        fontSize: tituloFont,
                        fontFamily: 'PressStart2P',
                      ),
                    ),

                    SizedBox(height: espacamentoTitulo),

                    // Caixa com o texto da história
                    Container(
                      width: double.infinity, // Ocupa toda a largura
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        // Se exibirNarracaoEmCaixa for true, coloca fundo escuro
                        color: exibirNarracaoEmCaixa
                            ? Colors.black.withOpacity(0.62)
                            : Colors.transparent, // Senão, fundo transparente
                        borderRadius: BorderRadius.circular(12),
                        border: exibirNarracaoEmCaixa
                            ? Border.all(color: Colors.white24)
                            : null, // Sem borda se não tiver caixa
                      ),
                      child: Text(
                        _formatarTexto(corpoNarracao!), // Formata o texto
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textoFont,
                          fontFamily: 'PressStart2P',
                          height: 1.5, // Espaçamento entre linhas
                        ),
                      ),
                    ),

                    SizedBox(height: espacamentoDica),

                    // Texto de dica (se existir)
                    if (dica != null && dica!.isNotEmpty)
                      Text(
                        dica!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: dicaFont,
                        ),
                      ),

                    SizedBox(height: espacamentoBotao),

///////////////////     LÓGICA PARA PROXIMA TELA           //////////////////

                    // Botão "Continuar" para avançar na história
                    SizedBox(
                      width: 260,
                      child: ElevatedButton(
                        onPressed: () {
                          // Vai para a próxima tela
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => proximaTela,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Fundo transparente
                          shadowColor: Colors.transparent, // Sem sombra
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4), // Fundo escuro
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Ícone de play
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              // Texto do botão
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Continuar",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 255, 213, 0),
                                      fontFamily: 'PressStart2P',
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Seguir na história",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 255, 249, 208),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}