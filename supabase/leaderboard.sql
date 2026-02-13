-- ═══════════════════════════════════════════════════════════════════════════════
-- EXANI Prep — Leaderboard Semanal
-- Versión: 1.0 MVP
-- Fecha: 2026-02-12
--
-- Ejecutar DESPUÉS de schema.sql + rls.sql + seed.sql
--
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- ─── FÓRMULA ─────────────────────────────────────────────────────────────────
--
--   score = (accuracy_pct × 0.65) + (speed_score × 0.20) + (consistency × 0.15)
--
--   Donde:
--     accuracy_pct    = (correctas / total) × 100              [0–100]
--     speed_score     = CLAMP(100 - (avg_time_sec - 30) × 0.5, 0, 100)
--                       → 30s o menos = 100 pts; 230s+ = 0 pts
--     consistency     = MIN(sessions_count × 15, 100)
--                       → 1 sesión = 15 pts; 7+ = 100 pts (máx)
--
-- ─── ANTI-TRAMPAS ────────────────────────────────────────────────────────────
--
--   1. Tiempo mínimo por pregunta: < 2s → se ignora la pregunta
--   2. Sesiones incompletas: solo cuentan sesiones con is_completed = true
--   3. Mínimo de preguntas: necesita ≥ 20 preguntas en la semana para rankear
--   4. Tiempo máximo: > 300s por pregunta → se capea a 300s
--
-- ═══════════════════════════════════════════════════════════════════════════════


-- ─── 1. FUNCIÓN: Calcular leaderboard de una semana ─────────────────────────

CREATE OR REPLACE FUNCTION compute_weekly_leaderboard(
  p_week_start DATE DEFAULT date_trunc('week', CURRENT_DATE)::DATE
)
RETURNS void AS $$
DECLARE
  v_week_end DATE := p_week_start + INTERVAL '7 days';
BEGIN

  -- Borrar datos previos de esta semana (idempotente)
  DELETE FROM leaderboards_weekly WHERE week_start = p_week_start;

  -- Insertar rankings calculados
  INSERT INTO leaderboards_weekly (
    exam_id, week_start, user_id,
    score, accuracy_pct, avg_time_ms,
    total_questions, sessions_count
  )
  SELECT
    s.exam_id,
    p_week_start,
    s.user_id,

    -- ── Score compuesto ──
    ROUND(
      (accuracy_raw * 0.65) +
      (speed_score * 0.20) +
      (consistency_score * 0.15)
    , 2) AS score,

    ROUND(accuracy_raw, 2) AS accuracy_pct,
    avg_time_ms_clean::INT,
    total_valid_questions::INT,
    session_count::INT

  FROM (
    SELECT
      s.exam_id,
      s.user_id,

      -- Precisión: correctas / total × 100
      CASE
        WHEN COUNT(sq.id) FILTER (WHERE sq.time_ms >= 2000) = 0 THEN 0
        ELSE (
          COUNT(sq.id) FILTER (WHERE sq.is_correct AND sq.time_ms >= 2000)::DECIMAL
          / COUNT(sq.id) FILTER (WHERE sq.time_ms >= 2000)
          * 100
        )
      END AS accuracy_raw,

      -- Tiempo promedio (ms) con cap de 300s y filtro de < 2s
      COALESCE(
        AVG(LEAST(sq.time_ms, 300000)) FILTER (WHERE sq.time_ms >= 2000),
        0
      ) AS avg_time_ms_clean,

      -- Speed score: 100 - (avg_seconds - 30) × 0.5, clamped [0, 100]
      GREATEST(0, LEAST(100,
        100 - (
          (COALESCE(AVG(LEAST(sq.time_ms, 300000)) FILTER (WHERE sq.time_ms >= 2000), 0) / 1000.0 - 30)
          * 0.5
        )
      )) AS speed_score,

      -- Sesiones completadas en la semana
      COUNT(DISTINCT s.id) AS session_count,

      -- Consistency: min(sessions × 15, 100)
      LEAST(COUNT(DISTINCT s.id) * 15, 100) AS consistency_score,

      -- Total preguntas válidas (≥ 2s)
      COUNT(sq.id) FILTER (WHERE sq.time_ms >= 2000) AS total_valid_questions

    FROM sessions s
    JOIN session_questions sq ON sq.session_id = s.id
    WHERE s.is_completed = true
      AND s.created_at >= p_week_start
      AND s.created_at < v_week_end
      AND sq.chosen_key IS NOT NULL  -- solo respondidas
    GROUP BY s.exam_id, s.user_id
  ) AS s

  -- Anti-trampa: mínimo 20 preguntas válidas para rankear
  WHERE total_valid_questions >= 20

  ORDER BY score DESC;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ─── 2. FUNCIÓN: Obtener ranking de la semana actual ────────────────────────

