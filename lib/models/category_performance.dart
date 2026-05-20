import 'package:examen_vial_edomex_app_2025/models/option.dart';

class CategoryPerformance {
  final QuestionCategory category;
  final int totalAnswered;
  final int correctAnswered;
  final int incorrectAnswered;

  const CategoryPerformance({
    required this.category,
    required this.totalAnswered,
    required this.correctAnswered,
    required this.incorrectAnswered,
  });

  double get accuracy =>
      totalAnswered == 0 ? 0 : (correctAnswered / totalAnswered) * 100;

  double get errorRate => 100 - accuracy;

  factory CategoryPerformance.fromMap(Map<String, dynamic> map) {
    final categoryIndex = map['category_id'] as int;
    return CategoryPerformance(
      category: QuestionCategory.values[categoryIndex],
      totalAnswered: map['total_answered'] as int,
      correctAnswered: map['correct_answered'] as int,
      incorrectAnswered: map['incorrect_answered'] as int,
    );
  }
}
