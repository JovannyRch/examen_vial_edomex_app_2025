import 'package:shared_preferences/shared_preferences.dart';
import 'package:examen_vial_edomex_app_2025/models/achievement.dart';
import 'package:examen_vial_edomex_app_2025/services/notification_service.dart';

class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  static const String _prefix = 'achievement_';
  static const String _failedCountKey = 'failed_streak_count';
  static const String _practicedCategoriesKey = 'practiced_categories';

  final Map<AchievementType, Achievement> _cache = {};
  List<Achievement> _recentlyUnlocked = [];

  List<Achievement> get recentlyUnlocked => _recentlyUnlocked;
  void clearRecentlyUnlocked() => _recentlyUnlocked = [];

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    for (final def in ACHIEVEMENT_DEFINITIONS) {
      final isUnlocked = prefs.getBool('$_prefix${def.id}_unlocked') ?? false;
      final unlockedAtStr = prefs.getString('$_prefix${def.id}_date');
      _cache[def.type] = Achievement(
        definition: def,
        isUnlocked: isUnlocked,
        unlockedAt:
            unlockedAtStr != null ? DateTime.parse(unlockedAtStr) : null,
      );
    }
  }

  Future<List<Achievement>> getAllAchievements() async {
    return ACHIEVEMENT_DEFINITIONS.map((def) {
      return _cache[def.type] ??
          Achievement(definition: def, isUnlocked: false);
    }).toList();
  }

  Future<List<Achievement>> getUnlockedAchievements() async {
    final all = await getAllAchievements();
    return all.where((a) => a.isUnlocked).toList();
  }

  Future<void> _unlock(AchievementType type) async {
    if (_cache[type]?.isUnlocked == true) return;

    final def = getAchievementDef(type)!;
    final achievement = Achievement(
      definition: def,
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
    _cache[type] = achievement;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix${def.id}_unlocked', true);
    await prefs.setString(
      '$_prefix${def.id}_date',
      achievement.unlockedAt!.toIso8601String(),
    );

    _recentlyUnlocked.add(achievement);
  }

  Future<void> checkExamCompleted({
    required int correctAnswers,
    required int totalQuestions,
    required bool passed,
    required int timeSpentSeconds,
    required int streak,
    required int totalExams,
    required int favoriteCount,
    required int failedCount,
    required List<int> practicedCategories,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final percentage = totalQuestions > 0
        ? (correctAnswers / totalQuestions) * 100
        : 0.0;

    if (totalExams >= 1) await _unlock(AchievementType.firstExam);
    if (totalExams >= 5) await _unlock(AchievementType.fiveExams);
    if (totalExams >= 10) await _unlock(AchievementType.tenExams);

    if (percentage >= 100) await _unlock(AchievementType.perfectScore);

    if (streak >= 3) await _unlock(AchievementType.streakThree);
    if (streak >= 7) await _unlock(AchievementType.streakSeven);
    if (streak >= 30) await _unlock(AchievementType.streakThirty);

    if (timeSpentSeconds < 180 && totalQuestions >= 10) {
      await _unlock(AchievementType.speedDemon);
    }

    if (practicedCategories.length >= 4) {
      await _unlock(AchievementType.allCategories);
    }

    if (favoriteCount >= 20) await _unlock(AchievementType.bookworm);

    if (totalQuestions >= 50) await _unlock(AchievementType.marathon);

    if (failedCount >= 3 && passed) {
      final prevFailed = prefs.getInt(_failedCountKey) ?? 0;
      if (prevFailed >= 3) {
        await _unlock(AchievementType.comeback);
      }
    }

    if (failedCount > 0) {
      await prefs.setInt(_failedCountKey, failedCount);
    } else {
      await prefs.setInt(_failedCountKey, 0);
    }

    for (final catId in practicedCategories) {
      final existing = prefs.getStringList(_practicedCategoriesKey) ?? [];
      if (!existing.contains(catId.toString())) {
        existing.add(catId.toString());
        await prefs.setStringList(_practicedCategoriesKey, existing);
      }
    }
  }

  Future<void> onExamResultSaved({
    required int correctAnswers,
    required int totalQuestions,
    required bool passed,
    required int timeSpentSeconds,
    required int streak,
    required int totalExams,
    required int favoriteCount,
    required List<int> categoryIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final failedCount = totalQuestions - correctAnswers;

    final practicedCats = prefs
        .getStringList(_practicedCategoriesKey)
        ?.map((e) => int.parse(e))
        .toList() ?? [];
    practicedCats.addAll(categoryIds);

    await checkExamCompleted(
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      passed: passed,
      timeSpentSeconds: timeSpentSeconds,
      streak: streak,
      totalExams: totalExams,
      favoriteCount: favoriteCount,
      failedCount: failedCount,
      practicedCategories: practicedCats,
    );

    if (_recentlyUnlocked.isNotEmpty) {
      await NotificationService().showAchievementNotification(
        _recentlyUnlocked.last.definition.title,
        _recentlyUnlocked.last.definition.emoji,
      );
    }
  }

  Future<int> getUnlockedCount() async {
    final all = await getAllAchievements();
    return all.where((a) => a.isUnlocked).length;
  }

  Future<Map<AchievementTier, int>> getUnlockedCountByTier() async {
    final all = await getAllAchievements();
    final unlocked = all.where((a) => a.isUnlocked);
    return {
      AchievementTier.bronze: unlocked.where((a) => a.definition.tier == AchievementTier.bronze).length,
      AchievementTier.silver: unlocked.where((a) => a.definition.tier == AchievementTier.silver).length,
      AchievementTier.gold: unlocked.where((a) => a.definition.tier == AchievementTier.gold).length,
      AchievementTier.platinum: unlocked.where((a) => a.definition.tier == AchievementTier.platinum).length,
    };
  }
}