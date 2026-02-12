/// Model representing a completed exam result stored in SQLite.
class ExamResult {
  final int? id;
  final int correctAnswers;
  final int totalQuestions;
  final bool passed;
  final int timeSpentSeconds;
  final DateTime date;

  ExamResult({
    this.id,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.passed,
    required this.timeSpentSeconds,
    required this.date,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  /// Convert to Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'passed': passed ? 1 : 0,
      'time_spent_seconds': timeSpentSeconds,
      'date': date.toIso8601String(),
    };
  }

  /// Create from SQLite Map
  factory ExamResult.fromMap(Map<String, dynamic> map) {
    return ExamResult(
      id: map['id'] as int?,
      correctAnswers: map['correct_answers'] as int,
      totalQuestions: map['total_questions'] as int,
      passed: (map['passed'] as int) == 1,
      timeSpentSeconds: map['time_spent_seconds'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
