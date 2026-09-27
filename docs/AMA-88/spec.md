# Spec: Global Mini Player (Audio Catalog)

## Objective
`AudioListPage` mini player sekarang cuma progress-less play/pause dan raib pas
keluar halaman Audio. Req dari user:

1. Progress indicator (posisi/durasi) di mini player.
2. Tap pause = pause, bukan hilang.
3. Seek forward/backward 10 detik.
4. Mini player tampil di **semua** halaman app, termasuk Chapter Reader (Muhud).
5. Audio tetap jalan di background OS (app di-minimize/keluar) + kontrol di
   lockscreen/notification.

User: pendengar audio Hadi/Muhud/Rodad Cabang yang mau lanjut dengar sambil
pindah-pindah halaman atau layar mati.

**Sukses** = mini player persisten lintas navigasi, progress akurat, seek
±10s jalan, dan audio + kontrol tetap hidup setelah app di-background dengan
notification media style (Android) / Control Center (iOS).

## Decisions From Clarification
- **Background playback:** `audio_service` + `just_audio_background`
  (bukan best-effort `just_audio` polos). Konsekuensi: dependency baru,
  native config baru (Android foreground service + permission
  `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, iOS `UIBackgroundModes: audio`) →
  **wajib rilis penuh** (Play Store), tidak bisa Shorebird patch untuk
  perubahan ini.
- **Scope halaman:** benar-benar semua halaman, termasuk Chapter Reader.
  Chapter Reader (`MuhudBloc`) punya `AudioPlayer` sendiri untuk audio
  per-ayat — beda instance dari `AudioListBloc`. Karena hanya satu track
  yang boleh bunyi dalam satu waktu, saat salah satu sumber mulai play,
  sumber lain **auto-stop** (bukan pause — beda track/context, resume tidak
  relevan).
- Catatan lama di knowledge graph ("no global mini player, per-verse inline
  audio only") dibalik oleh instruksi eksplisit user ini — diabaikan.

## Assumptions
1. Hanya satu audio track app-wide yang aktif sekaligus (AudioListBloc track
   ATAU Muhud verse track), tidak ada mixing.
2. Mini player untuk AudioListBloc track menggantikan/hidup berdampingan
   dengan UI audio per-ayat Chapter Reader yang sudah ada — mini player
   AudioListBloc disembunyikan otomatis saat yang aktif justru track Muhud
   (karena representasinya sudah ada di reader itu sendiri), dan sebaliknya
   Muhud UI tidak perlu direplikasi sebagai mini player generik.
   → Konkretnya: mini player global HANYA merepresentasikan
   `AudioListBloc.playingTrack`. Kalau user mulai play verse di Chapter
   Reader, `AudioListBloc` di-stop (kalau lagi playing) dan mini player
   hilang; sebaliknya kalau user play track Audio List, verse audio Muhud
   di-stop.
3. Notification/lockscreen kontrol: play/pause + seek ±10s (skip
   next/previous tidak diminta, tidak dibuat).
4. Format progress: `mm:ss / mm:ss`, linear `Slider`/`ProgressBar` yang bisa
   di-drag untuk seek (bonus alami dari `audio_service` — bukan requirement
   eksplisit tapi murah untuk disertakan sekalian dengan progress stream
   yang sudah ada).
5. Tidak perlu playback queue/playlist auto-next antar track — cakupan tetap
   satu track diputar sampai selesai atau user pilih track lain.
6. Tidak ada perubahan pada `HadiMiniPlayer` widget existing di konteks
   Hadi directory kalau ada pemakaian lain — perubahan diarahkan ke
   pembuatan widget baru (mis. `GlobalAudioMiniPlayer`) yang dipasang di
   root, bukan mengubah kontrak `HadiMiniPlayer` yang sudah dipakai di
   `AudioListPage` saat ini secara backward-incompatible.
   → Correct me now kalau `HadiMiniPlayer` justru boleh diperluas langsung.

## Tech Stack / New Dependencies
- `audio_service: ^0.18.x` — background service, media notification,
  lockscreen controls.
- `just_audio_background: ^0.0.1-beta.x` — bridge `just_audio` ↔
  `audio_service` tanpa rewrite manual `AudioHandler` playback logic.
- Existing: `just_audio`, `flutter_bloc`, `get_it`/`injectable`, `go_router`.

## Project Structure (perubahan)
```
lib/features/audio/
  domain/entities/audio_track_entity.dart      (tambah durasi? sudah ada `duration`)
  presentation/
    bloc/audio_list_bloc.dart                  → state position/duration, seek events
    bloc/audio_list_state.dart                 → tambah `position`, `duration`
    bloc/audio_list_event.dart                 → tambah `seekBy`, `positionChanged`
    widgets/global_audio_mini_player.dart       (BARU — progress + seek ±10s UI)
    pages/audio_list_page.dart                 → pakai GlobalAudioMiniPlayer, bukan render lokal
lib/core/audio/
  audio_service_handler.dart                    (BARU — AudioHandler untuk audio_service)
lib/features/scaffold/presentation/pages/main_scaffold.dart  → pasang overlay mini player
lib/main.dart / injection_container.dart        → AudioService.init(...) sebelum runApp
android/app/src/main/AndroidManifest.xml         → service + permission
ios/Runner/Info.plist                            → UIBackgroundModes audio
test/features/audio/...                          → unit test bloc position/seek logic
```
Mini player global dipasang **di atas root navigator** (bukan cuma di dalam
`MainScaffold`) supaya ikut muncul di halaman yang di-push GoRouter (Chapter
Reader, Hadi Detail, dll) — pakai `Stack` di `MaterialApp.builder` atau
bungkus `GoRouter` root dengan widget overlay yang subscribe ke
`AudioListBloc` (singleton, sudah bisa diakses lewat `sl()` di mana saja).

## Code Style
Ikuti pola existing di `audio_list_page.dart` — Freezed state/event, `sl<>()`
buat ambil singleton bloc, `BlocBuilder`/`BlocListener` untuk render, warna
konstan `_kDark`/`_kLime` per file (very_good_analysis, single quotes).

Contoh event baru (freezed union, mengikuti pola `AudioListEvent` yang ada):
```dart
const factory AudioListEvent.seekBy(Duration offset) = _SeekBy;
const factory AudioListEvent.positionChanged(Duration position) = _PositionChanged;
```

## Testing Strategy
- Unit test `AudioListBloc`: seek clamp (tidak negatif, tidak melebihi
  duration), auto-stop saat `MuhudBloc` mulai play (lewat fake cross-bloc
  signal — lihat mekanisme di bawah), position stream update ke state.
- Widget test `GlobalAudioMiniPlayer`: render progress bar dari state,
  tap ±10s memanggil event yang benar, tap play/pause toggle (bukan
  dismiss).
- Manual/device test wajib untuk background audio (unit test tidak bisa
  cover foreground service Android/iOS beneran) — jalankan `flutter run`,
  play track, home-button keluar app, cek notification + lockscreen kontrol.
- Lokasi test: `test/features/audio/...` (sudah ada folder `test/features/`
  di working tree).

## Cross-Bloc Coordination (AudioListBloc ⇄ MuhudBloc)
Perlu mekanisme "hanya satu yang play" tanpa bikin kedua bloc saling
depend langsung (circular). Pendekatan: broadcast singleton stream/notifier
kecil (mis. `ActiveAudioSource` di `lib/core/audio/active_audio_source.dart`)
yang di-emit oleh masing-masing bloc sebelum play, dan didengarkan keduanya
untuk stop diri sendiri kalau bukan pemilik sesi aktif saat ini.

## Boundaries
- **Always do:** jalankan `flutter analyze` + unit test bloc sebelum commit;
  ikuti pola Freezed/Injectable yang sudah ada; tidak sentuh
  `*.freezed.dart`/`*.g.dart` manual (regenerate lewat `build_runner`).
- **Ask first:** perubahan `AndroidManifest.xml`/`Info.plist` (permission
  baru) — sudah disetujui user di sesi ini tapi tetap tunjukkan diff
  sebelum apply; penentuan versi pin `audio_service`/`just_audio_background`
  (cek breaking changes vs `just_audio: ^0.10.0` yang sudah dipakai).
- **Never do:** commit tanpa jalanin `flutter analyze`; hapus/ubah kontrak
  `HadiMiniPlayer` existing tanpa cek pemakaian lain; ship perubahan ini
  lewat Shorebird patch (butuh full release karena native config + dependency
  baru).

## Success Criteria
- [ ] Mini player nampilin progress bar akurat (posisi update ≥1x/detik).
- [ ] Tap pause di mini player → audio pause, mini player tetap tampil
      (tap lagi → resume, bukan reset ke awal).
- [ ] Tombol ±10s berfungsi, clamp di 0 dan durasi total.
- [ ] Mini player tampil di semua route (tab-tab MainScaffold + halaman yang
      di-push: Chapter Reader, Hadi Detail, Kitab Reader, Tatanan Detail,
      Notifications).
- [ ] Play track Audio List saat lagi dengar verse Muhud (atau sebaliknya)
      → yang lama otomatis stop, tidak overlap suara.
- [ ] Audio + notification kontrol tetap hidup setelah app diminimize atau
      layar dikunci (Android & iOS device/emulator nyata, bukan cuma unit
      test).
- [ ] `flutter analyze` bersih, unit test bloc baru hijau.

## Open Questions
1. Versi exact `audio_service`/`just_audio_background` yang kompatibel
   dengan `just_audio: ^0.10.0` yang sudah dipakai — perlu dicek pas Plan
   phase (`flutter pub add` dry-run / pub.dev compatibility).
2. Icon/nama notification media session (app name "Ishari", artwork placeholder
   apa) — perlu aset atau cukup teks judul track + app icon existing?
3. Apakah tombol next/previous track perlu ditampilkan di notification
   Android (audio_service defaultnya nyediain slot itu) meski tidak diminta
   — default: sembunyikan/disable kalau tidak wajib ada.
