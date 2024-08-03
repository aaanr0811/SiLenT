import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'images.db');
    return await openDatabase(
      path,
      version: 2, // Tingkatkan versi database
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE images (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          path TEXT,
          label TEXT,
          timestamp INTEGER
        );
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE images ADD COLUMN prediction TEXT');
        }
      },
    );
  }

  Future<void> insertImagePath(String path, String label) async {
    final db = await database;
    await db.insert(
      'images',
      {
        'path': path,
        'label': label,
        'timestamp': DateTime.now().millisecondsSinceEpoch, // Add timestamp
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getImages() async {
    final db = await database;
    return await db.query('images',
        orderBy: 'timestamp DESC'); // pastikan mengambil kolom prediksi
  }

  Future<int> deleteImage(String path) async {
    final db = await database;
    return await db.delete(
      'images',
      where: 'path = ?',
      whereArgs: [path],
    );
  }
}
