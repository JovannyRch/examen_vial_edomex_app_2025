# 🎨 Design System — Base Template

> Referencia completa del sistema de diseño Duolingo-inspired para apps tipo quiz/examen.
> Todo nuevo elemento gráfico **debe** seguir estas reglas para mantener coherencia visual.

---

## 1. Paleta de Colores

### Colores de Acento (iguales en ambos temas)

| Token           | Hex       | Uso                                    |
| --------------- | --------- | -------------------------------------- |
| `primary`       | `#58CC02` | CTAs principales, progreso, éxito      |
| `primaryDark`   | `#46A302` | Gradientes con primary, sombras verdes |
| `secondary`     | `#1CB0F6` | Botones secundarios, enlaces, info     |
| `secondaryDark` | `#1899D6` | Gradientes con secondary               |
| `orange`        | `#FF9600` | Alertas, categorías, favoritos         |
| `orangeDark`    | `#E58600` | Sombra del naranja                     |
| `red`           | `#FF4B4B` | Errores, respuestas incorrectas        |
| `redDark`       | `#E53535` | Sombra del rojo                        |
| `purple`        | `#CE82FF` | Progreso, notificaciones, estadísticas |

### Colores Neutros — Light Mode

| Token           | Hex       | Uso                                 |
| --------------- | --------- | ----------------------------------- |
| `background`    | `#F7F7F7` | Fondo del Scaffold                  |
| `surface`       | `#FFFFFF` | Tarjetas, AppBar, sheets            |
| `cardBorder`    | `#E5E5E5` | Bordes de tarjetas y separadores    |
| `textPrimary`   | `#3C3C3C` | Títulos, texto principal            |
| `textSecondary` | `#777777` | Subtítulos, descripciones           |
| `textLight`     | `#AFAFAF` | Placeholders, iconos deshabilitados |

### Colores Neutros — Dark Mode

| Token           | Hex       | Uso                                 |
| --------------- | --------- | ----------------------------------- |
| `background`    | `#1B1B2F` | Fondo del Scaffold                  |
| `surface`       | `#262640` | Tarjetas, AppBar, sheets            |
| `cardBorder`    | `#3A3A52` | Bordes de tarjetas y separadores    |
| `textPrimary`   | `#EAEAEF` | Títulos, texto principal            |
| `textSecondary` | `#9E9EB3` | Subtítulos, descripciones           |
| `textLight`     | `#6B6B80` | Placeholders, iconos deshabilitados |

### Reglas de Color

- **NUNCA** uses `Colors.white` o `Colors.black` directamente para fondos o textos.
  Usa `AppColors.surface`, `AppColors.textPrimary`, etc.
- `Colors.white` solo es aceptable sobre fondos de acento (ej. texto blanco dentro del CTA verde).
- Para oscurecer un color de acento: `AppColors.darken(color, 0.18)`.
- Para fondos semi-transparentes de iconos: `color.withValues(alpha: 0.12)`.

---

## 2. Tipografía

Se usa la tipografía default de Material (Roboto en Android). No se importan fuentes custom.

| Rol              | fontSize | fontWeight        | color                     |
| ---------------- | -------- | ----------------- | ------------------------- |
| Título pantalla  | `18`     | `FontWeight.bold` | `AppColors.textPrimary`   |
| Título tarjeta   | `17`     | `FontWeight.bold` | `AppColors.textPrimary`   |
| Subtítulo        | `13-15`  | `normal`          | `AppColors.textSecondary` |
| Etiqueta pequeña | `11-12`  | `normal/w600`     | `AppColors.textSecondary` |
| CTA principal    | `19`     | `FontWeight.bold` | `Colors.white`            |
| Stat valor       | `16`     | `FontWeight.bold` | `AppColors.textPrimary`   |
| Stat label       | `11`     | `normal`          | `AppColors.textSecondary` |
| Sección header   | `14`     | `FontWeight.w700` | `AppColors.textSecondary` |

### Reglas de Tipografía

