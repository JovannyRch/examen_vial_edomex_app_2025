# PRD — MVP EXANI Prep App

> Product Requirements Document — v1.0
> Fecha: 2026-02-12

---

## 1. Visión del Producto

**Nombre provisional:** EXANI Prep (placeholder)

**Objetivo:** Transformar el template base de quiz/examen (actualmente orientado a examen vial EdoMex)
en la app más efectiva para prepararse para los exámenes de ingreso EXANI en México.

**Usuarios target:** Estudiantes mexicanos que presentarán EXANI-II (ingreso a universidad) o
EXANI-I (ingreso a preparatoria) en los próximos 1–6 meses.

**Propuesta de valor:**

1. Preparación **estratégica**: diagnóstico → plan → práctica adaptativa → simulacros.
2. UX Duolingo-like pero **seria**: animaciones, micro-metas, rachas, feedback claro.
3. Métricas profesionales: progreso por área/habilidad, tiempos, precisión, tendencia.

---

## 2. Estado Actual del Template

### Lo que ya existe (reutilizable)

| Componente                           | Estado         | Reutilizable                                                  |
| ------------------------------------ | -------------- | ------------------------------------------------------------- |
| Design System Duolingo-like          | ✅ Completo    | 100% — colores, botones 3D, animaciones                       |
| ThemeService (dark/light)            | ✅ Funcional   | 100%                                                          |
| AdMobService (banner + interstitial) | ✅ Funcional   | 100%                                                          |
| SoundService                         | ✅ Funcional   | 100%                                                          |
| NotificationService                  | ✅ Funcional   | 100%                                                          |
| PurchaseService (IAP Pro)            | ✅ Funcional   | 100%                                                          |
| DatabaseService (SQLite)             | ✅ Funcional   | ~60% — necesita nuevas tablas                                 |
| Modelos (Question/Option)            | ✅ Actualizado | 90% — ya soporta imágenes, dificultad, tags                   |
| ContentImage widgets                 | ✅ Nuevo       | 100% — renderiza imágenes en preguntas/opciones/explicaciones |
| ExamScreen (simulacro)               | ✅ Funcional   | ~70% — necesita adaptar a estructura EXANI                    |
| GuideScreen                          | ✅ Funcional   | ~80% — ya soporta imágenes y explicaciones                    |
| ReviewScreen                         | ✅ Funcional   | ~85% — ya soporta imágenes en opciones/explicaciones          |
| HomeScreen                           | ✅ Funcional   | ~40% — necesita rediseño para selección de examen             |
| CategoryScreen                       | ✅ Funcional   | ~50% — renombrar a áreas/habilidades                          |
| ProgressScreen                       | ✅ Funcional   | ~50% — adaptar métricas                                       |
| FavoritesScreen                      | ✅ Funcional   | ~90%                                                          |
| ProScreen                            | ✅ Funcional   | 100%                                                          |

### Lo que NO existe (hay que construir)

- Selección de examen (EXANI-II / EXANI-I)
- Onboarding (meta, módulos)
- Diagnóstico
- Jerarquía de contenido (Exam → Section → Area → Skill → Question)
- Algoritmo de selección adaptativa
- Simulacro con estructura real EXANI (secciones, tiempos)
- Dashboard de progreso por área/habilidad
- Integración con Supabase (backend remoto)
- Leaderboard semanal

---

## 3. Alcance del MVP

### 3.1 EN ALCANCE ✅

#### EXANI-II (fuerte)

- **Áreas transversales:**
  - Comprensión lectora (30 reactivos)
  - Redacción indirecta (30 reactivos)
  - Pensamiento matemático (30 reactivos)
- **Módulos disciplinares:**
  - 2 módulos seleccionables (24 + 24 reactivos)
  - Lanzar con 2–4 módulos populares (ej: "Probabilidad y estadística", "Física", "Química", "Administración")
  - Arquitectura para agregar módulos sin re-diseño
- **Inglés diagnóstico** (30 reactivos, no afecta puntaje global)
- **Banco de contenido:** 800–1500 preguntas total (transversales + módulos iniciales)

#### EXANI-I (básico)

- **Áreas:**
  - Pensamiento matemático (40 reactivos)
  - Pensamiento científico (30 reactivos)
  - Comprensión lectora (30 reactivos)
  - Redacción indirecta (30 reactivos)
- **Inglés diagnóstico** (30 reactivos)
- **Banco de contenido:** 250–500 preguntas total
- **1 simulacro lite**

#### Flujos core

