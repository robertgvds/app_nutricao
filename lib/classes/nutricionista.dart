import 'usuario.dart';
import 'dart:math';

const String _caracteresCRN = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

/// Gera um código CRN alfanumérico aleatório.
String gerarCRN({int length = 10}) {
  final random = Random();
  final buffer = StringBuffer();
  // Garante que o comprimento seja positivo
  if (length <= 0) {
    return '';
  }
  for (int i = 0; i < length; i++) {
    // Seleciona um caractere aleatório da nossa constante
    buffer.write(_caracteresCRN[random.nextInt(_caracteresCRN.length)]);
  }
  return buffer.toString();
}

class Nutricionista extends Usuario {
  String crn;

  Nutricionista({
    int? id,
    required String nome,
    required String email,
    required String senha,
    String? crn,
    required String codigo,
  }) : crn = crn ?? gerarCRN(length: 10),
       super(id: id, nome: nome, email: email, senha: senha, codigo: codigo);

  factory Nutricionista.fromMap(Map<String, dynamic> map) {
    return Nutricionista(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      crn: map['crn'],
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
