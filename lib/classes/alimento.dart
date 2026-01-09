// Classe que representa um alimento
class Alimento {
  final String id;
  final String nome;
  final String categoria; // Ex: 'TACO', 'Personalizado'
  final double calorias;
  final double proteinas;
  final double carboidratos;
  final double gorduras;
  double quantidade; // Em gramas ou unidade
  String unidade; // 'g', 'ml', 'unidade'

  Alimento({
    required this.id,
    required this.nome,
    this.categoria = 'Geral',
    required this.calorias,
    required this.proteinas,
    required this.carboidratos,
    required this.gorduras,
    this.quantidade = 100,
    this.unidade = 'g',
  });

  // Getters para calcular totais baseados na quantidade
  double get totalCalorias => (calorias * quantidade) / 100;
  double get totalProteinas => (proteinas * quantidade) / 100;
  double get totalCarboidratos => (carboidratos * quantidade) / 100;
  double get totalGorduras => (gorduras * quantidade) / 100;

  // Converte o objeto Alimento em um Map Útil para salvar em banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'calorias': calorias,
      'proteinas': proteinas,
      'carboidratos': carboidratos,
      'categoria': categoria,
      'gorduras': gorduras,
      'quantidade': quantidade,
      'unidade': unidade,
    };
  }

  // Construtor factory que cria um objeto Alimento a partir de um Map (ex: dados vindos do banco ou JSON)
  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      calorias: map['calorias'] ?? 0,
      proteinas: map['proteinas'] ?? 0,
      carboidratos: map['carboidratos'] ?? 0,
      categoria: map['categoria'] ?? 'Geral',
      gorduras: map['gorduras'] ?? 0,
      quantidade: map['quantidade'] ?? 0,
      unidade: map['unidade'] ?? 'g',
    );
  }
}
