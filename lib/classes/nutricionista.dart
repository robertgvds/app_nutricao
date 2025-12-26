import 'dart:convert';
import 'usuario.dart';

// Classe que representa um nutricionista
// Herda os dados básicos da classe Usuario
// e adiciona informações específicas da atuação profissional
class Nutricionista extends Usuario {
  // Número de registro profissional do nutricionista (CRN)
  String crn;

  // Lista com os IDs dos pacientes acompanhados pelo nutricionista
  // Utiliza apenas os identificadores para evitar duplicação de dados
  List<int> pacientesIds;

  // Construtor da classe
  // Utiliza inicialização direta dos campos da classe pai (Usuario)
  // por meio do uso de "super.campo"
  Nutricionista({
    super.id, // ID herdado do Usuario (pode ser nulo)
    required super.dataNascimento, // Data de nascimento do nutricionista
    required super.nome, // Nome do nutricionista
    required super.email, // Email utilizado para login/contato
    required super.senha, // Senha de autenticação
    required super.codigo, // Código interno do sistema
    required this.crn, // Registro profissional (CRN)
    List<int>? pacientesIds, // Lista opcional de pacientes
  }) : pacientesIds = pacientesIds ?? [];
  // Caso a lista não seja informada, inicia vazia

  // Construtor factory que cria um Nutricionista a partir de um Usuario
  // Usado quando um usuário é promovido ou cadastrado como nutricionista
  factory Nutricionista.fromUsuario(Usuario usuario, {required String crn}) {
    return Nutricionista(
      id: usuario.id,
      nome: usuario.nome,
      dataNascimento: usuario.dataNascimento,
      email: usuario.email,
      senha: usuario.senha,
      codigo: usuario.codigo,
      crn: crn,
      pacientesIds: [],
    );
  }

  // Adiciona o ID de um paciente à lista, evitando duplicações
  void adicionarPaciente(int pacienteId) {
    if (!pacientesIds.contains(pacienteId)) {
      pacientesIds.add(pacienteId);
    }
  }

  // Remove o ID de um paciente da lista
  void removerPaciente(int pacienteId) {
    pacientesIds.remove(pacienteId);
  }

  // Verifica se um paciente pertence à lista do nutricionista
  bool possuiPaciente(int pacienteId) {
    return pacientesIds.contains(pacienteId);
  }

  // Construtor factory que cria um Nutricionista a partir de um Map
  // Utilizado ao recuperar os dados do banco ou de um JSON
  factory Nutricionista.fromMap(Map<String, dynamic> map) {
    // Lista auxiliar para armazenar os IDs dos pacientes
    List<int> listaIds = [];
    var rawIds = map['pacientesIds'];

    // Lógica defensiva para decodificar a lista de pacientes
    // Aceita tanto String JSON quanto List<int>
    if (rawIds != null) {
      if (rawIds is String && rawIds.isNotEmpty) {
        listaIds = List<int>.from(jsonDecode(rawIds));
      } else if (rawIds is List) {
        listaIds = List<int>.from(rawIds);
      }
    }

    // Retorna o objeto Nutricionista completamente montado
    return Nutricionista(
      id: map['id'], // ID herdado do Usuario
      nome: map['nome'] ?? '',
      dataNascimento: map['dataNascimento'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '', // Código herdado do Usuario
      crn: map['crn'] ?? '',
      pacientesIds: listaIds,
    );
  }

  // Sobrescreve o método toMap da classe Usuario
  // Acrescenta os campos específicos do Nutricionista
  @override
  Map<String, dynamic> toMap() {
    // Obtém o mapa base da classe pai (Usuario)
    final map = super.toMap();

    // Adiciona o CRN do nutricionista
    map['crn'] = crn;

    // Converte a lista de IDs dos pacientes para JSON antes de salvar
    map['pacientesIds'] = jsonEncode(pacientesIds);

    return map;
  }
}
