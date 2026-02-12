#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
#  📦 commands.sh — Helper para personalizar y gestionar el proyecto Flutter
# ═══════════════════════════════════════════════════════════════════════════════
#
#  Uso:  ./commands.sh <comando> [argumentos]
#
#  Ejemplos:
#    ./commands.sh change-app-id com.mycompany.myapp
#    ./commands.sh change-app-name "Mi App"
#    ./commands.sh change-version 1.2.0 15
#    ./commands.sh change-admob-ids APP_ID BANNER_ID INTERSTITIAL_ID
#    ./commands.sh change-iap-product my_product_id
#    ./commands.sh toggle-test-ads true
#    ./commands.sh change-playstore-url "https://play.google.com/store/apps/details?id=com.mycompany.myapp"
#    ./commands.sh change-pdf-url "https://example.com/guide.pdf"
#    ./commands.sh change-exam-config 10 20 12
#    ./commands.sh generate-splash
#    ./commands.sh build-apk
#    ./commands.sh build-aab
#    ./commands.sh clean
#    ./commands.sh rename-project mi_nueva_app
#    ./commands.sh info
#
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─── Helpers ──────────────────────────────────────────────────────────────────

print_header() {
  echo ""
  echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
  echo -e "${BOLD}  $1${NC}"
  echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
  echo ""
}

print_success() {
  echo -e "  ${GREEN}✔${NC} $1"
}

print_warning() {
  echo -e "  ${YELLOW}⚠${NC} $1"
}

print_error() {
  echo -e "  ${RED}✘${NC} $1"
}

print_info() {
  echo -e "  ${BLUE}ℹ${NC} $1"
}

# ─── Validations ──────────────────────────────────────────────────────────────

require_arg() {
  if [ -z "$1" ]; then
    print_error "$2"
    exit 1
  fi
}

# ═══════════════════════════════════════════════════════════════════════════════
#  Commands
# ═══════════════════════════════════════════════════════════════════════════════

# ─── Change Android Application ID ───────────────────────────────────────────
cmd_change_app_id() {
  local NEW_ID="$1"
  require_arg "$NEW_ID" "Uso: ./commands.sh change-app-id <com.company.app>"

  print_header "Cambiando Application ID a: $NEW_ID"

  # 1. build.gradle.kts
  local GRADLE="android/app/build.gradle.kts"
  if [ -f "$GRADLE" ]; then
    sed -i '' "s|applicationId = \".*\"|applicationId = \"$NEW_ID\"|g" "$GRADLE"
    print_success "build.gradle.kts → applicationId = \"$NEW_ID\""
  else
    print_error "No se encontró $GRADLE"
  fi

  # 2. AndroidManifest — namespace
  local GRADLE_NS="android/app/build.gradle.kts"
  sed -i '' "s|namespace = \".*\"|namespace = \"$NEW_ID\"|g" "$GRADLE_NS"
  print_success "build.gradle.kts → namespace = \"$NEW_ID\""

  # 3. Move Kotlin/Java source directory
  print_warning "Recuerda mover/renombrar el directorio de código nativo si es necesario:"
  print_info "  android/app/src/main/kotlin/<old_package> → android/app/src/main/kotlin/$(echo $NEW_ID | tr '.' '/')"

  echo ""
  print_success "Application ID cambiado exitosamente."
}

# ─── Change App Display Name ─────────────────────────────────────────────────
cmd_change_app_name() {
  local NEW_NAME="$1"
  require_arg "$NEW_NAME" "Uso: ./commands.sh change-app-name <\"Nombre de la App\">"

  print_header "Cambiando nombre de la app a: $NEW_NAME"

  # AndroidManifest.xml
  local MANIFEST="android/app/src/main/AndroidManifest.xml"
  if [ -f "$MANIFEST" ]; then
    sed -i '' "s|android:label=\"[^\"]*\"|android:label=\"$NEW_NAME\"|g" "$MANIFEST"
    print_success "AndroidManifest.xml → android:label=\"$NEW_NAME\""
  fi

  # pubspec.yaml — MaterialApp title (solo como referencia, el título real está en main.dart)
  print_warning "Recuerda también cambiar el título en main.dart:"
  print_info "  MaterialApp(title: '$NEW_NAME', ...)"

  echo ""
  print_success "Nombre de la app cambiado."
}

