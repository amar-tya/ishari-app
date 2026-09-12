# Spec: Copy & Share actions on verse card (AMA-76)

## Objective
`VerseCard` punya tombol "more" (`Icons.more_horiz_rounded`) di action row sebelah bookmark, tapi `onTap: () {}` — belum ada aksi. User baca ayat di muhud/chapter reader, mau cepat salin teks ayat atau share ke app lain (WhatsApp, dll) tanpa harus select-text manual dari Arabic/RTL text.

Success: tap "more" → bottom sheet 2 opsi (Salin, Bagikan) → masing-masing beraksi atas teks ayat lengkap (arabic + transliteration + translation), independen dari toggle tampilan (`showArabic`/`showTransliteration`/`showTranslation`).

**Scope decision (revisi):** Awalnya rencana pakai `share_plus` untuk native OS share sheet, tapi itu plugin native baru — CLAUDE.md tegas: dependency/plugin baru wajib rilis penuh Play Store, TIDAK bisa lewat Shorebird patch. User mau fitur ini dikirim sebagai patch kecil, jadi "Bagikan" diganti: buka WhatsApp langsung via `url_launcher` (`whatsapp://send?text=...`) yang sudah jadi dependency existing. Trade-off: bukan universal share sheet, cuma WhatsApp — tapi zero new dependency, patchable.

## Tech Stack
Flutter (existing app) — no new architecture layer, no new dependency. Pure presentation-widget change in `lib/features/muhud/presentation/widgets/verse_card.dart`. Copy pakai `Clipboard` dari `flutter/services.dart` (SDK). Share pakai `url_launcher` (sudah ada di `pubspec.yaml`) dengan scheme `whatsapp://send?text=`.

## Commands
```
flutter pub get
flutter analyze
flutter run
```
(No `build_runner` needed — no `@freezed`/`@injectable`/`@JsonSerializable` class touched.)

## Project Structure
```
lib/features/muhud/presentation/widgets/verse_card.dart   → target file, add menu + actions
lib/features/muhud/presentation/widgets/verse_list.dart   → reference only (existing callback pattern), NOT modified
```
(No `pubspec.yaml` change — `url_launcher` already a dependency.)

## Code Style
Follow existing file conventions in `verse_card.dart`: single quotes, private widgets prefixed `_`, `const` constructors where possible, `very_good_analysis` lint. Example — new private helper mirrors existing `_ActionButton`/`_VerseNumberBadge` style:

```dart
String _buildShareText(VerseWithDetailsEntity verse, TranslationEntity? translation) {
  final parts = <String>[
    verse.verse.arabicText,
    if (verse.verse.transliteration.isNotEmpty) verse.verse.transliteration,
    if (translation != null) translation.translationText,
  ];
  return parts.join('\n\n');
}
```

## Testing Strategy
No existing widget tests for `muhud` feature (`test/` has no `muhud` dir today) — this change does not introduce a new test suite by itself. Verification is manual per Linear DoD: `flutter analyze` clean + manual tap-through on device/emulator (menu opens, copy shows snackbar + clipboard has full text, WhatsApp opens with full text prefilled, WhatsApp-not-installed doesn't crash, verse without translation doesn't crash).

## Boundaries
- **Always:** keep copy/share logic local to `VerseCard`/`_VerseCardState` (no BLoC event, no callback prop added to `VerseCard`'s public API) since it's a pure UI action with no domain/data side-effect; run `flutter analyze` before considering done; no new dependency (this ships as a Shorebird patch, not a full release).
- **Ask first:** nothing expected — scope is contained to one widget file, zero new dependencies.
- **Never:** touch `onBookmarkToggle`, `onPlayTap`, or any BLoC/state management in `muhud`; don't add image-share, custom share templates, or analytics tracking (explicitly out of scope per Linear issue); don't add `share_plus` or any native plugin (blocks Shorebird patch).

## Success Criteria
- [ ] Tap more icon → bottom sheet with "Salin" and "Bagikan" opens
- [ ] "Salin" copies arabic + transliteration + translation (all available fields) to clipboard regardless of current show/hide toggles, shows snackbar feedback
- [ ] "Bagikan" opens WhatsApp (via `url_launcher`) with the same full text prefilled in the message field
- [ ] WhatsApp not installed → `canLaunchUrl` fails gracefully, snackbar feedback, no crash
- [ ] Verse with no translation: copy/share works with just arabic + transliteration, no crash
- [ ] `flutter analyze` clean, no regression on bookmark/play buttons in the same row
- [ ] `pubspec.yaml` unchanged (no new dependency) — confirms this is patchable via `shorebird patch android`

## Open Questions
None — requirements confirmed via Linear issue AMA-76 (including the follow-up clarification that copied/shared text always includes all fields, independent of display toggles).

Ref: https://linear.app/amarfirmansyah/issue/AMA-76/add-copy-and-share-actions-to-verse-card-more-button-in-muhud-reader
