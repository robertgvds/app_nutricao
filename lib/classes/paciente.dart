import 'dart:convert';
import 'usuario.dart';
import 'refeicao.dart';
import 'antropometria.dart';

// Classe que representa um paciente
// Estende a classe Usuario, herdando seus dados básicos
// e adicionando informações específicas do acompanhamento nutricional
class Paciente extends Usuario {
  // CRN do nutricionista responsável pelo paciente
  // Utilizado para vínculo e controle profissional
  String? nutricionistaCrn;

  // Lista de refeições associadas ao paciente
  // Cada refeição contém seus respectivos alimentos
  List<Refeicao> refeicoes;

  // Dados antropométricos do paciente
  // Pode ser nulo caso ainda não tenha sido realizada avaliação física
  Antropometria? antropometria;

  // Construtor principal da classe
  // Reutiliza os atributos herdados de Usuario através do 'super'
  Paciente({
    super.id,
    required super.nome,
    required super.email,
    required super.senha,
    required super.codigo,
    required super.dataNascimento,
    this.nutricionistaCrn,
    this.refeicoes = const [],
    this.antropometria,
  });

  // Construtor factory que cria um Paciente a partir de um Usuario
  // Usado quando um usuário passa a ser acompanhado como paciente
  // Inicializa refeições vazias e dados antropométricos nulos
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

  // Construtor factory que cria um objeto Paciente a partir de um Map
  // Normalmente utilizado ao recuperar dados do banco de dados
  factory Paciente.fromMap(Map<String, dynamic> map) {
    // Lista auxiliar para armazenar as refeições decodificadas
    List<Refeicao> listaDecodificada = [];

    // Verifica se o campo 'refeicoes' existe e não está vazio
    if (map['refeicoes'] != null && map['refeicoes'].toString().isNotEmpty) {
      try {
        var rawRefeicoes = map['refeicoes'];

        // Caso as refeições estejam em formato String (JSON),
        // realiza a decodificação
        final decoded =
            (rawRefeicoes is String) ? jsonDecode(rawRefeicoes) : rawRefeicoes;

        // Garante que o resultado seja uma lista
        if (decoded is List) {
          listaDecodificada =
              decoded
                  .map((item) {
                    // Caso o item seja um Map, cria uma Refeicao completa
                    if (item is Map<String, dynamic>) {
                      return Refeicao.fromMap(item);
                    }

                    // Caso o item seja apenas uma String,
                    // cria uma refeição simples sem alimentos
                    if (item is String) {
                      return Refeicao(nome: item, alimentos: []);
                    }

                    // Ignora formatos inválidos
                    return null;
                  })
                  // Remove valores nulos da lista final
                  .whereType<Refeicao>()
                  .toList();
        }
      } catch (e) {
        // Evita que erros de decodificação quebrem a aplicação
        print("Erro ao ler refeições: $e");
      }
    }

    // Variável auxiliar para armazenar os dados antropométricos decodificados
    Antropometria? dadosDecodificados;

    // Verifica se existem dados antropométricos salvos
    if (map['antropometria'] != null) {
      try {
        var rawDados = map['antropometria'];

        // Decodifica caso os dados estejam em formato JSON (String)
        final decoded = (rawDados is String) ? jsonDecode(rawDados) : rawDados;

        // Garante que o resultado seja um Map válido
        if (decoded is Map<String, dynamic>) {
          dadosDecodificados = Antropometria.fromMap(decoded);
        }
      } catch (e) {
        // Tratamento de erro para problemas de leitura dos dados corporais
        print("Erro ao ler dados corporais: $e");
      }
    }

    // Retorna o objeto Paciente completamente montado
    return Paciente(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      codigo: map['codigo'] ?? '',
      nutricionistaCrn: map['nutricionistaCrn'] ?? '',
      refeicoes: listaDecodificada,
      dataNascimento: map['dataNascimento'] ?? '',
      antropometria: dadosDecodificados,
    );
  }

  // Sobrescreve o método toMap da classe Usuario
  // Adiciona os campos específicos do paciente
  @override
  Map<String, dynamic> toMap() {
    // Obtém o Map base da classe Usuario
    final map = super.toMap();

    // Adiciona o CRN do nutricionista
    map['nutricionistaCrn'] = nutricionistaCrn;

    // Converte a lista de refeições para JSON antes de salvar
    map['refeicoes'] = jsonEncode(refeicoes.map((e) => e.toMap()).toList());

    // Converte os dados antropométricos para JSON, caso existam
    if (antropometria != null) {
      map['antropometria'] = jsonEncode(antropometria!.toMap());
    } else {
      map['antropometria'] = null;
    }

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
