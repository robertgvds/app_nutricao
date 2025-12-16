import "alimento.dart";

class Refeicao {
  String nome; // Ex: "Café da Manhã", "Almoço", "Jantar"
  List<Alimento> alimentos;

  Refeicao({required this.nome, this.alimentos = const []});

  double get pesoTotal {
    return alimentos.fold(0, (soma, item) => soma + item.peso);
  }

  double get caloriasTotal {
    return alimentos.fold(0, (soma, item) => soma + item.calorias);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'alimentos': alimentos.map((x) => x.toMap()).toList(),
    };
  }

  factory Refeicao.fromMap(Map<String, dynamic> map) {
    return Refeicao(
      nome: map['nome'] ?? '',
      alimentos:
          map['alimentos'] != null
              ? List<Alimento>.from(
                (map['alimentos'] as List).map((x) => Alimento.fromMap(x)),
              )
              : [],
    );
  }

  // Método especial para o jsonEncode funcionar direto na lista
  Map<String, dynamic> toJson() => toMap();
}
