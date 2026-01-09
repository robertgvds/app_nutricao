import 'alimento.dart';

class Refeicao {
  String id;
  String nome; // Ex: Café da Manhã
  String horario; // Ex: 08:00
  List<Alimento> alimentos;

  Refeicao({
    required this.id,
    required this.nome,
    required this.horario,
    required this.alimentos,
  });

  // --- Totais da Refeição (Calculados Dinamicamente) ---
  
  double get totalCalorias => alimentos.fold(0, (sum, item) => sum + item.totalCalorias);
  
  double get totalProteinas => alimentos.fold(0, (sum, item) => sum + item.totalProteinas);
  
  double get totalCarboidratos => alimentos.fold(0, (sum, item) => sum + item.totalCarboidratos);
  
  double get totalGorduras => alimentos.fold(0, (sum, item) => sum + item.totalGorduras);

  // --- Serialização para o Firebase ---

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'horario': horario,
      'alimentos': alimentos.map((x) => x.toMap()).toList(),
    };
  }

  factory Refeicao.fromMap(Map<Object?, Object?> map) {
    final dados = Map<String, dynamic>.from(map);
    return Refeicao(
      id: dados['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nome: dados['nome'] ?? '',
      horario: dados['horario'] ?? '',
      alimentos: dados['alimentos'] != null
          ? (dados['alimentos'] as List)
              .map((x) => Alimento.fromMap(Map<String, dynamic>.from(x as Map)))
              .toList()
          : [],
    );
  }
}