// Classe que representa um alimento
class Alimento {
  // Nome do alimento (ex: Arroz, Maçã, Frango)
  String nome;

  // Peso do alimento (em gramas, por exemplo)
  double peso;

  // Quantidade de calorias do alimento
  double calorias;

  // Construtor da classe
  // O uso de 'required' obriga que todos os campos sejam informados ao criar um objeto Alimento
  Alimento({required this.nome, required this.peso, required this.calorias});

  // Converte o objeto Alimento em um Map Útil para salvar em banco de dados
  Map<String, dynamic> toMap() {
    return {'nome': nome, 'peso': peso, 'calorias': calorias};
  }

  // Construtor factory que cria um objeto Alimento a partir de um Map (ex: dados vindos do banco ou JSON)
  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      // Se o valor não existir no Map, usa um valor padrão
      nome: map['nome'] ?? '',
      peso: map['peso'] ?? 0,
      calorias: map['calorias'] ?? 0,
    );
  }
}