# ─── Change App Version ──────────────────────────────────────────────────────
cmd_change_version() {
  local VERSION="$1"
  local BUILD_NUMBER="$2"
  require_arg "$VERSION" "Uso: ./commands.sh change-version <1.2.0> [build_number]"

  print_header "Cambiando versión a: $VERSION${BUILD_NUMBER:++$BUILD_NUMBER}"

  local PUBSPEC="pubspec.yaml"
  if [ -n "$BUILD_NUMBER" ]; then
    sed -i '' "s|^version: .*|version: $VERSION+$BUILD_NUMBER|" "$PUBSPEC"
    print_success "pubspec.yaml → version: $VERSION+$BUILD_NUMBER"
  else
    # Mantener el build number actual
    local CURRENT=$(grep "^version:" "$PUBSPEC" | sed 's/version: //')
    local CURRENT_BUILD=$(echo "$CURRENT" | cut -d'+' -f2)
    sed -i '' "s|^version: .*|version: $VERSION+$CURRENT_BUILD|" "$PUBSPEC"
    print_success "pubspec.yaml → version: $VERSION+$CURRENT_BUILD"
  fi

  echo ""
  print_success "Versión actualizada."
}

# ─── Increment Build Number ──────────────────────────────────────────────────
cmd_bump_build() {
  print_header "Incrementando build number"

  local PUBSPEC="pubspec.yaml"
  local CURRENT=$(grep "^version:" "$PUBSPEC" | sed 's/version: //')
  local VERSION=$(echo "$CURRENT" | cut -d'+' -f1)
  local BUILD=$(echo "$CURRENT" | cut -d'+' -f2)
  local NEW_BUILD=$((BUILD + 1))

  sed -i '' "s|^version: .*|version: $VERSION+$NEW_BUILD|" "$PUBSPEC"
  print_success "pubspec.yaml → version: $VERSION+$NEW_BUILD (era +$BUILD)"

  echo ""
  print_success "Build number incrementado."
}

# ─── Change AdMob IDs ────────────────────────────────────────────────────────
cmd_change_admob_ids() {
  local APP_ID="$1"
  local BANNER_ID="$2"
  local INTERSTITIAL_ID="$3"
  require_arg "$APP_ID" "Uso: ./commands.sh change-admob-ids <APP_ID> <BANNER_ID> <INTERSTITIAL_ID>"
  require_arg "$BANNER_ID" "Falta BANNER_ID"
  require_arg "$INTERSTITIAL_ID" "Falta INTERSTITIAL_ID"

  print_header "Cambiando AdMob IDs"

  # 1. AndroidManifest — APP_ID
  local MANIFEST="android/app/src/main/AndroidManifest.xml"
  sed -i '' "s|android:value=\"ca-app-pub-[^\"]*\"|android:value=\"$APP_ID\"|g" "$MANIFEST"
  print_success "AndroidManifest.xml → AdMob App ID"

  # 2. admob_service.dart — Banner + Interstitial
  local SERVICE="lib/services/admob_service.dart"
  sed -i '' "s|_prodBannerAdUnitId =.*|_prodBannerAdUnitId = '$BANNER_ID';|" "$SERVICE"
  sed -i '' "s|_prodInterstitialAdUnitId =.*|_prodInterstitialAdUnitId = '$INTERSTITIAL_ID';|" "$SERVICE"
  print_success "admob_service.dart → Banner: $BANNER_ID"
  print_success "admob_service.dart → Interstitial: $INTERSTITIAL_ID"

  echo ""
  print_success "AdMob IDs actualizados."
}

