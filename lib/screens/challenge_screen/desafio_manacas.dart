import 'dart:math';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../models/entidade_dialogo.dart';
import '../game/personagem_screen.dart';
import '../game/exploration_screen.dart';
import '../../main.dart';
import '../../services/progress_service.dart';
import '../../widgets/game_timer_widget.dart';

class DesafioManacasScreen extends StatefulWidget {
  const DesafioManacasScreen({super.key});

  @override
  State<DesafioManacasScreen> createState() =>
      _DesafioManacasScreenState();
}

class _DesafioManacasScreenState
    extends State<DesafioManacasScreen> {

  final ProgressService _progress =
      ProgressService();

  List<String> board =
      List.filled(9,'');

  final _falasGuardiao=[

    FalaConfig.guardiao(
      '...Você observou.',
    ),

    FalaConfig.guardiao(
      'Talvez exista esperança para você.',
    ),

    FalaConfig.guardiao(
      'Mas isso é apenas o começo.',
    ),

    FalaConfig.guardiao(
      'O silêncio do Manacás te observa.',
    ),
  ];

  final _falasPersonagem=[

    FalaConfig.personagem(
      'Consegui vencer o guardião!',
    ),

    FalaConfig.personagem(
      'O tabuleiro finalmente parou...',
    ),

    FalaConfig.personagem(
      'De repente, algo brilha na escuridão.',
    ),
  ];

  Widget _espaco(double h)=>
      SizedBox(height:h);

  Widget _dialogo(
      List<FalaConfig> falas){

    return PersonagemScreen(

      imagemFundo:
          "assets/manacas.png",

      falasConfig:
          falas,

      instrucaoToque:
          'Toque para continuar',

      substituirAoAvancarFinal:
          true,

      proximaTela:
          const SizedBox.shrink(),
    );
  }

  Text _texto(
    String txt,{
    Color cor=
        Colors.white,
    double size=11,
    FontWeight peso=
        FontWeight.normal,
  }){

    return Text(

      txt,

      textAlign:
          TextAlign.center,

      style:TextStyle(

        color:cor,

        fontSize:size,

        fontWeight:peso,

        fontFamily:
            'PressStart2P',

        height:1.7,
      ),
    );
  }

  Widget _telaComputadorConcluido(){

    return Scaffold(

      appBar: AppBar(

        title:
            const Text(
                "Fragmento de Chave"),

        backgroundColor:
            const Color.fromARGB(
                255,0,19,48),

        foregroundColor:
            Colors.white,
      ),

      body: Background(

        imagem:
            "assets/manacas.png",

        child: Center(

          child:
              SingleChildScrollView(

            child: Column(

              children:[

                _espaco(30),

                TweenAnimationBuilder<double>(

                  tween:Tween(
                    begin:0,
                    end:1,
                  ),

                  duration:
                      const Duration(
                    milliseconds:
                        1500,
                  ),

                  builder:
                  (_,value,child){

                    return Transform.scale(

                      scale:value,

                      child:Opacity(

                        opacity:value,

                        child:child,
                      ),
                    );
                  },

                  child:
                      Container(

                    padding:
                        const EdgeInsets
                            .all(30),

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.green
                              .withOpacity(
                                  .15),

                      shape:
                          BoxShape.circle,

                      border:
                          Border.all(

                        color:
                            Colors.green
                                .withOpacity(
                                    .5),

                        width:3,
                      ),

                      boxShadow:[

                        BoxShadow(

                          color:
                              Colors.green
                                  .withOpacity(
                                      .35),

                          blurRadius:30,

                          spreadRadius:
                              10,
                        )
                      ],
                    ),

                    child:
                        const Icon(

                      Icons.vpn_key,

                      color:
                          Colors.green,

                      size:80,
                    ),
                  ),
                ),

                _espaco(30),

                _texto(

                  "FRAGMENTO ENCONTRADO",

                  cor:
                      Colors.green,

                  size:20,

                  peso:
                      FontWeight.bold,
                ),

                _espaco(20),

                Container(

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal:30,
                  ),

                  padding:
                      const EdgeInsets.all(
                          20),

                  decoration:
                      BoxDecoration(

                    color:
                        Colors.black
                            .withOpacity(
                                .75),

                    borderRadius:
                        BorderRadius.circular(
                            15),

                    border:
                        Border.all(

                      color:
                          Colors.green
                              .withOpacity(
                                  .4),
                    ),
                  ),

                  child:
                      Column(

                    children:[

                      const Text(
                        "🗝️",
                        style:
                            TextStyle(
                          fontSize:40,
                        ),
                      ),

                      _espaco(12),

                      _texto(
                        "Você conseguiu um",
                      ),

                      _espaco(10),

                      _texto(

                        "FRAGMENTO DE CHAVE",

                        cor:
                            Colors.green,

                        size:14,

                        peso:
                            FontWeight.bold,
                      ),

                      _espaco(15),

                      _texto(

                        "O silêncio do Manacás parece diferente.\n\n"
                        "Algo observava você...\n"
                        "mas agora desapareceu.\n\n"
                        "Continue explorando para encontrar\n"
                        "os outros fragmentos.",

                        cor:
                            Colors.white70,
                      ),
                    ],
                  ),
                ),

                _espaco(30),

                GestureDetector(

                  onTap:
                      _salvarProgressoERetornar,

                  child:
                      Container(

                    width:280,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical:15,
                    ),

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.green
                              .withOpacity(
                                  .2),

                      borderRadius:
                          BorderRadius.circular(
                              15),

                      border:
                          Border.all(

                        color:
                            Colors.green
                                .withOpacity(
                                    .5),
                      ),
                    ),

                    child:
                        const Row(

                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children:[

                        Icon(
                          Icons.arrow_forward,
                          color:
                              Colors.green,
                        ),

                        SizedBox(
                            width:10),

                        Text(

                          "CONTINUAR",

                          style:
                              TextStyle(

                            color:
                                Colors.green,

                            fontSize:12,

                            fontWeight:
                                FontWeight.bold,

                            fontFamily:
                                'PressStart2P',
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                _espaco(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void jogar(int index){

    if(board[index]!="")
      return;

    setState(() =>
        board[index]="X");

    if(verificar("X")){
      _vitoria();
      return;
    }

    if(!board.contains("")){
      _erro();
      return;
    }

    _jogadaGuardiao();
  }

  void _jogadaGuardiao(){

    final livres=[];

    for(int i=0;i<9;i++){

      if(board[i]==''){
        livres.add(i);
      }
    }

    int escolha=
        livres[
          Random().nextInt(
            livres.length,
          )
        ];

    setState(() {
      board[escolha]="O";
    });

    if(verificar("O")){
      _erro();
    }
  }

  bool verificar(String p){

    final wins=[

      [0,1,2],
      [3,4,5],
      [6,7,8],

      [0,3,6],
      [1,4,7],
      [2,5,8],

      [0,4,8],
      [2,4,6],
    ];

    return wins.any(
      (w)=>

      board[w[0]]==p &&
      board[w[1]]==p &&
      board[w[2]]==p
    );
  }

  void _erro(){

    showDialog(

      context:context,

      barrierDismissible:false,

      builder:(_)=>AlertDialog(

        backgroundColor:
            const Color.fromARGB(
                255,0,19,48),

        title:
            const Text(
              "VOCÊ FALHOU",
            ),

        content:
            const Text(

          "O guardião observa em silêncio.\n\n"
          "O tabuleiro reinicia.",

          textAlign:
              TextAlign.center,
        ),

        actions:[

          TextButton(

            onPressed:(){

              Navigator.pop(
                  context);

              setState(() {

                board=
                    List.filled(
                        9,'');
              });
            },

            child:
                const Text(
                    "TENTAR"),
          )
        ],
      ),
    );
  }

  void _vitoria() async{

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:(_)=>
            _dialogo(
              _falasGuardiao,
            ),
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:(_)=>
            _dialogo(
              _falasPersonagem,
            ),
      ),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:(_)=>
            _telaComputadorConcluido(),
      ),
    );
  }

  Future<void>
  _salvarProgressoERetornar()
  async{

    await _progress
        .marcarSalaConcluida(
      raJogador,
      'Manacas',
    );

    if(!mounted)return;

    Navigator
        .pushNamedAndRemoveUntil(

      context,

      ExplorationScreen
          .routeName,

      (route)=>false,
    );
  }

  @override
  Widget build(
      BuildContext context){

    return Scaffold(

      appBar: AppBar(

        title:
            const Text(
          "Jogo do Guardião - Manacas",
        ),

        backgroundColor:
            const Color.fromARGB(
                255,0,19,48),

        foregroundColor:
            Colors.white,

        actions:[

          Padding(

            padding:
                const EdgeInsets.only(
                    right:16),

            child:
                const Center(

              child:
                  GameTimerWidget(),
            ),
          )
        ],
      ),

      body: Background(

        imagem:
            "assets/manacas.png",

        child: Center(

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children:[

              const Icon(
                Icons.games,
                color:
                    Colors.amber,
                size:50,
              ),

              _espaco(20),

              SizedBox(

                width:300,

                child:
                    GridView.builder(

                  shrinkWrap:true,

                  itemCount:9,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:3,
                  ),

                  itemBuilder:
                      (_,i)=>
                          GestureDetector(

                    onTap:
                        ()=>jogar(i),

                    child:
                        Container(

                      margin:
                          const EdgeInsets.all(
                              5),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.black
                                .withOpacity(
                                    .6),

                        border:
                            Border.all(

                          color:
                              Colors.amber
                                  .withOpacity(
                                      .5),
                        ),

                        borderRadius:
                            BorderRadius.circular(
                                8),
                      ),

                      child:
                          Center(

                        child:
                            Text(

                          board[i],

                          style:
                              TextStyle(

                            color:
                            board[i]=="X"
                                ?Colors.cyan
                                :Colors.redAccent,

                            fontSize:30,

                            fontFamily:
                            'PressStart2P',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              _espaco(20),

              Text(

                'Faça uma linha para vencer!',

                style:
                    TextStyle(

                  color:
                      Colors.white
                          .withOpacity(
                              .5),

                  fontSize:10,

                  fontFamily:
                      'PressStart2P',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}