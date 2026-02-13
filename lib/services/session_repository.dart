/// ─── Session Repository ─────────────────────────────────────────────────────
/// Interfaz abstracta que define las operaciones de persistencia para sesiones.
/// Implementaciones concretas: SQLite (local) y Supabase (remoto).
library;

import 'package:exani/models/session.dart';
import 'package:exani/models/option.dart';
import 'package:exani/services/question_selector.dart';

/// Interfaz del repositorio de sesiones.
/// Permite cambiar entre SQLite y Supabase sin tocar la lógica del engine.
abstract class SessionRepository {
  // ─── Sesiones ───────────────────────────────────────────────────────────

  /// Crea una nueva sesión y devuelve el ID asignado.
  Future<int> createSession(Session session);

  /// Actualiza el estado de una sesión.
  Future<void> updateSessionStatus(int sessionId, SessionStatus status);

  /// Marca una sesión como completada con sus totales.
  Future<void> completeSession({
    required int sessionId,
    required int totalQuestions,
    required int correctAnswers,
    required double accuracy,
    required int totalTimeMs,
  });

  /// Obtiene una sesión por ID (con sus preguntas).
  Future<Session?> getSession(int sessionId);

  /// Obtiene sesiones incompletas del usuario para resume.
  Future<List<Session>> getIncompleteSessions(int examId);

  // ─── Respuestas ─────────────────────────────────────────────────────────

  /// Registra la respuesta a una pregunta dentro de una sesión.
  Future<void> saveAnswer({
    required int sessionId,
    required int questionId,
    required String chosenKey,
    required bool isCorrect,
    required int timeMs,
    required SessionMode mode,
  });

  // ─── Preguntas (lectura) ────────────────────────────────────────────────

  /// Obtiene IDs de preguntas disponibles filtradas por scope.
  /// Respeta is_active y question_set activo.
  Future<List<int>> getAvailableQuestionIds({
    required int examId,
    int? sectionId,
    int? areaId,
    int? skillId,
  });

  /// Obtiene preguntas por IDs (para poblar la sesión).
  Future<List<Question>> getQuestionsByIds(List<int> ids);

  /// Mapa de questionId → skillId para el selector.
  Future<Map<int, int>> getQuestionSkillMap(List<int> questionIds);

  /// Preguntas agrupadas por skill (para diagnóstico).
  Future<Map<int, List<int>>> getQuestionsBySkill({
    required int examId,
    int? sectionId,
  });

  /// Preguntas agrupadas por section (para simulacro).
  Future<Map<int, List<int>>> getQuestionsBySection({
    required int examId,
    List<int>? moduleIds,
  });

  /// Cuotas por sección (num_questions) para simulacro.
  Future<Map<int, int>> getSectionQuotas({
    required int examId,
    List<int>? moduleIds,
  });

  // ─── Stats del usuario ──────────────────────────────────────────────────

  /// Stats de intentos por pregunta del usuario.
  Future<Map<int, QuestionAttemptStats>> getUserQuestionStats(
    List<int> questionIds,
  );

  /// Stats de habilidades del usuario.
  Future<Map<int, SkillStats>> getUserSkillStats(int examId);

  /// Actualiza las estadísticas agregadas de una skill.
  Future<void> refreshSkillStats(int skillId);
}
