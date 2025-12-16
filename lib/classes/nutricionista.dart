import 'dart:convert';
import 'usuario.dart';

// --- CLASSE NUTRICIONISTA (FILHO) ---
class Nutricionista extends Usuario {
  String crn;
  List<int> pacientesIds;

  // 1. CONSTRUTOR CORRIGIDO
  Nutricionista({
    super.id, // Permite passar o ID do Usuario
    required super.nome, // Preenche automaticamente o atributo da classe pai
    required super.email,
    required super.senha,
    required super.codigo,
    required this.crn,
    List<int>? pacientesIds,
  }) : pacientesIds = pacientesIds ?? [];
  // Nota: Não usamos "super(...)" aqui no final porque já usamos "super.campo" acima.

  // 2. Factory fromUsuario ajustada
  factory Nutricionista.fromUsuario(Usuario usuario, {required String crn}) {
    return Nutricionista(
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      senha: usuario.senha,
      codigo: usuario.codigo,
      crn: crn,
      pacientesIds: [],
    );
  }

  // Métodos de manipulação de lista mantidos iguais
  void adicionarPaciente(int pacienteId) {
    if (!pacientesIds.contains(pacienteId)) {
      pacientesIds.add(pacienteId);
    }
  }

  void removerPaciente(int pacienteId) {
    pacientesIds.remove(pacienteId);
  }

  bool possuiPaciente(int pacienteId) {
    return pacientesIds.contains(pacienteId);
  }

  // 3. FromMap ajustado
  factory Nutricionista.fromMap(Map<String, dynamic> map) {
    List<int> listaIds = [];
    var rawIds = map['pacientesIds'];

    // Lógica de segurança para decodificar a lista
    if (rawIds != null) {
      if (rawIds is String && rawIds.isNotEmpty) {
        listaIds = List<int>.from(jsonDecode(rawIds));
      } else if (rawIds is List) {
        listaIds = List<int>.from(rawIds);
      }
    }

    return Nutricionista(
      id: map['id'], // Passa para o pai
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '', // Passa para o pai
      crn: map['crn'] ?? '',
      pacientesIds: listaIds,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // Pega o mapa da classe Pai (id, nome, email...)
    final map = super.toMap();
    // Adiciona os campos específicos do Nutricionista
    map['crn'] = crn;
    map['pacientesIds'] = jsonEncode(pacientesIds); // Salva como string JSON
    return map;
  }
}