1. **Selección de examen** — EXANI-II / EXANI-I
2. **Onboarding** — Fecha objetivo, módulos disciplinares (EXANI-II)
3. **Diagnóstico** — Mini-test por examen (20–40 reactivos)
4. **Práctica por área/habilidad** — Sesiones cortas (5–15 preguntas), dificultad adaptativa
5. **Simulacro** — Estructura real del examen con temporizador
6. **Revisión post-examen** — Con explicaciones e imágenes
7. **Progreso** — Dashboard por examen → área → habilidad

#### Monetización

- **Gratis:** Diagnóstico + práctica limitada (N preguntas/día) + 1 simulacro
- **Pro (IAP):** Práctica ilimitada + todos los simulacros + sin ads + estadísticas avanzadas

#### Datos y backend

- **SQLite local** para resultados, favoritos, progreso offline
- **Supabase** para banco de preguntas remoto, sincronización, leaderboard
- Modelo de contenido: `Exam → Section → Area → Skill → Question`

#### Rich content (ya implementado)

- Preguntas con imágenes (principal + múltiples)
- Opciones con imágenes
- Explicaciones con imágenes
- Soporte para assets locales y URLs remotas

### 3.2 FUERA DE ALCANCE ❌ (post-MVP)

- Otros exámenes (EXANI-III, TOEFL, etc.)
- Más de 4 módulos disciplinares EXANI-II
- Chat/comunidad de estudiantes
- Video explicaciones
- Generación de contenido con IA
- Versión web / desktop
- Push notifications personalizadas por progreso
- Gamificación avanzada (logros, badges, niveles)
- Repaso espaciado con algoritmo SM-2
- Reportes PDF descargables
- Multi-idioma
- Apple IAP (solo Google Play en MVP)

---

## 4. Criterios de Aceptación del MVP

### CA-01: Selección de examen

- [ ] El usuario puede elegir entre EXANI-II y EXANI-I desde la pantalla principal
- [ ] La elección se persiste y se muestra en la UI

### CA-02: Onboarding

- [ ] El usuario puede establecer fecha objetivo (opcional)
- [ ] (EXANI-II) El usuario puede seleccionar 2 módulos disciplinares
- [ ] Opción "No sé" sugiere módulos default

### CA-03: Diagnóstico

- [ ] Mini-test de 20–40 preguntas que cubre todas las áreas del examen elegido
- [ ] Resultado muestra nivel por área (bajo/medio/alto)
- [ ] Se puede retomar si no se completó

### CA-04: Práctica

- [ ] Sesiones de 5–15 preguntas por área/habilidad seleccionada
- [ ] Preguntas con imágenes se renderizan correctamente
- [ ] Opciones con imágenes se renderizan correctamente
- [ ] Explicación con imágenes se muestra en revisión
- [ ] Algoritmo prioriza: falladas > habilidades débiles > nuevas
- [ ] Se registra tiempo por pregunta

### CA-05: Simulacro

- [ ] EXANI-II: estructura real (3 transversales + 2 módulos + inglés) con temporizador
- [ ] EXANI-I: versión lite (todas las áreas) con temporizador
- [ ] Reporte: score estimado, precisión por área, tiempo por pregunta
- [ ] Se puede revisar respuestas post-simulacro

### CA-06: Progreso

- [ ] Dashboard por examen con gráfica de tendencia
- [ ] Desglose por área y por habilidad
- [ ] Métricas: precisión, tiempo promedio, preguntas vistas, racha

### CA-07: Contenido

- [ ] Mínimo 200 preguntas EXANI-II (transversales) al lanzar
- [ ] Mínimo 100 preguntas EXANI-I al lanzar
- [ ] Cada pregunta tiene explicación
- [ ] Banco versionable (question_sets)

### CA-08: Offline

- [ ] La app funciona sin internet (preguntas descargadas localmente)
- [ ] Resultados se guardan local y sincronizan cuando hay conexión

### CA-09: Monetización

- [ ] Banner ads en pantallas principales (no durante examen)
- [ ] Interstitial después de simulacro
- [ ] Compra Pro elimina ads y desbloquea contenido
- [ ] Restaurar compras funciona

### CA-10: Calidad

- [ ] Arranque < 2s
- [ ] Sin crashes en flujo core
- [ ] Dark/light mode funcional
- [ ] Animaciones fluidas (60fps)

---

## 5. Backlog Priorizado por Épicas

### Épica 1: Modelo de Datos y Backend 🗄️

