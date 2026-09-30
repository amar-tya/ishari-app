# Spec: Route chapter_media notification tap to Audio page

## Objective
Tap notif "Audio Baru" trigger dari `chapter_media` (full-chapter recording, bukan per-verse) → app buka `ChapterReaderPage` (`/chapter/:id`). SEHARUSNYA buka `AudioListPage` (`/audio`) — `chapter_media` itu track audio standalone, bukan bacaan verse-by-verse, jadi salah konteks kalau dibawa ke reader.

Notif dari `verse_media` (per-verse audio) TETAP harus ke `ChapterReaderPage` — itu benar, ga diubah.

Root cause: `FcmService._navigateToChapter` (`lib/features/push_notification/data/services/fcm_service.dart:95`) selalu `go('/chapter/$chapterId...')` apa pun sumbernya, ga ngecek `verseId` buat nentuin tujuan.

**Cara bedain di client:** edge function `notify-new-audio` (`supabase/functions/notify-new-audio/index.ts:306-311`) cuma sisipin `verseId` ke FCM data kalau sumbernya `verse_media` (chapter_media punya `verseId: null` di `ChapterInfo`, di-spread-out jadi key-nya ga ada sama sekali). Jadi cukup: `verseId` ada & non-empty → chapter reader; `verseId` kosong/absen → audio list. **Ga perlu ubah backend/edge function.**

## Tech Stack
Flutter/Dart, existing stack — no dependency baru, no perubahan Supabase/edge function.

## Commands
```bash
flutter analyze
flutter run
```

## Project Structure
```
lib/features/push_notification/data/services/fcm_service.dart   → satu-satunya file yang diubah
```

## Code Style

Ganti `_navigateToChapter` jadi router dua-cabang. Nama & signature call site (`_onNotificationTap`, `onDidReceiveNotificationResponse`) ga berubah — cuma body-nya:

```dart
void _navigateToTarget(String? chapterId, {String? verseId}) {
  final hasVerse = verseId != null && verseId.isNotEmpty;
  final hasChapter = chapterId != null && chapterId.isNotEmpty;
  if (!hasVerse && !hasChapter) return;

  void attempt() {
    final context = rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      final path = hasVerse
          ? '/chapter/$chapterId?verseId=$verseId'
          : AudioListPage.routePath;
      GoRouter.of(context).go(path);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => attempt());
    }
  }

  attempt();
}
```

Tambah import:
```dart
import 'package:ishari/features/audio/presentation/pages/audio_list_page.dart';
```

Rename semua pemanggil `_navigateToChapter(...)` → `_navigateToTarget(...)` (3 call site: `onDidReceiveNotificationResponse`, `_onNotificationTap`, dan retry-loop internalnya sendiri).

Catatan: `hasVerse` butuh `chapterId` juga secara implisit buat bentuk path `/chapter/$chapterId` — kalau ada kasus aneh `verseId` ada tapi `chapterId` null (harusnya ga pernah terjadi dari edge function manapun), fallback ke audio list tetap lebih aman daripada `/chapter/null`. Guard eksplisit boleh ditambah kalau mau defensif, tapi bukan required buat nutup bug ini.

Single quotes, no doc comments beyond existing non-obvious-reasoning style.

## Testing Strategy
Ga ada automated test buat file ini sekarang (static navigation lewat `GoRouter.of(context)`, susah di-unit-test tanpa widget harness). Verifikasi manual, 3 skenario × 3 app state (foreground/background/killed):

1. **chapter_media insert** (curl edge function lokal dengan `table: "chapter_media"`) → tap notif → `AudioListPage` (`/audio`) kebuka, BUKAN chapter reader.
2. **verse_media insert** (`table: "verse_media"`) → tap notif → `ChapterReaderPage` (`/chapter/:id?verseId=...`) kebuka, sama seperti sebelum fix — regression check.
3. `flutter analyze` — clean.

## Boundaries
- **Always:** verse_media path (`/chapter/:id?verseId=...`) tetap identik ke behavior lama — ini regression-sensitive, jangan sampai keubah.
- **Ask first:** nambahin deep-link ke track spesifik di Audio list (auto-play/scroll ke track chapter_media yang baru) — edge function saat ini GA kirim `chapter_media.id` di FCM data payload, jadi butuh perubahan backend (`notify-new-audio/index.ts`) + `AudioListPage` nerima initial-track param. Di luar scope fix ini.
- **Never:** ubah topic FCM (`new_audio`), channel notifikasi, atau isi teks notifikasi.

## Success Criteria
- Notif dari `chapter_media` insert, tap dari state manapun (foreground/background/killed) → `/audio` kebuka.
- Notif dari `verse_media` insert, tap dari state manapun → `/chapter/:id?verseId=...` kebuka, tidak regresi.
- Payload tanpa `chapterId` maupun `verseId` → no-op (behavior lama, ga crash).
- `flutter analyze` clean.

## Open Questions
Resolved — auto-play out of scope (confirmed), spec lama (`docs/fix-fcm-notification-blank-page/spec.md`) udah di-patch biar konsisten.
</content>
