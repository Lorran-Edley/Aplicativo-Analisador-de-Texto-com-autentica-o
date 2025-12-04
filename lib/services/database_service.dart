import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'analisador_texto.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_completo TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        data_nascimento TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha_hash TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertUsuario(Usuario usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> getUsuarioByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<Usuario?> login(String email, String senhaHash) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ? AND senha_hash = ?',
      whereArgs: [email, senhaHash],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
