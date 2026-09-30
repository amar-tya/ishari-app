# Spec: Fix blank/white page on FCM notification tap

## Objective
User tap notif "Audio Baru" (trigger dari `chapter_media`/`verse_media` upload) → app kebuka tapi nampilin blank/white page, konsisten kejadian pas cold start (app killed). Crashlytics nangkep fatal exception:

```
type 'Null' is not a subtype of type 'qJ' in type cast
```

Stack trace obfuscated (release build, no symbol file) — exact crash line ga bisa dipastikan tanpa `flutter symbolize`. User konfirmasi skip symbolize, lanjut berdasar audit kode.

Audit nemu 3 defect nyata di code path yang dilewatin notif-tap → chapter-reader:

1. **Ga ada custom `ErrorWidget.builder`.** Ini akar simtom: di Flutter release mode, default behavior kalau ada uncaught exception pas build widget ya render blank/grey screen, tanpa info, tanpa recovery path. Dari MANA PUN uncaught exception-nya asalnya, hasilnya selalu "blank page" — match persis sama laporan bug.
2. **`VerseMediaModel.hadi`** (`lib/features/muhud/data/models/verse_media_model.dart:20`) — field non-nullable (`required HadiMediaModel hadi`), padahal kolom `hadi_id` di tabel `chapter_media`/`verse_media` NULLABLE (FK tanpa `NOT NULL`, lihat `supabase/migrations/20260915120000_create_chapter_media_table.sql:7`). Kalau Supabase PostgREST embed balikin `hadi: null`, generated `fromJson` throw type cast error. Field `duration` di model yang sama UDAH di-handle null-safe (lihat `_idToString` + guard di `toEntity()`) — `hadi` kelewatan. Saat ini tertangkep oleh catch-all di datasource (`muhud_remote_datasource.dart:141`) jadi error state graceful, TAPI tetap defect laten yang harus ditutup.
3. **`MuhudBloc._onLoadChapter`** (`lib/features/muhud/presentation/bloc/muhud_bloc.dart:157`) — catch clause `on Exception catch`. Di Dart, `TypeError` (hasil cast gagal) adalah subclass `Error`, BUKAN `Exception` → clause ini TIDAK menangkap `TypeError`. Kalau ada cast mentah nyelip di try block ini di masa depan, exception-nya lolos uncaught lagi, persis pola crash yang dilaporkan.

**Goal:** app GA AKAN PERNAH nampilin blank/white page lagi akibat uncaught exception manapun (symptom closed permanently), plus 2 defect nyata di atas ditutup (root-cause hardening).

## Tech Stack
Flutter/Dart, existing stack — no dependency baru. `ErrorWidget.builder` (Flutter core API, set sekali di entry point). Freezed — perlu `build_runner` re-run kalau field model diubah.

## Commands
```bash
flutter analyze
dart run build_runner build --delete-conflicting-outputs   # setelah ubah VerseMediaModel
flutter run
```

## Project Structure
```
lib/core/app_loader.dart                                  → set ErrorWidget.builder (di _initialize(), sebelum widget tree lain kebangun)
lib/features/muhud/data/models/verse_media_model.dart      → hadi jadi nullable, toEntity() null-safe
lib/features/muhud/domain/entities/verse_media_entity.dart → hadi jadi nullable (entity ikut kontrak model)
lib/features/muhud/presentation/widgets/*.dart             → consumer widget yang akses verseMedia.hadi.* perlu null-check (cari via grep)
lib/features/muhud/presentation/bloc/muhud_bloc.dart        → widen catch clause _onLoadChapter
```

## Code Style

**ErrorWidget.builder** — set di `AppLoader._initialize()` (`app_loader.dart`), sebelum `configureDependencies()`, konsisten posisi sama `FlutterError.onError` override yang udah ada di situ:
```dart
ErrorWidget.builder = (FlutterErrorDetails details) {
  FlutterError.presentError(details); // tetap lewat existing FlutterError.onError → Crashlytics + Sentry
  return Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF79747E)),
            const SizedBox(height: 16),
            const Text('Terjadi kesalahan. Coba lagi.'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                final ctx = rootNavigatorKey.currentContext;
                if (ctx != null && ctx.mounted) GoRouter.of(ctx).go(HomePage.routePath);
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
};
```

**`VerseMediaModel.hadi`** — pola sama kayak `duration` (nullable, defensive):
```dart
HadiMediaModel? hadi,   // was: required HadiMediaModel hadi
```
`toEntity()`:
```dart
hadi: hadi?.toEntity(),  // VerseMediaEntity.hadi jadi HadiMediaEntity?
```

**`MuhudBloc._onLoadChapter`** — ganti `on Exception catch (e, stackTrace)` → unqualified `catch (e, stackTrace)`, konsisten sama pola catch-all yang udah dipake di `muhud_remote_datasource.dart:141`.

Single quotes, no doc comments beyond existing non-obvious-reasoning `///` style.

## Testing Strategy
Ga ada automated widget test buat error boundary ini sekarang. Verifikasi manual:
- Throw exception sementara di dalam widget build (test lokal) → confirm muncul error screen custom (bukan blank), tombol "Kembali ke Beranda" jalan
- Local Supabase: insert row `verse_media` dengan `hadi_id = null` → buka chapter itu di app → confirm render normal (verse card tanpa info hadi / fallback text), BUKAN crash, BUKAN blank
- `flutter analyze` — clean, no regression
- Manual end-to-end: kill app → tap notif verse_media (dengan verseId di payload) → confirm ChapterReaderPage kebuka normal. Untuk chapter_media (tanpa verseId), tujuan navigasi yang benar sekarang `/audio` (AudioListPage), bukan ChapterReaderPage — lihat `docs/fix-fcm-chapter-media-audio-route/spec.md`

## Boundaries
- **Always:** exception tetap ke-log ke Crashlytics/Sentry (`ErrorWidget.builder` WAJIB panggil `FlutterError.presentError`/lewat hook existing, jangan swallow diam-diam), styling error screen konsisten sama existing pattern (`Color(0xFFF0F5EE)` bg, icon `Icons.wifi_off_outlined`/`error_outline` style yang udah dipakai di `chapter_reader_page.dart`)
- **Ask first:** ubah skema DB (`hadi_id` jadi `NOT NULL`) — itu keputusan data-integrity level, di luar scope Flutter, perlu koordinasi ke yang pegang CMS/upload flow chapter_media & verse_media
- **Never:** hapus/ubah pola null-handling `duration` yang udah ada, skip Crashlytics reporting di `ErrorWidget.builder`

## Success Criteria
- Release build: uncaught exception di widget manapun → muncul error screen informatif + tombol balik Home, BUKAN blank/grey screen
- Chapter dengan verse_media ber-`hadi_id` null → chapter reader tetap kebuka, ga crash
- Tap notif chapter_media/verse_media dari app killed state → `/chapter/:id` kebuka normal
- `flutter analyze` clean

## Open Questions
1. Semua widget consumer `VerseMediaEntity.hadi` (misal `verse_card.dart`, `audio_selection_sheet.dart`) perlu di-audit satu-satu buat null-check setelah field jadi nullable — belum di-list lengkap, bakal di-scan pas implementasi (`dart run build_runner` + `flutter analyze` bakal nunjukin compile error di tiap titik pemakaian).
2. Copy text & style tombol di error screen — dipake bahasa Indonesia gaya existing app, bisa direvisi kalau user mau beda.
3. Root cause exact (line pasti) tetap ga terkonfirmasi tanpa symbol file — kalau setelah fix ini symptom MASIH muncul, perlu symbolize crash report beneran buat lanjut investigasi.
