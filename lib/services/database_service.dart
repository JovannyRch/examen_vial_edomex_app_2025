import 'package:sqflite/sqflite.dart';
import 'package:my_quiz_app/models/exam_result.dart';

/// Singleton service for managing the SQLite database.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/examen_vial.db';

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE exam_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            correct_answers INTEGER NOT NULL,
            total_questions INTEGER NOT NULL,
            passed INTEGER NOT NULL,
            time_spent_seconds INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE favorite_questions (
            question_id INTEGER PRIMARY KEY,
            source TEXT NOT NULL DEFAULT 'manual',
            date_added TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS favorite_questions (
              question_id INTEGER PRIMARY KEY,
              source TEXT NOT NULL DEFAULT 'manual',
              date_added TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // ─── CRUD Operations ──────────────────────────────────────────────────────

  /// Insert a new exam result
  Future<int> insertExamResult(ExamResult result) async {
    final db = await database;
    return await db.insert('exam_results', result.toMap());
  }

  /// Get all exam results ordered by date (newest first)
  Future<List<ExamResult>> getAllResults() async {
    final db = await database;
    final maps = await db.query('exam_results', orderBy: 'date DESC');
    return maps.map((m) => ExamResult.fromMap(m)).toList();
  }

  /// Get the last N exam results (for chart)
  Future<List<ExamResult>> getLastResults(int count) async {
    final db = await database;
    final maps = await db.query(
      'exam_results',
      orderBy: 'date DESC',
      limit: count,
    );
    // Reverse so oldest is first (for chart left-to-right)
    return maps.map((m) => ExamResult.fromMap(m)).toList().reversed.toList();
  }

  // ─── Aggregated Stats ─────────────────────────────────────────────────────

  /// Total number of exams taken
  Future<int> getTotalExams() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM exam_results',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Total exams passed
  Future<int> getTotalPassed() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM exam_results WHERE passed = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Average score percentage
  Future<double> getAverageScore() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(CAST(correct_answers AS REAL) / total_questions * 100) as avg FROM exam_results',
    );
    if (result.isEmpty || result.first['avg'] == null) return 0;
    return (result.first['avg'] as num).toDouble();
  }

  /// Best score percentage
  Future<double> getBestScore() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MAX(CAST(correct_answers AS REAL) / total_questions * 100) as best FROM exam_results',
    );
    if (result.isEmpty || result.first['best'] == null) return 0;
    return (result.first['best'] as num).toDouble();
  }

  /// Calculate study streak (consecutive days with at least one exam)
  Future<int> getStudyStreak() async {
    final db = await database;
    final maps = await db.rawQuery(
      "SELECT DISTINCT date(date) as day FROM exam_results ORDER BY day DESC",
    );

    if (maps.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();
    // Normalize to start of day
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (final row in maps) {
      final dayStr = row['day'] as String;
      final day = DateTime.parse(dayStr);

      if (day == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (day == checkDate.subtract(const Duration(days: 1)) &&
          streak == 0) {
        // Allow streak to start from yesterday if no exam today yet
        checkDate = day;
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get all stats as a single map
  Future<Map<String, dynamic>> getAllStats() async {
    final totalExams = await getTotalExams();
    final totalPassed = await getTotalPassed();
    final avgScore = await getAverageScore();
    final bestScore = await getBestScore();
    final streak = await getStudyStreak();
    final lastResults = await getLastResults(20);

    return {
      'totalExams': totalExams,
      'totalPassed': totalPassed,
      'avgScore': avgScore,
      'bestScore': bestScore,
      'streak': streak,
      'lastResults': lastResults,
      'passRate': totalExams > 0 ? (totalPassed / totalExams * 100) : 0.0,
    };
  }

  /// Delete all results (for reset)
  Future<void> clearAllResults() async {
    final db = await database;
    await db.delete('exam_results');
  }

  // ─── Favorite Questions ─────────────────────────────────────────────────────

  /// Add a question to favorites
  /// [source] can be 'manual' (user bookmarked) or 'failed' (auto-saved from exam)
  Future<void> addFavorite(int questionId, {String source = 'manual'}) async {
    final db = await database;
    await db.insert('favorite_questions', {
      'question_id': questionId,
      'source': source,
      'date_added': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Remove a question from favorites
  Future<void> removeFavorite(int questionId) async {
    final db = await database;
    await db.delete(
      'favorite_questions',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  /// Toggle a question's favorite status. Returns true if now favorited.
  Future<bool> toggleFavorite(
    int questionId, {
    String source = 'manual',
  }) async {
    final isFav = await isFavorite(questionId);
    if (isFav) {
      await removeFavorite(questionId);
      return false;
    } else {
      await addFavorite(questionId, source: source);
      return true;
    }
  }

  /// Check if a question is favorited
  Future<bool> isFavorite(int questionId) async {
    final db = await database;
    final result = await db.query(
      'favorite_questions',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
    return result.isNotEmpty;
  }

  /// Get all favorite question IDs
  Future<List<int>> getFavoriteIds() async {
    final db = await database;
    final maps = await db.query(
      'favorite_questions',
      orderBy: 'date_added DESC',
    );
    return maps.map((m) => m['question_id'] as int).toList();
  }

  /// Get total number of favorites
  Future<int> getFavoriteCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM favorite_questions',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Auto-save failed questions from an exam
  Future<void> saveFailedQuestions(List<int> failedQuestionIds) async {
    for (final id in failedQuestionIds) {
      await addFavorite(id, source: 'failed');
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    final db = await database;
    await db.delete('favorite_questions');
  }
}
