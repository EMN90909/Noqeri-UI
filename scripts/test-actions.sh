#!/usr/bin/env bash
# Functional native Noqeri button/form/CSRF test, zero JavaScript.
set -euo pipefail
PORT="${1:?Missing native server port}"
TMP="${2:?Missing temporary directory}"
URL="http://127.0.0.1:$PORT/"
COOKIE="$TMP/cookies.txt"
HOME="$TMP/native-home.html"
HEADERS="$TMP/native-headers.txt"
extract_csrf() {
  grep -oE 'name="_nq_csrf" value="[a-z0-9]+"' "$1" | sed -nE '1s/.*value="([^"]+)".*/\1/p'
}
extract_actions() {
  grep -oE 'name="_nq_action" value="[0-9]+"' "$1" | sed -E 's/.*value="([^"]+)".*/\1/'
}
status="$(curl --silent --show-error --cookie "$COOKIE" --cookie-jar "$COOKIE" \
  --dump-header "$HEADERS" --output "$HOME" --write-out '%{http_code}' "$URL")"
[[ "$status" == "200" ]] || { echo "Initial GET returned HTTP $status" >&2; exit 1; }
grep -qi 'content-security-policy' "$HEADERS"
grep -qi 'httponly' "$HEADERS"
TOKEN="$(extract_csrf "$HOME")"
mapfile -t ACTIONS < <(extract_actions "$HOME")
[[ -n "$TOKEN" && "${#ACTIONS[@]}" -ge 2 ]] || { echo "Missing native action IDs or CSRF" >&2; exit 1; }
CLICK_CODE="$(curl --silent --show-error --cookie "$COOKIE" --cookie-jar "$COOKIE" \
 --output "$TMP/posted.html" --write-out '%{http_code}' \
 --data-urlencode "_nq_csrf=$TOKEN" --data-urlencode "_nq_action=${ACTIONS[0]}" "$URL")"
[[ "$CLICK_CODE" == "303" ]] || { echo "Click POST returned HTTP $CLICK_CODE (expected 303)" >&2; exit 1; }
REPLAY_CODE="$(curl --silent --show-error --cookie "$COOKIE" --cookie-jar "$COOKIE" \
 --output "$TMP/replay.html" --write-out '%{http_code}' \
 --data-urlencode "_nq_csrf=$TOKEN" --data-urlencode "_nq_action=${ACTIONS[0]}" "$URL")"
[[ "$REPLAY_CODE" == "403" ]] || { echo "CSRF replay returned HTTP $REPLAY_CODE (expected 403)" >&2; exit 1; }
curl --silent --show-error --cookie "$COOKIE" --cookie-jar "$COOKIE" --output "$HOME" "$URL"
grep -q 'Button clicks: 1' "$HOME" || { echo "Server click didn't update the counter" >&2; exit 1; }
TOKEN="$(extract_csrf "$HOME")"
mapfile -t ACTIONS < <(extract_actions "$HOME")
[[ -n "$TOKEN" && "${#ACTIONS[@]}" -ge 2 ]] || exit 1
FORM_CODE="$(curl --silent --show-error --cookie "$COOKIE" --cookie-jar "$COOKIE" \
 --output "$TMP/form-post.html" --write-out '%{http_code}' \
 --data-urlencode "_nq_csrf=$TOKEN" --data-urlencode "_nq_action=${ACTIONS[1]}" \
 --data-urlencode 'displayName=Manu <svg onload=alert(1)>' "$URL")"
[[ "$FORM_CODE" == "303" ]] || { echo "Form POST returned HTTP $FORM_CODE (expected 303)" >&2; exit 1; }
curl --silent --show-error --cookie "$COOKIE" --cookie-jar "$COOKIE" --output "$HOME" "$URL"
grep -Fq 'Manu &lt;svg onload=alert(1)&gt;' "$HOME" || {
  echo "Server didn't persist and HTML-escape submitted form data" >&2; exit 1;
}
if grep -q '<svg onload' "$HOME"; then
  echo "Unsafe user-submitted markup was rendered" >&2; exit 1;
fi
echo "PASS: no-JavaScript POST click, session state, form submit, HTML escape, CSRF replay rejection"
