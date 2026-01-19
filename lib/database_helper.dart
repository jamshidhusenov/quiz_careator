import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE options (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE question_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL UNIQUE,
        is_correct INTEGER NOT NULL,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS question_results (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          question_id INTEGER NOT NULL UNIQUE,
          is_correct INTEGER NOT NULL,
          FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<int> insertQuestion(Question question) async {
    final db = await database;
    int id = await db.insert('questions', question.toMap());
    for (var option in question.options) {
      await db.insert('options', option.toMap(id));
    }
    return id;
  }

  Future<List<Question>> getQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> questionMaps = await db.query('questions');

    List<Question> questions = [];
    for (var qMap in questionMaps) {
      final List<Map<String, dynamic>> optionMaps = await db.query(
        'options',
        where: 'question_id = ?',
        whereArgs: [qMap['id']],
      );
      List<Option> options = optionMaps
          .map((oMap) => Option.fromMap(oMap))
          .toList();
      questions.add(Question.fromMap(qMap, options));
    }
    return questions;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('question_results');
    await db.delete('options');
    await db.delete('questions');
  }

  Future<void> saveQuestionResult(int questionId, bool isCorrect) async {
    final db = await database;
    await db.insert('question_results', {
      'question_id': questionId,
      'is_correct': isCorrect ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<int, bool>> getQuestionResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('question_results');
    return {for (var m in maps) m['question_id'] as int: m['is_correct'] == 1};
  }

  Future<void> clearQuestionResults() async {
    final db = await database;
    await db.delete('question_results');
  }
}
