class Alimento {
  String nome;
  double peso;
  double calorias;

  Alimento({required this.nome, required this.peso, required this.calorias});

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'peso': peso, 'calorias': calorias};
  }

  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      nome: map['nome'] ?? '',
      peso: (map['peso'] ?? 0),
      calorias: (map['calorias'] ?? 0),
    );
  }
}
