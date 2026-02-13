import 'package:exani/models/option.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  📦 DATOS DE EJEMPLO — REEMPLAZAR CON TUS PREGUNTAS
//
//  Instrucciones:
//  1. Define tus categorías en QuestionCategory (lib/models/option.dart)
//  2. Agrega tus preguntas aquí con la estructura Question(...)
//  3. Cada pregunta necesita: id, text, options, correctOptionId, category
//  4. El campo 'explanation' es opcional pero recomendado para la revisión
//  5. Asegúrate de que correctOptionId coincida con el id de la opción correcta
//
//  Campos nuevos disponibles (todos opcionales):
//  - imagePath: Imagen principal del enunciado (asset o URL)
//  - stemImages: Lista de imágenes adicionales en el enunciado
//  - explanationImages: Imágenes que acompañan la explicación
//  - difficulty: QuestionDifficulty.easy / .medium / .hard
//  - tags: Lista de etiquetas para filtrado flexible
//  - Option.imagePath: Imagen en una opción de respuesta
// ═══════════════════════════════════════════════════════════════════════════════

final List<Question> questions = [
  // ─── Ejemplo 1: Pregunta solo texto (retrocompatible) ──────────────────────
  Question(
    id: 1,
    text: '¿Pregunta de ejemplo número 1?',
    options: [
      Option(id: 1, text: 'Respuesta correcta'),
      Option(id: 2, text: 'Distractor A'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Explicación de por qué esta es la respuesta correcta.',
  ),

  // ─── Ejemplo 2: Pregunta con imagen en el enunciado ────────────────────────
  // Para EXANI: gráficas, tablas, diagramas, figuras geométricas
  Question(
    id: 2,
    text: '¿Qué indica la siguiente señal de tránsito?',
    imagePath: 'assets/images/senal_ejemplo.png', // imagen principal
    options: [
      Option(id: 1, text: 'Distractor A'),
      Option(id: 2, text: 'Respuesta correcta'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 2,
    category: QuestionCategory.senales,
    explanation: 'Explicación de la respuesta correcta.',
    difficulty: QuestionDifficulty.easy,
  ),

  // ─── Ejemplo 3: Opciones con imágenes ──────────────────────────────────────
  // Para EXANI: identificar figuras, señales, gráficas como opciones
  Question(
    id: 3,
    text: '¿Cuál de las siguientes señales indica "Alto"?',
    options: [
      Option(id: 1, text: 'Señal A', imagePath: 'assets/images/senal_a.png'),
      Option(id: 2, text: 'Señal B', imagePath: 'assets/images/senal_b.png'),
      Option(id: 3, text: 'Señal C', imagePath: 'assets/images/senal_c.png'),
    ],
    correctOptionId: 3,
    category: QuestionCategory.circulacion,
    explanation: 'La señal octagonal roja indica "Alto" en todo el mundo.',
    difficulty: QuestionDifficulty.medium,
    tags: ['señales', 'alto', 'octagonal'],
  ),

  // ─── Ejemplo 4: Explicación con imágenes ───────────────────────────────────
  // Para EXANI: fórmulas, diagramas explicativos, pasos visuales
  Question(
    id: 4,
    text: '¿Cuál es la distancia mínima de seguimiento recomendada?',
    options: [
      Option(id: 1, text: '2 segundos'),
      Option(id: 2, text: '5 segundos'),
      Option(id: 3, text: '10 segundos'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.circulacion,
    explanation:
        'La regla de los 2 segundos es el estándar internacional para mantener '
        'distancia segura. Se mide eligiendo un punto fijo y contando el tiempo '
        'que tarda tu vehículo en llegar al mismo punto.',
    explanationImages: ['assets/images/regla_2_segundos.png'],
    difficulty: QuestionDifficulty.medium,
  ),

  // ─── Ejemplo 5: Pregunta con múltiples imágenes en el enunciado ────────────
  // Para EXANI: ejercicios con tabla + gráfica, o múltiples figuras
  Question(
    id: 5,
    text:
        'Observa las siguientes señales y selecciona la que indica una curva peligrosa:',
    stemImages: [
      'assets/images/senal_curva_1.png',
      'assets/images/senal_curva_2.png',
      'assets/images/senal_curva_3.png',
    ],
    options: [
      Option(id: 1, text: 'Señal 1'),
      Option(id: 2, text: 'Señal 2'),
      Option(id: 3, text: 'Señal 3'),
    ],
    correctOptionId: 2,
    category: QuestionCategory.multas,
    explanation: 'La señal 2 corresponde a curva peligrosa según la NOM.',
    difficulty: QuestionDifficulty.hard,
    tags: ['señales', 'curvas', 'peligro'],
  ),

  // ─── Ejemplo 6: Pregunta completa (todos los campos) ──────────────────────
  Question(
    id: 6,
    text: '¿Qué debe hacer ante la siguiente situación vial?',
    imagePath: 'assets/images/situacion_vial.png',
    stemImages: ['assets/images/contexto_adicional.png'],
    options: [
      Option(id: 1, text: 'Acelerar para pasar'),
      Option(id: 2, text: 'Ceder el paso'),
      Option(
        id: 3,
        text: 'Detenerse y esperar',
        imagePath: 'assets/images/senal_alto.png',
      ),
    ],
    correctOptionId: 2,
    category: QuestionCategory.seguridad,
    explanation:
        'Según el reglamento, siempre se debe ceder el paso al peatón en cruces.',
    explanationImages: [
      'assets/images/reglamento_cruce.png',
      'assets/images/diagrama_ceder_paso.png',
    ],
    difficulty: QuestionDifficulty.hard,
    tags: ['ceder_paso', 'peatones', 'cruce'],
  ),

  // ─── Preguntas básicas (retrocompatibles) ──────────────────────────────────
  Question(
    id: 7,
    text: '¿Pregunta de ejemplo número 7?',
    options: [
      Option(id: 1, text: 'Respuesta correcta'),
      Option(id: 2, text: 'Distractor A'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.vehiculo,
    explanation: 'Explicación de la respuesta.',
  ),
  Question(
    id: 8,
    text: '¿Pregunta de ejemplo número 8?',
    options: [
      Option(id: 1, text: 'Distractor A'),
      Option(id: 2, text: 'Respuesta correcta'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 2,
    category: QuestionCategory.prioridades,
    explanation: 'Explicación de la respuesta.',
  ),
  Question(
    id: 9,
    text: '¿Pregunta de ejemplo número 9?',
    options: [
      Option(id: 1, text: 'Distractor A'),
      Option(id: 2, text: 'Distractor B'),
      Option(id: 3, text: 'Respuesta correcta'),
    ],
    correctOptionId: 3,
    category: QuestionCategory.seguridad,
    explanation: 'Explicación de la respuesta.',
  ),
  Question(
    id: 10,
    text: '¿Pregunta de ejemplo número 10?',
    options: [
      Option(id: 1, text: 'Respuesta correcta'),
      Option(id: 2, text: 'Distractor A'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.senales,
    explanation: 'Explicación de la respuesta.',
  ),
];
