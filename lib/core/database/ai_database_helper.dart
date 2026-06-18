import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

class AiDatabaseHelper {
  static final AiDatabaseHelper instance = AiDatabaseHelper._init();
  static Database? _database;

  AiDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ai_chat_sessions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Initialize FFI for Windows/Desktop if needed
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } catch (_) {}
    
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE sessions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  messages TEXT NOT NULL,
  updatedAt INTEGER NOT NULL
)
''');
  }

  Future<void> saveSession(Map<String, dynamic> session) async {
    final db = await instance.database;
    await db.insert(
      'sessions',
      {
        'id': session['id'],
        'title': session['title'],
        'messages': jsonEncode(session['messages']),
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await instance.database;
    final result = await db.query('sessions', orderBy: 'updatedAt DESC');
    
    return result.map((json) => {
      'id': json['id'],
      'title': json['title'],
      'messages': jsonDecode(json['messages'] as String),
    }).toList();
  }

  Future<int> deleteSession(String id) async {
    final db = await instance.database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
