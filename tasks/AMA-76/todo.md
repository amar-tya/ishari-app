# Tasks: AMA-76

- [ ] Task: Build full verse text helper + wire "more" button to show action sheet
  - Acceptance: tapping more icon opens bottom sheet with "Salin" and "Bagikan" options; text helper concatenates arabic + transliteration + translation (skipping empty fields) regardless of display toggles
  - Verify: `flutter analyze`; manual run, tap more button, sheet appears
  - Files: `lib/features/muhud/presentation/widgets/verse_card.dart`

- [ ] Task: Implement Salin (copy) action
  - Acceptance: selecting "Salin" copies full text to clipboard, shows snackbar "Teks disalin"
  - Verify: manual — tap Salin, paste in another text field, confirm content matches
  - Files: `lib/features/muhud/presentation/widgets/verse_card.dart`

- [ ] Task: Implement Bagikan (share via WhatsApp) action
  - Acceptance: selecting "Bagikan" opens WhatsApp via `url_launcher` with the same full text prefilled; if WhatsApp isn't installed, shows snackbar instead of crashing
  - Verify: manual — tap Bagikan, confirm WhatsApp opens with correct text; check `canLaunchUrl` false path
  - Files: `lib/features/muhud/presentation/widgets/verse_card.dart`

- [ ] Task: Edge case + regression check
  - Acceptance: verse without translation copies/shares fine (arabic + transliteration only), no crash; bookmark/play buttons still work unaffected; `pubspec.yaml` untouched
  - Verify: manual test on a verse with empty translation list; `flutter analyze` clean; `git diff pubspec.yaml` empty
  - Files: `lib/features/muhud/presentation/widgets/verse_card.dart`
