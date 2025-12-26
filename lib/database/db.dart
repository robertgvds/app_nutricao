import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Classe responsável pelo gerenciamento do banco de dados SQLite
// Implementa um padrão simples de Singleton para garantir
// apenas uma instância do banco durante a execução do app
class DB {
  // Instância única do banco de dados
  // É estática para ser compartilhada em toda a aplicação
  static Database? _db;

  // Método público para obter a instância do banco
  // Se o banco já estiver aberto, retorna a instância existente
  // Caso contrário, inicializa o banco
  static Future<Database> get() async {
    if (_db != null) return _db!;
    return await _init();
  }

  // Método privado responsável por inicializar o banco de dados
  static Future<Database> _init() async {
    // Obtém o caminho padrão onde os bancos SQLite são armazenados
    final dbPath = await getDatabasesPath();

    // Define o caminho completo do arquivo do banco
    final path = join(dbPath, 'meu_banco.db');

    // Abre o banco de dados (ou cria, caso não exista)
    return await openDatabase(
      path,
      version: 1,

      // Callback executado apenas na primeira criação do banco
      onCreate: (db, version) async {
        // ---------------- TABELA USUÁRIOS ----------------
        // Armazena os dados básicos de autenticação e identificação
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT,
            codigo TEXT,
            dataNascimento TEXT
          );
        ''');

        // ---------------- TABELA PACIENTES ----------------
        // Contém os dados do paciente e informações específicas
        // como refeições e dados antropométricos (salvos como JSON)
        await db.execute('''
          CREATE TABLE pacientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT,
            codigo TEXT,
            refeicoes TEXT,
            antropometria TEXT,
            dataNascimento TEXT,
            nutricionistaCrn TEXT
          );
        ''');

        // ---------------- TABELA NUTRICIONISTAS ----------------
        // Armazena os dados do nutricionista e seus pacientes vinculados
        // A lista de pacientes é armazenada como JSON
        await db.execute('''
          CREATE TABLE nutricionistas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT,
            crn TEXT,
            codigo TEXT,
            dataNascimento TEXT,
            pacientesIds TEXT
          );
        ''');
      },
    );
  }
}
