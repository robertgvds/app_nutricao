import 'dart:convert';
import 'usuario.dart';
import 'refeicao.dart';
import 'antropometria.dart';

class Paciente extends Usuario {
  String nutricionistaCrn;
  List<Refeicao> refeicoes;
  Antropometria? antropometria;

  Paciente({
    super.id,
    required super.nome,
    required super.email,
    required super.senha,
    required super.codigo,
    required this.nutricionistaCrn,
    this.refeicoes = const [],
    this.antropometria,
  });

  // --- NOVO: Construtor para Evolução ---
  factory Paciente.fromUsuario(
    Usuario usuario, {
    required String nutricionistaCrn,
  }) {
    return Paciente(
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      senha: usuario.senha,
      codigo: usuario.codigo,
      nutricionistaCrn: nutricionistaCrn,
      refeicoes: [],
      antropometria: null,
    );
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    List<Refeicao> listaDecodificada = [];
    if (map['refeicoes'] != null && map['refeicoes'].toString().isNotEmpty) {
      try {
        var rawRefeicoes = map['refeicoes'];
        final decoded =
            (rawRefeicoes is String) ? jsonDecode(rawRefeicoes) : rawRefeicoes;
        if (decoded is List) {
          listaDecodificada =
              decoded
                  .map((item) {
                    if (item is Map<String, dynamic>) {
                      return Refeicao.fromMap(item);
                    }
                    if (item is String) {
                      return Refeicao(nome: item, alimentos: []);
                    }
                    return null;
                  })
                  .whereType<Refeicao>()
                  .toList();
        }
      } catch (e) {
        print("Erro ao ler refeições: $e");
      }
    }

    Antropometria? dadosDecodificados;
    if (map['antropometria'] != null) {
      try {
        var rawDados = map['antropometria'];
        final decoded = (rawDados is String) ? jsonDecode(rawDados) : rawDados;
        if (decoded is Map<String, dynamic>) {
          dadosDecodificados = Antropometria.fromMap(decoded);
        }
      } catch (e) {
        print("Erro ao ler dados corporais: $e");
      }
    }

    return Paciente(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
      nutricionistaCrn: map['nutricionistaCrn'] ?? '',
      refeicoes: listaDecodificada,
      antropometria: dadosDecodificados,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['nutricionistaCrn'] = nutricionistaCrn;
    map['refeicoes'] = jsonEncode(refeicoes.map((e) => e.toMap()).toList());
    if (antropometria != null) {
      map['antropometria'] = jsonEncode(antropometria!.toMap());
    } else {
      map['antropometria'] = null;
    }
    return map;
  }
}
