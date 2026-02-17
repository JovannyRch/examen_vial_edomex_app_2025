# Generador de Preguntas de Señales de Tránsito

## 📋 Resumen

He creado un generador completo de preguntas basado en las señales del archivo `info.html`. Incluye **87 preguntas** sobre señales de tránsito con imágenes.

## 🎯 Formato de las Preguntas

Cada pregunta sigue este patrón:

- **Pregunta**: "¿Qué señal de tránsito es esta?"
- **Imagen**: URL de la señal desde S3
- **4 opciones**: Una correcta y 3 similares (distractores inteligentes)
- **Explicación**: Descripción del significado de la señal

## 📂 Archivos Creados

### `lib/data/traffic_signs_questions_generator.dart`

- ✅ 35 señales preventivas (amarillas)
- ✅ 22 señales restrictivas (rojas)
- ✅ 30 señales informativas (azules/verdes - servicios y turísticas)

IDs asignados: **1001 - 1087** (para evitar conflictos con IDs existentes)

## 🔧 Cómo Integrar las Preguntas

### Opción 1: Agregar todas las preguntas al archivo principal

```dart
// En lib/data/data.dart
import 'traffic_signs_questions_generator.dart';

final List<Question> questions = [
  // ... tus preguntas existentes ...

  // Agregar las nuevas preguntas con imágenes
  ...trafficSignsQuestions,
];
```

### Opción 2: Crear una categoría especial de "Señales Visuales"

```dart
// En lib/data/data.dart
final List<Question> allQuestions = [
  ...questions,  // Preguntas tradicionales
  ...trafficSignsQuestions,  // Preguntas con imágenes
];
```

## 📊 Estadísticas del Generador

### Señales Preventivas (35 preguntas)

- ✅ Curvas y caminos sinuosos (5)
- ✅ Cruces y entronques (7)
- ✅ Condiciones del camino (8)
- ✅ Intersecciones especiales (5)
- ✅ Advertencias de tráfico (10)

### Señales Restrictivas (22 preguntas)

- ✅ Alto, Ceda el paso, Inspección
- ✅ Velocidad máxima, No rebasar
- ✅ Circulación, Conservar la derecha, Doble circulación
- ✅ Restricciones físicas (altura, anchura, peso)
- ✅ Estacionamiento y paradas
- ✅ Vueltas y retornos prohibidos
- ✅ Restricciones por tipo de vehículo
- ✅ Uso obligatorio de cinturón
- ✅ Prohibido usar claxon

### Señales Informativas (30 preguntas)

- ✅ Servicios: Primeros auxilios, Gasolinera, Taller mecánico, Baños, Restaurantes, Hospedaje
- ✅ Comunicaciones: Teléfono, Correos, Información
- ✅ Transporte: Estación de ferrocarriles, Fin de autopista
- ✅ Turismo: Artesanías, Zona turística, Sitio histórico, Monumento religioso
- ✅ Actividades recreativas: Parque nacional, Zona de acampar, Juegos infantiles
- ✅ Actividades acuáticas: Playa, Natación, Buceo, Pesca, Cascada
- ✅ Actividades terrestres: Excursión, Alpinismo, Volcán
- ✅ Servicios generales: Comedor al aire libre, Botes de basura

## 🎨 Ejemplo de Pregunta Generada

```dart
Question(
  id: 1028,
  text: '¿Qué señal de tránsito es esta?',
  imagePath: 'https://s3.amazonaws.com/nexu-ghost-blog/2016/Aug/Zona_escolar-1471557208809.png',
  options: [
    Option(id: 1, text: 'Zona escolar'),
    Option(id: 2, text: 'Paso peatonal'),
    Option(id: 3, text: 'Trabajadores en el camino'),
    Option(id: 4, text: 'Semáforo'),
  ],
  correctOptionId: 1,
  category: QuestionCategory.senales,
  explanation: 'Advierte sobre una zona de escuelas cercana para que el conductor reduzca su velocidad.',
)
```

## ✅ Estado Actual

### ¡Generación Completa! 🎉

Todas las **87 señales** del archivo `info.html` han sido procesadas y convertidas en preguntas:

- ✅ **35 preguntas** sobre señales preventivas
- ✅ **22 preguntas** sobre señales restrictivas
- ✅ **30 preguntas** sobre señales informativas

## 📝 Patrón de Generación Usado

Para cada señal:

1. **Pregunta estándar**: "¿Qué señal de tránsito es esta?"
2. **URL de imagen**: Extraída del HTML
3. **Respuesta correcta**: Nombre de la señal del HTML
4. **Distractores**: Señales similares del mismo tipo (preventiva/restrictiva/informativa)
5. **Explicación**: Descripción oficial del HTML

## ✅ Ventajas de Este Enfoque

- ✨ **Realista**: Muestra la señal real como en el examen oficial
- 📚 **Educativo**: El usuario aprende visualmente
- 🎯 **Distractores inteligentes**: Opciones similares que requieren conocimiento real
- 🖼️ **Caché optimizado**: Ya implementaste `cached_network_image`
- 📱 **Responsive**: Las imágenes se adaptan al diseño existente

## 🔍 Verificación de Imágenes

Todas las URLs apuntan a S3 de Nexu. Si alguna imagen no carga:

- El sistema mostrará el error widget que ya implementaste
- Las imágenes están públicamente disponibles
- Están optimizadas y cacheadas con `cached_network_image`

## 🚀 Para Integrar

Simplemente importa y agrega las preguntas a tu archivo principal:

```dart
import 'traffic_signs_questions_generator.dart';

final List<Question> allQuestions = [
  ...questions,  // Tus 100+ preguntas existentes
  ...trafficSignsQuestions,  // 87 preguntas con imágenes
];
```

Ahora tendrás **~190 preguntas en total** para un examen súper completo. 🎯
