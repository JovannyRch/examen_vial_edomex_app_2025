-- ═══════════════════════════════════════════════════════════════════════════════
-- EXANI Prep — Seed inicial (MOCK)
-- Versión: 1.0 MVP
-- Fecha: 2026-02-12
--
-- NOTA: Este es un seed mínimo con datos ficticios para testing.
-- Los datos reales de estructura (sections, areas, skills) se agregarán después.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ─── 1. EXÁMENES ─────────────────────────────────────────────────────────────

INSERT INTO exams (id, code, name, level, description, is_active) VALUES
  (1, 'exani_ii', 'EXANI-II', 'superior', 'Examen Nacional de Ingreso a la Educación Superior', true),
  (2, 'exani_i', 'EXANI-I', 'medio_superior', 'Examen Nacional de Ingreso a la Educación Media Superior', true);

SELECT setval('exams_id_seq', 2, true);


-- ─── 2. CONFIGURACIONES DE EXAMEN ────────────────────────────────────────────

INSERT INTO exam_configs (exam_id, version, rules_json, is_active) VALUES
  (1, 1, '{
    "total_duration_minutes": 270,
    "sections": [
      {"section_code": "comprension_lectora", "num_questions": 30},
      {"section_code": "redaccion_indirecta", "num_questions": 30},
      {"section_code": "pensamiento_matematico", "num_questions": 30},
      {"section_code": "modulo_1", "num_questions": 24},
      {"section_code": "modulo_2", "num_questions": 24},
      {"section_code": "ingles_diagnostico", "num_questions": 30}
    ],
    "passing_score_percentage": 60
  }', true),
  
  (2, 1, '{
    "total_duration_minutes": 270,
    "sections": [
      {"section_code": "pensamiento_matematico", "num_questions": 40},
      {"section_code": "pensamiento_cientifico", "num_questions": 30},
      {"section_code": "comprension_lectora", "num_questions": 30},
      {"section_code": "redaccion_indirecta", "num_questions": 30},
      {"section_code": "ingles_diagnostico", "num_questions": 30}
    ],
    "passing_score_percentage": 60
  }', true);


-- ─── 3. SECCIONES (MOCK MÍNIMO) ─────────────────────────────────────────────
-- EXANI-II: 3 transversales + módulos configurables + inglés diagnóstico

INSERT INTO sections (id, exam_id, code, name, type, num_questions, sort_order, is_active) VALUES
  -- EXANI-II Transversales
  (1, 1, 'comprension_lectora', 'Comprensión lectora', 'transversal', 30, 1, true),
  (2, 1, 'redaccion_indirecta', 'Redacción indirecta', 'transversal', 30, 2, true),
  (3, 1, 'pensamiento_matematico', 'Pensamiento matemático', 'transversal', 30, 3, true),
  
  -- EXANI-II Módulos (ejemplo con 4 de los 16 disponibles)
  (4, 1, 'modulo_fisica', 'Física', 'module', 24, 10, true),
  (5, 1, 'modulo_quimica', 'Química', 'module', 24, 11, true),
  (6, 1, 'modulo_probabilidad', 'Probabilidad y estadística', 'module', 24, 12, true),
  (7, 1, 'modulo_administracion', 'Administración', 'module', 24, 13, true),
  
  -- EXANI-II Diagnóstico
  (8, 1, 'ingles_diagnostico', 'Inglés (diagnóstico)', 'diagnostic', 30, 99, true),
  
  -- EXANI-I
  (9, 2, 'pensamiento_matematico', 'Pensamiento matemático', 'transversal', 40, 1, true),
  (10, 2, 'pensamiento_cientifico', 'Pensamiento científico', 'transversal', 30, 2, true),
  (11, 2, 'comprension_lectora', 'Comprensión lectora', 'transversal', 30, 3, true),
  (12, 2, 'redaccion_indirecta', 'Redacción indirecta', 'transversal', 30, 4, true),
  (13, 2, 'ingles_diagnostico', 'Inglés (diagnóstico)', 'diagnostic', 30, 99, true);

SELECT setval('sections_id_seq', 13, true);


-- ─── 4. ÁREAS (MOCK MÍNIMO - 1 área por sección transversal) ────────────────