# ─── Toggle Test Ads ──────────────────────────────────────────────────────────
cmd_toggle_test_ads() {
  local VALUE="$1"
  require_arg "$VALUE" "Uso: ./commands.sh toggle-test-ads <true|false>"

  print_header "Cambiando _testAds a: $VALUE"

  local SERVICE="lib/services/admob_service.dart"
  sed -i '' "s|static const bool _testAds = .*;|static const bool _testAds = $VALUE;|" "$SERVICE"
  print_success "admob_service.dart → _testAds = $VALUE"

  if [ "$VALUE" = "true" ]; then
    print_warning "Modo de prueba ACTIVADO — Los ads NO generan ingresos."
  else
    print_success "Modo producción — Los ads reales están activos."
  fi
}

# ─── Change IAP Product ID ───────────────────────────────────────────────────
cmd_change_iap_product() {
  local PRODUCT_ID="$1"
  require_arg "$PRODUCT_ID" "Uso: ./commands.sh change-iap-product <product_id>"

  print_header "Cambiando IAP Product ID a: $PRODUCT_ID"

  local SERVICE="lib/services/purchase_service.dart"
  sed -i '' "s|const String kProProductId = '.*';|const String kProProductId = '$PRODUCT_ID';|" "$SERVICE"
  print_success "purchase_service.dart → kProProductId = '$PRODUCT_ID'"
}

# ─── Change Play Store URL ───────────────────────────────────────────────────
cmd_change_playstore_url() {
  local URL="$1"
  require_arg "$URL" "Uso: ./commands.sh change-playstore-url <url>"

  print_header "Cambiando Play Store URL"

  local CONST="lib/const/const.dart"
  sed -i '' "s|const String PLAYSTORE_APP_ID =.*|const String PLAYSTORE_APP_ID = \"$URL\";|" "$CONST"
  print_success "const.dart → PLAYSTORE_APP_ID"
}

# ─── Change PDF URL ──────────────────────────────────────────────────────────
cmd_change_pdf_url() {
  local URL="$1"
  require_arg "$URL" "Uso: ./commands.sh change-pdf-url <url>"

  print_header "Cambiando PDF URL"

  local CONST="lib/const/const.dart"
  sed -i '' "s|const String PDF_URL =.*|const String PDF_URL = \"$URL\";|" "$CONST"
  print_success "const.dart → PDF_URL"
}

# ─── Change Exam Configuration ───────────────────────────────────────────────
cmd_change_exam_config() {
  local DURATION="$1"
  local TOTAL="$2"
  local PASSING="$3"
  require_arg "$DURATION" "Uso: ./commands.sh change-exam-config <duration_min> <total_questions> <passing_score>"
  require_arg "$TOTAL" "Falta total_questions"
  require_arg "$PASSING" "Falta passing_score"

  print_header "Cambiando configuración de examen"

  local CONST="lib/const/const.dart"
  sed -i '' "s|const int EXAM_DURATION_MINUTES = .*;|const int EXAM_DURATION_MINUTES = $DURATION;|" "$CONST"
  sed -i '' "s|const int EXAM_TOTAL_QUESTIONS = .*;|const int EXAM_TOTAL_QUESTIONS = $TOTAL;|" "$CONST"
  sed -i '' "s|const int EXAM_PASSING_SCORE = .*;|const int EXAM_PASSING_SCORE = $PASSING;|" "$CONST"
  print_success "EXAM_DURATION_MINUTES = $DURATION"
  print_success "EXAM_TOTAL_QUESTIONS = $TOTAL"
  print_success "EXAM_PASSING_SCORE = $PASSING"
  print_info "EXAM_PASSING_PERCENTAGE se calcula automáticamente."
}

