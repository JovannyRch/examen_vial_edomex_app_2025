-- ═══════════════════════════════════════════════════════════════════════════════
-- EXANI Prep — Políticas RLS (Row Level Security)
-- Ejecutar DESPUÉS de schema.sql
--
-- Principios:
--   1. Contenido (exams, sections, areas, skills, questions): lectura pública
--      solo si is_active = true
--   2. Datos de usuario (profiles, sessions, attempts, stats, favorites):
--      solo el dueño puede leer/escribir
--   3. Leaderboard: lectura pública, escritura solo por funciones server-side
--   4. Sync queue: solo el dueño
-- ═══════════════════════════════════════════════════════════════════════════════


-- ─── HABILITAR RLS EN TODAS LAS TABLAS ───────────────────────────────────────

ALTER TABLE profiles             ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams                ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_configs         ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections             ENABLE ROW LEVEL SECURITY;
ALTER TABLE areas                ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills               ENABLE ROW LEVEL SECURITY;
ALTER TABLE question_sets        ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions            ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions             ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_questions    ENABLE ROW LEVEL SECURITY;
ALTER TABLE attempts             ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skill_stats     ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_area_stats      ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_exam_stats      ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites       ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaderboards_weekly  ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue           ENABLE ROW LEVEL SECURITY;


-- ═══════════════════════════════════════════════════════════════════════════════
-- CONTENIDO (lectura pública si is_active)
-- ═══════════════════════════════════════════════════════════════════════════════

-- exams: cualquier usuario autenticado puede ver exámenes activos
CREATE POLICY "exams_select_active"
  ON exams FOR SELECT
  TO authenticated
  USING (is_active = true);

-- exam_configs
CREATE POLICY "exam_configs_select_active"
  ON exam_configs FOR SELECT
  TO authenticated
  USING (is_active = true);

-- sections
CREATE POLICY "sections_select_active"
  ON sections FOR SELECT
  TO authenticated
  USING (is_active = true);

-- areas
CREATE POLICY "areas_select_active"
  ON areas FOR SELECT
  TO authenticated
  USING (is_active = true);

-- skills
CREATE POLICY "skills_select_active"
  ON skills FOR SELECT
  TO authenticated
  USING (is_active = true);

-- question_sets
CREATE POLICY "question_sets_select_active"
  ON question_sets FOR SELECT
  TO authenticated
  USING (is_active = true);

-- questions: solo activas y de sets activos
CREATE POLICY "questions_select_active"
  ON questions FOR SELECT
  TO authenticated
  USING (
    is_active = true
    AND set_id IN (SELECT id FROM question_sets WHERE is_active = true)
  );


-- ═══════════════════════════════════════════════════════════════════════════════
-- PROFILES (solo dueño)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE POLICY "profiles_select_own"
  ON profiles FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "profiles_update_own"
  ON profiles FOR UPDATE
  TO authenticated
  USING (id = auth.uid())
  WITH CHECK (id = auth.uid());

-- INSERT se maneja por trigger (handle_new_user), no necesita policy de usuario


-- ═══════════════════════════════════════════════════════════════════════════════
-- SESSIONS (solo dueño)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE POLICY "sessions_select_own"
  ON sessions FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "sessions_insert_own"
  ON sessions FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "sessions_update_own"
  ON sessions FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());


-- ═══════════════════════════════════════════════════════════════════════════════
-- SESSION_QUESTIONS (solo dueño vía session)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE POLICY "sq_select_own"
  ON session_questions FOR SELECT
  TO authenticated
  USING (
    session_id IN (SELECT id FROM sessions WHERE user_id = auth.uid())
  );

CREATE POLICY "sq_insert_own"
  ON session_questions FOR INSERT
  TO authenticated
  WITH CHECK (
    session_id IN (SELECT id FROM sessions WHERE user_id = auth.uid())
  );

CREATE POLICY "sq_update_own"
  ON session_questions FOR UPDATE
  TO authenticated
  USING (
    session_id IN (SELECT id FROM sessions WHERE user_id = auth.uid())
  )
  WITH CHECK (
    session_id IN (SELECT id FROM sessions WHERE user_id = auth.uid())
  );


-- ═══════════════════════════════════════════════════════════════════════════════
-- ATTEMPTS (solo dueño)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE POLICY "attempts_select_own"
  ON attempts FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "attempts_insert_own"
  ON attempts FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());


-- ═══════════════════════════════════════════════════════════════════════════════
-- USER STATS (solo dueño)
-- ═══════════════════════════════════════════════════════════════════════════════

-- user_skill_stats
CREATE POLICY "uss_select_own"
  ON user_skill_stats FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "uss_upsert_own"
  ON user_skill_stats FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "uss_update_own"
  ON user_skill_stats FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- user_area_stats
CREATE POLICY "uas_select_own"
  ON user_area_stats FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "uas_upsert_own"
  ON user_area_stats FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "uas_update_own"
  ON user_area_stats FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- user_exam_stats
CREATE POLICY "ues_select_own"
  ON user_exam_stats FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "ues_upsert_own"
  ON user_exam_stats FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "ues_update_own"
  ON user_exam_stats FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());


-- ═══════════════════════════════════════════════════════════════════════════════
-- FAVORITOS (solo dueño)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE POLICY "favorites_select_own"
  ON user_favorites FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "favorites_insert_own"
  ON user_favorites FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "favorites_delete_own"
  ON user_favorites FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());


-- ═══════════════════════════════════════════════════════════════════════════════
-- LEADERBOARD (lectura pública, escritura server-side)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Cualquier autenticado puede ver el ranking
CREATE POLICY "lb_select_all"
  ON leaderboards_weekly FOR SELECT
  TO authenticated
  USING (true);

-- Solo funciones server-side (service_role) pueden escribir
-- No se crea policy de INSERT/UPDATE para authenticated
-- Las edge functions usan service_role key para escribir


-- ═══════════════════════════════════════════════════════════════════════════════
-- SYNC QUEUE (solo dueño)
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE POLICY "sync_select_own"
  ON sync_queue FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "sync_insert_own"
  ON sync_queue FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "sync_update_own"
  ON sync_queue FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());


-- ═══════════════════════════════════════════════════════════════════════════════
-- GUÍA DE PRUEBAS RLS
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- Para verificar que RLS funciona correctamente, ejecutar estas queries
-- desde el SQL Editor de Supabase con diferentes roles:
--
-- 1. Como usuario autenticado (user A):
--    SELECT * FROM profiles;            → solo ve su perfil
--    SELECT * FROM exams;               → ve todos los activos
--    SELECT * FROM questions;           → ve todas las activas
--    SELECT * FROM sessions;            → solo ve las suyas
--    SELECT * FROM attempts;            → solo ve los suyos
--    SELECT * FROM leaderboards_weekly; → ve todo el ranking
--
-- 2. Como usuario autenticado (user B):
--    SELECT * FROM sessions;            → NO ve las de user A
--    SELECT * FROM attempts;            → NO ve los de user A
--
-- 3. Como anon (no autenticado):
--    SELECT * FROM exams;               → ERROR (no tiene acceso)
--    SELECT * FROM questions;           → ERROR
--
-- 4. Contenido desactivado:
--    UPDATE exams SET is_active = false WHERE code = 'exani_i';
--    SELECT * FROM exams;               → ya NO aparece EXANI-I
--
-- 5. Leaderboard write:
--    INSERT INTO leaderboards_weekly ... → ERROR como authenticated
--    (solo funciona con service_role key)
