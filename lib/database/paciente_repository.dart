import 'db.dart';
import '../classes/paciente.dart';
import '../classes/usuario.dart'; // Importação necessária

class PacienteRepository {
  // --- MÉTODO DE EVOLUÇÃO ---
  Future<void> evoluirDeUsuario(int usuarioId, String nutricionistaCrn) async {
    final db = await DB.get();

    // 1. Busca o usuário na tabela base
    final result = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [usuarioId],
    );

    if (result.isEmpty) {
      throw Exception("Usuário base não encontrado para evolução.");
    }

    // 2. Converte para Paciente
    final usuarioBase = Usuario.fromMap(result.first);
    final novoPaciente = Paciente.fromUsuario(
      usuarioBase,
      nutricionistaCrn: nutricionistaCrn,
    );

    // 3. Transação segura
    await db.transaction((txn) async {
      await txn.insert('pacientes', novoPaciente.toMap());
      await txn.delete('usuarios', where: 'id = ?', whereArgs: [usuarioId]);
    });
  }

  // --- MÉTODOS EXISTENTES ---
  Future<int> inserir(Paciente paciente) async {
    final db = await DB.get();
    return await db.insert('pacientes', paciente.toMap());
  }

  Future<List<Paciente>> listar() async {
    final db = await DB.get();
    final result = await db.query('pacientes');
    return result.map((e) => Paciente.fromMap(e)).toList();
  }

  Future<Paciente?> buscarPorId(int id) async {
    final db = await DB.get();
    final result = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Paciente.fromMap(result.first) : null;
  }

  Future<int> atualizar(Paciente paciente) async {
    final db = await DB.get();
    return await db.update(
      'pacientes',
      paciente.toMap(),
      where: 'id = ?',
      whereArgs: [paciente.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await DB.get();
    return await db.delete('pacientes', where: 'id = ?', whereArgs: [id]);
  }

  // Limpar tabela
  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('pacientes');
  }
}