# ─── Rename Flutter Project ──────────────────────────────────────────────────
cmd_rename_project() {
  local NEW_NAME="$1"
  require_arg "$NEW_NAME" "Uso: ./commands.sh rename-project <nuevo_nombre_snake_case>"

  print_header "Renombrando proyecto a: $NEW_NAME"

  local PUBSPEC="pubspec.yaml"
  local OLD_NAME=$(grep "^name:" "$PUBSPEC" | sed 's/name: //')

  # 1. pubspec.yaml
  sed -i '' "s|^name: .*|name: $NEW_NAME|" "$PUBSPEC"
  print_success "pubspec.yaml → name: $NEW_NAME"

  # 2. Update all Dart imports
  local COUNT=0
  while IFS= read -r -d '' file; do
    if grep -q "package:$OLD_NAME/" "$file" 2>/dev/null; then
      sed -i '' "s|package:$OLD_NAME/|package:$NEW_NAME/|g" "$file"
      COUNT=$((COUNT + 1))
    fi
  done < <(find lib test -name "*.dart" -print0 2>/dev/null)
  print_success "Actualizados $COUNT archivos con imports package:$NEW_NAME/"

  # 3. Update .iml files if they exist
  find . -name "*.iml" -exec sed -i '' "s|$OLD_NAME|$NEW_NAME|g" {} \; 2>/dev/null
  print_success "Archivos .iml actualizados"

  echo ""
  print_success "Proyecto renombrado de '$OLD_NAME' a '$NEW_NAME'."
  print_warning "Ejecuta 'flutter pub get' para actualizar las referencias."
}

# ─── Change Splash Screen Color ──────────────────────────────────────────────
cmd_change_splash_color() {
  local COLOR="$1"
  require_arg "$COLOR" "Uso: ./commands.sh change-splash-color <#HEXCOLOR>"

  print_header "Cambiando color de splash a: $COLOR"

  local PUBSPEC="pubspec.yaml"
  sed -i '' "s|color: \"#[0-9A-Fa-f]*\"|color: \"$COLOR\"|" "$PUBSPEC"
  print_success "pubspec.yaml → splash color: $COLOR"

  print_info "Ejecuta './commands.sh generate-splash' para aplicar."
}

# ─── Generate Splash Screen ──────────────────────────────────────────────────
cmd_generate_splash() {
  print_header "Generando splash screen"
  dart run flutter_native_splash:create
  print_success "Splash screen generado."
}

# ─── Build APK (release) ─────────────────────────────────────────────────────
cmd_build_apk() {
  print_header "Construyendo APK (release)"
  flutter build apk --release
  echo ""
  print_success "APK generado en: build/app/outputs/flutter-apk/app-release.apk"
}

# ─── Build AAB (App Bundle para Play Store) ──────────────────────────────────
cmd_build_aab() {
  print_header "Construyendo AAB (App Bundle)"
  flutter build appbundle --release
  echo ""
  print_success "AAB generado en: build/app/outputs/bundle/release/app-release.aab"
}

# ─── Clean ────────────────────────────────────────────────────────────────────
cmd_clean() {
  print_header "Limpiando proyecto"
  flutter clean
  print_success "flutter clean completado"
  flutter pub get
  print_success "flutter pub get completado"
  echo ""
  print_success "Proyecto limpio y dependencias descargadas."
}

