import 'package:flutter/material.dart';
import '../../widgets/background.dart';

class NarradorScreen extends StatelessWidget {
  final Widget proximaTela;
  final String imagemFundo;
  final String tituloAppBar;
  final String corpoNarracao;
  final String dica;
  final bool exibirNarracaoEmCaixa;

  const NarradorScreen({
    super.key,
    required this.proximaTela,
    required this.imagemFundo,
    String? tituloAppBar,
    String? corpoNarracao,
    String? dica,
    this.exibirNarracaoEmCaixa = false,
  })  : tituloAppBar = tituloAppBar ?? 'Narrador',
        corpoNarracao = corpoNarracao ?? _corpoPadrao,
        dica = dica ?? _dicaPadrao;

  static const String _corpoPadrao =
      'Você acorda no campus...\n\nEstá escuro.\n\nO silêncio domina o lugar.\n\nVocê não sabe como chegou ali...\n\nMas algo não está certo.';

  static const String _dicaPadrao = '💭 Dica:\nExplore o ambiente ao seu redor...';

  String _formatarTexto(String texto) {
    const marcador = '__ELLIPSIS__';
    return texto
        .replaceAll('...', marcador)
        .replaceAll('. ', '.\n')
        .replaceAll('.', '.\n')
        .replaceAll('$marcador\n', '...')
        .replaceAll(marcador, '...')
        .replaceAll('\n\n\n', '\n\n')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // estrutura básica da tela

      appBar: AppBar(
      title: Text(tituloAppBar),
      backgroundColor: const Color.fromARGB(255, 0, 19, 48), // azul escuro
      foregroundColor: Colors.white, // texto + ícone branco
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Voltar',
        onPressed: () => Navigator.maybePop(context),
      ),
       ),

      body: Background(
        imagem: imagemFundo,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final telaPequena = constraints.maxHeight < 700;
                final tituloFont = telaPequena ? 15.0 : 18.0;
                final textoFont = telaPequena ? 11.0 : 13.0;
                final dicaFont = telaPequena ? 10.0 : 12.0;
                final espacamentoTitulo = telaPequena ? 16.0 : 30.0;
                final espacamentoDica = telaPequena ? 20.0 : 40.0;
                final espacamentoBotao = telaPequena ? 26.0 : 50.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                Text(
                  tituloAppBar,
                  style: TextStyle(
                    color:  Color.fromARGB(255, 255, 213, 0),
                    fontSize: tituloFont,
                    fontFamily: 'PressStart2P',
                  ),
                ),

                SizedBox(height: espacamentoTitulo),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: exibirNarracaoEmCaixa
                        ? Colors.black.withValues(alpha: 0.62)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: exibirNarracaoEmCaixa
                        ? Border.all(color: Colors.white24)
                        : null,
                  ),
                  child: Text(
                    _formatarTexto(corpoNarracao),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textoFont,
                      fontFamily: 'PressStart2P',
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: espacamentoDica),

                Text(
                  dica,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: dicaFont,
                  ),
                ),

                SizedBox(height: espacamentoBotao),

                //Botão para avançar para a próxima tela
               SizedBox(
                width: 260,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => proximaTela,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
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
              )
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