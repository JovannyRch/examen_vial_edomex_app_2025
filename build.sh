#!/usr/bin/env bash

# ==========================
# Flutter Build Runner
# macOS + gum
# ==========================

if ! command -v gum &> /dev/null; then
  echo "❌ gum no está instalado."
  echo "👉 Instálalo desde: https://github.com/charmbracelet/gum"
  exit 1
fi

clear

gum style \
  --border normal \
  --margin "1 2" \
  --padding "1 2" \
  --border-foreground 212 \
  "🚀 Examen Vial Edomex\nBuild Runner"

# Acción
ACTION=$(gum choose \
  "▶️  Run app (debug)" \
  "📦 Build AppBundle (Play Store)" \
  "📱 Build APK (debug)" \
  "🔖 Bump version only")

echo ""

if [[ "$ACTION" == *"Run"* ]]; then
  CMD="flutter run"

  gum style --foreground 14 "🧾 Comando:"
  gum style --foreground 250 "$CMD"
  echo ""

  gum confirm "¿Ejecutar?" || exit 0
  gum spin --spinner dot --title "Ejecutando..." -- $CMD

elif [[ "$ACTION" == *"AppBundle"* ]]; then
  CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
  VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
  MAJOR=$(echo "$VERSION_NAME" | cut -d'.' -f1)
  MINOR=$(echo "$VERSION_NAME" | cut -d'.' -f2)
  PATCH=$(echo "$VERSION_NAME" | cut -d'.' -f3)

  gum style --foreground 14 "📦 Versión actual:"
  gum style --foreground 250 "  $CURRENT_VERSION"
  echo ""

  BUMP=$(gum choose \
    "patch  ($MAJOR.$MINOR.$PATCH → $MAJOR.$MINOR.$((PATCH + 1)))" \
    "minor  ($MAJOR.$MINOR.$PATCH → $MAJOR.$((MINOR + 1)).0)" \
    "major  ($MAJOR.$MINOR.$PATCH → $((MAJOR + 1)).0.0)" \
    "no incrementar" \
    --header "¿Incrementar versión?")

  [[ -z "$BUMP" ]] && exit 0

  if [[ "$BUMP" != no* ]]; then
    if [[ "$BUMP" == patch* ]]; then
      NEW_MAJOR=$MAJOR; NEW_MINOR=$MINOR; NEW_PATCH=$((PATCH + 1))
    elif [[ "$BUMP" == minor* ]]; then
      NEW_MAJOR=$MAJOR; NEW_MINOR=$((MINOR + 1)); NEW_PATCH=0
    else
      NEW_MAJOR=$((MAJOR + 1)); NEW_MINOR=0; NEW_PATCH=0
    fi

    NEW_BUILD=$((NEW_MAJOR * 10000 + NEW_MINOR * 1000 + NEW_PATCH))
    NEW_VERSION="$NEW_MAJOR.$NEW_MINOR.$NEW_PATCH+$NEW_BUILD"

    gum style --foreground 10 "✔ Nueva versión: $NEW_VERSION"
    echo ""

    gum confirm "¿Actualizar pubspec.yaml?" || exit 0
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml
    gum style --foreground 10 "✅ pubspec.yaml actualizado"
    echo ""
  else
    NEW_VERSION="$CURRENT_VERSION"
  fi

  gum style --foreground 14 "📦 Construyendo AppBundle..."
  gum spin --spinner dot --title "Generando bundle..." -- flutter build appbundle --release

  gum style --foreground 10 "✅ AppBundle generado: $NEW_VERSION"
  gum style --foreground 250 "   build/app/outputs/bundle/release/app-release.aab"
  echo ""

  if gum confirm "¿Abrir carpeta de salida?"; then
    open build/app/outputs/bundle/release
  fi

elif [[ "$ACTION" == *"APK"* ]]; then
  gum style --foreground 14 "📱 Construyendo APK debug..."
  gum spin --spinner dot --title "Generando APK..." -- flutter build apk --debug

  gum style --foreground 10 "✅ APK debug generado"
  gum style --foreground 250 "   build/app/outputs/flutter-apk/app-debug.apk"
  echo ""

  if gum confirm "¿Abrir carpeta de salida?"; then
    open build/app/outputs/flutter-apk
  fi

else
  CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')

  gum style --foreground 14 "🔖 Versión actual:"
  gum style --foreground 250 "  $CURRENT_VERSION"
  echo ""

  BUMP=$(gum choose \
    "patch" \
    "minor" \
    "major" \
    --header "¿Qué tipo de incremento?")

  VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
  MAJOR=$(echo "$VERSION_NAME" | cut -d'.' -f1)
  MINOR=$(echo "$VERSION_NAME" | cut -d'.' -f2)
  PATCH=$(echo "$VERSION_NAME" | cut -d'.' -f3)

  if [[ "$BUMP" == patch ]]; then
    NEW_PATCH=$((PATCH + 1)); NEW_MAJOR=$MAJOR; NEW_MINOR=$MINOR
  elif [[ "$BUMP" == minor ]]; then
    NEW_PATCH=0; NEW_MAJOR=$MAJOR; NEW_MINOR=$((MINOR + 1))
  else
    NEW_PATCH=0; NEW_MAJOR=$((MAJOR + 1)); NEW_MINOR=0
  fi

  NEW_BUILD=$((NEW_MAJOR * 10000 + NEW_MINOR * 1000 + NEW_PATCH))
  NEW_VERSION="$NEW_MAJOR.$NEW_MINOR.$NEW_PATCH+$NEW_BUILD"

  gum confirm "¿Actualizar a $NEW_VERSION?" || exit 0
  sed -i '' "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml

  gum style --foreground 10 "✅ Version: $NEW_VERSION"
fi

echo ""
gum style --foreground 212 "🎉 Listo"