INSERT INTO areas (id, section_id, code, name, description, weight, sort_order, is_active) VALUES
  -- EXANI-II Comprensión lectora
  (1, 1, 'cl_general', 'Comprensión lectora general', 'Habilidades de lectura y análisis de textos', 1.00, 1, true),
  
  -- EXANI-II Redacción indirecta
  (2, 2, 'ri_general', 'Redacción indirecta general', 'Gramática, ortografía y estructura textual', 1.00, 1, true),
  
  -- EXANI-II Pensamiento matemático
  (3, 3, 'pm_general', 'Pensamiento matemático general', 'Razonamiento lógico-matemático', 1.00, 1, true),
  
  -- EXANI-II Módulos (1 área cada uno por ahora)
  (4, 4, 'fisica_general', 'Física general', 'Mecánica, termodinámica, electromagnetismo', 1.00, 1, true),
  (5, 5, 'quimica_general', 'Química general', 'Estructura atómica, enlaces, reacciones', 1.00, 1, true),
  (6, 6, 'prob_est_general', 'Probabilidad y estadística general', 'Estadística descriptiva e inferencial', 1.00, 1, true),
  (7, 7, 'admin_general', 'Administración general', 'Proceso administrativo y organizaciones', 1.00, 1, true),
  
  -- EXANI-II Inglés diagnóstico
  (8, 8, 'ingles_b1', 'Inglés nivel B1', 'Comprensión lectora y redacción en inglés', 1.00, 1, true),
  
  -- EXANI-I
  (9, 9, 'pm_general', 'Pensamiento matemático general', 'Aritmética, álgebra, geometría', 1.00, 1, true),
  (10, 10, 'pc_general', 'Pensamiento científico general', 'Método científico, biología, física, química', 1.00, 1, true),
  (11, 11, 'cl_general', 'Comprensión lectora general', 'Análisis y comprensión de textos', 1.00, 1, true),
  (12, 12, 'ri_general', 'Redacción indirecta general', 'Gramática y ortografía', 1.00, 1, true),
  (13, 13, 'ingles_a2', 'Inglés nivel A2', 'Comprensión básica en inglés', 1.00, 1, true);

SELECT setval('areas_id_seq', 13, true);


-- ─── 5. HABILIDADES (MOCK MÍNIMO - 3-4 skills por área) ─────────────────────

INSERT INTO skills (id, area_id, code, name, description, sort_order, is_active) VALUES
  -- Área 1: Comprensión lectora EXANI-II
  (1, 1, 'cl_idea_principal', 'Identificar idea principal', 'Reconocer el tema central del texto', 1, true),
  (2, 1, 'cl_inferencias', 'Hacer inferencias', 'Deducir información implícita', 2, true),
  (3, 1, 'cl_proposito', 'Identificar propósito', 'Reconocer la intención del autor', 3, true),
  
  -- Área 2: Redacción indirecta EXANI-II
  (4, 2, 'ri_ortografia', 'Ortografía', 'Uso correcto de grafías y acentos', 1, true),
  (5, 2, 'ri_sintaxis', 'Sintaxis', 'Estructura gramatical de oraciones', 2, true),
  (6, 2, 'ri_cohesion', 'Cohesión textual', 'Conectores y coherencia', 3, true),
  
  -- Área 3: Pensamiento matemático EXANI-II
  (7, 3, 'pm_aritmetica', 'Aritmética', 'Operaciones y proporciones', 1, true),
  (8, 3, 'pm_algebra', 'Álgebra', 'Ecuaciones y expresiones algebraicas', 2, true),
  (9, 3, 'pm_geometria', 'Geometría', 'Figuras, áreas y volúmenes', 3, true),
  
  -- Área 4: Física
  (10, 4, 'fis_mecanica', 'Mecánica', 'Cinemática y dinámica', 1, true),
  (11, 4, 'fis_termodinamica', 'Termodinámica', 'Calor y temperatura', 2, true),
  (12, 4, 'fis_ondas', 'Ondas', 'Movimiento ondulatorio', 3, true),
  
  -- Área 5: Química
  (13, 5, 'quim_atomica', 'Estructura atómica', 'Átomos y tabla periódica', 1, true),
  (14, 5, 'quim_enlaces', 'Enlaces químicos', 'Tipos de enlaces', 2, true),
  (15, 5, 'quim_reacciones', 'Reacciones químicas', 'Balanceo y estequiometría', 3, true),
  
  -- Área 6: Probabilidad y estadística
  (16, 6, 'prob_descriptiva', 'Estadística descriptiva', 'Media, mediana, moda', 1, true),
  (17, 6, 'prob_probabilidad', 'Probabilidad', 'Eventos y combinatoria', 2, true),
  (18, 6, 'prob_inferencial', 'Estadística inferencial', 'Muestreo e hipótesis', 3, true),
  
  -- Área 7: Administración
  (19, 7, 'admin_proceso', 'Proceso administrativo', 'Planeación, organización, dirección, control', 1, true),
  (20, 7, 'admin_organizaciones', 'Teoría de organizaciones', 'Estructuras organizacionales', 2, true),
  (21, 7, 'admin_rh', 'Recursos humanos', 'Gestión del talento', 3, true),
  
  -- Área 8: Inglés EXANI-II
  (22, 8, 'ing_reading', 'Reading comprehension', 'Comprensión de textos en inglés', 1, true),
  (23, 8, 'ing_grammar', 'Grammar', 'Gramática y estructura', 2, true),
  (24, 8, 'ing_vocabulary', 'Vocabulary', 'Vocabulario en contexto', 3, true),
  
  -- Área 9: Pensamiento matemático EXANI-I
  (25, 9, 'pm_aritmetica', 'Aritmética', 'Operaciones básicas', 1, true),
  (26, 9, 'pm_algebra_basica', 'Álgebra básica', 'Ecuaciones lineales', 2, true),
  (27, 9, 'pm_geometria_basica', 'Geometría básica', 'Perímetros y áreas', 3, true),
  
  -- Área 10: Pensamiento científico EXANI-I
  (28, 10, 'pc_metodo', 'Método científico', 'Observación, hipótesis, experimentación', 1, true),
  (29, 10, 'pc_biologia', 'Biología básica', 'Células, organismos, ecosistemas', 2, true),
  (30, 10, 'pc_fisica_basica', 'Física básica', 'Movimiento, fuerza, energía', 3, true),
  
  -- Área 11: Comprensión lectora EXANI-I
  (31, 11, 'cl_idea_principal', 'Identificar idea principal', 'Tema central del texto', 1, true),
  (32, 11, 'cl_detalles', 'Identificar detalles', 'Información específica', 2, true),
  (33, 11, 'cl_vocabulario', 'Vocabulario en contexto', 'Significado de palabras', 3, true),
  
  -- Área 12: Redacción indirecta EXANI-I
  (34, 12, 'ri_ortografia_basica', 'Ortografía básica', 'Uso de mayúsculas y acentos', 1, true),
  (35, 12, 'ri_puntuacion', 'Puntuación', 'Uso de signos de puntuación', 2, true),
  (36, 12, 'ri_coherencia', 'Coherencia', 'Orden lógico de ideas', 3, true),
  
  -- Área 13: Inglés EXANI-I
  (37, 13, 'ing_reading_a2', 'Reading A2', 'Comprensión básica de textos', 1, true),
  (38, 13, 'ing_grammar_a2', 'Grammar A2', 'Gramática básica', 2, true),
  (39, 13, 'ing_vocabulary_a2', 'Vocabulary A2', 'Vocabulario cotidiano', 3, true);

