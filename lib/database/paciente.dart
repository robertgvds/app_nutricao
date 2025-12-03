import 'usuario.dart';

class Paciente extends Usuario {
  List<String> refeicoes;

  Paciente({
    int? id,
    required String nome,
    required String email,
    required String senha,
    required String codigo,
    this.refeicoes = const [],
  }) : super(id: id, nome: nome, email: email, senha: senha, codigo: codigo);

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      codigo: map['codigo'],
      refeicoes: List<String>.from(map['refeicoes'] ?? []),
    );
  }
}
