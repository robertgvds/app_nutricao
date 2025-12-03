import 'db.dart';
import 'usuario.dart';

class UsuarioRepository {
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

  // Limpar tabela
  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('usuarios');
  }
}
