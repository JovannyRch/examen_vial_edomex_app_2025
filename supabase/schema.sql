-- ═══════════════════════════════════════════════════════════════════════════════
-- EXANI Prep — Esquema Supabase (PostgreSQL)
-- Versión: 1.0 MVP
-- Fecha: 2026-02-12
--
-- Ejecutar en orden:
--   1. Este archivo (tipos + tablas + índices + constraints)
--   2. supabase_rls.sql (políticas RLS)
--   3. supabase_seed.sql (datos iniciales de estructura)
--
-- Convenciones:
--   - snake_case en todo
--   - UUID para PKs de usuario, SERIAL/BIGSERIAL para contenido
--   - JSONB para datos flexibles (options, config, tags, images)
--   - timestamps con timezone (timestamptz)
--   - soft-delete con is_active donde aplica
-- ═══════════════════════════════════════════════════════════════════════════════

-- ─── 0. EXTENSIONES ──────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ─── 1. TIPOS ENUM ──────────────────────────────────────────────────────────

-- Nivel del examen
CREATE TYPE exam_level AS ENUM ('medio_superior', 'superior');

-- Tipo de sección dentro de un examen
CREATE TYPE section_type AS ENUM ('transversal', 'module', 'diagnostic');

-- Dificultad de la pregunta
CREATE TYPE question_difficulty AS ENUM ('easy', 'medium', 'hard');

-- Modo de sesión (cómo se está usando la pregunta)
CREATE TYPE session_mode AS ENUM ('diagnostic', 'practice', 'simulation');


-- ─── 2. TABLAS DE USUARIO ────────────────────────────────────────────────────

-- profiles: Extiende auth.users con datos de la app
CREATE TABLE profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name  TEXT,
  exam_id       BIGINT,                     -- examen objetivo actual (FK abajo)
  exam_date     DATE,                       -- fecha objetivo del examen
  modules_json  JSONB DEFAULT '[]'::jsonb,  -- módulos disciplinares elegidos (EXANI-II)
                                            -- ej: [3, 7] (IDs de sections tipo module)
  onboarding_done BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT now(),
  updated_at    TIMESTAMPTZ DEFAULT now()
);

-- Trigger para crear perfil automáticamente al registrar usuario
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, display_name)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'name', 'Estudiante'));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();


-- ─── 3. TABLAS DE CONTENIDO (jerarquía Exam → Section → Area → Skill) ───────

-- exams: EXANI-II, EXANI-I
CREATE TABLE exams (
  id          BIGSERIAL PRIMARY KEY,
  code        TEXT UNIQUE NOT NULL,         -- 'exani_ii', 'exani_i'
  name        TEXT NOT NULL,                -- 'EXANI-II', 'EXANI-I'
  level       exam_level NOT NULL,
  description TEXT,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- exam_configs: Reglas del examen (número de reactivos, duración, etc.)
-- Se guarda en JSONB para flexibilidad ante cambios de Ceneval
CREATE TABLE exam_configs (
  id          BIGSERIAL PRIMARY KEY,
  exam_id     BIGINT NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
  version     INT DEFAULT 1,               -- para versionar configs
  rules_json  JSONB NOT NULL,
  -- Ejemplo rules_json:
  -- {
  --   "total_duration_minutes": 270,
  --   "sections": [
  --     {"section_code": "comprension_lectora", "num_questions": 30, "duration_minutes": null},
  --     {"section_code": "modulo_1", "num_questions": 24, "duration_minutes": null}
  --   ],
  --   "passing_score_percentage": 60
  -- }
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),

  UNIQUE(exam_id, version)
);

-- sections: Agrupación de áreas (transversal, módulo, diagnóstico)
CREATE TABLE sections (
  id          BIGSERIAL PRIMARY KEY,
  exam_id     BIGINT NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
  code        TEXT NOT NULL,                -- 'comprension_lectora', 'modulo_fisica', etc.
  name        TEXT NOT NULL,                -- 'Comprensión lectora', 'Física'
  type        section_type NOT NULL,
  num_questions INT DEFAULT 30,             -- reactivos oficiales en esta sección
  sort_order  INT DEFAULT 0,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),

  UNIQUE(exam_id, code)
);

-- areas: Subdivisiones dentro de una sección
-- Para transversales: el área ES la sección (1:1)
-- Para módulos: puede tener sub-áreas (ej: Física → Mecánica, Termodinámica)
CREATE TABLE areas (
  id          BIGSERIAL PRIMARY KEY,
  section_id  BIGINT NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
  code        TEXT NOT NULL,                -- 'inferencias', 'idea_principal', etc.
  name        TEXT NOT NULL,
  description TEXT,
  weight      DECIMAL(3,2) DEFAULT 1.00,   -- peso relativo en score (0.00–1.00)
  sort_order  INT DEFAULT 0,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),

  UNIQUE(section_id, code)
);

