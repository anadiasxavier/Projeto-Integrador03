// Esse arquivo define a estrutura de dados do jogador.
// Quais informações o jogo guarda sobre o personagem do jogador.
//O class define quais atributos cada jogador terá. Podemos criar vários jogadores a partir dela
class Player {
  String nome;
  String email;
  String ra;
  String genero;
  int nivel;
  int experiencia;

  // O construtor é o que permite criar um jogador novo. O required significa que todos os três campos são obrigatórios —> não dá pra criar um Player sem informar nome, nível e experiência.

  Player({
    required this.nome,
    required this.email,
    required this.ra,
    required this.genero,
    required this.nivel,
    required this.experiencia,
  });

  // Método para converter de Map (do Firestore)
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      ra: map['ra'] ?? '',
      genero: map['genero'] ?? 'masculino',
      nivel: map['nivel'] ?? 1,
      experiencia: map['experiencia'] ?? 0,
    );
  }

  // Método para converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'ra': ra,
      'genero': genero,
      'nivel': nivel,
      'experiencia': experiencia,
    };
  }
}
