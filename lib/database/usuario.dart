class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  String codigo;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.codigo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'codigo': codigo,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      codigo: map['codigo'],
    );
  }
}