| #   | Historia                                                                               | Size | Prioridad |
| --- | -------------------------------------------------------------------------------------- | ---- | --------- |
| 1.1 | Diseñar esquema SQL Supabase (exams, sections, areas, skills, questions, etc.)         | M    | P0        |
| 1.2 | Implementar políticas RLS (seguridad)                                                  | S    | P0        |
| 1.3 | Crear seed de estructura (exams + sections + areas + skills sin preguntas)             | S    | P0        |
| 1.4 | Crear SupabaseService en Flutter (init, auth anónimo, queries)                         | M    | P0        |
| 1.5 | Migrar DatabaseService local para nuevas tablas (attempts, sessions, user_skill_stats) | M    | P0        |
| 1.6 | Sincronización offline: cola de eventos + resolución de conflictos                     | L    | P1        |

### Épica 2: Jerarquía de Contenido y Navegación 🧭

| #   | Historia                                                                | Size | Prioridad |
| --- | ----------------------------------------------------------------------- | ---- | --------- |
| 2.1 | Crear modelos Dart: Exam, Section, Area, Skill (+ mapeo desde Supabase) | M    | P0        |
| 2.2 | Pantalla de selección de examen (EXANI-II / EXANI-I)                    | S    | P0        |
| 2.3 | Adaptar HomeScreen para mostrar contenido del examen seleccionado       | M    | P0        |
| 2.4 | Adaptar CategoryScreen → AreaScreen (navegar por áreas del examen)      | M    | P0        |
| 2.5 | Crear SkillScreen (práctica por habilidad dentro de un área)            | S    | P1        |

### Épica 3: Onboarding 🚀

| #   | Historia                                                  | Size | Prioridad |
| --- | --------------------------------------------------------- | ---- | --------- |
| 3.1 | Pantalla de onboarding: elegir examen + fecha objetivo    | M    | P0        |
| 3.2 | (EXANI-II) Selector de módulos disciplinares              | S    | P0        |
| 3.3 | Persistir preferencias del usuario (exam, módulos, fecha) | S    | P0        |
| 3.4 | Flujo "primera vez" vs "ya configurado"                   | S    | P1        |

### Épica 4: Diagnóstico 🔍

| #   | Historia                                                                | Size | Prioridad |
| --- | ----------------------------------------------------------------------- | ---- | --------- |
| 4.1 | Motor de diagnóstico: seleccionar N preguntas cubriendo todas las áreas | M    | P0        |
| 4.2 | Pantalla de resultados diagnóstico (nivel por área, recomendaciones)    | M    | P0        |
| 4.3 | Guardar resultados diagnóstico en DB (local + remoto)                   | S    | P0        |

### Épica 5: Motor de Sesión (Session Engine) ⚙️

| #   | Historia                                                                   | Size | Prioridad |
| --- | -------------------------------------------------------------------------- | ---- | --------- |
| 5.1 | Diseñar session engine reutilizable (diagnostic, practice, simulation)     | L    | P0        |
| 5.2 | Algoritmo de selección de preguntas (falladas > débiles > nuevas > repaso) | M    | P0        |
| 5.3 | Registrar session_questions + attempts con time_ms                         | M    | P0        |
| 5.4 | Calcular y actualizar user_skill_stats tras cada sesión                    | M    | P1        |

### Épica 6: Simulacro con Estructura Real 📋

| #   | Historia                                                              | Size | Prioridad |
| --- | --------------------------------------------------------------------- | ---- | --------- |
| 6.1 | Adaptar ExamScreen para múltiples secciones (transversales + módulos) | L    | P0        |
| 6.2 | Temporizador por sección (no solo global)                             | M    | P0        |
| 6.3 | Reporte post-simulacro: score estimado, precisión por área, tiempos   | M    | P0        |
| 6.4 | config_snapshot_json para reproducibilidad                            | S    | P1        |

### Épica 7: Progreso y Estadísticas 📊

| #   | Historia                                                | Size | Prioridad |
| --- | ------------------------------------------------------- | ---- | --------- |
| 7.1 | Dashboard de progreso por examen (gráfica de tendencia) | M    | P0        |
| 7.2 | Desglose por área con precisión y tiempo                | M    | P0        |
| 7.3 | Desglose por habilidad (micro-nivel)                    | S    | P1        |
| 7.4 | "Next Best Session" en HomeScreen                       | M    | P1        |

### Épica 8: Contenido 📚

| #   | Historia                                                             | Size | Prioridad |
| --- | -------------------------------------------------------------------- | ---- | --------- |
| 8.1 | Crear pipeline de ingesta de preguntas (formato JSON/CSV → Supabase) | M    | P0        |
| 8.2 | Cargar banco inicial EXANI-II transversales (200+ preguntas)         | L    | P0        |
| 8.3 | Cargar banco inicial EXANI-I (100+ preguntas)                        | M    | P0        |
| 8.4 | Cargar 2 módulos disciplinares EXANI-II (50+ c/u)                    | M    | P1        |
| 8.5 | Sistema de question_sets (versionado de bancos)                      | S    | P1        |

