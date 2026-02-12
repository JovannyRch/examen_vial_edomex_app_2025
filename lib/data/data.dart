import 'package:my_quiz_app/models/option.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  📦 DATOS DE EJEMPLO — REEMPLAZAR CON TUS PREGUNTAS
//
//  Instrucciones:
//  1. Define tus categorías en QuestionCategory (lib/models/option.dart)
//  2. Agrega tus preguntas aquí con la estructura Question(...)
//  3. Cada pregunta necesita: id, text, options, correctOptionId, category
//  4. El campo 'explanation' es opcional pero recomendado para la revisión
//  5. Asegúrate de que correctOptionId coincida con el id de la opción correcta
// ═══════════════════════════════════════════════════════════════════════════════

final List<Question> questions = [
  // ─── Categoría 1: Ejemplo ─────────────────────────────────────────────────
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
  Question(
    id: 2,
    text: '¿Pregunta de ejemplo número 2?',
    options: [
      Option(id: 1, text: 'Distractor A'),
      Option(id: 2, text: 'Respuesta correcta'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 2,
    category: QuestionCategory.senales,
    explanation: 'Explicación de la respuesta correcta.',
  ),
  Question(
    id: 3,
    text: '¿Pregunta de ejemplo número 3?',
    options: [
      Option(id: 1, text: 'Distractor A'),
      Option(id: 2, text: 'Distractor B'),
      Option(id: 3, text: 'Respuesta correcta'),
    ],
    correctOptionId: 3,
    category: QuestionCategory.circulacion,
    explanation: 'Explicación de la respuesta.',
  ),
  Question(
    id: 4,
    text: '¿Pregunta de ejemplo número 4?',
    options: [
      Option(id: 1, text: 'Respuesta correcta'),
      Option(id: 2, text: 'Distractor A'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 1,
    category: QuestionCategory.circulacion,
    explanation: 'Explicación de la respuesta.',
  ),
  Question(
    id: 5,
    text: '¿Pregunta de ejemplo número 5?',
    options: [
      Option(id: 1, text: 'Distractor A'),
      Option(id: 2, text: 'Respuesta correcta'),
      Option(id: 3, text: 'Distractor B'),
    ],
    correctOptionId: 2,
    category: QuestionCategory.multas,
    explanation: 'Explicación de la respuesta.',
  ),
  Question(
    id: 6,
    text: '¿Pregunta de ejemplo número 6?',
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
