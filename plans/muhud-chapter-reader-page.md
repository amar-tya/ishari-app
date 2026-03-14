---
planStatus:
  planId: plan-muhud-chapter-reader
  title: Muhud - Chapter Reader Page (Mobile)
  status: draft
  planType: feature
  priority: high
  owner: aamar
  stakeholders: []
  tags:
    - flutter
    - ui
    - audio
    - reader
  created: "2026-03-14"
  updated: "2026-03-14T03:20:00.000Z"
  progress: 0
---
# Muhud – Chapter Reader Page (Mobile)

## Konteks & Tujuan

Halaman Muhud di website adalah **chapter reader** — tampilan baca shalawat per-verse dengan teks Arab, transliterasi, dan audio per hadi/recitation style. Di mobile, halaman ini adalah **layar detail chapter** yang di-push saat user mengetuk chapter card dari mana saja (Beranda, dsb).

> Berbeda dengan web yang punya sidebar kiri + konten kanan, mobile menggunakan layout **single-column scroll** yang lebih sesuai layar kecil.

---

## Skema Database (sudah ada)

| Tabel | Kolom Relevan |
| --- | --- |
| `chapters` | id, title, category, total_verses |
| `verses` | id, chapter_id, verse_number, arabic_text, transliteration |
| `translations` | verse_id, language_code, translation_text |
| `verse_media` | verse_id, hadi_id, media_type, media_url, duration, type (Joz/Yahum/Terem/Inat/Rojazz) |
| `bookmarks` | user_id, verse_id |
| `hadi` | id, name, image_url |

---

## Navigasi

```
Beranda → tap ChapterCard → push /chapter/:chapterId → ChapterReaderPage
```

- Route: `GoRoute(path: '/chapter/:chapterId', builder: ChapterReaderPage)`
- Bottom nav **tetap tersembunyi** saat di reader (Scaffold tanpa bottom nav, karena reader adalah sub-route)
- Tombol back untuk kembali ke Beranda

---

## Desain Layar

### Screen 1: Chapter Reader (Konten Utama)

```
┌─────────────────────────────┐
│ ← Ibtida' ▼          [≡]    │  ← AppBar (dengan Quick Tools icon)
├─────────────────────────────┤
│  اللَّهُمَّ صَلِّ عَلَى...   │  ← Shalawat Nabi Header
├─────────────────────────────┤
│ ①  ▶  □  🔖  ···            │  ← Verse 1 header (nomor + 4 ikon)
│       الْأَلِفُ اوَّلَ...   │  ← Teks Arab full-width
│       ālālifu awwala...      │  ← Transliterasi
│   TERJEMAHAN                 │  ← Label Terjemahan
│   Huruf Alif, pertama...     │  ← Teks terjemahan
├─────────────────────────────┤
│ ②  ▶  □  🔖✓  ···           │  ← Verse 2 (bookmarked)
│       الْبَاءُ بِاللَّهِ...  │
│       ālbā'u billahi...      │
│   TERJEMAHAN                 │
│   Huruf Ba, dengan...        │
├─────────────────────────────┤
│ ③  ⏸  □  🔖  ···  [pulse]   │  ← Verse 3 (playing, pulsing number, pause icon)
│       الثَّاءُ تَوَبًا...    │     [background highlight hijau]
│       ālttā'u tawa...        │
│   TERJEMAHAN                 │
│   Huruf Tsa, bertaubat...    │
├─────────────────────────────┤
│  [● Pusat Audio]  [↓ Auto]   │  ← Bottom Toolbar
├─────────────────────────────┤
│ 🏠 🔲 📖 👤 🔖 👤            │  ← Bottom Nav (Beranda|Muhud|Kitab|Hadi|Bookmark|Profil)
└─────────────────────────────┘
```

### VerseCard — Per-Verse Audio Flow

1. User tap **▶ (play button)** di verse tertentu
2. Muncul **Audio Selection Bottom Sheet**:
  - Pilih Hadi (avatar chips)
  - Pilih Recitation Style (Joz, Yahum, Terem, Inat, Rojazz)
  - Tombol **"Putar"**
3. Setelah pilih & putar:
  - Ikon ▶ berubah jadi ⏸ di verse tersebut
  - Animasi ripple/pulse di verse number circle
4. Tap ⏸ → pause
5. Play audio yang bisa diputar hanya 1, jika dipaksa memutar audio yang lain maka audio yang sebelumnya play menjadi pause

> Tidak ada global mini player (per user feedback — inline per-verse saja)

### Audio Selection Bottom Sheet

```
┌─────────────────────────────┐
│          ━━━━ drag handle   │
│ Pusat Pilihan Audio         │
│ Pilih bacaan untuk [title]  │
│  Ayat [number]              │
├─────────────────────────────┤
│ PILIH PIMPINAN HADI         │
│ ┌────┐ ┌────┐ ┌────┐        │
│ │ G  │ │ A  │ │ B  │        │
│ │Gus │ │Ali │ │... │        │
│ │Hadi│ │    │ │    │        │
│ └────┘ └────┘ └────┘        │
├─────────────────────────────┤
│ RECITATION STYLE            │
│ [Joz] [Yahum] [Terem]       │
│ [Inat] [Rojazz]             │
├─────────────────────────────┤
│  ▶  Putar                   │ ← full-width green button
└─────────────────────────────┘
```

