import 'db.dart';
import 'nutricionista.dart';

class NutricionistaRepository {
  // Inserir novo nutricionista
  Future<int> inserir(Nutricionista nutricionista) async {
    final db = await DB.get();
    return await db.insert('nutricionistas', nutricionista.toMap());
  }

  // Listar todos os nutricionistas
  Future<List<Nutricionista>> listar() async {
    final db = await DB.get();
    final result = await db.query('nutricionistas');
    return result.map((e) => Nutricionista.fromMap(e)).toList();
  }

  // Buscar por ID
  Future<Nutricionista?> buscarPorId(int id) async {
    final db = await DB.get();
    final result = await db.query(
      'nutricionistas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Nutricionista.fromMap(result.first);
    }
    return null;
  }

  // Atualizar um nutricionista
  Future<int> atualizar(Nutricionista nutricionista) async {
    final db = await DB.get();
    return await db.update(
      'nutricionistas',
      nutricionista.toMap(),
      where: 'id = ?',
      whereArgs: [nutricionista.id],
    );
  }

  // Excluir por ID
  Future<int> excluir(int id) async {
    final db = await DB.get();
    return await db.delete('nutricionistas', where: 'id = ?', whereArgs: [id]);
  }

  // Limpar tabela
  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('nutricionistas');
  }
}
