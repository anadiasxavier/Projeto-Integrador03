// Esse arquivo define a estrutura de dados do jogador.
// Quais informações o jogo guarda sobre o personagem do jogador.
//O class define quais atributos cada jogador terá. Podemos criar vários jogadores a partir dela
class Player { 

  String nome;
  int nivel;
  int experiencia;

  // O construtor é o que permite criar um jogador novo. O required significa que todos os três campos são obrigatórios — não dá pra criar um Player sem informar nome, nível e experiência.

  Player({
    required this.nome,
    required this.nivel,
    required this.experiencia,
  });

}