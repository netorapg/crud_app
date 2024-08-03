import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'crud_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    ''');
  }

  Future<int> insertItem(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('items', row);
  }

  Future<List<Map<String, dynamic>>> queryAllItems() async {
    Database db = await database;
    return await db.query('items');
  }

  Future<int> updateItem(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('items', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
