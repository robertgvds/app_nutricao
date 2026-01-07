import '../classes/antropometria.dart';

class AntropometriaRepository {
  
  // Banco de dados em memória:
  // Chave = ID do Paciente
  // Valor = Lista de avaliações dele
  static final Map<int, List<Antropometria>> _bancoDeDados = {};

  Future<void> salvarAvaliacao(int pacienteId, Antropometria dados) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Se o paciente ainda não tem histórico, cria a lista
    if (!_bancoDeDados.containsKey(pacienteId)) {
      _bancoDeDados[pacienteId] = [];
    }

    final listaDoPaciente = _bancoDeDados[pacienteId]!;

    // --- LÓGICA DE EDIÇÃO VS CRIAÇÃO ---
    
    if (dados.id_avaliacao != null) {
      // CENÁRIO 1: EDIÇÃO (Já tem ID da avaliação)
      // Procura na lista qual item tem esse mesmo ID
      final index = listaDoPaciente.indexWhere((item) => item.id_avaliacao == dados.id_avaliacao);
      
      if (index != -1) {
        // Encontrou! Substitui o antigo pelo novo (editado)
        listaDoPaciente[index] = dados;
        print("Avaliação ${dados.id_avaliacao} ATUALIZADA com sucesso.");
      } else {
        // (Segurança) Se tiver ID mas não achar, adiciona.
        listaDoPaciente.add(dados);
      }

    } else {
      // CENÁRIO 2: NOVA AVALIAÇÃO (ID é nulo)
      // Gera um ID único baseado no tempo atual (timestamp)
      dados.id_avaliacao = DateTime.now().millisecondsSinceEpoch.toString();
      
      listaDoPaciente.add(dados);
      print("Nova avaliação CRIADA com ID: ${dados.id_avaliacao}");
    }
  }

  Future<List<Antropometria>> buscarHistorico(int pacienteId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Retorna a lista ou uma lista vazia se não tiver nada
    return _bancoDeDados[pacienteId] ?? []; 
  }

  Future<Antropometria?> buscarUltimaAvaliacao(int pacienteId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lista = _bancoDeDados[pacienteId];
    if (lista != null && lista.isNotEmpty) {
      // Ordena para garantir que pega a mais recente por data
      lista.sort((a, b) => (a.data ?? DateTime(2000)).compareTo(b.data ?? DateTime(2000)));
      return lista.last;
    }
    return null;
  }
}