-- skills: Micro-habilidades dentro de un área
-- Nivel más granular para práctica adaptativa
CREATE TABLE skills (
  id          BIGSERIAL PRIMARY KEY,
  area_id     BIGINT NOT NULL REFERENCES areas(id) ON DELETE CASCADE,
  code        TEXT NOT NULL,
  name        TEXT NOT NULL,
  description TEXT,
  sort_order  INT DEFAULT 0,
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),

  UNIQUE(area_id, code)
);


-- ─── 4. TABLAS DE PREGUNTAS ─────────────────────────────────────────────────

-- question_sets: Permite versionar bancos de preguntas
-- Al actualizar contenido, se crea un nuevo set sin romper reportes históricos
CREATE TABLE question_sets (
  id          BIGSERIAL PRIMARY KEY,
  exam_id     BIGINT NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,                -- 'EXANI-II v1.0', 'EXANI-II v1.1'
  description TEXT,
  is_active   BOOLEAN DEFAULT true,         -- solo el set activo se usa para nuevas sesiones
  created_at  TIMESTAMPTZ DEFAULT now(),
  activated_at TIMESTAMPTZ
);

-- questions: Banco de preguntas con soporte rich content
-- ▸ Soporta imágenes en: enunciado, opciones y explicación
-- ▸ options_json almacena las opciones con texto + imagen opcional
-- ▸ stem_images_json y explanation_images_json almacenan listas de URLs/paths
CREATE TABLE questions (
  id                      BIGSERIAL PRIMARY KEY,
  skill_id                BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  set_id                  BIGINT NOT NULL REFERENCES question_sets(id) ON DELETE CASCADE,

  -- Enunciado
  stem                    TEXT NOT NULL,             -- texto del enunciado
  stem_image              TEXT,                      -- imagen principal (URL o path)
  stem_images_json        JSONB DEFAULT '[]'::jsonb, -- imágenes adicionales: ["url1", "url2"]

  -- Opciones (JSONB para flexibilidad: 3 o 4 opciones, con/sin imagen)
  options_json            JSONB NOT NULL,
  -- Formato options_json:
  -- [
  --   {"key": "a", "text": "Opción A", "image": null},
  --   {"key": "b", "text": "Opción B", "image": "https://..."},
  --   {"key": "c", "text": "Opción C", "image": null}
  -- ]

  correct_key             TEXT NOT NULL,             -- 'a', 'b', 'c', 'd'

  -- Explicación
  explanation             TEXT,                      -- texto explicativo
  explanation_images_json JSONB DEFAULT '[]'::jsonb, -- imágenes de la explicación

  -- Metadatos
  difficulty              question_difficulty DEFAULT 'medium',
  tags_json               JSONB DEFAULT '[]'::jsonb, -- ["inferencias", "texto_expositivo"]
  source                  TEXT,                      -- origen/referencia de la pregunta
  is_active               BOOLEAN DEFAULT true,
  created_at              TIMESTAMPTZ DEFAULT now(),
  updated_at              TIMESTAMPTZ DEFAULT now()
);


-- ─── 5. TABLAS DE SESIONES Y RESPUESTAS ──────────────────────────────────────

-- sessions: Cada vez que el usuario inicia un diagnóstico, práctica o simulacro
CREATE TABLE sessions (
  id                  BIGSERIAL PRIMARY KEY,
  user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exam_id             BIGINT NOT NULL REFERENCES exams(id),
  mode                session_mode NOT NULL,
  config_snapshot_json JSONB,               -- snapshot de reglas al momento del simulacro
                                            -- para reproducibilidad
  section_id          BIGINT REFERENCES sections(id), -- sección específica (práctica por área)
  area_id             BIGINT REFERENCES areas(id),    -- área específica (práctica por habilidad)
  skill_id            BIGINT REFERENCES skills(id),   -- skill específica

  total_questions     INT DEFAULT 0,
  correct_answers     INT DEFAULT 0,
  accuracy            DECIMAL(5,2),          -- porcentaje 0.00–100.00
  total_time_ms       BIGINT DEFAULT 0,

  started_at          TIMESTAMPTZ DEFAULT now(),
  ended_at            TIMESTAMPTZ,
  is_completed        BOOLEAN DEFAULT false,

  created_at          TIMESTAMPTZ DEFAULT now()
);

-- session_questions: Cada pregunta dentro de una sesión (orden + respuesta)
CREATE TABLE session_questions (
  id              BIGSERIAL PRIMARY KEY,
  session_id      BIGINT NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  question_id     BIGINT NOT NULL REFERENCES questions(id),
  question_order  INT NOT NULL,              -- posición en la sesión (1, 2, 3...)

  chosen_key      TEXT,                      -- respuesta elegida ('a', 'b', 'c')
  is_correct      BOOLEAN,
  time_ms         INT,                       -- tiempo en milisegundos para esta pregunta

  answered_at     TIMESTAMPTZ,

  UNIQUE(session_id, question_id)
);

