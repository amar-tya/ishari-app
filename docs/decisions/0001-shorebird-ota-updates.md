# 1. Shorebird for Android OTA code push

## Status

Accepted

## Context

Dart/Flutter-only bug fixes (no native code change, no new asset, no new
permission) previously required a full Play Store release — build, submit,
review, staged rollout — to reach users. Review turnaround is hours to days,
which is too slow for a hotfix after a bad production release.

We needed a way to push small Dart-level patches directly to installed apps
without going through Play Store review, while keeping the existing release
pipeline (`build-and-distribute-android.yml`: cider version bump → Firebase
App Distribution → Google Play production track) intact for regular releases.

## Decision

Adopt [Shorebird](https://shorebird.dev) for Android OTA code push:

- CI builds production releases via `shorebird release android --artifact apk
  --flutter-version 3.41.6 -- --obfuscate --split-debug-info=build/symbols`
  instead of `flutter build appbundle`/`flutter build apk` directly.
  `--artifact apk` produces the `.aab` in the same run, so the existing
  Firebase Distribution and Google Play upload steps consume the same output
  paths unchanged.
- `--flutter-version 3.41.6` pins Shorebird's build to the same Flutter
  version the rest of the project targets (`.fvmrc`), since Shorebird
  otherwise bundles its own Flutter version that drifts from ours.
- `--split-per-abi` is **not** used — Shorebird hard-rejects it ("does not
  support the split-per-abi option at this time",
  [shorebirdtech/shorebird#1141](https://github.com/shorebirdtech/shorebird/issues/1141),
  still open as of CLI 1.6.115, verified locally). We ship one universal APK
  instead of per-ABI APKs — larger file, but patches actually work.
- Patches are pushed manually per hotfix (`shorebird patch android
  --release-version=<version+build>`), not auto-triggered on every commit.
  See `CLAUDE.md` for the documented command.
- `shorebird.yaml` (app registered on Shorebird console, `app_id` committed —
  not a secret) lives at the project root.
- `SHOREBIRD_TOKEN` (generated manually via console.shorebird.dev → Account →
  API Keys — `shorebird login:ci` was removed in CLI 1.6.115) is held as a
  GitHub Actions secret, set up by the account owner outside of CI.

## Alternatives Considered

- **Full Play Store release for every hotfix** — status quo. Rejected:
  review turnaround (hours–days) is too slow for post-release hotfixes;
  motivated this decision in the first place.
- **Firebase Remote Config / feature flags for kill-switches** — mitigates
  some bad-release scenarios by disabling a feature remotely, but can't ship
  an actual code fix. Complementary, not a replacement — out of scope here.
- **Codemagic / other CI-native app distribution with expedited review** —
  doesn't remove Play Store review latency, only automates the submission
  step. Doesn't solve the core problem.
- **Roll our own OTA patch mechanism** (e.g. custom Dart VM snapshot
  delivery) — significant build/maintenance cost for something Shorebird
  already provides as a maintained product built on Flutter's own patching
  primitives.

## Consequences

**Positive**

- Dart/Flutter-only hotfixes reach installed devices on next app restart,
  without Play Store review.
- Existing release pipeline (version bump, Firebase testers distribution,
  Play Store production upload) is unaffected — Shorebird only replaces the
  `flutter build` step and produces the same artifact paths.

**Negative / risks**

- New external dependency: releases now require a working Shorebird console
  account and valid `SHOREBIRD_TOKEN`; if the Shorebird service is
  unavailable, production release builds fail (rollback: revert
  `build-and-distribute-android.yml` to a plain `flutter build`
  apk/appbundle step — patches are additive/opt-in per release, so already
  Play Store–published builds are unaffected).
- Universal APK only (no per-ABI splits) — larger download/install size for
  Firebase testers than the previous per-ABI build.
- Scope is Android only. No iOS CI workflow exists yet in this repo; iOS
  Shorebird integration is tracked separately (AMA-57).
- Patches cannot touch native code, add new assets, or require new
  permissions — those changes still require a full Play Store release.
- Patches are manual/opt-in per hotfix, not automatic — a hotfix isn't live
  until someone explicitly runs `shorebird patch`.
