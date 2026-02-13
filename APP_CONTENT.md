Perfecto: **MVP con EXANI-II fuerte + EXANI-I básico**, usando **Supabase**, y tu **base UI tipo Duolingo**. Te dejo una **documentación de referencia (tipo CONTEXT.md)** para tu agente, y luego un set de **prompts listos** para ir construyendo el MVP de forma sólida.

Para el modelado:

- **EXANI-I** (prepa) tiene 4 áreas que componen puntaje global (Pensamiento matemático 40, Redacción indirecta 30, Comprensión lectora 30, Pensamiento científico 30) + Inglés diagnóstico 30. ([Ceneval][1])
- **EXANI-II** (universidad) se aplica en una sola sesión (máx 4.5h) y su estructura típica incluye 2 módulos disciplinares (24+24) + 3 áreas transversales (30+30+30) + Inglés diagnóstico 30. ([Ceneval][2])

---

## Documentación de referencia para el agente (CONTEXT.md)

### 1) Visión del producto

**Nombre provisional:** Forja / IngresoPro (placeholder)
**Objetivo:** Ser la app más efectiva y profesional para prepararse para exámenes de ingreso en México, iniciando con:

- **EXANI-II (fuerte)**
- **EXANI-I (básico)**

**Propuesta de valor:**

1. Preparación **estratégica** (diagnóstico → plan → práctica adaptativa → simulacros).
2. UX “Duolingo-like” pero **seria** (animaciones, micro-metas, rachas, feedback claro).
3. Métricas profesionales: progreso por área/habilidad, tiempos, precisión, tendencia.

### 2) Alcance del MVP

#### EXANI-II (fuerte)

- Soporta estructura real:
  - Áreas transversales: **Comprensión lectora (30), Redacción indirecta (30), Pensamiento matemático (30)** ([Ceneval][2])
  - Módulos disciplinares: **2 módulos (24 + 24)**, seleccionables (menú de módulos).
  - Inglés diagnóstico (30) (no afecta puntaje global). ([Ceneval][2])

- Contenido inicial recomendado (para “fuerte” pero realista):
  - Transversales: banco robusto (ej. 800–1500 preguntas total, distribuido por habilidades).
  - Módulos: lanzar con 2–4 módulos populares (p.ej. “Probabilidad y estadística”, “Física”, “Química”, “Administración”), y permitir agregar más sin re-arquitectura.

#### EXANI-I (básico)

- Soporta estructura real:
  - Pensamiento matemático 40
  - Pensamiento científico 30
  - Comprensión lectora 30
  - Redacción indirecta 30
  - Inglés diagnóstico 30 ([Ceneval][1])

- Contenido inicial “básico”:
  - 250–500 preguntas total (repartidas en las 4 áreas del puntaje global).
  - 1 simulacro “lite”.

### 3) Principios de diseño (serio, no infantil)

- UI limpia, confiable, “académica moderna”.
- Gamificación con propósito: rachas, metas, ranking semanal **opcional** (sin humillar).
- Explicaciones claras, sin chistes ni tono caricaturesco.
- Accesibilidad: tamaño de letra, modo oscuro, offline (mínimo: guardar sesiones y preguntas descargadas).

### 4) Flujos core del usuario

1. **Onboarding**
   - Elegir examen: EXANI-II / EXANI-I
   - Elegir fecha objetivo (opcional)
   - (EXANI-II) elegir 2 módulos disciplinares (o “aún no sé” → default sugerido)

2. **Diagnóstico**
   - Mini-diagnóstico por examen (20–40 reactivos)
   - Resultado: nivel por área + recomendaciones

3. **Plan de estudio**
   - Plan semanal (metas diarias)
   - “Siguiente mejor acción” (Next Best Session)

4. **Práctica**
   - Sesiones cortas (5–15 preguntas)
   - Dificultad adaptativa
   - Explicación y error típico
   - Guardar “preguntas falladas” y “dudosas”

5. **Simulacro**
   - Simulacro por examen (EXANI-II con estructura real y temporizador; EXANI-I lite en MVP)
   - Reporte: score estimado, precisión por área, tiempo por pregunta

6. **Progreso**
   - Dashboard por examen → área → habilidad
   - Tendencia semanal (mejorando/empeorando)

### 5) Modelo de contenido (para no errar)

#### Jerarquía