-- attempts: Registro individual de cada intento (desnormalizado para queries rápidos)
-- Permite análisis sin joins pesados a sessions
CREATE TABLE attempts (
  id          BIGSERIAL PRIMARY KEY,
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  question_id BIGINT NOT NULL REFERENCES questions(id),
  session_id  BIGINT REFERENCES sessions(id) ON DELETE SET NULL,

  chosen_key  TEXT NOT NULL,
  is_correct  BOOLEAN NOT NULL,
  time_ms     INT,                           -- milisegundos
  mode        session_mode NOT NULL,

  created_at  TIMESTAMPTZ DEFAULT now()
);


-- ─── 6. TABLAS DE PROGRESO DEL USUARIO ───────────────────────────────────────

-- user_skill_stats: Estadísticas agregadas por habilidad (se actualiza tras cada sesión)
CREATE TABLE user_skill_stats (
  id                  BIGSERIAL PRIMARY KEY,
  user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  skill_id            BIGINT NOT NULL REFERENCES skills(id),

  total_attempts      INT DEFAULT 0,
  correct_attempts    INT DEFAULT 0,
  accuracy            DECIMAL(5,2) DEFAULT 0.00,  -- porcentaje
  avg_time_ms         INT DEFAULT 0,
  streak              INT DEFAULT 0,               -- racha actual de correctas
  best_streak         INT DEFAULT 0,

  last_practiced_at   TIMESTAMPTZ,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now(),

  UNIQUE(user_id, skill_id)
);

-- user_area_stats: Estadísticas agregadas por área (calculada de skills)
CREATE TABLE user_area_stats (
  id                  BIGSERIAL PRIMARY KEY,
  user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  area_id             BIGINT NOT NULL REFERENCES areas(id),

  total_attempts      INT DEFAULT 0,
  correct_attempts    INT DEFAULT 0,
  accuracy            DECIMAL(5,2) DEFAULT 0.00,
  avg_time_ms         INT DEFAULT 0,

  last_practiced_at   TIMESTAMPTZ,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now(),

  UNIQUE(user_id, area_id)
);

-- user_exam_stats: Estadísticas generales por examen
CREATE TABLE user_exam_stats (
  id                  BIGSERIAL PRIMARY KEY,
  user_id             UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exam_id             BIGINT NOT NULL REFERENCES exams(id),

  total_sessions      INT DEFAULT 0,
  total_simulations   INT DEFAULT 0,
  best_simulation_pct DECIMAL(5,2) DEFAULT 0.00,
  last_simulation_pct DECIMAL(5,2),
  study_streak_days   INT DEFAULT 0,
  best_streak_days    INT DEFAULT 0,

  diagnostic_done     BOOLEAN DEFAULT false,
  diagnostic_json     JSONB,                  -- resultado del diagnóstico
  -- Ejemplo: {"areas": [{"area_id": 1, "level": "alto", "accuracy": 85.5}, ...]}

  last_session_at     TIMESTAMPTZ,
  created_at          TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now(),

  UNIQUE(user_id, exam_id)
);


-- ─── 7. TABLA DE FAVORITOS (preguntas guardadas) ────────────────────────────

CREATE TABLE user_favorites (
  id          BIGSERIAL PRIMARY KEY,
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  question_id BIGINT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  source      TEXT DEFAULT 'manual',         -- 'manual' | 'failed' (auto-guardada al fallar)
  created_at  TIMESTAMPTZ DEFAULT now(),

  UNIQUE(user_id, question_id)
);


-- ─── 8. LEADERBOARD SEMANAL ─────────────────────────────────────────────────

CREATE TABLE leaderboards_weekly (
  id              BIGSERIAL PRIMARY KEY,
  exam_id         BIGINT NOT NULL REFERENCES exams(id),
  week_start      DATE NOT NULL,             -- lunes de la semana
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  score           DECIMAL(8,2) DEFAULT 0.00, -- fórmula: accuracy * 0.7 + speed * 0.2 + consistency * 0.1
  accuracy_pct    DECIMAL(5,2) DEFAULT 0.00,
  avg_time_ms     INT DEFAULT 0,
  total_questions INT DEFAULT 0,
  sessions_count  INT DEFAULT 0,

  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now(),

  UNIQUE(exam_id, week_start, user_id)
);


-- ─── 9. TABLA DE SYNC OFFLINE ────────────────────────────────────────────────

