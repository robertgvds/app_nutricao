import "alimento.dart";

// Classe que representa uma refeição do dia
// Exemplo: Café da Manhã, Almoço, Lanche, Jantar
class Refeicao {
  final String id;
  final String nome; // "Café da Manhã", "Almoço"
  final String horario; // "08:00"
  final List<Alimento> alimentos;

  Refeicao({
    required this.id,
    required this.nome,
    required this.horario,
    required this.alimentos,
  });

  double get totalCalorias => alimentos.fold(0, (sum, item) => sum + item.totalCalorias);

  // Getter que calcula o total de calorias da refeição
  // Soma as calorias de todos os alimentos da lista
  double get caloriasTotal {
    return alimentos.fold(0, (soma, item) => soma + item.calorias);
  }

  // Converte o objeto Refeicao em um Map<String, dynamic>
  // Usado para salvar os dados em banco de dados ou serializar em JSON
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      // Converte cada objeto Alimento da lista em Map
      'alimentos': alimentos.map((x) => x.toMap()).toList(),
    };
  }

  // Construtor factory que cria um objeto Refeicao a partir de um Map
  // Normalmente utilizado ao recuperar dados do banco ou de um JSON
  factory Refeicao.fromMap(Map<String, dynamic> map) {
    return Refeicao(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      horario: map['horario'] ?? '',
      alimentos: List<Alimento>.from(
        (map['alimentos'] as List<dynamic>? ?? []).map((x) => Alimento.fromMap(Map<String, dynamic>.from(x))),
      ),
    );
  }

  // Método auxiliar para permitir que o jsonEncode
  // funcione diretamente com objetos do tipo Refeicao
  Map<String, dynamic> toJson() => toMap();
}
