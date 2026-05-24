enum TipoEntidade { personagem, guardiao }

class FalaConfig {
  final TipoEntidade entidade;
  final String texto;

  const FalaConfig({required this.entidade, required this.texto});

  // Helpers para criar falas rapidamente
  static FalaConfig guardiao(String texto) =>
      FalaConfig(entidade: TipoEntidade.guardiao, texto: texto);

  static FalaConfig personagem(String texto) =>
      FalaConfig(entidade: TipoEntidade.personagem, texto: texto);
}