- Los títulos de AppBar van centrados (`centerTitle: true`) con `fontSize: 18, bold`.
- Emojis se usan como decoración visual en stat chips (🎯, ⭐, 🔥, 📚, etc.).
- `letterSpacing: 0.5` solo para section headers (etiquetas como "Herramientas").

---

## 3. Componentes

### 3.1 DuoButton (Botón 3D Duolingo)

Botón principal con efecto de "push" 3D. La parte inferior oscura desaparece al presionar.

```
┌─────────────────────────┐
│     TEXTO DEL BOTÓN     │ ← Container con color (ej. primary)
├─────────────────────────┤
│   ███████████████████   │ ← Borde oscuro (primaryDark) visible = 4px bottom
└─────────────────────────┘
```

**Propiedades:**

- `color`: Color base (default: `AppColors.primary`)
- `outlined`: Si es `true`, fondo transparente con borde de color
- `fullWidth`: Si es `true`, ocupa todo el ancho
- `icon`: Icono opcional a la izquierda

**Specs:**

- Border radius: `16`
- Padding: `horizontal: 24, vertical: 14`
- Bottom shadow: `4px` (desaparece a `0px` on press)
- Top margin: `0px` → `4px` on press (efecto de hundimiento)
- Animation duration: `80ms`
- Sound: `SoundService().playTap()` al soltar

**Uso:**

```dart
DuoButton(
  text: 'Iniciar examen',
  color: AppColors.primary,
  icon: Icons.play_arrow_rounded,
  onPressed: () => ...,
)
```

### 3.2 ActionCard (Tarjeta de Acción con press 3D)

Tarjeta para acciones principales. Tiene el mismo efecto 3D que DuoButton.

```
┌─────────────────────────────────────┐
│ ┌──────┐                            │
│ │ Icon │  Título                   >│
│ │  bg  │  Subtítulo                  │
│ └──────┘                            │
├─────────────────────────────────────┤
│  ████████████ dark border ██████████│ ← 3px bottom
└─────────────────────────────────────┘
```

**Specs:**

- Border radius: `18`
- Fondo: `AppColors.surface`
- Borde: `AppColors.cardBorder, width: 2`
- Sombra 3D: `AppColors.darken(color, 0.18)`, `3px` bottom
- Icon container: `54×54`, border radius `14`, fondo `color.withValues(alpha: 0.12)`
- Icon size: `28`
- Padding: `horizontal: 16, vertical: 18`
- Flecha derecha: `Icons.chevron_right_rounded`, color `AppColors.textLight`, size `24`

### 3.3 CompactCard (Tarjeta Compacta para Grid)

Tarjeta cuadrada para grids 2×2. Mismo efecto 3D pero más compacta.

```
┌─────────────┐
│   ┌─────┐   │
│   │Icon │   │
│   └─────┘   │
│   Título    │
├─────────────┤
│  ██ dark ██ │ ← 2px bottom
└─────────────┘
```

**Specs:**

- Border radius: `16`
- Padding: `horizontal: 14, vertical: 14`
- Icon container: `44×44`, border radius `12`, fondo `color.withValues(alpha: 0.12)`
- Icon size: `22`
- Título: `fontSize: 13, bold`, centrado

### 3.4 StatChip (Chip de Estadística)

Chip para mostrar métricas en fila horizontal.

```
┌─────────────┐
│     🎯      │
│     15      │
│  exámenes   │
└─────────────┘
```

**Specs:**

- Fondo: `AppColors.surface`
- Border radius: `14`
- Borde: `AppColors.cardBorder`
- Padding: `vertical: 10, horizontal: 6`
- Emoji size: `18`
- Value: `fontSize: 16, bold, AppColors.textPrimary`
- Label: `fontSize: 11, AppColors.textSecondary`
- Se usan 3 en fila con `Expanded` y `SizedBox(width: 10)` entre ellos.

### 3.5 Hero CTA (Call To Action Principal)

Banner grande con gradiente para la acción principal.

**Specs:**

