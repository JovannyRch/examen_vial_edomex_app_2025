# Contexto de la App — Examen Vial EdoMex 2025

## 📋 Descripción General

App de Flutter orientada a usuarios que necesitan aprobar el **examen de licencia de conducir en el Estado de México**. Permite estudiar la guía oficial, practicar con exámenes simulados y descargar la guía en PDF.

- **Plataforma principal:** Android (iOS configurado pero no priorizado)
- **Versión actual:** 1.0.0+7
- **SDK:** Flutter ≥ 3.7.0
- **Monetización:** Google AdMob (banners + intersticiales)

---

## 🏗️ Arquitectura Actual

```
lib/
├── main.dart              # Entry point, inicializa AdMob
├── const/const.dart       # Constante PDF_URL
├── data/data.dart         # 54 preguntas hardcodeadas con opciones
├── models/
│   ├── option.dart        # Clases Question y Option (con shuffleOptions)
│   ├── question.dart      # Modelo Question duplicado (no se usa activamente)
│   └── question_stat.dart # Modelo QuestionStat (sin uso activo)
├── screens/
│   ├── home_screen.dart       # Pantalla principal con grid de 3 cards
│   ├── exam_screen.dart       # Examen simulado de 10 preguntas + ResultsScreen
│   ├── guide_screen.dart      # Guía de estudio con PageView
│   └── pdf_viewer_screen.dart # Visor PDF con descarga
├── services/
│   └── admob_service.dart     # Gestión de ads (banner + intersticial)
└── widgets/               # Vacío — sin widgets reutilizables
```

---

## 🔑 Funcionalidades Actuales

| Funcionalidad       | Descripción                                                                                                       |
| ------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **Guía de estudio** | PageView con las 54 preguntas, muestra solo la respuesta correcta                                                 |
| **Examen simulado** | 10 preguntas aleatorias, 3 opciones shuffleadas, timer de 30 min, resultado aprobado/no aprobado (requiere 10/10) |
| **Visor PDF**       | Carga PDF embebido desde assets, opción de descarga desde URL                                                     |
| **Monetización**    | Banner en home, guía y examen; intersticial al abrir PDF                                                          |

---

## 📊 Datos del Banco de Preguntas

- **Total:** 54 preguntas
- **Formato:** Hardcodeadas en `data.dart` (738 líneas)
- **Opciones por pregunta:** 4 opciones, siempre `correctOptionId: 1`
- **Categorías cubiertas:** Señales de tránsito, velocidades, multas, cinturón de seguridad, licencias, prioridades de paso, estacionamiento, alcohol, etc.

---

## 🧩 Modelos

### `Question` (en option.dart - el modelo activamente usado)

- `id`, `text`, `options`, `correctOptionId`, `imagePath?`
- Método `getShuffledOptions(maxOptions)` — reduce y baraja opciones

### `Question` (en question.dart - DUPLICADO, no se usa)

- Campos similares pero con `correctAnswerId`
- Getters: `formattedText`, `formattedAnswer`, `correctAnswer`, `shuffledOptions`

### `Option`

- `id`, `text`

### `QuestionStat` (sin uso activo)

- `id`, `viewCount` — preparado para tracking de progreso

---

## 📱 Flujo de Usuario

```
Home Screen
├── "Guía" → GuideScreen (PageView de 54 preguntas con respuesta correcta)
├── "Examen" → ExamScreen (10 preguntas aleatorias) → ResultsScreen
└── "Descargar guía en PDF" → PdfViewerScreen (visor + descarga)
```

---

## 💰 Monetización

- **BannerAd:** Se muestra en HomeScreen, ExamScreen y GuideScreen
- **InterstitialAd:** Se muestra 3 segundos después de abrir PdfViewerScreen
- **IDs de producción configurados** (no test ads)
- Sin control de frecuencia de intersticiales

---

## ⚠️ Problemas Técnicos Identificados

1. **Modelo duplicado:** `Question` existe en `option.dart` y `question.dart` con campos diferentes
2. **`QuestionStat` sin uso:** Modelo preparado para estadísticas pero no implementado
3. **Directorio `services /` (con espacio):** Posible error de nombre
4. **Widgets vacío:** Sin componentes reutilizables extraídos
5. **Sin persistencia de datos:** No se guardan resultados, progreso ni preferencias
6. **Respuesta siempre id=1:** Todas las preguntas tienen `correctOptionId: 1`, el shuffle lo mitiga pero es un patrón predecible
7. **Aprobación requiere 10/10:** Umbral poco realista vs. el examen real
8. **Sin tema centralizado:** Colores hardcodeados repetidos (`0xFF121212`, `0xFF1E1E1E`)
9. **Sin manejo de estado:** Todo con setState básico
10. **Sin navegación con rutas nombradas**

---

## 📦 Dependencias

| Paquete                        | Uso                                  |
| ------------------------------ | ------------------------------------ |
| `url_launcher`                 | Declarado pero sin uso visible       |
| `syncfusion_flutter_pdfviewer` | Visor PDF embebido                   |
| `dio`                          | Descarga de PDF                      |
| `path_provider`                | Ruta de almacenamiento para descarga |
| `open_filex`                   | Abrir PDF descargado                 |
| `google_mobile_ads`            | Monetización AdMob                   |
| `flutter_native_splash`        | Splash screen personalizado          |
