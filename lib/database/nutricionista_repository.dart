import 'db.dart';
import '../classes/nutricionista.dart';
import '../classes/usuario.dart'; // Necessário para a evolução de Usuario → Nutricionista

// Repository responsável pelo acesso aos dados da entidade Nutricionista
// Centraliza toda a lógica de persistência no banco de dados
class NutricionistaRepository {
  // ------------------------------------------------------------------
  // VERIFICAÇÃO DE EMAIL RETORNANDO USUARIO
  // ------------------------------------------------------------------
  // Verifica se o email já está cadastrado em qualquer tabela.
  // Retorna o objeto Usuario completo se encontrado, ou null caso contrário.
  Future<Usuario?> verificarEmailExiste(String email) async {
    final db = await DB.get();

    // Verifica na tabela de nutricionistas
    final List<Map<String, dynamic>> resNutri = await db.query(
      'nutricionistas',
      // columns: null, // Removemos o filtro de colunas para trazer o objeto todo
      where: 'email = ?',
      whereArgs: [email],
    );

    if (resNutri.isNotEmpty) {
      // Mapeia o resultado encontrado para um objeto Usuario
      return Nutricionista.fromMap(resNutri.first);
    }

    // Retorna null se o email não for encontrado na tabela
    return null;
  }

  // ------------------------------------------------------------------
  // MÉTODO DE EVOLUÇÃO
  // ------------------------------------------------------------------
  // Transforma um Usuario existente em um Nutricionista
  // 1) Busca o usuário na tabela base
  // 2) Converte para Nutricionista
  // 3) Insere na tabela de nutricionistas e remove da tabela de usuários
  // Tudo isso é feito dentro de uma transação para garantir consistência
  Future<void> evoluirDeUsuario(int usuarioId, String crn) async {
    final db = await DB.get();

    // Busca o usuário base na tabela 'usuarios' pelo ID
    final result = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [usuarioId],
    );

    // Caso o usuário não seja encontrado, interrompe o processo
    if (result.isEmpty) {
      throw Exception("Usuário base não encontrado para evolução.");
    }

    // Converte o Map retornado do banco para um objeto Usuario
    final usuarioBase = Usuario.fromMap(result.first);

    // Cria um novo objeto Nutricionista a partir do Usuario existente
    final novoNutri = Nutricionista.fromUsuario(usuarioBase, crn: crn);

    // Executa a operação de forma transacional
    // Garante que a inserção e a exclusão ocorram juntas
    await db.transaction((txn) async {
      // Insere o nutricionista na tabela 'nutricionistas'
      await txn.insert('nutricionistas', novoNutri.toMap());

      // Remove o usuário da tabela 'usuarios'
      await txn.delete('usuarios', where: 'id = ?', whereArgs: [usuarioId]);
    });
  }

  // ------------------------------------------------------------------
  // MÉTODOS CRUD
  // ------------------------------------------------------------------

  // Insere um novo nutricionista no banco
  // Retorna o ID gerado pelo SQLite
  Future<int> inserir(Nutricionista nutricionista) async {
    final db = await DB.get();
    return await db.insert('nutricionistas', nutricionista.toMap());
  }

  // Atualiza os dados de um nutricionista existente
  // Usa o ID como critério de atualização
  Future<int> atualizar(Nutricionista nutricionista) async {
    final db = await DB.get();
    return await db.update(
      'nutricionistas',
      nutricionista.toMap(),
      where: 'id = ?',
      whereArgs: [nutricionista.id],
    );
  }

  // Retorna a lista de todos os nutricionistas cadastrados
  Future<List<Nutricionista>> listar() async {
    final db = await DB.get();

    // Consulta todos os registros da tabela
    final result = await db.query('nutricionistas');

    // Converte cada Map em um objeto Nutricionista
    return result.map((e) => Nutricionista.fromMap(e)).toList();
  }

  // Busca um nutricionista pelo ID
  // Retorna null caso não seja encontrado
  Future<Nutricionista?> buscarPorId(int id) async {
    final db = await DB.get();

    final result = await db.query(
      'nutricionistas',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? Nutricionista.fromMap(result.first) : null;
  }

  // Busca um nutricionista pelo CRN
  // Útil para validações e autenticação profissional
  Future<Nutricionista?> buscarPorCRN(String crn) async {
    final db = await DB.get();

    final result = await db.query(
      'nutricionistas',
      where: 'crn = ?',
      whereArgs: [crn],
    );

    return result.isNotEmpty ? Nutricionista.fromMap(result.first) : null;
  }

  // Remove um nutricionista do banco pelo ID
  Future<int> excluir(int id) async {
    final db = await DB.get();
    return await db.delete('nutricionistas', where: 'id = ?', whereArgs: [id]);
  }

  // Remove todos os registros da tabela de nutricionistas
  // Útil para testes ou reset de dados
  Future<void> limparTabela() async {
    final db = await DB.get();
    await db.delete('nutricionistas');
  }
}
