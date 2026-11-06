#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NOQERI_SOURCE="${NOQERI_SOURCE:-$ROOT/../Noqeri}"
NOQERI_BIN="${NOQERI_BIN:-$NOQERI_SOURCE/build/noqeri}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
bash "$ROOT/scripts/native.sh" build "$TMP/site"
# Rendering all public exports catches invalid HTML, attributes and arguments.
bash "$ROOT/scripts/native.sh" build "$TMP/coverage" "$ROOT/tests/component-coverage.noqeri"
test -s "$TMP/coverage/index.html"
grep -q "native component coverage" "$TMP/coverage/index.html"
test -s "$TMP/site/index.html"
test -s "$TMP/site/components/index.html"
test -s "$TMP/site/forms/index.html"
test -s "$TMP/site/theme.css"
grep -q 'nui-card' "$TMP/site/components/index.html"
grep -q 'nq-card' "$TMP/site/components/index.html"
grep -q 'nui-accordion-item' "$TMP/site/components/index.html"
grep -q 'CoreNotice imported' "$TMP/site/index.html"
grep -q -- '--nui-primary' "$TMP/site/theme.css"
if grep -RiE '<script|\.mjs|javascript:' "$TMP/site"; then
  echo "Native build unexpectedly included JavaScript" >&2
  exit 1
fi
if find "$TMP/site" -type f \( -name '*.js' -o -name '*.mjs' \) | grep -q .; then
  echo "Native build emitted JavaScript assets" >&2
  exit 1
fi
if [[ ! -x "$NOQERI_BIN" ]]; then
  echo "Missing Noqeri compiler: $NOQERI_BIN" >&2
  exit 1
fi
"$NOQERI_BIN" check "$ROOT/tests/ecosystem_test.noqeri"
RESULT="$("$NOQERI_BIN" run "$ROOT/tests/ecosystem_test.noqeri")"
if [[ "$RESULT" != "0" ]]; then
  echo "Noqeri ecosystem test failed: $RESULT" >&2
  exit 1
fi
# Exercise the fully native server-rendered example without reactive JS.
PORT=40983
bash "$ROOT/scripts/native.sh" serve "$PORT" >"$TMP/server.log" 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true; wait "$SERVER_PID" 2>/dev/null || true; rm -rf "$TMP"' EXIT
READY=0
for i in $(seq 1 50); do
  if curl --max-time 2 -fsS "http://127.0.0.1:$PORT/" -o "$TMP/server.html" 2>/dev/null; then
    READY=1
    break
  fi
  if ! kill -0 "$SERVER_PID" 2>/dev/null; then break; fi
  sleep 0.2
done
if [[ "$READY" != "1" ]]; then
  cat "$TMP/server.log" >&2
  echo "Native action server did not serve HTML" >&2
  exit 1
fi
grep -q 'Button clicks' "$TMP/server.html"
grep -q 'name="displayName"' "$TMP/server.html"
if grep -qi '<script' "$TMP/server.html"; then
  echo "Native action server emitted a script" >&2
  exit 1
fi
bash "$ROOT/scripts/test-actions.sh" "$PORT" "$TMP"
echo "Noqeri UI native static build, all components, registry imports and no-JavaScript actions: PASS"