- **Exam** (EXANI-II / EXANI-I)
  - **Section** (Transversal / Módulo / Diagnóstico)
    - **Area** (p.ej. Comprensión lectora)
      - **Skill** (micro-habilidad: inferencias, idea principal, etc.)
        - **Question**

#### Tipos de preguntas

- Opción múltiple (3 opciones es común en EXANI-II; diseña el engine para soportar 3–4 opciones por si varía) ([Ceneval][2])
- Explicación obligatoria en preguntas “core” (especialmente las de práctica adaptativa)

### 6) Entidades y datos (Supabase / PostgreSQL)

**Tablas mínimas (MVP):**

- `profiles` (user_id, name, exam_goal_id?, created_at)
- `exams` (id, code, name, level)
- `exam_configs` (exam_id, rules_json: #preguntas por área, duración, etc.)
- `sections` (id, exam_id, type: transversal|module|diagnostic)
- `areas` (id, section_id, name, weight?, order)
- `skills` (id, area_id, name, order)
- `question_sets` (id, exam*id, name, is_active) \_para versionar bancos*
- `questions` (id, skill_id, set_id, stem, options_json, correct_key, explanation, difficulty, tags_json, source?)
- `attempts` (id, user_id, question_id, is_correct, chosen_key, time_ms, mode: practice|diagnostic|sim, created_at)
- `sessions` (id, user_id, exam_id, mode, started_at, ended_at, config_snapshot_json)
- `session_questions` (session_id, question_id, order, chosen_key, is_correct, time_ms)
- `leaderboards_weekly` (exam_id, week_start_date, user_id, score, time_ms, attempts_count)

**Notas clave de modelado**

- Guarda siempre un `config_snapshot_json` en `sessions` para que un simulacro sea reproducible aunque cambie el banco/reglas.
- `question_sets` permite actualizar contenido sin romper reportes históricos.

### 7) Seguridad y permisos (RLS)

- RLS ON en todo lo sensible.
- `profiles`: usuario solo ve/edita su perfil.
- `attempts/sessions/session_questions`: usuario solo ve los suyos.
- Tablas de contenido (`questions`, `skills`, etc.) lectura pública o por “is_active”, según monetización.

### 8) Algoritmo de práctica (simple pero efectivo)

**Prioridad de preguntas =**

- Preguntas falladas recientemente (alto)
- Habilidades con baja precisión (alto)
- Preguntas nuevas (medio)
- Repaso espaciado (medio)

Guardar por usuario:

- `user_skill_stats` (accuracy, avg_time, last_practiced_at, streak)

### 9) Estándar de calidad (MVP “profesional”)

- Tiempo de arranque < 2s (pantalla cache + precarga ligera)
- Offline mínimo: última sesión + banco descargado por área
- Animaciones suaves, sin saturar
- Textos cuidados, consistentes, sin faltas

---

## Prompts para tu agente IA (lista lista para ejecutar)

> **Uso sugerido:** dale estos prompts uno por uno a tu agente. Cada prompt debe producir entregables concretos (SQL, estructura, pantallas, etc.).

### Prompt 1 — Product Spec + checklist MVP

```text
Actúa como Product Owner + Tech Lead. Con base en el documento CONTEXT.md (pegado abajo), genera:
1) Un PRD del MVP (EXANI-II fuerte + EXANI-I básico) con alcance exacto, fuera de alcance, criterios de aceptación.
2) Un backlog priorizado por épicas e historias (con estimación t-shirt: S/M/L).
3) Un plan de releases (v0.1, v0.2, v1.0) enfocado en lanzar rápido pero profesional.
Entrega en Markdown.
CONTEXT.md:
[PEGA AQUÍ EL CONTEXT.md]
```

### Prompt 2 — Esquema SQL Supabase (tablas + índices + constraints)

```text
Eres un arquitecto de datos. Diseña el esquema PostgreSQL para Supabase del MVP:
- Tablas: profiles, exams, exam_configs, sections, areas, skills, question_sets, questions, sessions, session_questions, attempts, leaderboards_weekly, user_skill_stats
- Incluye PK/FK, índices, constraints útiles, tipos enum donde convenga, y campos JSONB donde sea adecuado.
- Incluye scripts SQL listos para ejecutar.
- Incluye notas sobre cómo versionar bancos (question_sets) y reproducir simulacros (config_snapshot_json).
```

### Prompt 3 — Políticas RLS (seguridad real)

```text
Eres experto en Supabase RLS. Escribe:
- ENABLE RLS en tablas necesarias
- Policies para: profiles, attempts, sessions, session_questions, user_skill_stats (solo dueño)
- Policies para lectura de contenido: exams/areas/skills/questions solo si is_active=true o role=admin
- Incluye SQL completo de policies y una guía breve de pruebas.
```

### Prompt 4 — Seed inicial (EXANI-II y EXANI-I) + estructura de contenidos

```text
Actúa como Content Engineer. Define un seed mínimo de estructura (sin preguntas aún):
- exams: EXANI-II y EXANI-I
- sections/areas según estructura oficial
- skills: al menos 8-12 skills por área transversal EXANI-II; 5-8 skills por área EXANI-I
Devuelve inserts SQL + justificación de skills y naming consistente.
Nota: EXANI-I incluye Pensamiento científico, Comprensión lectora, Redacción indirecta, Pensamiento matemático; EXANI-II incluye Comprensión lectora, Redacción indirecta, Pensamiento matemático + 2 módulos disciplinares configurables + Inglés diagnóstico.
```

### Prompt 5 — Motor de sesión (diagnóstico, práctica, simulacro)

```text
Eres Flutter Lead. Diseña el “session engine” reusable para 3 modos: diagnostic, practice, simulation.
Requisitos:
- Crea session en DB con config_snapshot_json
- Obtiene preguntas por skill/area y aplica algoritmo de selección (falladas > débiles > nuevas > repaso)
- Registra session_questions y attempts con time_ms
- Permite resume/retry
Entrega:
- Diagrama de estados
- Interfaces/dtos
- Pseudocódigo del selector
- Estructura de carpetas en Flutter (clean architecture)
```

### Prompt 6 — Ranking semanal justo (no solo rapidez)

```text
Diseña el leaderboard semanal por examen:
- Fórmula que combine precisión (peso mayor), tiempo (peso menor), y consistencia.
- Prevención básica de trampas (tiempos absurdos, sesiones incompletas, etc.)
- SQL para generar leaderboards_weekly (cron/edge function)
- UX recomendada para mostrar ranking sin frustrar novatos.
```

### Prompt 7 — Pantallas MVP (Duolingo-like, serio)

```text
Eres UX/UI + Flutter implementer. Propón y especifica pantallas MVP:
1) Selección de examen (EXANI-II / EXANI-I)
2) Onboarding (meta, módulos EXANI-II)
3) Diagnóstico + resultados
4) Home con “Next Best Session”
5) Práctica por área/habilidad
6) Simulacro
7) Reporte y progreso
Para cada pantalla: layout, componentes, estados, animaciones (ligeras), y navegación.
Entrega lista de widgets y componentes reusables.
```

### Prompt 8 — Estrategia offline mínima

```text
Define una estrategia offline MVP:
- Cache local (Hive/Drift) de estructura + últimas preguntas consultadas
- Cola de eventos (attempts) para sincronizar cuando haya conexión
- Reglas de resolución de conflictos
Entrega implementación propuesta + responsabilidades por capa.
```

### Prompt 9 — Telemetría y métricas producto

```text
Diseña eventos de analytics para medir:
- Activación (diagnóstico completado)
- Retención (D1/D7)
- Efectividad (mejora de precisión por área)
- Conversión a premium (si aplica)
Incluye nombres de eventos y propiedades.
```

---

## Prompt extra (muy útil): “modo auditor” para no errar con EXANI

```text
Antes de generar cualquier modelo/feature, valida que la estructura del examen en el diseño sea coherente con la estructura oficial (áreas y número de reactivos). Si detectas discrepancias, corrige el diseño y explícitalo. Trabaja con EXANI-II y EXANI-I.
```

---

Si me pegas **cómo se llama tu app base** y si ya tienes un `CONTEXT.md` actual (aunque sea corto), te lo adapto a tu repo/arquitectura real (Flutter: layers, servicios, naming, y hasta tus convenciones). Además, si vas a empezar por Supabase, te puedo dejar el **SQL + RLS** ya cerrado para que literalmente copies/pegues y arranques.

[1]: https://ceneval.edu.mx/examenes-ingreso-exani_i/?utm_source=chatgpt.com "Nivel Medio Superior EXANI I"
[2]: https://ceneval.edu.mx/examenes-ingreso-exani_ii/ "Nivel Superior EXANI II - Ceneval"
