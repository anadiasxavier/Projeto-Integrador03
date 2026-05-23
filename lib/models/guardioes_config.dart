class GuardioesConfig {
  // Imagens dos guardiões de cada ambiente
  static const String guardiaoBiblioteca = 'assets/guardia_biblioteca.png';
  // ... outros guardiões
  
  // Configurações específicas de cada guardião (opcional)
  static const Map<String, GuardiaoEstilo> estilos = {
    'biblioteca': GuardiaoEstilo(
      imagem: guardiaoBiblioteca,
      opacidade: 0.7,
      alturaPercentual: 0.8,
    ) // ... outros guardiões
  };
}

class GuardiaoEstilo {
  final String imagem;
  final double opacidade;
  final double alturaPercentual;

  const GuardiaoEstilo({
    required this.imagem,
    this.opacidade = 0.7,
    this.alturaPercentual = 0.8,
  });
}