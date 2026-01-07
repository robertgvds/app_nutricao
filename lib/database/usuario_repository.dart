import 'db.dart';
import '../classes/usuario.dart';
import '../classes/nutricionista.dart';
import '../classes/paciente.dart';

// Repository responsável pelo gerenciamento de dados de Usuario
// Gerencia o login e as operações CRUD para o usuário e suas subclasses (Nutricionista e Paciente)
class UsuarioRepository {
  /// Realiza o login, buscando em todas as tabelas de usuários:
  /// 'nutricionistas', 'pacientes' e 'usuarios'
  /// Retorna o objeto específico de acordo com a tabela encontrada
  Future<Usuario?> login(String email, String senha) async {
    final db = await DB.get();

    // 3. Busca na tabela base de usuarios (caso ainda não tenha evoluído)
    final List<Map<String, dynamic>> resUsuario = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (resUsuario.isNotEmpty) {
      // Retorna o usuário base caso encontrado
      return Usuario.fromMap(resUsuario.first);
    }

    // 1. Busca na tabela de nutricionistas
    final List<Map<String, dynamic>> resNutri = await db.query(
      'nutricionistas',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (resNutri.isNotEmpty) {
      // Retorna o nutricionista caso encontrado
      return Nutricionista.fromMap(resNutri.first);
    }

    // 2. Busca na tabela de pacientes
    final List<Map<String, dynamic>> resPaciente = await db.query(
      'pacientes',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (resPaciente.isNotEmpty) {
      // Retorna o paciente caso encontrado
      return Paciente.fromMap(resPaciente.first);
    }

    // Caso não seja encontrado em nenhuma das tabelas, retorna null
    return null;
  }

  // ------------------------------------------------------------------
  // MÉTODOS CRUD PADRÃO
  // ------------------------------------------------------------------

  // Insere um novo usuário na tabela 'usuarios'
  // Retorna o ID gerado pelo SQLite
  Future<int> inserir(Usuario usuario) async {
    final db = await DB.get();
    return await db.insert('usuarios', usuario.toMap());
  }

  // Verifica se o email já está cadastrado em qualquer uma das tabelas.
  // Retorna true se encontrar, false se não encontrar.
  Future<bool> verificarEmailExiste(String email) async {
    final db = await DB.get();

    // 1. Verifica na tabela de nutricionistas
    final List<Map<String, dynamic>> resNutri = await db.query(
      'nutricionistas',
      columns: [
        'id',
      ], // Otimização: traz apenas o ID, pois não precisamos dos dados
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

    // Se passou por todas as verificações e não encontrou nada:
    return false;
  }

  // Retorna todos os usuários da tabela 'usuarios'
  Future<List<Usuario>> listar() async {
    final db = await DB.get();

    // Consulta todos os registros da tabela
    final result = await db.query('usuarios');

    // Converte cada Map retornado pelo banco para um objeto Usuario
    return result.map((e) => Usuario.fromMap(e)).toList();
  }

  // Atualiza os dados de um usuário existente
  // Usa o ID do usuário como critério para atualização
  Future<int> atualizar(Usuario usuario) async {
    final db = await DB.get();
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  // Remove um usuário da tabela 'usuarios' pelo ID
  Future<int> excluir(int id) async {
    final db = await DB.get();
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  // Limpa a tabela 'usuarios', removendo todos os registros
  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('usuarios');
  }
}
