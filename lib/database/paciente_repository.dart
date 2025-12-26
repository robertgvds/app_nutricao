import 'db.dart';
import '../classes/paciente.dart';
import '../classes/usuario.dart'; // Necessário para a evolução de Usuario → Paciente

// Repository responsável pelo acesso aos dados da entidade Paciente
// Centraliza toda a lógica de persistência no banco de dados
class PacienteRepository {
  // ------------------------------------------------------------------
  // NOVO MÉTODO: VERIFICAÇÃO DE EMAIL
  // ------------------------------------------------------------------
  // Verifica se o email já está cadastrado em qualquer tabela (Nutri, Paciente ou Usuario)
  // Retorna true se encontrar, false se não encontrar.
  Future<bool> verificarEmailExiste(String email) async {
    final db = await DB.get();

    // 1. Verifica na tabela de nutricionistas
    final List<Map<String, dynamic>> resNutri = await db.query(
      'nutricionistas',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (resNutri.isNotEmpty) return true;

    // 2. Verifica na tabela de pacientes
    final List<Map<String, dynamic>> resPaciente = await db.query(
      'pacientes',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (resPaciente.isNotEmpty) return true;

    // 3. Verifica na tabela base de usuarios
    final List<Map<String, dynamic>> resUsuario = await db.query(
      'usuarios',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (resUsuario.isNotEmpty) return true;

    return false;
  }

  // ------------------------------------------------------------------
  // MÉTODO DE EVOLUÇÃO
  // ------------------------------------------------------------------
  // Converte um Usuario existente em um Paciente
  // 1) Busca o usuário na tabela base
  // 2) Constrói o objeto Paciente
  // 3) Insere na tabela de pacientes e remove da tabela de usuários
  // Todo o processo ocorre dentro de uma transação
  Future<void> evoluirDeUsuario(int usuarioId, String nutricionistaCrn) async {
    final db = await DB.get();

    // Busca o usuário base pelo ID
    final result = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [usuarioId],
    );

    // Caso o usuário não seja encontrado, interrompe o processo
    if (result.isEmpty) {
      throw Exception("Usuário base não encontrado para evolução.");
    }

    // Converte o registro do banco para um objeto Usuario
    final usuarioBase = Usuario.fromMap(result.first);

    // Cria o objeto Paciente a partir do Usuario existente
    final novoPaciente = Paciente.fromUsuario(
      usuarioBase,
      nutricionistaCrn: nutricionistaCrn,
    );

    // Executa a operação dentro de uma transação
    // Garante consistência entre inserção e exclusão
    await db.transaction((txn) async {
      // Insere o novo paciente na tabela 'pacientes'
      await txn.insert('pacientes', novoPaciente.toMap());

      // Remove o usuário da tabela 'usuarios'
      await txn.delete('usuarios', where: 'id = ?', whereArgs: [usuarioId]);
    });
  }

  // ------------------------------------------------------------------
  // MÉTODOS CRUD
  // ------------------------------------------------------------------

  // Insere um novo paciente no banco de dados
  // Retorna o ID gerado pelo SQLite
  Future<int> inserir(Paciente paciente) async {
    final db = await DB.get();
    return await db.insert('pacientes', paciente.toMap());
  }

  // Retorna a lista de todos os pacientes cadastrados
  Future<List<Paciente>> listar() async {
    final db = await DB.get();

    // Consulta todos os registros da tabela
    final result = await db.query('pacientes');

    // Converte cada Map em um objeto Paciente
    return result.map((e) => Paciente.fromMap(e)).toList();
  }

  // Busca um paciente pelo ID
  // Retorna null caso o paciente não seja encontrado
  Future<Paciente?> buscarPorId(int id) async {
    final db = await DB.get();

    final result = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? Paciente.fromMap(result.first) : null;
  }

  // Atualiza os dados de um paciente existente
  // Usa o ID como critério de atualização
  Future<int> atualizar(Paciente paciente) async {
    final db = await DB.get();
    return await db.update(
      'pacientes',
      paciente.toMap(),
      where: 'id = ?',
      whereArgs: [paciente.id],
    );
  }

  // Remove um paciente do banco de dados pelo ID
  Future<int> excluir(int id) async {
    final db = await DB.get();
    return await db.delete('pacientes', where: 'id = ?', whereArgs: [id]);
  }

  // Remove todos os registros da tabela de pacientes
  // Útil para testes ou limpeza completa dos dados
  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('pacientes');
  }
}