- Gradiente: `LinearGradient(colors: [primary, primaryDark], topLeft → bottomRight)`
- Border radius: `20`
- Padding: `20`
- Box shadow: `primary.withValues(alpha: 0.35), blur: 12, offset: (0, 5)`
- Icon container: `58×58`, fondo `Colors.white.withValues(alpha: 0.2)`, radius `16`
- Icon: `size: 30, color: Colors.white`
- Título: `fontSize: 19, bold, Colors.white`
- Subtítulo: `fontSize: 13, Colors.white.withValues(alpha: 0.9)`
- Flecha: `Icons.arrow_forward_rounded, Colors.white, size: 24`

### 3.6 Pro Banner (Banner Premium)

Banner dorado para versión premium.

**Specs:**

- Gradiente: `LinearGradient(colors: [#FFD700, #FFA000], topLeft → bottomRight)`
- Border radius: `16`
- Padding: `horizontal: 18, vertical: 14`
- Box shadow: `#FFD700.withValues(alpha: 0.3), blur: 8, offset: (0, 3)`
- Icon: `Icons.workspace_premium_rounded` (o `check_circle_rounded` si Pro)
- Textos en `Colors.white`

### 3.7 Reminder Banner (Banner de Recordatorio)

Tarjeta con toggle y selector de hora.

**Specs:**

- Fondo: `AppColors.surface`
- Border radius: `18`
- Borde: `AppColors.cardBorder, width: 2`
- Box shadow: `Colors.black.withValues(alpha: 0.04), blur: 8, offset: (0, 3)`
- Icon container: `42×42`, radius `12`, fondo `purple.withValues(alpha: 0.12)`
- Toggle: `Switch.adaptive` con `activeColor: AppColors.primary`
- Botón de hora: fondo `primary.withValues(alpha: 0.06)`, borde `primary.withValues(alpha: 0.2)`, radius `12`

### 3.8 AdBannerWidget (Banner de Publicidad)

Widget reutilizable que se coloca al fondo de pantallas.

**Specs:**

- Se coloca fuera del `SingleChildScrollView`, dentro del `Column` principal.
- Se oculta automáticamente para usuarios Pro (`ValueListenableBuilder<bool>`).
- Alineación: `center`, fondo `transparent`.

---

## 4. Layouts

### 4.1 Estructura de Pantalla Estándar

```
Scaffold
└── SafeArea
    └── Column
        ├── Expanded
        │   └── SingleChildScrollView (padding: horizontal 20)
        │       ├── Content...
        │       └── SizedBox(height: 24)  ← bottom padding
        └── AdBannerWidget()  ← fijo al fondo
```

### 4.2 Layout del Home

```
ScrollView
├── Theme Toggle (align right)
├── Subtitle text
├── Stats Row (3 StatChips)
├── Hero CTA (Examen Simulado)
├── ActionCard (Guía)
├── ActionCard (Categoría)
├── Section Header "Herramientas"
├── 2×2 Grid (CompactCards)
├── Pro Banner
└── Reminder Banner
```

### 4.3 Pantalla con AppBar

```dart
Scaffold(
  appBar: AppBar(
    title: Text('Título'),
    // Hereda del AppBarTheme (centrado, sin elevación)
  ),
  body: SafeArea(
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [...]),
          ),
        ),
        AdBannerWidget(),
      ],
    ),
  ),
)
```

### 4.4 Botón Fijo al Fondo

Para pantallas con botón de acción fijo (ej. ProScreen):

```dart
Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        Expanded(child: SingleChildScrollView(...)), // contenido scrolleable
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
          ),
          child: DuoButton(text: 'Acción', onPressed: ...),
        ),
      ],
    ),
  ),
)
```

---

## 5. Animaciones

### 5.1 Staggered Entrance (Entrada Escalonada)

Patrón usado en HomeScreen y ProScreen. Cada elemento entra con delay progresivo.

