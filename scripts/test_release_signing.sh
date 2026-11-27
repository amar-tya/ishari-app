#!/usr/bin/env bash
# Behaviour test for the release signing guard in android/app/build.gradle.kts.
#
# Runs Gradle up to the variant "pre build" tasks only, so nothing is compiled,
# signed or uploaded. Needs android/local.properties,
# android/app/google-services.json and a cached Gradle (runs with --offline).
#
# Usage: GRADLE=/path/to/gradle scripts/test_release_signing.sh
set -u

cd "$(dirname "$0")/../android" || exit 1

GRADLE="${GRADLE:-./gradlew}"
KEY_FILE=key.properties

if [ -e "$KEY_FILE" ]; then
  echo "android/$KEY_FILE exists. Refusing to run: this test must start without it." >&2
  exit 2
fi

unset ORG_GRADLE_PROJECT_allowDebugSigning
failures=0
LOG="$(mktemp)"
created_key=0
cleanup() {
  rm -f "$LOG"
  if [ "$created_key" = 1 ]; then rm -f "$KEY_FILE"; fi
}
trap cleanup EXIT

run() {
  "$GRADLE" --offline "$@" >"$LOG" 2>&1
}

report() {
  if [ "$1" = 0 ]; then
    echo "PASS: $2"
  else
    echo "FAIL: $2"
    tail -20 "$LOG"
    failures=$((failures + 1))
  fi
}

expect_success() {
  local name="$1"
  shift
  run "$@"
  report $? "$name"
}

expect_guard_failure() {
  local name="$1"
  shift
  if run "$@"; then
    report 1 "$name (build succeeded)"
  else
    grep -q 'Release signing is not configured' "$LOG"
    report $? "$name"
  fi
}

expect_in_task_graph() {
  local task="$1"
  run "$task" --dry-run && grep -q ':app:verifyReleaseSigning' "$LOG"
  report $? "$task runs the signing guard"
}

expect_guard_failure "release without key.properties fails" :app:preReleaseBuild
expect_guard_failure "opt-in set to false still fails" :app:preReleaseBuild -PallowDebugSigning=false
expect_success "-PallowDebugSigning allows release" :app:preReleaseBuild -PallowDebugSigning
expect_success "-PallowDebugSigning=true allows release" :app:preReleaseBuild -PallowDebugSigning=true
ORG_GRADLE_PROJECT_allowDebugSigning=true \
  expect_success "ORG_GRADLE_PROJECT_allowDebugSigning=true allows release" :app:preReleaseBuild
expect_success "debug build is unaffected" :app:preDebugBuild
expect_success "profile build is unaffected" :app:preProfileBuild
expect_in_task_graph :app:assembleRelease
expect_in_task_graph :app:bundleRelease

# A present key.properties satisfies the guard. The values are placeholders:
# nothing is signed because Gradle stops before packaging.
printf 'storePassword=x\nkeyPassword=x\nkeyAlias=x\nstoreFile=placeholder.jks\n' >"$KEY_FILE"
created_key=1
expect_success "release with key.properties passes the guard" :app:preReleaseBuild

# On Windows an unclosed stream in the Gradle daemon keeps the file locked.
rm -f "$KEY_FILE" 2>"$LOG"
report $? "Gradle does not keep key.properties open"

echo
if [ "$failures" -ne 0 ]; then
  echo "$failures check(s) failed."
  exit 1
fi
echo "All release signing checks passed."
