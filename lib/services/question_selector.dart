/// ─── Question Selector ──────────────────────────────────────────────────────
/// Algoritmo de selección de preguntas para práctica adaptativa.
///
/// Prioridad:
///   1. Preguntas falladas recientemente (alto)
///   2. Habilidades con baja precisión (alto)
///   3. Preguntas nuevas / nunca vistas (medio)
///   4. Repaso espaciado de preguntas ya dominadas (bajo)
library;

import 'dart:math';

/// Stats de una pregunta vista por el usuario (viene del repository)
class QuestionAttemptStats {
  final int questionId;
  final int skillId;
  final int totalAttempts;
  final int correctAttempts;
  final DateTime? lastAttemptAt;
  final bool lastWasCorrect;

  const QuestionAttemptStats({
    required this.questionId,
    required this.skillId,
    this.totalAttempts = 0,
    this.correctAttempts = 0,
    this.lastAttemptAt,
    this.lastWasCorrect = false,
  });

  double get accuracy =>
      totalAttempts > 0 ? correctAttempts / totalAttempts : 0;

  bool get neverSeen => totalAttempts == 0;

  /// Horas desde el último intento
  double get hoursSinceLastAttempt {
    if (lastAttemptAt == null) return double.infinity;
    return DateTime.now().difference(lastAttemptAt!).inMinutes / 60;
  }
}

/// Stats de una habilidad del usuario
class SkillStats {
  final int skillId;
  final double accuracy;
  final int totalAttempts;
  final DateTime? lastPracticedAt;

  const SkillStats({
    required this.skillId,
    this.accuracy = 0,
    this.totalAttempts = 0,
    this.lastPracticedAt,
  });
}

/// Candidato con su score de prioridad calculado
class _ScoredQuestion {
  final int questionId;
  final double score;

  _ScoredQuestion(this.questionId, this.score);
}

/// Selector de preguntas con algoritmo adaptativo.
class QuestionSelector {
  final Random _random = Random();

  /// Selecciona [count] preguntas del pool de [availableIds] usando el algoritmo
  /// adaptativo basado en los stats del usuario.
  ///
  /// - [availableIds]: IDs de preguntas válidas (filtradas por exam/section/area/skill)
  /// - [questionStats]: historial de intentos por pregunta del usuario
  /// - [skillStats]: precisión por habilidad del usuario
  /// - [count]: cuántas preguntas seleccionar
  /// - [questionSkillMap]: mapa questionId → skillId
  List<int> select({
    required List<int> availableIds,
    required Map<int, QuestionAttemptStats> questionStats,
    required Map<int, SkillStats> skillStats,
    required Map<int, int> questionSkillMap,
    required int count,
  }) {
    if (availableIds.length <= count) return _shuffle(availableIds);

    final scored = <_ScoredQuestion>[];

    for (final qId in availableIds) {
      final qStats = questionStats[qId];
      final skillId = questionSkillMap[qId];
      final sStats = skillId != null ? skillStats[skillId] : null;

      final score = _calculateScore(qStats, sStats);
      scored.add(_ScoredQuestion(qId, score));
    }

    // Ordenar por score descendente (mayor prioridad primero)
    scored.sort((a, b) => b.score.compareTo(a.score));

    // Tomar top N con un poco de variación (80% top, 20% aleatorio)
    final topCount = (count * 0.8).ceil();
    final randomCount = count - topCount;

    final topPicks = scored.take(topCount).map((s) => s.questionId).toList();
    final remaining = scored.skip(topCount).map((s) => s.questionId).toList();
    remaining.shuffle(_random);
    final randomPicks = remaining.take(randomCount).toList();

    final selected = [...topPicks, ...randomPicks];
    selected.shuffle(_random);
    return selected;
  }

  /// Selección simple para diagnóstico: muestreo uniforme por skills.
  /// Intenta distribuir proporcionalmente entre las habilidades disponibles.
  List<int> selectForDiagnostic({
    required Map<int, List<int>> questionsBySkill,
    required int count,
  }) {
    final selected = <int>[];
    final skills = questionsBySkill.keys.toList()..shuffle(_random);

    if (skills.isEmpty) return [];

    // Distribuir equitativamente entre skills
    final perSkill = (count / skills.length).ceil();
    for (final skillId in skills) {
      final pool = List<int>.from(questionsBySkill[skillId] ?? []);
      pool.shuffle(_random);
      selected.addAll(pool.take(perSkill));
    }

    // Recortar si sobrepasamos
    if (selected.length > count) {
      selected.shuffle(_random);
      return selected.sublist(0, count);
    }

    return _shuffle(selected);
  }

  /// Selección para simulacro: mezcla proporcional respetando estructura oficial.
  /// [sectionQuotas]: sectionId → número de reactivos que esa sección debe tener.
  /// [questionsBySection]: sectionId → lista de IDs disponibles.
  List<int> selectForSimulation({
    required Map<int, int> sectionQuotas,
    required Map<int, List<int>> questionsBySection,
  }) {
    final selected = <int>[];

    for (final entry in sectionQuotas.entries) {
      final sectionId = entry.key;
      final quota = entry.value;
      final pool = List<int>.from(questionsBySection[sectionId] ?? []);
      pool.shuffle(_random);
      selected.addAll(pool.take(quota));
    }

    return selected;  // mantener orden por sección (como en examen real)
  }

  // ─── Scoring interno ────────────────────────────────────────────────────

  /// Calcula score de prioridad para una pregunta.
  ///
  /// Mayor score = mayor prioridad de ser seleccionada.
  ///
  /// Factores:
  ///   - Fallada recientemente           → +40 pts
  ///   - Skill con baja precisión        → +30 pts
  ///   - Nunca vista                     → +20 pts
  ///   - Repaso espaciado (>48h)         → +10 pts
  ///   - Dominada (>80% accuracy)        → +2 pts (base baja)
  double _calculateScore(QuestionAttemptStats? qStats, SkillStats? sStats) {
    // Pregunta nunca vista → prioridad media
    if (qStats == null || qStats.neverSeen) return 20 + _random.nextDouble();

    double score = 0;

    // ── Factor 1: Último intento fue incorrecto (+40)
    if (!qStats.lastWasCorrect) {
      score += 40;
      // Bonus si fue muy reciente (últimas 24h)
      if (qStats.hoursSinceLastAttempt < 24) score += 5;
    }

    // ── Factor 2: Skill débil (+30)
    if (sStats != null && sStats.accuracy < 60) {
      score += 30 * (1 - sStats.accuracy / 100); // más débil = más puntos
    }

    // ── Factor 3: Baja precisión personal en esta pregunta (+20)
    if (qStats.accuracy < 0.5 && qStats.totalAttempts >= 2) {
      score += 20;
    }

    // ── Factor 4: Repaso espaciado (+10)
    if (qStats.accuracy >= 0.8 && qStats.hoursSinceLastAttempt > 48) {
      score += 10;
    }

    // ── Factor 5: Ya dominada, prioridad mínima (+2)
    if (qStats.accuracy >= 0.8 && qStats.hoursSinceLastAttempt < 24) {
      score += 2;
    }

    // Jitter para evitar determinismo
    score += _random.nextDouble() * 3;

    return score;
  }

  List<int> _shuffle(List<int> list) {
    final copy = List<int>.from(list);
    copy.shuffle(_random);
    return copy;
  }
}
