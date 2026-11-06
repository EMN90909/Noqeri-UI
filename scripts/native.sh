#!/usr/bin/env bash
# Native Noqeri UI compiler: No Node.js, JavaScript, or npm.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NOQERI_SOURCE="${NOQERI_SOURCE:-$ROOT/../Noqeri}"
NOQERI_WEB_BIN="${NOQERI_WEB_BIN:-$NOQERI_SOURCE/build/noqeri-web}"
MODE="${1:-build}"
DEST="${2:-$ROOT/dist/native}"
APP_SOURCE="${3:-}"
if [[ "$MODE" != "build" && "$MODE" != "serve" ]]; then
  echo "Usage: bash scripts/native.sh [build output-directory [app.noqeri] | serve port [app.noqeri]]" >&2
  exit 2
fi
if [[ ! -x "$NOQERI_WEB_BIN" ]]; then
  echo "Noqeri native web compiler not found: $NOQERI_WEB_BIN" >&2
  echo "Build it with: cmake -S $NOQERI_SOURCE -B $NOQERI_SOURCE/build && cmake --build $NOQERI_SOURCE/build --target noqeri-web" >&2
  exit 1
fi
CORE="$NOQERI_SOURCE/Lib/web/ui.noqeri"
if [[ ! -f "$CORE" ]]; then
  echo "Missing Noqeri core UI library: $CORE" >&2
  exit 1
fi
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/app"
# Noqeri's native UI importer is currently restricted to "noqeri/ui".
# Load both libraries through its documented NOQERI_WEB_UI_PATH interface.
# Prefix the core names to avoid shadowing Noqeri UI's public names.
{
  printf '// Components from Noqeri core (Apache-2.0), prefixed Core*\n'
  sed -E '/^module /d; s/^component ([A-Za-z][A-Za-z_0-9]*)\(/component Core\1(/' "$CORE"
  printf '\n// Components from Noqeri-UI (MIT)\n'
  cat "$ROOT/src/components.noqeri"
} > "$TMP/ui.noqeri"
# Accept a real application source path, not only the built-in demonstration.
if [[ -n "$APP_SOURCE" ]]; then
  if [[ -d "$APP_SOURCE" ]]; then APP_SOURCE="$APP_SOURCE/main.noqeri"; fi
  if [[ ! -f "$APP_SOURCE" || "${APP_SOURCE##*.}" != "noqeri" ]]; then
    echo "Application source must be an existing .noqeri file or a directory with main.noqeri: $APP_SOURCE" >&2
    exit 2
  fi
else
  if [[ "$MODE" == "build" ]]; then
    APP_SOURCE="$ROOT/examples/native/main.noqeri"
  else
    APP_SOURCE="$ROOT/examples/native-actions/main.noqeri"
  fi
fi
# The native compiler embeds custom CSS into its generated same-origin theme.css.
# It never loads client-side JavaScript.
{
  printf 'style """\n'
  cat "$ROOT/styles.css"
  printf '\n"""\n'
  cat "$APP_SOURCE"
} > "$TMP/app/main.noqeri"
if [[ "$MODE" == "build" ]]; then
  NOQERI_WEB_UI_PATH="$TMP/ui.noqeri" "$NOQERI_WEB_BIN" build "$TMP/app" "$DEST"
else
  NOQERI_WEB_REACTIVE=0 NOQERI_WEB_UI_PATH="$TMP/ui.noqeri" "$NOQERI_WEB_BIN" serve-app "$TMP/app" "$DEST" "$TMP/state.nqkv"
fi
