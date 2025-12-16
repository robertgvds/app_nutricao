import 'db.dart';
import '../classes/usuario.dart';
import '../classes/nutricionista.dart';
import '../classes/paciente.dart';

class UsuarioRepository {
  /// Realiza o login buscando em todas as tabelas de usuários.
  /// Retorna o objeto específico (Paciente, Nutricionista ou Usuario base).
  Future<Usuario?> login(String email, String senha) async {
    final db = await DB.get();

    // 1. Tenta buscar na tabela de Nutricionistas
    final List<Map<String, dynamic>> resNutri = await db.query(
      'nutricionistas',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (resNutri.isNotEmpty) {
      return Nutricionista.fromMap(resNutri.first);
    }

    // 2. Tenta buscar na tabela de Pacientes
    final List<Map<String, dynamic>> resPaciente = await db.query(
      'pacientes',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (resPaciente.isNotEmpty) {
      return Paciente.fromMap(resPaciente.first);
    }

    // 3. Tenta buscar na tabela base de Usuarios (ainda não evoluídos)
    final List<Map<String, dynamic>> resUsuario = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (resUsuario.isNotEmpty) {
      return Usuario.fromMap(resUsuario.first);
    }

    return null; // Login falhou em todas as tabelas
  }

  // --- MÉTODOS CRUD PADRÃO ---

  Future<int> inserir(Usuario usuario) async {
    final db = await DB.get();
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<List<Usuario>> listar() async {
    final db = await DB.get();
    final result = await db.query('usuarios');
    return result.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<int> atualizar(Usuario usuario) async {
    final db = await DB.get();
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await DB.get();
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('usuarios');
  }
}
