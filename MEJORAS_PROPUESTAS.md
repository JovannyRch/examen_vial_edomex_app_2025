# Propuestas de Mejoras Funcionales — Examen Vial EdoMex 2025

> La app ya tiene descargas. Estas mejoras están priorizadas por **impacto en retención y monetización**.

---

## 🔥 PRIORIDAD ALTA — Retención y engagement inmediato

### 1. Historial de Exámenes y Progreso del Usuario

**Problema:** El usuario hace un examen y no queda registro. No sabe si está mejorando.
**Propuesta:**

- Guardar cada resultado de examen con `shared_preferences` o SQLite
- Pantalla de "Progreso" (ya está el card comentado en home) con:
  - Gráfica de evolución de calificaciones
  - Número de exámenes realizados
  - Racha de días estudiando (streak)
  - Porcentaje de preguntas dominadas
- **Impacto:** Los usuarios regresan a la app para mejorar su score → más sesiones → más ads

### 2. Modo de Práctica por Categoría

**Problema:** Las 54 preguntas están mezcladas, el usuario no puede enfocarse en sus áreas débiles.
**Propuesta:**

- Categorizar preguntas: Señales, Velocidades, Multas, Seguridad, Prioridades, etc.
- Agregar campo `category` al modelo `Question`
- Nueva pantalla para seleccionar categoría y practicar solo esas preguntas
- **Impacto:** Estudio más eficiente → usuario percibe valor → mejor rating en Play Store

### 3. Revisión de Respuestas Post-Examen

**Problema:** Al terminar el examen, solo se muestra "Aprobado/No aprobado" sin detalles.
**Propuesta:**

- Después del resultado, mostrar lista de preguntas con:
  - ✅ Respuesta correcta del usuario
  - ❌ Respuesta incorrecta + cuál era la correcta
  - Explicación breve (agregar campo `explanation` a Question)
- **Impacto:** El usuario aprende de sus errores → valor educativo real → retención

### 4. Ajustar Umbral de Aprobación

**Problema:** Se requiere 10/10 para aprobar. El examen real del EdoMex no exige 100%.
**Propuesta:**

- Cambiar umbral a 8/10 (80%) como el examen real
- Mostrar calificación numérica: "8/10 — Aprobado"
- **Impacto:** Menos frustración → el usuario no abandona la app

---

## ⚡ PRIORIDAD MEDIA — Diferenciación y valor agregado

### 5. Modo Examen Realista (Simulacro Completo)

**Problema:** El examen actual es de 10 preguntas, el real puede tener más y diferente formato.
**Propuesta:**

- Ofrecer 2 modos:
  - **Examen rápido:** 10 preguntas, 10 min (actual)
  - **Simulacro completo:** 30 preguntas, 30 min (más cercano al real)
- Selector de modo antes de iniciar examen
- **Impacto:** Usuarios serios lo prefieren → diferenciación vs. competencia

### 6. Preguntas con Imágenes de Señales de Tránsito

**Problema:** El modelo ya soporta `imagePath` pero no se usa. Las preguntas de señales son texto.
**Propuesta:**

- Agregar imágenes de señales viales reales a las preguntas correspondientes
- Mostrar la imagen en la guía y en el examen
- **Impacto:** Aprendizaje visual mucho más efectivo → mejor preparación

### 7. Sistema de Favoritos / Preguntas Difíciles

**Problema:** No hay forma de marcar preguntas para repaso.
**Propuesta:**

- Botón de bookmark en cada pregunta (guía y examen)
- Sección "Mis preguntas guardadas" accesible desde home
- Auto-guardar preguntas falladas en exámenes
- **Impacto:** Estudio personalizado → mayor valor percibido

### 8. Notificaciones de Recordatorio de Estudio

**Problema:** Sin notificaciones, el usuario olvida la app.
**Propuesta:**

- Notificación diaria configurable: "¿Ya practicaste hoy? 📚"
- Usar `flutter_local_notifications`
- **Impacto:** Retención diaria → más sesiones → más ingresos por ads

### 9. Dark/Light Mode y Tema Mejorado

**Problema:** Solo hay dark mode hardcodeado. Algunos usuarios preferirían modo claro.
**Propuesta:**

