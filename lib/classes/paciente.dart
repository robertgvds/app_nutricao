import 'dart:convert';
import 'usuario.dart';
import 'refeicao.dart';
import 'antropometria.dart';

class Paciente extends Usuario {
  String? nutricionistaCrn;
  List<Refeicao> refeicoes;
  Antropometria? antropometria;

  Paciente({
    super.id, // Agora é String 
    required super.nome,
    required super.email,
    required super.senha,
    required super.codigo,
    required super.dataNascimento,
    this.nutricionistaCrn,
    this.refeicoes = const [],
    this.antropometria,
  });

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
      dataNascimento: usuario.dataNascimento,
      antropometria: null,
    );
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    List<Refeicao> listaDecodificada = [];

    if (map['refeicoes'] != null) {
      try {
        var rawRefeicoes = map['refeicoes'];
        final decoded = (rawRefeicoes is String) ? jsonDecode(rawRefeicoes) : rawRefeicoes;

        if (decoded is List) {
          listaDecodificada = decoded.map((item) {
            if (item is Map) return Refeicao.fromMap(Map<String, dynamic>.from(item));
            return null;
          }).whereType<Refeicao>().toList();
        }
      } catch (e) {
        print("Erro ao ler refeições: $e");
      }
    }

    Antropometria? dadosAntropometria;
    if (map['antropometria'] != null) {
      try {
        var rawDados = map['antropometria'];
        final decoded = (rawDados is String) ? jsonDecode(rawDados) : rawDados;
        if (decoded is Map) {
          dadosAntropometria = Antropometria.fromMap(Map<String, dynamic>.from(decoded));
        }
      } catch (e) {
        print("Erro ao ler dados corporais: $e");
      }
    }

    return Paciente(
      id: map['id']?.toString(), // Garante conversão para String
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
      nutricionistaCrn: map['nutricionistaCrn'] ?? '',
      refeicoes: listaDecodificada,
      dataNascimento: map['dataNascimento'] ?? '',
      antropometria: dadosAntropometria,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['nutricionistaCrn'] = nutricionistaCrn;
    map['refeicoes'] = refeicoes.map((e) => e.toMap()).toList(); 
    map['antropometria'] = antropometria?.toMap();
    return map;
  }

  int get idade {
    if (dataNascimento.isEmpty) return 0;
    try {
      DateTime nascimento;

      if (dataNascimento.contains('/')) {
        List<String> partes = dataNascimento.split('/');

        nascimento = DateTime(
          int.parse(partes[2]),
          int.parse(partes[1]),
          int.parse(partes[0]),
        );
      } else {
        nascimento = DateTime.parse(dataNascimento);
      }

      DateTime hoje = DateTime.now();
      int idade = hoje.year - nascimento.year;

      if (hoje.month < nascimento.month ||
          (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
        idade--;
      }
      return idade;
    } catch (e) {
      // Se a data estiver mal formatada no banco, ele cai aqui
      print("Erro ao calcular idade: $e");
      return 0;
    }
  }
}