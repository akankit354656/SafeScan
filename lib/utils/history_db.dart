import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/qr_history_item.dart';

class HistoryDB {
  static final HistoryDB instance = HistoryDB._init();
  static Database? _db;

  HistoryDB._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('qr_history.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        type TEXT NOT NULL,
        emoji TEXT NOT NULL,
        scannedAt TEXT NOT NULL,
        isFavourite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insert(QRHistoryItem item) async {
    final db = await database;
    await db.insert('history', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<QRHistoryItem>> fetchAll() async {
    final db = await database;
    final maps = await db.query('history', orderBy: 'scannedAt DESC');
    return maps.map((m) => QRHistoryItem.fromMap(m)).toList();
  }

  Future<List<QRHistoryItem>> fetchFavourites() async {
    final db = await database;
    final maps = await db.query('history',
        where: 'isFavourite = ?', whereArgs: [1], orderBy: 'scannedAt DESC');
    return maps.map((m) => QRHistoryItem.fromMap(m)).toList();
  }

  Future<void> toggleFavourite(String id, bool isFavourite) async {
    final db = await database;
    await db.update('history', {'isFavourite': isFavourite ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete('history');
  }
}