- Centralizar colores en un `AppTheme`
- Toggle de tema en ajustes
- Persistir preferencia
- **Impacto:** Mejor UX → mejor rating

---

## 📈 PRIORIDAD MEDIA-BAJA — Crecimiento y monetización

### 10. Compartir Resultados

**Problema:** No hay viralidad orgánica.
**Propuesta:**

- Botón "Compartir resultado" en ResultsScreen
- Generar imagen o texto: "Aprobé mi examen de práctica vial EdoMex con 9/10 🚗✅"
- Incluir link de la app en Play Store
- **Impacto:** Adquisición orgánica gratuita de usuarios

### 11. Pantalla "Acerca de" / Información del Examen Real

**Problema:** No hay info contextual sobre el examen real.
**Propuesta:**

- Sección informativa con:
  - Requisitos para sacar licencia en EdoMex
  - Ubicaciones de módulos
  - Costos actualizados
  - Tips para el día del examen
- Link a la página oficial
- **Impacto:** La app se vuelve "la guía completa" → más retención

### 12. Rating y Review Prompt

**Problema:** Sin prompt de calificación, pocos usuarios dejan review.
**Propuesta:**

- Después de aprobar un examen, mostrar dialog: "¿Te sirvió la app? ¡Déjanos una reseña! ⭐"
- Usar `in_app_review` package
- Mostrar solo después de 3+ exámenes completados
- **Impacto:** Más reviews positivos → mejor posicionamiento en Play Store

### 13. Ampliar Banco de Preguntas

**Problema:** Solo 54 preguntas. Los usuarios las memorizan rápido.
**Propuesta:**

- Incrementar a 100-150 preguntas
- Posibilidad de cargar preguntas nuevas remotamente (JSON desde API/GitHub)
- **Impacto:** Mayor vida útil de la app → menos desinstalaciones

### 14. Monetización Premium (Opcional)

**Problema:** Solo ads como ingreso. Algunos usuarios pagarían por quitar ads.
**Propuesta:**

- Versión "Pro" por compra única ($29-49 MXN):
  - Sin anuncios
  - Acceso a simulacro completo
  - Estadísticas avanzadas
- Usar `in_app_purchase`
- **Impacto:** Ingreso adicional + usuarios satisfechos

---

## 🔧 Mejoras Técnicas Recomendadas

| Mejora                               | Descripción                                                 |
| ------------------------------------ | ----------------------------------------------------------- |
| **Eliminar modelo duplicado**        | Unificar `Question` de `option.dart` y `question.dart`      |
| **Implementar `shared_preferences`** | Para persistir progreso, favoritos y preferencias           |
| **Extraer widgets reutilizables**    | `QuestionCard`, `OptionTile`, `AdBannerWidget`              |
| **Centralizar tema**                 | `AppTheme` con `ThemeData` para colores y estilos           |
| **Agregar categorías a preguntas**   | Campo `category` en el modelo para filtrado                 |
| **Control de frecuencia de ads**     | No mostrar intersticial cada vez, cada 3-5 acciones         |
| **Analytics**                        | Firebase Analytics para entender comportamiento del usuario |
| **Crash reporting**                  | Firebase Crashlytics para detectar errores en producción    |
| **Borrar directorio `services /`**   | Directorio con espacio en el nombre (typo)                  |

---

## 🗺️ Roadmap Sugerido

### Versión 1.1 (1-2 semanas)

- [ ] Revisión de respuestas post-examen
- [ ] Ajustar umbral a 8/10
- [ ] Historial básico de resultados
- [ ] Eliminar modelo duplicado
- [ ] Compartir resultados

### Versión 1.2 (2-3 semanas)

- [ ] Categorías de preguntas
- [ ] Modo práctica por categoría
- [ ] Sistema de favoritos
- [ ] Prompt de calificación (in_app_review)

### Versión 1.3 (3-4 semanas)

- [ ] Simulacro completo (30 preguntas)
- [ ] Imágenes de señales de tránsito
- [ ] Notificaciones de recordatorio
- [ ] Información del examen real

### Versión 2.0 (1-2 meses)

- [ ] Ampliar banco a 100+ preguntas
- [ ] Firebase Analytics + Crashlytics
- [ ] Versión Pro sin ads
- [ ] Dark/Light mode
- [ ] Carga remota de preguntas
