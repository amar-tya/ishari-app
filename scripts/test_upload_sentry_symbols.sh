#!/usr/bin/env bash
# Tests for scripts/upload_sentry_symbols.sh. `dart` is replaced by a stub, so
# nothing is downloaded or uploaded and no real token is needed.
set -u

SCRIPT="$(cd "$(dirname "$0")" && pwd)/upload_sentry_symbols.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
failures=0

mkdir -p "$WORK/bin"
cat >"$WORK/bin/dart" <<'EOF'
#!/usr/bin/env bash
echo "$*" >"$STUB_RECORD"
echo "SENTRY_RELEASE=${SENTRY_RELEASE:-}" >>"$STUB_RECORD"
echo "$STUB_OUTPUT"
exit "$STUB_EXIT"
EOF
chmod +x "$WORK/bin/dart"

export PATH="$WORK/bin:$PATH"
export STUB_RECORD="$WORK/record"

OK_SUMMARY='Dart symbol map upload summary: attempted=3, succeeded=3, failed=0'

# Fresh project directory with symbols and an obfuscation map in place.
reset() {
  rm -rf "$WORK/project" "$STUB_RECORD"
  mkdir -p "$WORK/project/build/symbols" "$WORK/project/build/map"
  echo symbols >"$WORK/project/build/symbols/app.android-arm64.symbols"
  echo '["a","b"]' >"$WORK/project/build/map/obfuscation.json"
  export SENTRY_AUTH_TOKEN=stub-token
  export STUB_OUTPUT="$OK_SUMMARY"
  export STUB_EXIT=0
}

# check <name> <expected: pass|fail> <text expected in output> [script args...]
check() {
  local name="$1" expected="$2" text="$3" output status actual
  shift 3
  output="$(cd "$WORK/project" && bash "$SCRIPT" "$@" 2>&1)"
  status=$?
  if [ "$status" -eq 0 ]; then actual=pass; else actual=fail; fi
  if [ "$actual" = "$expected" ] && [[ "$output" == *"$text"* ]]; then
    echo "PASS: $name"
  else
    echo "FAIL: $name (exit $status)"
    echo "$output"
    failures=$((failures + 1))
  fi
}

assert() {
  local name="$1"
  shift
  if "$@"; then
    echo "PASS: $name"
  else
    echo "FAIL: $name"
    failures=$((failures + 1))
  fi
}

ARGS=(1.2.3+4 build/map/obfuscation.json)

reset
check "uploads when everything is present" pass "Sentry symbols uploaded for 1.2.3+4" "${ARGS[@]}"
assert "release name matches the one the app reports" grep -qx 'SENTRY_RELEASE=1.2.3+4' "$STUB_RECORD"
assert "plugin gets the symbols directory" grep -q -- '--sentry-define=symbols_path=build/symbols' "$STUB_RECORD"
assert "plugin gets the obfuscation map" grep -q -- '--sentry-define=dart_symbol_map_path=build/map/obfuscation.json' "$STUB_RECORD"

reset
unset SENTRY_AUTH_TOKEN
check "missing token fails and names the secret" fail "::error title=Sentry symbols not uploaded::SENTRY_AUTH_TOKEN" "${ARGS[@]}"
assert "plugin is not run without a token" test ! -e "$STUB_RECORD"

reset
export SENTRY_AUTH_TOKEN=''
check "empty token (unset GitHub secret) fails" fail "SENTRY_AUTH_TOKEN" "${ARGS[@]}"

reset
rm "$WORK/project/build/symbols/app.android-arm64.symbols"
check "missing symbol file fails" fail "app.android-arm64.symbols" "${ARGS[@]}"

reset
: >"$WORK/project/build/symbols/app.android-arm64.symbols"
check "empty symbol file fails" fail "app.android-arm64.symbols" "${ARGS[@]}"

reset
rm "$WORK/project/build/map/obfuscation.json"
check "missing obfuscation map fails" fail "build/map/obfuscation.json" "${ARGS[@]}"

reset
check "missing arguments fail" fail "Usage:"

reset
export STUB_EXIT=1
check "plugin error fails" fail "::error title=Sentry symbols not uploaded::" "${ARGS[@]}"

reset
export STUB_OUTPUT='Skipping Dart symbol map uploads: no Flutter-relevant debug files found.'
check "silent skip with exit 0 fails" fail "::error title=Sentry symbols not uploaded::" "${ARGS[@]}"

reset
export STUB_OUTPUT='Dart symbol map upload summary: attempted=3, succeeded=2, failed=1'
check "partly failed map upload with exit 0 fails" fail "::error title=Sentry symbols not uploaded::" "${ARGS[@]}"

reset
export STUB_OUTPUT='Dart symbol map upload summary: attempted=0, succeeded=0, failed=0'
check "nothing uploaded with exit 0 fails" fail "::error title=Sentry symbols not uploaded::" "${ARGS[@]}"

echo
if [ "$failures" -ne 0 ]; then
  echo "$failures check(s) failed."
  exit 1
fi
echo "All Sentry symbol upload checks passed."
