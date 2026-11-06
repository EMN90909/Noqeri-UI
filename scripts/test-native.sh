#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NOQERI_SOURCE="${NOQERI_SOURCE:-$ROOT/../Noqeri}"
NOQERI_BIN="${NOQERI_BIN:-$NOQERI_SOURCE/build/noqeri}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
bash "$ROOT/scripts/native.sh" build "$TMP/site"
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
echo "Noqeri UI native static build, no-JavaScript audit, core library and registry imports: PASS"