### Épica 9: Leaderboard 🏆

| #   | Historia                                                      | Size | Prioridad |
| --- | ------------------------------------------------------------- | ---- | --------- |
| 9.1 | Diseñar fórmula de ranking (precisión × peso + tiempo × peso) | S    | P2        |
| 9.2 | Edge function para generar leaderboard semanal                | M    | P2        |
| 9.3 | Pantalla de ranking                                           | M    | P2        |

### Épica 10: Polish y Launch 🎯

| #    | Historia                                            | Size | Prioridad |
| ---- | --------------------------------------------------- | ---- | --------- |
| 10.1 | Actualizar textos, títulos, nombres de secciones    | S    | P0        |
| 10.2 | Nuevo logo y splash screen                          | S    | P0        |
| 10.3 | Configurar AdMob IDs de producción                  | S    | P0        |
| 10.4 | Configurar IAP product en Google Play Console       | S    | P0        |
| 10.5 | Telemetría básica (eventos de analytics)            | M    | P1        |
| 10.6 | Play Store listing (screenshots, descripción, etc.) | M    | P0        |

---

## 6. Plan de Releases

### v0.1 — "Foundation" (2–3 semanas)

**Objetivo:** Estructura de datos, navegación base, y contenido mínimo jugable.

**Entregables:**

- Esquema Supabase completo (tablas + RLS + seed)
- SupabaseService en Flutter
- Modelos Dart (Exam, Section, Area, Skill)
- Pantalla de selección de examen
- Onboarding básico (examen + módulos)
- HomeScreen adaptado al examen seleccionado
- AreaScreen (ex-CategoryScreen) con áreas del examen
- 50+ preguntas de ejemplo cargadas
- Práctica por área funcional (usando session engine básico)

**Lo que NO incluye:** Diagnóstico, simulacro real, leaderboard, offline sync.

### v0.2 — "Core Experience" (2–3 semanas)

**Objetivo:** Flujo completo de preparación: diagnóstico → práctica adaptativa → simulacro.

**Entregables:**

- Motor de diagnóstico + pantalla de resultados
- Algoritmo de selección adaptativa
- user_skill_stats calculados
- Simulacro EXANI-II con estructura real (secciones + temporizador)
- Simulacro EXANI-I lite
- Dashboard de progreso por examen y área
- "Next Best Session"
- Banco 200+ preguntas EXANI-II, 100+ EXANI-I
- Pipeline de ingesta de contenido
- Offline básico (preguntas cacheadas localmente)

**Lo que NO incluye:** Leaderboard, módulos disciplinares extras, polish final.

### v1.0 — "Launch" (1–2 semanas)

**Objetivo:** App lista para publicar en Play Store.

**Entregables:**

- 2 módulos disciplinares EXANI-II cargados
- Question sets (versionado)
- Leaderboard semanal
- Telemetría (analytics básicos)
- Logo, splash, textos finales
- AdMob producción + IAP configurado
- Play Store listing completo
- Bug fixes y polish
- Config snapshot para simulacros reproducibles

---

## 7. Métricas de Éxito (post-launch)

| Métrica                  | Target 30 días    |
| ------------------------ | ----------------- |
| Instalaciones            | 1,000+            |
| Retención D1             | > 40%             |
| Retención D7             | > 20%             |
| Diagnósticos completados | > 60% de installs |
| Simulacros completados   | > 30% de installs |
| Conversión a Pro         | > 3%              |
| Rating Play Store        | > 4.2             |

---

## 8. Riesgos y Mitigaciones

| Riesgo                             | Probabilidad | Impacto | Mitigación                                                                   |
| ---------------------------------- | ------------ | ------- | ---------------------------------------------------------------------------- |
| Contenido insuficiente al lanzar   | Alta         | Alto    | Pipeline de ingesta automatizado + priorizar calidad sobre cantidad          |
| Estructura EXANI cambia            | Baja         | Alto    | exam_configs flexible (JSON), question_sets versionables                     |
| Latencia Supabase en zonas rurales | Media        | Medio   | Offline-first: todo funciona local, sync en background                       |
| Competencia ya establecida         | Alta         | Medio   | Diferenciación en UX (Duolingo-like) y explicaciones de calidad              |
| Problemas legales por usar "EXANI" | Baja         | Alto    | Verificar lineamientos de Ceneval, usar "preparación para examen de ingreso" |
