import "alimento.dart";

// Classe que representa uma refeição do dia
// Exemplo: Café da Manhã, Almoço, Lanche, Jantar
class Refeicao {
  // Nome da refeição
  // Ex: "Café da Manhã", "Almoço", "Jantar"
  String nome;

  // Lista de alimentos que compõem a refeição
  // Cada alimento possui informações como peso e calorias
  List<Alimento> alimentos;

  // Construtor da classe
  // O nome da refeição é obrigatório
  // A lista de alimentos é opcional e, por padrão, inicia vazia
  Refeicao({required this.nome, this.alimentos = const []});

  // Getter que calcula o peso total da refeição
  // Soma o peso de todos os alimentos presentes na lista
  double get pesoTotal {
    return alimentos.fold(0, (soma, item) => soma + item.peso);
  }

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
      // Caso o nome não exista no Map, usa string vazia como padrão
      nome: map['nome'] ?? '',
      // Converte a lista de Maps em uma lista de objetos Alimento
      alimentos:
          map['alimentos'] != null
              ? List<Alimento>.from(
                (map['alimentos'] as List).map((x) => Alimento.fromMap(x)),
              )
              : [],
    );
  }

  // Método auxiliar para permitir que o jsonEncode
  // funcione diretamente com objetos do tipo Refeicao
  Map<String, dynamic> toJson() => toMap();
}
