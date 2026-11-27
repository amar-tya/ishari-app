#!/usr/bin/env bash
# Uploads the Dart debug symbols and obfuscation map of the build that just ran
# to Sentry, so production stack traces and issue titles are readable.
#
# Usage: SENTRY_AUTH_TOKEN=... scripts/upload_sentry_symbols.sh <release> <obfuscation-map>
#   <release>          version+build, as the app reports it (see lib/main.dart)
#   <obfuscation-map>  file written by --save-obfuscation-map during the build
# Run from the project root, after a build with --split-debug-info=build/symbols.
#
# Exits non-zero unless the upload is confirmed. sentry_dart_plugin can exit 0
# without uploading anything, so its exit code alone is not enough.
set -euo pipefail

SYMBOLS_DIR=build/symbols

fail() {
  echo "::error title=Sentry symbols not uploaded::$1"
  exit 1
}

[ "$#" -eq 2 ] && [ -n "$1" ] && [ -n "$2" ] ||
  fail "Usage: upload_sentry_symbols.sh <release> <obfuscation-map>"
release="$1"
obfuscation_map="$2"

[ -n "${SENTRY_AUTH_TOKEN:-}" ] ||
  fail "SENTRY_AUTH_TOKEN is empty. Add it as a GitHub Actions secret (Sentry organization auth token). Crashes from $release stay unreadable until its symbols are uploaded."

# arm64 covers nearly all devices, so a build without it is not what we expect.
[ -s "$SYMBOLS_DIR/app.android-arm64.symbols" ] ||
  fail "$SYMBOLS_DIR/app.android-arm64.symbols is missing or empty. Was the build run with --split-debug-info=$SYMBOLS_DIR?"

[ -s "$obfuscation_map" ] ||
  fail "Obfuscation map $obfuscation_map is missing or empty."

log="$(mktemp)"
trap 'rm -f "$log"' EXIT

# The plugin reads SENTRY_AUTH_TOKEN from the environment, so the token never
# appears on a command line.
if ! SENTRY_RELEASE="$release" dart run sentry_dart_plugin \
  "--sentry-define=symbols_path=$SYMBOLS_DIR" \
  "--sentry-define=dart_symbol_map_path=$obfuscation_map" 2>&1 | tee "$log"; then
  fail "sentry_dart_plugin failed for $release. See the log above; check that SENTRY_AUTH_TOKEN is valid and may upload to this project."
fi

# Printed by the plugin only after it paired the map with the symbol files.
grep -Eq 'Dart symbol map upload summary: attempted=[0-9]+, succeeded=[1-9][0-9]*, failed=0([^0-9]|$)' "$log" ||
  fail "sentry_dart_plugin exited successfully but did not confirm the symbol upload for $release. See the log above."

echo "Sentry symbols uploaded for $release."