-- Cola de eventos para sincronización offline → online
CREATE TABLE sync_queue (
  id          BIGSERIAL PRIMARY KEY,
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_type  TEXT NOT NULL,                 -- 'attempt', 'session_complete', 'favorite_toggle'
  payload     JSONB NOT NULL,                -- datos del evento
  is_synced   BOOLEAN DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT now(),
  synced_at   TIMESTAMPTZ
);


-- ═══════════════════════════════════════════════════════════════════════════════
-- ÍNDICES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Contenido: búsquedas frecuentes
CREATE INDEX idx_sections_exam      ON sections(exam_id) WHERE is_active = true;
CREATE INDEX idx_areas_section      ON areas(section_id) WHERE is_active = true;
CREATE INDEX idx_skills_area        ON skills(area_id) WHERE is_active = true;
CREATE INDEX idx_questions_skill    ON questions(skill_id) WHERE is_active = true;
CREATE INDEX idx_questions_set      ON questions(set_id) WHERE is_active = true;
CREATE INDEX idx_questions_difficulty ON questions(difficulty) WHERE is_active = true;

-- Sesiones: por usuario y modo
CREATE INDEX idx_sessions_user      ON sessions(user_id, exam_id);
CREATE INDEX idx_sessions_mode      ON sessions(user_id, mode);
CREATE INDEX idx_sessions_date      ON sessions(user_id, created_at DESC);

-- Session questions: por sesión
CREATE INDEX idx_sq_session         ON session_questions(session_id, question_order);

-- Attempts: queries de progreso y algoritmo adaptativo
CREATE INDEX idx_attempts_user_q    ON attempts(user_id, question_id, created_at DESC);
CREATE INDEX idx_attempts_user_mode ON attempts(user_id, mode, created_at DESC);
CREATE INDEX idx_attempts_correct   ON attempts(user_id, is_correct, created_at DESC);

-- Stats: por usuario
CREATE INDEX idx_uss_user           ON user_skill_stats(user_id);
CREATE INDEX idx_uas_user           ON user_area_stats(user_id);
CREATE INDEX idx_ues_user           ON user_exam_stats(user_id);

-- Leaderboard: ranking semanal
CREATE INDEX idx_lb_exam_week       ON leaderboards_weekly(exam_id, week_start, score DESC);

-- Favoritos: por usuario
CREATE INDEX idx_fav_user           ON user_favorites(user_id);

-- Sync queue: pendientes
CREATE INDEX idx_sync_pending       ON sync_queue(user_id, is_synced) WHERE is_synced = false;


-- ═══════════════════════════════════════════════════════════════════════════════
-- FUNCIONES AUXILIARES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers de updated_at
CREATE TRIGGER trg_profiles_updated    BEFORE UPDATE ON profiles          FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_questions_updated   BEFORE UPDATE ON questions         FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_uss_updated         BEFORE UPDATE ON user_skill_stats  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_uas_updated         BEFORE UPDATE ON user_area_stats   FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_ues_updated         BEFORE UPDATE ON user_exam_stats   FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_lb_updated          BEFORE UPDATE ON leaderboards_weekly FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- FK diferida de profiles → exams (se crea después de que exams exista)
ALTER TABLE profiles
  ADD CONSTRAINT fk_profiles_exam
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE SET NULL;


-- ═══════════════════════════════════════════════════════════════════════════════
-- FUNCIÓN: Actualizar user_skill_stats tras un attempt
-- Se llama desde la app o como trigger
-- ═══════════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION update_skill_stats(
  p_user_id UUID,
  p_skill_id BIGINT
)
RETURNS void AS $$
DECLARE
  v_total INT;
  v_correct INT;
  v_avg_time INT;
BEGIN
  SELECT
    COUNT(*),
    COUNT(*) FILTER (WHERE is_correct),
    COALESCE(AVG(time_ms) FILTER (WHERE time_ms > 0), 0)
  INTO v_total, v_correct, v_avg_time
  FROM attempts a
  JOIN questions q ON q.id = a.question_id
  WHERE a.user_id = p_user_id
    AND q.skill_id = p_skill_id;

  INSERT INTO user_skill_stats (user_id, skill_id, total_attempts, correct_attempts, accuracy, avg_time_ms, last_practiced_at)
  VALUES (
    p_user_id,
    p_skill_id,
    v_total,
    v_correct,
    CASE WHEN v_total > 0 THEN (v_correct::decimal / v_total * 100) ELSE 0 END,
    v_avg_time,
    now()
  )
  ON CONFLICT (user_id, skill_id)
  DO UPDATE SET
    total_attempts = v_total,
    correct_attempts = v_correct,
    accuracy = CASE WHEN v_total > 0 THEN (v_correct::decimal / v_total * 100) ELSE 0 END,
    avg_time_ms = v_avg_time,
    last_practiced_at = now();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