SELECT setval('skills_id_seq', 39, true);


-- ─── 6. CONJUNTOS DE PREGUNTAS ──────────────────────────────────────────────

INSERT INTO question_sets (id, exam_id, name, description, is_active, activated_at) VALUES
  (1, 1, 'EXANI-II v1.0', 'Banco de preguntas inicial EXANI-II', true, now()),
  (2, 2, 'EXANI-I v1.0', 'Banco de preguntas inicial EXANI-I', true, now());

SELECT setval('question_sets_id_seq', 2, true);


-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTA: Las preguntas reales se agregarán después mediante:
-- INSERT INTO questions (skill_id, set_id, stem, options_json, correct_key, ...)
-- ═══════════════════════════════════════════════════════════════════════════════


-- ─── 7. PREGUNTAS DE EJEMPLO (3 MOCK para testing) ──────────────────────────

INSERT INTO questions (skill_id, set_id, stem, stem_image, stem_images_json, options_json, correct_key, explanation, explanation_images_json, difficulty, tags_json, source, is_active) VALUES
  -- Pregunta 1: Comprensión lectora
  (1, 1, 
   'Lee el siguiente fragmento: "La fotosíntesis es el proceso mediante el cual las plantas convierten la luz solar en energía química." ¿Cuál es la idea principal?',
   NULL,
   '[]'::jsonb,
   '[
     {"key": "a", "text": "Las plantas necesitan agua", "image": null},
     {"key": "b", "text": "Las plantas convierten luz en energía", "image": null},
     {"key": "c", "text": "El sol emite luz", "image": null}
   ]'::jsonb,
   'b',
   'La idea principal es la conversión de luz solar en energía química por parte de las plantas.',
   '[]'::jsonb,
   'easy',
   '["comprension_lectora", "idea_principal"]'::jsonb,
   'Mock question',
   true),
  
  -- Pregunta 2: Redacción indirecta
  (4, 1,
   '¿Qué palabra está mal escrita?',
   NULL,
   '[]'::jsonb,
   '[
     {"key": "a", "text": "Exámen", "image": null},
     {"key": "b", "text": "Emoción", "image": null},
     {"key": "c", "text": "Situación", "image": null}
   ]'::jsonb,
   'a',
   'La palabra correcta es "examen" (sin tilde). Las palabras graves terminadas en "n" no llevan acento.',
   '[]'::jsonb,
   'medium',
   '["ortografia", "acentuacion"]'::jsonb,
   'Mock question',
   true),
  
  -- Pregunta 3: Pensamiento matemático
  (7, 1,
   'Si x + 5 = 12, ¿cuánto vale x?',
   NULL,
   '[]'::jsonb,
   '[
     {"key": "a", "text": "5", "image": null},
     {"key": "b", "text": "7", "image": null},
     {"key": "c", "text": "17", "image": null}
   ]'::jsonb,
   'b',
   'Despejando: x = 12 - 5 = 7',
   '[]'::jsonb,
   'easy',
   '["algebra", "ecuaciones_lineales"]'::jsonb,
   'Mock question',
   true);


-- ═══════════════════════════════════════════════════════════════════════════════
-- FIN DEL SEED
-- Los datos reales de estructura (más sections, areas, skills) y preguntas
-- se agregarán manualmente después.
-- ═══════════════════════════════════════════════════════════════════════════════