```dart
// Crear N controllers con duración creciente
_controllers = List.generate(N, (index) {
  return AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500 + (index * 150)),
  );
});

// Slide: 0.3 → 0 en Y
_slideAnimations = _controllers.map((c) {
  return Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
      .animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic));
}).toList();

// Fade: 0 → 1
_fadeAnimations = _controllers.map((c) {
  return Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
}).toList();

// Forward all
for (var c in _controllers) { c.forward(); }
```

**Wrapping:**

```dart
SlideTransition(
  position: _slideAnimations[index],
  child: FadeTransition(
    opacity: _fadeAnimations[index],
    child: widget,
  ),
)
```

### 5.2 Efecto 3D Press

Aplicado en DuoButton, ActionCard, CompactCard.

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 80),
  margin: EdgeInsets.only(top: _isPressed ? 4 : 0),
  padding: EdgeInsets.only(bottom: _isPressed ? 0 : 4),
  decoration: BoxDecoration(
    color: darkColor, // Color.darken(baseColor, 0.18)
    borderRadius: BorderRadius.circular(16),
  ),
  child: Container(
    decoration: BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: content,
  ),
)
```

### 5.3 Transiciones de Navegación

Slide desde la derecha con `CurvedAnimation`:

```dart
Route slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      );
    },
  );
}
```

---

## 6. Iconografía

- Usar **siempre** variantes `_rounded` de Material Icons (ej. `Icons.quiz_rounded`).
- Tamaños estándar: `18` (stat chip), `22` (compact card/small), `28` (action card), `30` (CTA).
- Iconos dentro de container decorativo: fondo `color.withValues(alpha: 0.12)`, radius `12-16`.

---

## 7. Espaciado

| Contexto                    | Valor   |
| --------------------------- | ------- |
| Padding horizontal pantalla | `20`    |
| Entre tarjetas principales  | `12-16` |
| Entre secciones             | `20-24` |
| Padding interna de tarjeta  | `16-18` |
| Gap entre icon y texto      | `14-16` |
| Bottom padding del scroll   | `24`    |
| Gap en grid 2×2             | `12`    |

---

## 8. Border Radius

| Componente      | Radius  |
| --------------- | ------- |
| DuoButton       | `16`    |
| ActionCard      | `18`    |
| CompactCard     | `16`    |
| Hero CTA        | `20`    |
| Pro Banner      | `16`    |
| Reminder Banner | `18`    |
| Icon containers | `12-16` |
| Theme toggle    | `12`    |
| StatChip        | `14`    |
| SnackBar        | `12`    |

---

## 9. Sombras

| Componente      | Color                                  | Blur | Offset    |
| --------------- | -------------------------------------- | ---- | --------- |
| Hero CTA        | `primary.withValues(alpha: 0.35)`      | `12` | `(0, 5)`  |
| Pro Banner      | `#FFD700.withValues(alpha: 0.3)`       | `8`  | `(0, 3)`  |
| Reminder Banner | `Colors.black.withValues(alpha: 0.04)` | `8`  | `(0, 3)`  |
| Pinned bottom   | `Colors.black12`                       | `10` | `(0, -3)` |

---

## 10. Checklist para Nuevos Elementos

Al agregar un nuevo componente o pantalla:

- [ ] Usa `AppColors` en lugar de colores hardcoded
- [ ] Los fondos de tarjetas son `AppColors.surface`, no `Colors.white`
- [ ] Los textos usan `AppColors.textPrimary / textSecondary / textLight`
- [ ] Los bordes usan `AppColors.cardBorder`
- [ ] Los botones principales usan `DuoButton`
- [ ] Las tarjetas interactivas tienen efecto 3D press
- [ ] La pantalla sigue la estructura `Scaffold > SafeArea > Column > [Expanded(ScrollView), AdBanner]`
- [ ] Animaciones de entrada usan el patrón staggered
- [ ] Los iconos usan variante `_rounded`
- [ ] Se reproduce `SoundService().playTap()` en interacciones principales
- [ ] La navegación usa `_slideRoute()` (slide desde la derecha)
- [ ] No hay `const` en widgets que usen `AppColors` neutros (son getters dinámicos)
