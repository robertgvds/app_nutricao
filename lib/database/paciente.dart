import 'usuario.dart';

class Paciente extends Usuario {
  String codigo;

  Paciente({
    int? id,
    required String nome,
    required String email,
    required String senha,
    required this.codigo,
  }) : super(id: id, nome: nome, email: email, senha: senha);

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      codigo: map['codigo'],
    );
  }
}