# ─── Project Info ─────────────────────────────────────────────────────────────
cmd_info() {
  print_header "Información del Proyecto"

  local PUBSPEC="pubspec.yaml"
  local NAME=$(grep "^name:" "$PUBSPEC" | sed 's/name: //')
  local VERSION=$(grep "^version:" "$PUBSPEC" | sed 's/version: //')

  local GRADLE="android/app/build.gradle.kts"
  local APP_ID=$(grep 'applicationId' "$GRADLE" | sed 's/.*"\(.*\)".*/\1/')
  local NAMESPACE=$(grep 'namespace' "$GRADLE" | sed 's/.*"\(.*\)".*/\1/')

  local MANIFEST="android/app/src/main/AndroidManifest.xml"
  local APP_NAME=$(grep 'android:label' "$MANIFEST" | head -1 | sed 's/.*android:label="\([^"]*\)".*/\1/')

  local SERVICE="lib/services/admob_service.dart"
  local TEST_ADS=$(grep '_testAds' "$SERVICE" | head -1 | sed 's/.*= \(.*\);.*/\1/')

  echo -e "  ${BOLD}Nombre del proyecto:${NC}  $NAME"
  echo -e "  ${BOLD}Versión:${NC}              $VERSION"
  echo -e "  ${BOLD}Application ID:${NC}       $APP_ID"
  echo -e "  ${BOLD}Namespace:${NC}            $NAMESPACE"
  echo -e "  ${BOLD}Nombre visible:${NC}       $APP_NAME"
  echo -e "  ${BOLD}Test Ads:${NC}             $TEST_ADS"
  echo ""

  # Check if test ads are on
  if echo "$TEST_ADS" | grep -q "true"; then
    print_warning "Los ads están en modo de PRUEBA."
  else
    print_success "Los ads están en modo de PRODUCCIÓN."
  fi
}

# ─── Deploy Checklist ─────────────────────────────────────────────────────────
cmd_checklist() {
  print_header "Checklist de Deploy"

  local SERVICE="lib/services/admob_service.dart"
  local TEST_ADS=$(grep '_testAds' "$SERVICE" | head -1 | sed 's/.*= \(.*\);.*/\1/')

  local PUBSPEC="pubspec.yaml"
  local VERSION=$(grep "^version:" "$PUBSPEC" | sed 's/version: //')

  echo "  Verificando configuración..."
  echo ""

  # Test ads
  if echo "$TEST_ADS" | grep -q "false"; then
    print_success "_testAds = false (producción)"
  else
    print_error "_testAds = true — ¡Cambiar antes de publicar!"
  fi

  # Version
  echo -e "  ${BLUE}ℹ${NC} Versión actual: $VERSION"

  # Key properties
  if [ -f "android/key.properties" ]; then
    print_success "key.properties existe"
  else
    print_error "key.properties NO ENCONTRADO — necesario para release signing"
  fi

  # AdMob IDs check (no son test IDs?)
  local BANNER=$(grep '_prodBannerAdUnitId' "$SERVICE" | head -1)
  if echo "$BANNER" | grep -q "3940256099942544"; then
    print_error "Banner Ad ID parece ser de prueba"
  else
    print_success "Banner Ad ID configurado"
  fi

  local INTERSTITIAL=$(grep '_prodInterstitialAdUnitId' "$SERVICE" | head -1)
  if echo "$INTERSTITIAL" | grep -q "3940256099942544"; then
    print_error "Interstitial Ad ID parece ser de prueba"
  else
    print_success "Interstitial Ad ID configurado"
  fi

  echo ""
  print_info "Si todo está ✔, ejecuta: ./commands.sh build-aab"
}

