class Usuario {
  String? id; // MUDADO DE int PARA String (Firebase UID)
  String nome;
  String email;
  String senha;
  String codigo;
  String dataNascimento;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.codigo,
    required this.dataNascimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'codigo': codigo,
      'dataNascimento': dataNascimento,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id']?.toString(), // Garante conversão para String
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
      dataNascimento: map['dataNascimento'] ?? '',
    );
  }
}