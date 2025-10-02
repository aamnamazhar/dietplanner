import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/feedback_model.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diet_planner.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE feedback(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            message TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  /// Insert feedback
  Future<int> insertFeedback(FeedbackModel feedback) async {
    final db = await database;
    return await db.insert(
      'feedback',
      feedback.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all feedback
  Future<List<FeedbackModel>> getAllFeedback() async {
    final db = await database;
    final result = await db.query('feedback', orderBy: 'id DESC');
    return result.map((map) => FeedbackModel.fromMap(map)).toList();
  }
}