# ─── Setup (first time) ──────────────────────────────────────────────────────
cmd_setup() {
  local APP_ID="$1"
  local APP_NAME="$2"
  local PROJECT_NAME="$3"

  require_arg "$APP_ID" "Uso: ./commands.sh setup <com.company.app> <\"App Name\"> <project_name_snake>"
  require_arg "$APP_NAME" "Falta nombre de la app"
  require_arg "$PROJECT_NAME" "Falta nombre del proyecto (snake_case)"

  print_header "Setup inicial del proyecto"

  cmd_change_app_id "$APP_ID"
  echo ""
  cmd_change_app_name "$APP_NAME"
  echo ""
  cmd_rename_project "$PROJECT_NAME"
  echo ""
  cmd_toggle_test_ads "true"

  echo ""
  print_header "Setup completado"
  print_info "Próximos pasos:"
  echo "  1. Reemplaza los datos en lib/data/data.dart"
  echo "  2. Actualiza assets/ con tus recursos (logo, sonidos, PDF)"
  echo "  3. Cambia los AdMob IDs: ./commands.sh change-admob-ids ..."
  echo "  4. Configura IAP en Google Play Console"
  echo "  5. Cambia el producto IAP: ./commands.sh change-iap-product ..."
  echo "  6. Actualiza const.dart con tus URLs"
  echo "  7. Ejecuta: flutter pub get"
  echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
#  Command Router
# ═══════════════════════════════════════════════════════════════════════════════

show_help() {
  echo ""
  echo -e "${BOLD}📦 Flutter Template Helper${NC}"
  echo ""
  echo -e "${BOLD}Uso:${NC} ./commands.sh <comando> [argumentos]"
  echo ""
  echo -e "${BOLD}Comandos disponibles:${NC}"
  echo ""
  echo -e "  ${CYAN}setup${NC} <app_id> <\"app_name\"> <project_name>   Setup inicial completo"
  echo -e "  ${CYAN}change-app-id${NC} <com.company.app>               Android Application ID"
  echo -e "  ${CYAN}change-app-name${NC} <\"Nombre\">                    Nombre visible de la app"
  echo -e "  ${CYAN}change-version${NC} <1.0.0> [build_number]         Versión de la app"
  echo -e "  ${CYAN}bump-build${NC}                                     Incrementar build number (+1)"
  echo -e "  ${CYAN}change-admob-ids${NC} <APP> <BANNER> <INTERSTITIAL> IDs de AdMob"
  echo -e "  ${CYAN}toggle-test-ads${NC} <true|false>                  Activar/desactivar ads de prueba"
  echo -e "  ${CYAN}change-iap-product${NC} <product_id>               ID del producto premium"
  echo -e "  ${CYAN}change-playstore-url${NC} <url>                    URL de la Play Store"
  echo -e "  ${CYAN}change-pdf-url${NC} <url>                          URL del PDF de guía"
  echo -e "  ${CYAN}change-exam-config${NC} <min> <total> <passing>    Config del examen"
  echo -e "  ${CYAN}change-splash-color${NC} <#HEX>                    Color del splash screen"
  echo -e "  ${CYAN}rename-project${NC} <snake_case_name>              Renombrar proyecto Flutter"
  echo -e "  ${CYAN}generate-splash${NC}                                Generar splash screen"
  echo -e "  ${CYAN}build-apk${NC}                                      Build APK release"
  echo -e "  ${CYAN}build-aab${NC}                                      Build AAB para Play Store"
  echo -e "  ${CYAN}clean${NC}                                          Limpiar + pub get"
  echo -e "  ${CYAN}info${NC}                                           Mostrar info del proyecto"
  echo -e "  ${CYAN}checklist${NC}                                      Checklist pre-deploy"
  echo ""
}

case "${1:-}" in
  change-app-id)      cmd_change_app_id "$2" ;;
  change-app-name)    cmd_change_app_name "$2" ;;
  change-version)     cmd_change_version "$2" "$3" ;;
  bump-build)         cmd_bump_build ;;
  change-admob-ids)   cmd_change_admob_ids "$2" "$3" "$4" ;;
  toggle-test-ads)    cmd_toggle_test_ads "$2" ;;
  change-iap-product) cmd_change_iap_product "$2" ;;
  change-playstore-url) cmd_change_playstore_url "$2" ;;
  change-pdf-url)     cmd_change_pdf_url "$2" ;;
  change-exam-config) cmd_change_exam_config "$2" "$3" "$4" ;;
  change-splash-color) cmd_change_splash_color "$2" ;;
  rename-project)     cmd_rename_project "$2" ;;
  generate-splash)    cmd_generate_splash ;;
  build-apk)          cmd_build_apk ;;
  build-aab)          cmd_build_aab ;;
  clean)              cmd_clean ;;
  info)               cmd_info ;;
  checklist)          cmd_checklist ;;
  setup)              cmd_setup "$2" "$3" "$4" ;;
  help|--help|-h)     show_help ;;
  *)
    print_error "Comando desconocido: '${1:-}'"
    show_help
    exit 1
    ;;
esac
