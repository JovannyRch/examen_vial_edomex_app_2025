import 'package:sqflite/sqflite.dart';
import 'package:examen_vial_edomex_app_2025/models/category_performance.dart';
import 'package:examen_vial_edomex_app_2025/models/exam_result.dart';

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
      version: 4,
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
        await db.execute('''
          CREATE TABLE category_performance (
            category_id INTEGER PRIMARY KEY,
            total_answered INTEGER NOT NULL DEFAULT 0,
            correct_answered INTEGER NOT NULL DEFAULT 0,
            incorrect_answered INTEGER NOT NULL DEFAULT 0,
            last_practiced TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE review_schedule (
            question_id INTEGER PRIMARY KEY,
            mistakes INTEGER NOT NULL DEFAULT 0,
            successful_reviews INTEGER NOT NULL DEFAULT 0,
            due_at TEXT NOT NULL,
            last_reviewed TEXT
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
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS category_performance (
              category_id INTEGER PRIMARY KEY,
              total_answered INTEGER NOT NULL DEFAULT 0,
              correct_answered INTEGER NOT NULL DEFAULT 0,
              incorrect_answered INTEGER NOT NULL DEFAULT 0,
              last_practiced TEXT NOT NULL
            )
          ''');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS review_schedule (
              question_id INTEGER PRIMARY KEY,
              mistakes INTEGER NOT NULL DEFAULT 0,
              successful_reviews INTEGER NOT NULL DEFAULT 0,
              due_at TEXT NOT NULL,
              last_reviewed TEXT
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
    final weakAreas = await getWeakAreas();

    return {
      'totalExams': totalExams,
      'totalPassed': totalPassed,
      'avgScore': avgScore,
      'bestScore': bestScore,
      'streak': streak,
      'lastResults': lastResults,
      'weakAreas': weakAreas,
      'passRate': totalExams > 0 ? (totalPassed / totalExams * 100) : 0.0,
    };
  }

  /// Delete all results (for reset)
  Future<void> clearAllResults() async {
    final db = await database;
    await db.delete('exam_results');
    await db.delete('category_performance');
    await db.delete('review_schedule');
  }

  // ─── Category Performance ─────────────────────────────────────────────────

  /// Add per-category answer results from a completed exam.
  Future<void> recordCategoryPerformance(
    Map<int, ({int correct, int incorrect})> categoryResults,
  ) async {
    if (categoryResults.isEmpty) return;

    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      for (final entry in categoryResults.entries) {
        final categoryId = entry.key;
        final correct = entry.value.correct;
        final incorrect = entry.value.incorrect;
        final total = correct + incorrect;
        final existing = await txn.query(
          'category_performance',
          where: 'category_id = ?',
          whereArgs: [categoryId],
          limit: 1,
        );

        if (existing.isEmpty) {
          await txn.insert('category_performance', {
            'category_id': categoryId,
            'total_answered': total,
            'correct_answered': correct,
            'incorrect_answered': incorrect,
            'last_practiced': now,
          });
        } else {
          await txn.rawUpdate(
            '''
            UPDATE category_performance
            SET total_answered = total_answered + ?,
                correct_answered = correct_answered + ?,
                incorrect_answered = incorrect_answered + ?,
                last_practiced = ?
            WHERE category_id = ?
            ''',
            [total, correct, incorrect, now, categoryId],
          );
        }
      }
    });
  }

  /// Categories with the lowest accuracy, prioritizing areas with mistakes.
  Future<List<CategoryPerformance>> getWeakAreas({int limit = 3}) async {
    final db = await database;
    final maps = await db.query(
      'category_performance',
      where: 'total_answered > 0 AND incorrect_answered > 0',
      orderBy:
          'CAST(correct_answered AS REAL) / total_answered ASC, incorrect_answered DESC, total_answered DESC',
      limit: limit,
    );
    return maps.map((m) => CategoryPerformance.fromMap(m)).toList();
  }

  // ─── Spaced Repetition ─────────────────────────────────────────────────────

  Future<void> recordReviewOutcomes(Map<int, bool> questionOutcomes) async {
    if (questionOutcomes.isEmpty) return;

    final db = await database;
    final now = DateTime.now();
    final nowIso = now.toIso8601String();

    await db.transaction((txn) async {
      for (final entry in questionOutcomes.entries) {
        final questionId = entry.key;
        final wasCorrect = entry.value;
        final existing = await txn.query(
          'review_schedule',
          where: 'question_id = ?',
          whereArgs: [questionId],
          limit: 1,
        );

        if (!wasCorrect) {
          if (existing.isEmpty) {
            await txn.insert('review_schedule', {
              'question_id': questionId,
              'mistakes': 1,
              'successful_reviews': 0,
              'due_at': nowIso,
              'last_reviewed': nowIso,
            });
          } else {
            await txn.rawUpdate(
              '''
              UPDATE review_schedule
              SET mistakes = mistakes + 1,
                  successful_reviews = 0,
                  due_at = ?,
                  last_reviewed = ?
              WHERE question_id = ?
              ''',
              [nowIso, nowIso, questionId],
            );
          }
        } else if (existing.isNotEmpty) {
          final successfulReviews =
              (existing.first['successful_reviews'] as int) + 1;
          await txn.update(
            'review_schedule',
            {
              'successful_reviews': successfulReviews,
              'due_at':
                  _nextReviewDate(now, successfulReviews).toIso8601String(),
              'last_reviewed': nowIso,
            },
            where: 'question_id = ?',
            whereArgs: [questionId],
          );
        }
      }
    });
  }

  Future<void> markReviewQuestionsStudied(List<int> questionIds) async {
    if (questionIds.isEmpty) return;

    final outcomes = {for (final id in questionIds) id: true};
    await recordReviewOutcomes(outcomes);
  }

  Future<List<int>> getDueReviewQuestionIds({int limit = 20}) async {
    final db = await database;
    final nowIso = DateTime.now().toIso8601String();
    final maps = await db.query(
      'review_schedule',
      columns: ['question_id'],
      where: 'due_at <= ?',
      whereArgs: [nowIso],
      orderBy: 'mistakes DESC, due_at ASC',
      limit: limit,
    );
    return maps.map((m) => m['question_id'] as int).toList();
  }

  Future<int> getDueReviewCount() async {
    final db = await database;
    final nowIso = DateTime.now().toIso8601String();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM review_schedule WHERE due_at <= ?',
      [nowIso],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  DateTime _nextReviewDate(DateTime from, int successfulReviews) {
    final intervals = [1, 3, 7, 14, 30];
    final index = (successfulReviews - 1).clamp(0, intervals.length - 1);
    return from.add(Duration(days: intervals[index]));
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
