/// Predefined achievement definitions
enum AchievementType {
  firstExam,
  fiveExams,
  tenExams,
  perfectScore,
  streakThree,
  streakSeven,
  streakThirty,
  allCategories,
  speedDemon,
  comeback,
  marathon,
  bookworm,
}

class AchievementDefinition {
  final AchievementType type;
  final String id;
  final String title;
  final String description;
  final String emoji;
  final AchievementTier tier;

  const AchievementDefinition({
    required this.type,
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.tier,
  });
}

enum AchievementTier { bronze, silver, gold, platinum }

class Achievement {
  final AchievementDefinition definition;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  const Achievement({
    required this.definition,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  Achievement copyWith({DateTime? unlockedAt, bool? isUnlocked}) {
    return Achievement(
      definition: definition,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': definition.id,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'is_unlocked': isUnlocked,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map, AchievementDefinition def) {
    return Achievement(
      definition: def,
      unlockedAt: map['unlocked_at'] != null
          ? DateTime.parse(map['unlocked_at'] as String)
          : null,
      isUnlocked: map['is_unlocked'] as bool? ?? false,
    );
  }
}

const List<AchievementDefinition> ACHIEVEMENT_DEFINITIONS = [
  AchievementDefinition(
    type: AchievementType.firstExam,
    id: 'first_exam',
    title: 'Primer Paso',
    description: 'Completa tu primer examen',
    emoji: '🎯',
    tier: AchievementTier.bronze,
  ),
  AchievementDefinition(
    type: AchievementType.fiveExams,
    id: 'five_exams',
    title: 'En Fuego',
    description: 'Completa 5 exámenes',
    emoji: '🔥',
    tier: AchievementTier.bronze,
  ),
  AchievementDefinition(
    type: AchievementType.tenExams,
    id: 'ten_exams',
    title: 'Dedicado',
    description: 'Completa 10 exámenes',
    emoji: '💪',
    tier: AchievementTier.silver,
  ),
  AchievementDefinition(
    type: AchievementType.perfectScore,
    id: 'perfect_score',
    title: 'Perfecto',
    description: 'Obtén 100% en un examen',
    emoji: '💯',
    tier: AchievementTier.gold,
  ),
  AchievementDefinition(
    type: AchievementType.streakThree,
    id: 'streak_three',
    title: 'Racha de 3',
    description: '3 días seguidos de estudio',
    emoji: '📅',
    tier: AchievementTier.bronze,
  ),
  AchievementDefinition(
    type: AchievementType.streakSeven,
    id: 'streak_seven',
    title: 'Semana Perfecta',
    description: '7 días seguidos de estudio',
    emoji: '📆',
    tier: AchievementTier.silver,
  ),
  AchievementDefinition(
    type: AchievementType.streakThirty,
    id: 'streak_thirty',
    title: 'Mes de Disciplina',
    description: '30 días seguidos de estudio',
    emoji: '🏆',
    tier: AchievementTier.platinum,
  ),
  AchievementDefinition(
    type: AchievementType.allCategories,
    id: 'all_categories',
    title: 'Completista',
    description: 'Practica en todas las categorías',
    emoji: '📚',
    tier: AchievementTier.gold,
  ),
  AchievementDefinition(
    type: AchievementType.speedDemon,
    id: 'speed_demon',
    title: 'Velocista',
    description: 'Completa un examen en menos de 3 minutos',
    emoji: '⚡',
    tier: AchievementTier.silver,
  ),
  AchievementDefinition(
    type: AchievementType.comeback,
    id: 'comeback',
    title: 'Resurrección',
    description: 'Aprueba después de fallar 3 seguidos',
    emoji: '🌟',
    tier: AchievementTier.silver,
  ),
  AchievementDefinition(
    type: AchievementType.marathon,
    id: 'marathon',
    title: 'Maratoniano',
    description: 'Completa 50 preguntas en una sesión',
    emoji: '🏃',
    tier: AchievementTier.gold,
  ),
  AchievementDefinition(
    type: AchievementType.bookworm,
    id: 'bookworm',
    title: 'Ratoncito Bibliotecario',
    description: 'Guarda 20 preguntas como favoritas',
    emoji: '📖',
    tier: AchievementTier.silver,
  ),
];

AchievementDefinition? getAchievementDef(AchievementType type) {
  return ACHIEVEMENT_DEFINITIONS.firstWhere((d) => d.type == type);
}

AchievementDefinition? getAchievementDefById(String id) {
  return ACHIEVEMENT_DEFINITIONS.firstWhere((d) => d.id == id);
}