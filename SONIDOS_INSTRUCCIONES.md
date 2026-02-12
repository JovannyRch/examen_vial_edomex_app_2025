# 🔊 Sonidos de la App

La app utiliza efectos de sonido estilo Duolingo para mejorar la experiencia del usuario. Los sonidos se reproducen en:

- **Tap/Click**: Al presionar botones y opciones
- **Éxito**: Al aprobar el examen (≥8/10)
- **Falla**: Al no aprobar el examen (<8/10)

## 📁 Estructura de archivos de sonido

Los archivos de audio deben estar en formato **WAV** (o MP3) y colocarse en:

```
assets/sounds/
├── tap.wav          # Sonido sutil al presionar botones
├── correct.wav      # [Opcional] Para respuestas correctas
├── incorrect.wav    # [Opcional] Para respuestas incorrectas
├── success.wav      # Sonido festivo al aprobar
└── fail.wav         # Sonido de ánimo al no aprobar
```

## 🎵 Dónde conseguir sonidos gratuitos

### Opción 1: Freesound.org (Recomendado)

Sitio con sonidos de alta calidad y licencia libre:

- **URL**: https://freesound.org/
- **Búsquedas recomendadas**:
  - `tap.mp3`: "button click", "UI tap", "soft click"
  - `success.mp3`: "success", "achievement", "level complete", "fanfare"
  - `fail.mp3`: "fail", "wrong", "error", "try again"

### Opción 2: Mixkit

Efectos de sonido gratuitos sin atribución:

- **URL**: https://mixkit.co/free-sound-effects/
- Sección: "User Interface" y "Game"

### Opción 3: Zapsplat

Biblioteca amplia de efectos de sonido:

- **URL**: https://www.zapsplat.com/
- Requiere cuenta gratuita

### Opción 4: Pixabay Sound Effects

Sonidos libres de derechos:

- **URL**: https://pixabay.com/sound-effects/

## 📝 Características técnicas de los sonidos

| Sonido      | Duración | Volumen | Características                         |
| ----------- | -------- | ------- | --------------------------------------- |
| tap.mp3     | 0.1-0.3s | 30%     | Muy corto, sutil, click suave           |
| success.mp3 | 1-2s     | 70%     | Alegre, fanfarria corta, triunfante     |
| fail.mp3    | 0.5-1s   | 50%     | Descendente pero no negativo, motivador |

## 🔧 Instalación

1. Descarga los archivos WAV (o MP3)
2. Colócalos en `assets/sounds/`
3. Asegúrate que los nombres sean exactos (minúsculas)
4. La app funcionará sin los sonidos (degradación elegante)

## 🎨 Recomendaciones de estilo Duolingo

- **tap.wav**: Click minimalista, casi imperceptible
- **success.wav**: Celebración positiva pero no exagerada (2-3 notas ascendentes)
- **fail.wav**: Sonido neutro/motivador, NO usar buzzer molesto

## ⚙️ Control de volumen

Los volúmenes están pre-configurados en el código:

- Tap: 30% (sutil)
- Success: 70% (celebratorio)
- Fail: 50% (moderado)

## 🚀 Si no tienes tiempo para buscar sonidos

La app funcionará perfectamente **sin los archivos de audio**. El SoundService tiene manejo de errores integrado y simplemente no reproducirá sonidos si los archivos no existen.

---

💡 **Tip**: Para la mejor experiencia, usa sonidos cortos (<2s) en formato **WAV o MP3**. Ambos formatos son totalmente compatibles multiplataforma.
