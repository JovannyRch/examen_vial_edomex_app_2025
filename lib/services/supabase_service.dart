/// ─── Supabase Service ────────────────────────────────────────────────────────
/// Singleton que centraliza el acceso a Supabase.
/// - Inicialización con URL + anon key desde const.dart
/// - Shortcuts para auth, client, tablas frecuentes
/// - Helpers para el user actual
library;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
/* import 'package:exani/const/const.dart'; */

class SupabaseService {
  // ─── Singleton ──────────────────────────────────────────────────────────
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  bool _initialized = false;

  // ─── Inicialización ─────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: 'https://quicsqnemgdvzmldalcq.supabase.co',
      anonKey: 'sb_publishable_AUvnD8jXNN5HoCzUHf0i-g_ziZ7Lp3L',
    );

    _initialized = true;
    debugPrint('✅ Supabase initialized');
  }

  // ─── Shortcuts ──────────────────────────────────────────────────────────

  SupabaseClient get client => Supabase.instance.client;
  GoTrueClient get auth => client.auth;

  /// Usuario actual o null si no está logueado.
  User? get currentUser => auth.currentUser;

  /// ID del usuario actual (lanza si no hay sesión).
  String get userId {
    final user = currentUser;
    if (user == null) throw Exception('No hay sesión activa');
    return user.id;
  }

  /// ¿Tiene sesión activa?
  bool get isLoggedIn => currentUser != null;

  /// Stream de cambios de autenticación.
  Stream<AuthState> get authStateChanges => auth.onAuthStateChange;

  // ─── Auth helpers ───────────────────────────────────────────────────────

  /// Sign up con email + password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await auth.signUp(
      email: email,
      password: password,
      data: displayName != null ? {'name': displayName} : null,
    );
  }

  /// Sign in con email + password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await auth.signInWithPassword(email: email, password: password);
  }

  /// Sign in anónimo (para probar sin registro).
  Future<AuthResponse> signInAnonymously() async {
    return await auth.signInAnonymously();
  }

  /// Cerrar sesión.
  Future<void> signOut() async {
    await auth.signOut();
  }

  // ─── Table shortcuts ───────────────────────────────────────────────────

  /// Tabla de perfiles de usuario.
  SupabaseQueryBuilder get profiles => client.from('profiles');

  /// Tabla de exámenes.
  SupabaseQueryBuilder get exams => client.from('exams');

  /// Tabla de secciones.
  SupabaseQueryBuilder get sections => client.from('sections');

  /// Tabla de áreas.
  SupabaseQueryBuilder get areas => client.from('areas');

  /// Tabla de skills.
  SupabaseQueryBuilder get skills => client.from('skills');

  /// Tabla de preguntas.
  SupabaseQueryBuilder get questions => client.from('questions');

  /// Tabla de question_sets.
  SupabaseQueryBuilder get questionSets => client.from('question_sets');

  /// Tabla de sesiones.
  SupabaseQueryBuilder get sessions => client.from('sessions');

  /// Tabla de session_questions.
  SupabaseQueryBuilder get sessionQuestions => client.from('session_questions');

  /// Tabla de attempts.
  SupabaseQueryBuilder get attempts => client.from('attempts');

  /// Tabla de user_skill_stats.
  SupabaseQueryBuilder get userSkillStats => client.from('user_skill_stats');

  /// Tabla de user_area_stats.
  SupabaseQueryBuilder get userAreaStats => client.from('user_area_stats');

  /// Tabla de user_exam_stats.
  SupabaseQueryBuilder get userExamStats => client.from('user_exam_stats');

  /// Tabla de favoritos.
  SupabaseQueryBuilder get favorites => client.from('user_favorites');

  /// Tabla de leaderboard semanal.
  SupabaseQueryBuilder get leaderboard => client.from('leaderboards_weekly');

  /// Tabla de sync queue (offline).
  SupabaseQueryBuilder get syncQueue => client.from('sync_queue');

  // ─── RPC (funciones de servidor) ────────────────────────────────────────

  /// Llama una función RPC de Supabase.
  Future<dynamic> rpc(String functionName, {Map<String, dynamic>? params}) {
    return client.rpc(functionName, params: params ?? {});
  }

  // ─── Profile helpers ────────────────────────────────────────────────────

  /// Obtiene el perfil del usuario actual.
  Future<Map<String, dynamic>?> getMyProfile() async {
    if (!isLoggedIn) return null;
    final data = await profiles.select().eq('id', userId).maybeSingle();
    return data;
  }

  /// Actualiza campos del perfil.
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await profiles.update(updates).eq('id', userId);
  }

  /// Guarda la selección de examen + fecha + módulos del onboarding.
  Future<void> saveOnboardingData({
    required int examId,
    DateTime? examDate,
    List<int> moduleIds = const [],
  }) async {
    await profiles
        .update({
          'exam_id': examId,
          'exam_date': examDate?.toIso8601String().substring(0, 10),
          'modules_json': moduleIds,
          'onboarding_done': true,
        })
        .eq('id', userId);
  }
}
