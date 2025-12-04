import 'dart:convert';
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
    // Decodifica o JSON das refeições
    List<String> refeicoesLista = [];

    if (map['refeicoes'] != null && map['refeicoes'].toString().isNotEmpty) {
      try {
        // Se for String (JSON), decodifica
        if (map['refeicoes'] is String) {
          refeicoesLista = List<String>.from(jsonDecode(map['refeicoes']));
        }
        // Se já for List, converte direto
        else if (map['refeicoes'] is List) {
          refeicoesLista = List<String>.from(map['refeicoes']);
        }
      } catch (e) {
        print('Erro ao decodificar refeições: $e');
      }
    }

    return Paciente(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
      refeicoes: refeicoesLista,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    // Converte a lista para JSON antes de salvar
    map['refeicoes'] = jsonEncode(refeicoes);
    return map;
  }
}
