class Alimento {
  final String id;
  final String nome;
  final String categoria;
  final double calorias;
  final double proteinas;
  final double carboidratos;
  final double gorduras;
  double quantidade; // Em gramas
  String unidade;

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

  double get totalCalorias => (calorias * quantidade) / 100;
  double get totalProteinas => (proteinas * quantidade) / 100;
  double get totalCarboidratos => (carboidratos * quantidade) / 100;
  double get totalGorduras => (gorduras * quantidade) / 100;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'categoria': categoria,
      'calorias': calorias,
      'proteinas': proteinas,
      'carboidratos': carboidratos,
      'gorduras': gorduras,
      'quantidade': quantidade,
      'unidade': unidade,
    };
  }

  // CORREÇÃO AQUI: Usamos (valor as num?)?.toDouble() para aceitar tanto int quanto double
  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      id: map['id']?.toString() ?? '',
      nome: map['nome']?.toString() ?? '',
      categoria: map['categoria']?.toString() ?? 'Geral',
      
      // O 'num' é o pai de 'int' e 'double', então aceita ambos e converte
      calorias: (map['calorias'] as num?)?.toDouble() ?? 0.0,
      proteinas: (map['proteinas'] as num?)?.toDouble() ?? 0.0,
      carboidratos: (map['carboidratos'] as num?)?.toDouble() ?? 0.0,
      gorduras: (map['gorduras'] as num?)?.toDouble() ?? 0.0,
      
      quantidade: (map['quantidade'] as num?)?.toDouble() ?? 100.0,
      unidade: map['unidade']?.toString() ?? 'g',
    );
  }
}