---

## Arsitektur Clean (Fitur Baru: `muhud`)

### Domain Layer

**Entities:**
- `VerseEntity` — id, chapterId, verseNumber, arabicText, transliteration
- `TranslationEntity` — id, verseId, languageCode, translationText
- `VerseMediaEntity` — id, verseId, hadiId, mediaUrl, duration, type (enum: Joz/Yahum/Terem/Inat/Rojazz)
- `VerseWithDetailsEntity` — VerseEntity + List\<TranslationEntity\> + List\<VerseMediaEntity\>

**Repository Interface:** `MuhudRepository`
- `getVersesByChapter(chapterId)` → `Either<Failure, List<VerseWithDetailsEntity>>`
- `toggleBookmark(verseId, userId)` → `Either<Failure, bool>`
- `getBookmarkedVerseIds(userId)` → `Either<Failure, List<int>>`

**Use Cases:**
- `GetVersesByChapter`
- `ToggleBookmark`
- `GetBookmarkedVerseIds`

### Data Layer

**Models:** `VerseModel`, `TranslationModel`, `VerseMediaModel` (Freezed + JsonSerializable)

**Remote Datasource:** `MuhudRemoteDataSource`
- Fetch verses + translations + verse_media sekaligus via Supabase join
- Query: `verses.select('*, translations(*), verse_media(*, hadi(*))')`

**Repository Impl:** `MuhudRepositoryImpl`
- Network → remote; cache → local (shared_preferences / hive)

### Presentation Layer

**BLoC:** `MuhudBloc`

Events:
```dart
@freezed
sealed class MuhudEvent {
  factory MuhudEvent.loadChapter({required String chapterId}) = _LoadChapter;
  factory MuhudEvent.toggleTranslation() = _ToggleTranslation;
  factory MuhudEvent.toggleBookmark({required int verseId}) = _ToggleBookmark;
  factory MuhudEvent.playVerse({
    required int verseId,
    required String hadiId,
    required VerseMediaType recitationType,
  }) = _PlayVerse;
  factory MuhudEvent.stopAudio() = _StopAudio;
}
```

State:
```dart
@freezed
sealed class MuhudState {
  factory MuhudState.initial() = _Initial;
  factory MuhudState.loading() = _Loading;
  factory MuhudState.loaded({
    required ChapterEntity chapter,
    required List<VerseWithDetailsEntity> verses,
    required Set<int> bookmarkedVerseIds,
    required bool showTranslation,
    int? playingVerseId,
    bool isAudioLoading = false,
  }) = _Loaded;
  factory MuhudState.error({required String message}) = _Error;
}
```

**Pages & Widgets:**
- `ChapterReaderPage` — root page, provides `MuhudBloc`
- `_ChapterAppBar` — title, category, share icon, back button
- `_TranslationToggle` — sticky top bar dengan toggle show/hide transliteration
- `VerseList` — `ListView.separated` dengan `VerseCard`
- `VerseCard` — Arabic text (RTL, large font), transliteration, translation, bookmark icon, play button
- `_VerseNumberBadge` — nomor verse dalam lingkaran dengan optional pulsing animation saat playing
- `AudioSelectionSheet` — bottom sheet pilih hadi + recitation style
- `HadiChip` — avatar + nama dalam selectable chip
- `RecitationStyleChip` — chip pilih Joz/Yahum/Terem/Inat/Rojazz

---

## Urutan Implementasi

### Phase 1 — Data & Domain
1. Buat entities: `VerseEntity`, `TranslationEntity`, `VerseMediaEntity`, `VerseWithDetailsEntity`
2. Buat `MuhudRepository` interface + use cases
3. Buat models dengan Freezed + JSON
4. Buat `MuhudRemoteDataSource` (Supabase query dengan join)
5. Buat `MuhudRepositoryImpl`
6. Jalankan `build_runner`

### Phase 2 — BLoC
7. Buat `MuhudBloc` dengan events & states di atas
8. Register di Injectable

### Phase 3 — UI Dasar
9. Buat route `/chapter/:chapterId` di `app_router.dart`
10. Buat `ChapterReaderPage` dengan AppBar, loading/error states
11. Buat `VerseCard` (teks Arab + transliterasi, tanpa audio dulu)
12. Implementasi toggle show/hide transliteration

### Phase 4 — Audio
13. Tambah dependency: `just_audio` atau `audioplayers`
14. Buat `AudioSelectionSheet`
15. Integrasikan play/pause per verse ke BLoC
16. Animasi pulse di verse number saat playing

### Phase 5 — Bookmark
17. Buat `ToggleBookmark` use case
18. Integrasikan bookmark icon di `VerseCard`
19. Gate untuk guest mode (tampilkan login prompt)

### Phase 6 — Navigasi dari Home
20. Update `ChapterCard` widget agar tap push ke reader route

---

## Mockup

![Chapter Reader Page Mobile](screenshot.png){mockup:plans/mockups/muhud-chapter-reader.mockup.html}

---

## Dependensi Baru

| Package | Kegunaan |
| --- | --- |
| `just_audio` | Audio playback per-verse |
| `just_audio_background` | (opsional) audio saat layar mati |

---

## Hal Yang Tidak Termasuk (MVP)

- Smart Suggest panel
- Global/persistent mini player
- Offline caching audio
- Search dalam chapter
