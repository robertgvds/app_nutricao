import 'db.dart';
import '../classes/nutricionista.dart';
import '../classes/usuario.dart'; // Importação necessária

class NutricionistaRepository {
  // --- MÉTODO DE EVOLUÇÃO ---
  Future<void> evoluirDeUsuario(int usuarioId, String crn) async {
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

    // 2. Converte para o objeto Nutricionista usando o factory de evolução
    final usuarioBase = Usuario.fromMap(result.first);
    final novoNutri = Nutricionista.fromUsuario(usuarioBase, crn: crn);

    // 3. Transação: Insere na nova tabela e deleta da antiga
    await db.transaction((txn) async {
      await txn.insert('nutricionistas', novoNutri.toMap());
      await txn.delete('usuarios', where: 'id = ?', whereArgs: [usuarioId]);
    });
  }

  // --- MÉTODOS EXISTENTES ---
  Future<int> inserir(Nutricionista nutricionista) async {
    final db = await DB.get();
    return await db.insert('nutricionistas', nutricionista.toMap());
  }

  Future<int> atualizar(Nutricionista nutricionista) async {
    final db = await DB.get();
    return await db.update(
      'nutricionistas',
      nutricionista.toMap(),
      where: 'id = ?',
      whereArgs: [nutricionista.id],
    );
  }

  Future<List<Nutricionista>> listar() async {
    final db = await DB.get();
    final result = await db.query('nutricionistas');
    return result.map((e) => Nutricionista.fromMap(e)).toList();
  }

  Future<Nutricionista?> buscarPorId(int id) async {
    final db = await DB.get();
    final result = await db.query(
      'nutricionistas',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Nutricionista.fromMap(result.first) : null;
  }

  Future<Nutricionista?> buscarPorCRN(String crn) async {
    final db = await DB.get();
    final result = await db.query(
      'nutricionistas',
      where: 'crn = ?',
      whereArgs: [crn],
    );
    return result.isNotEmpty ? Nutricionista.fromMap(result.first) : null;
  }

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
