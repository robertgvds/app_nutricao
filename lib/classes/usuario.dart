// Classe que representa um usuário do sistema
// Armazena dados básicos de identificação e autenticação
class Usuario {
  // Identificador único do usuário no banco de dados
  // Pode ser nulo quando o usuário ainda não foi salvo
  int? id;

  // Nome completo do usuário
  String nome;

  // Endereço de e-mail do usuário
  // Geralmente utilizado como login
  String email;

  // Senha do usuário
  // Idealmente deve ser armazenada de forma criptografada
  String senha;

  // Código de identificação adicional do usuário
  // Pode representar matrícula, código interno ou token
  String codigo;

  // Construtor da classe
  // O campo 'id' é opcional, pois normalmente é gerado pelo banco de dados
  // Os demais campos são obrigatórios
  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.codigo,
  });

  // Converte o objeto Usuario em um Map<String, dynamic>
  // Esse formato é utilizado para salvar os dados em banco
  // ou para serialização (ex: JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'codigo': codigo,
    };
  }

  // Construtor factory que cria um objeto Usuario a partir de um Map
  // Normalmente usado ao recuperar dados do banco de dados ou de um JSON
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      // Converte o id para int, caso exista
      // Pode ser nulo se o registro ainda não foi persistido
      id: map['id'] is int ? map['id'] : null,

      // Define valores padrão caso alguma chave não exista no Map
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
    );
  }
}
