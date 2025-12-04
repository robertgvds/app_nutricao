import 'db.dart';
import '../classes/paciente.dart';

class PacienteRepository {
  // Inserir novo paciente
  Future<int> inserir(Paciente paciente) async {
    final db = await DB.get();
    return await db.insert('pacientes', paciente.toMap());
  }

  // Listar todos os pacientes
  Future<List<Paciente>> listar() async {
    final db = await DB.get();
    final result = await db.query('pacientes');
    return result.map((e) => Paciente.fromMap(e)).toList();
  }

  // Buscar paciente por ID
  Future<Paciente?> buscarPorId(int id) async {
    final db = await DB.get();
    final result = await db.query(
      'pacientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Paciente.fromMap(result.first);
    }
    return null;
  }

  // Atualizar um paciente
  Future<int> atualizar(Paciente paciente) async {
    final db = await DB.get();
    return await db.update(
      'pacientes',
      paciente.toMap(),
      where: 'id = ?',
      whereArgs: [paciente.id],
    );
  }

  // Excluir paciente
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
