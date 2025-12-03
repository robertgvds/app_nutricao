import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;

  static Future<Database> get() async {
    if (_db != null) return _db!;

    return await _init();
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meu_banco.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabela base de usuários
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT,
						codigo TEXT
          );
        ''');

        // Tabela de pacientes
        await db.execute('''
          CREATE TABLE pacientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT,
            codigo TEXT,
						refeicoes TEXT
          );
        ''');

        // Tabela de nutricionistas
        await db.execute('''
          CREATE TABLE nutricionistas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            senha TEXT,
            crn TEXT
            codigo TEXT,
          );
        ''');
      },
    );
  }
}
