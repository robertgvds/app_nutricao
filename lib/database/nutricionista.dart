import 'usuario.dart';

class Nutricionista extends Usuario {
  String crn;

  Nutricionista({
    int? id,
    required String nome,
    required String email,
    required String senha,
    required this.crn,
    required String codigo,
  }) : super(id: id, nome: nome, email: email, senha: senha, codigo: codigo);

  factory Nutricionista.fromMap(Map<String, dynamic> map) {
    return Nutricionista(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      crn: map['crn'] ?? '',
      codigo: map['codigo'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['crn'] = crn;
    return map;
  }
}
