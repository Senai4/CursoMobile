// Uma classe para criar as conexões com o banco de dados
// instalar as dependências do banco de dados - pubspec

import 'package:exemplo_sqlite/models/nota_models.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class NotaDbHelper {
  static Database? _database; //pode ser nula - inicialmente

  static const String DB_NAME = "nota.db";
  static const String TABLE_NAME = "nota";
  static const String CREATE_SQL = """
   CREATE TABLE IF NOT EXISTS $TABLE_NAME(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   titulo TEXT NOT NULL,
   conteudo TEXT NOT NULL)""";

  //Criar a Conexão com o DB
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DB_NAME);
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(CREATE_SQL);
      },
      version: 1,
    );
  }

  //criar o CRUD - para BD
  //create
  Future<int> insertNota(Nota nota) async {
    final db = await database;
    //executo o comando para inserir
    return await db.insert(TABLE_NAME, nota.toMap());
  }

  //read
  Future<List<Nota>> getNotas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return maps.map((e) => Nota.fromMap(e)).toList();
  }

  //update
  Future<int> updateNota(Nota nota) async {
    if (nota.id == null) {
      //Não é possivel atualizar a nota
      throw Exception("Impossivel Atualizar Nota sem ID");
    } else {
      final db = await database;
      return await db.update(
        TABLE_NAME,
        nota.toMap(),
        where: "id = ?",
        whereArgs: [nota.id],
      );
    }
  }

  //delete
  Future<int> deleteNota(int id) async {
    final db = await database;
    return await db.delete(TABLE_NAME, where: "id=?", whereArgs: [id]);
  }
}