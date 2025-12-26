// Classe que representa um usuário do sistema
// Armazena dados básicos de identificação e autenticação
class Usuario {
  // Identificador único do usuário no banco de dados
  int? id;

  // Nome completo do usuário
  String nome;

  // Endereço de e-mail do usuário
  String email;

  // Senha do usuário
  String senha;

  // Código de identificação adicional
  String codigo;

  // Data de nascimento do usuário
  String dataNascimento;

  // Construtor da classe
  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.codigo,
    required this.dataNascimento,
  });

  // Converte o objeto Usuario em um Map<String, dynamic>
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

  // Construtor factory que cria um objeto Usuario a partir de um Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] is int ? map['id'] : null,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
      dataNascimento: map['dataNascimento'] ?? '',
    );
  }
}
