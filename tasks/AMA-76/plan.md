# Plan: AMA-76 Copy & Share verse actions

**Revised:** Share = open WhatsApp via `url_launcher` (no `share_plus`, no new dependency) so this change is patchable via `shorebird patch android` instead of requiring a full Play Store release.

## Components
1. **Text builder** — helper that assembles full copy/share text from `VerseWithDetailsEntity` (arabic + transliteration + first/`id` translation), independent of the widget's display toggles.
2. **Action sheet UI** — `showModalBottomSheet` triggered from more button's `onTap`, listing "Salin" / "Bagikan" with icons, consistent with app's existing bottom-sheet/rounded style.
3. **Wire actions** — Salin → `Clipboard.setData` + `ScaffoldMessenger` snackbar. Bagikan → `Uri.parse('whatsapp://send?text=$encoded')` + `canLaunchUrl`/`launchUrl` from `url_launcher`, with snackbar fallback if WhatsApp isn't installed.

## Dependency order
1 → 2 → 3 (sequential; single file, no pubspec change).

## Risks
- `whatsapp://` scheme on Android 11+ needs the package visibility query declared, OR just rely on `canLaunchUrl` returning false gracefully — check `android/app/src/main/AndroidManifest.xml` for existing `<queries>` block (url_launcher may already need this for other schemes).
- RTL Arabic text in WhatsApp message: WhatsApp handles RTL fine, not our concern.

## Verification checkpoints
- After step 2: manual run, more button opens sheet.
- After step 3: manual run — copy → clipboard verified (paste somewhere); share → WhatsApp opens with correct text prefilled; test with WhatsApp not installed (or airplane-mode style check via `canLaunchUrl` false path); test with a verse missing translation.
- Final: `flutter analyze` clean; `git diff pubspec.yaml` empty (proves no new dependency, patch-safe).
