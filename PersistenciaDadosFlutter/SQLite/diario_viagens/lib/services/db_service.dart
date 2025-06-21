import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/viagem.dart';
import '../models/entrada_diaria.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'travel_planner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE viagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        destino TEXT NOT NULL,
        data_inicio TEXT NOT NULL,
        data_fim TEXT NOT NULL,
        descricao TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE entradas_diarias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        viagem_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        texto TEXT NOT NULL,
        foto_path TEXT NOT NULL,
        FOREIGN KEY (viagem_id) REFERENCES viagens(id)
      );
    ''');
  }

  Future<int> inserirViagem(Viagem viagem) async {
    final db = await database;
    return await db.insert('viagens', viagem.toMap());
  }

  Future<List<Viagem>> listarViagens() async {
    final db = await database;
    final maps = await db.query('viagens');
    return maps.map((e) => Viagem.fromMap(e)).toList();
  }

  Future<int> inserirEntrada(EntradaDiaria entrada) async {
    final db = await database;
    return await db.insert('entradas_diarias', entrada.toMap());
  }

  Future<List<EntradaDiaria>> listarEntradas(int viagemId) async {
    final db = await database;
    final maps = await db.query(
      'entradas_diarias',
      where: 'viagem_id = ?',
      whereArgs: [viagemId],
    );
    return maps.map((e) => EntradaDiaria.fromMap(e)).toList();
  }
}