CREATE OR REPLACE FUNCTION get_weekly_leaderboard(
  p_exam_id BIGINT,
  p_week_start DATE DEFAULT date_trunc('week', CURRENT_DATE)::DATE,
  p_limit INT DEFAULT 50
)
RETURNS TABLE (
  rank        BIGINT,
  user_id     UUID,
  display_name TEXT,
  score       DECIMAL(8,2),
  accuracy_pct DECIMAL(5,2),
  avg_time_ms INT,
  total_questions INT,
  sessions_count INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ROW_NUMBER() OVER (ORDER BY lb.score DESC) AS rank,
    lb.user_id,
    COALESCE(p.display_name, 'Anónimo') AS display_name,
    lb.score,
    lb.accuracy_pct,
    lb.avg_time_ms,
    lb.total_questions,
    lb.sessions_count
  FROM leaderboards_weekly lb
  LEFT JOIN profiles p ON p.id = lb.user_id
  WHERE lb.exam_id = p_exam_id
    AND lb.week_start = p_week_start
  ORDER BY lb.score DESC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ─── 3. FUNCIÓN: Posición del usuario actual ────────────────────────────────

CREATE OR REPLACE FUNCTION get_my_leaderboard_position(
  p_exam_id BIGINT,
  p_week_start DATE DEFAULT date_trunc('week', CURRENT_DATE)::DATE
)
RETURNS TABLE (
  rank          BIGINT,
  score         DECIMAL(8,2),
  accuracy_pct  DECIMAL(5,2),
  total_questions INT,
  sessions_count INT,
  total_participants BIGINT
) AS $$
BEGIN
  RETURN QUERY
  WITH ranked AS (
    SELECT
      lb.user_id,
      ROW_NUMBER() OVER (ORDER BY lb.score DESC) AS pos,
      lb.score AS lb_score,
      lb.accuracy_pct AS lb_accuracy,
      lb.total_questions AS lb_total,
      lb.sessions_count AS lb_sessions,
      COUNT(*) OVER () AS total_p
    FROM leaderboards_weekly lb
    WHERE lb.exam_id = p_exam_id
      AND lb.week_start = p_week_start
  )
  SELECT
    r.pos,
    r.lb_score,
    r.lb_accuracy,
    r.lb_total,
    r.lb_sessions,
    r.total_p
  FROM ranked r
  WHERE r.user_id = auth.uid()
  LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTAS DE DEPLOYMENT
-- ═══════════════════════════════════════════════════════════════════════════════
--
-- Opción A: Cron con pg_cron (si está habilitado en Supabase)
--   SELECT cron.schedule(
--     'compute-leaderboard',
--     '0 */6 * * *',  -- cada 6 horas
--     $$ SELECT compute_weekly_leaderboard() $$
--   );
--
-- Opción B: Edge Function que llama la función
--   // supabase/functions/compute-leaderboard/index.ts
--   const { data, error } = await supabase.rpc('compute_weekly_leaderboard');
--   // Trigger: cron job externo, o al completar una sesión
--
-- Opción C: Llamar desde la app tras completar simulacro
--   await supabase.rpc('compute_weekly_leaderboard');
--
-- Recomendación MVP: Opción C (simple) + Opción A cuando tengan pg_cron
-- ═══════════════════════════════════════════════════════════════════════════════
