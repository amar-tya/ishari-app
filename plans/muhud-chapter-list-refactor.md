---
planStatus:
  planId: plan-muhud-chapter-list-refactor
  title: Muhud Chapter List Refactor
  status: in-review
  planType: refactor
  priority: medium
  owner: aamar
  stakeholders: []
  tags:
    - flutter
    - ui
    - muhud
    - navigation
  created: "2026-03-19"
  updated: "2026-03-20T00:00:00.000Z"
  progress: 100
---
# Muhud Chapter List Refactor

## Tujuan

Refactor tab Muhud dari langsung menampilkan reader chapter pertama, menjadi:
1. Tampilkan **daftar semua chapter** (seperti Quran surah list di referensi desain)
2. Tap chapter → navigate ke **halaman detail reader** (full screen, dengan back button)
3. Dari **beranda**, tap kartu kategori → langsung navigate ke halaman detail chapter

---

## Keadaan Saat Ini

### Alur navigasi saat ini
- `MuhudTab` langsung load `chapterId = 1` dan tampilkan `ChapterReaderBody`
- Beranda: tap kartu chapter → set `AppState.muhudChapterRequest.value = id`
- `MainScaffold` mendengar `muhudChapterRequest`, lalu switch ke tab index 1 (Muhud)
- `MuhudTab` mendengar `muhudChapterRequest`, lalu minta `MuhudBloc` load chapter baru

### File-file yang relevan
| File | Peran |
| --- | --- |
| `lib/features/muhud/presentation/pages/muhud_tab.dart` | Tab Muhud (saat ini = reader langsung) |
| `lib/features/muhud/presentation/pages/chapter_reader_page.dart` | Full-screen reader (route `/chapter/:id`) |
| `lib/features/muhud/presentation/bloc/muhud_bloc.dart` | BLoC untuk load & play chapter |
| `lib/features/muhud/domain/repositories/muhud_repository.dart` | Interface repo Muhud |
| `lib/features/home/presentation/pages/home_page.dart` | Beranda — kartu chapter pakai AppState |
| `lib/features/home/presentation/widgets/hadi_section.dart` | Kartu hadi (TODO: navigate) |
| `lib/core/router/app_router.dart` | GoRouter, ada route `/chapter/:id` |
| `lib/core/app_state.dart` | `muhudChapterRequest` ValueNotifier |
| `lib/features/scaffold/presentation/pages/main_scaffold.dart` | IndexedStack + listener AppState |

---

## Desain Baru

### Alur navigasi baru
```
Tab Muhud → MuhudListPage (daftar chapter)
                    ↓ tap
              context.push('/chapter/:id')  →  ChapterReaderPage (full screen)
                    ↑
Beranda kartu kategori → context.push('/chapter/:id')
```

Keuntungan:
- Tidak perlu `AppState.muhudChapterRequest` lagi (hapus)
- Navigasi lebih standar (GoRouter push)
- `ChapterReaderPage` sudah ada, tinggal dipakai

---

## Rencana Implementasi

### Step 1 — Tambah `getAllChapters` ke data layer (MuhudRepository)

**File yang dimodifikasi:**
- `lib/features/muhud/domain/repositories/muhud_repository.dart`
  - Tambah method: `Future<Either<Failure, List<ChapterEntity>>> getAllChapters()`
- `lib/features/muhud/data/datasources/muhud_remote_datasource.dart`
  - Tambah method `getAllChapters()` yang query Supabase `chapters` order by `chapter_number`
- `lib/features/muhud/data/repositories/muhud_repository_impl.dart`
  - Implementasi `getAllChapters()` (network check → remote → Either)

**File baru:**
- `lib/features/muhud/domain/usecases/get_all_chapters.dart`
  - `GetAllChapters` use case yang call `repository.getAllChapters()`

### Step 2 — Buat BLoC baru: `ChapterListBloc`

**File baru:**
- `lib/features/muhud/presentation/bloc/chapter_list_event.dart`
  - Event: `load`
- `lib/features/muhud/presentation/bloc/chapter_list_state.dart`
  - States: `initial`, `loading`, `loaded(List<ChapterEntity>)`, `error(String)`
- `lib/features/muhud/presentation/bloc/chapter_list_bloc.dart`
  - `@injectable` BLoC, inject `GetAllChapters` use case
  - Handle `load` event → emit loading → call use case → emit loaded/error

> **Catatan**: Perlu jalankan `build_runner` setelah langkah ini karena menggunakan `@freezed` dan `@injectable`.

### Step 3 — Buat widget item list chapter

**File baru:**
- `lib/features/muhud/presentation/widgets/chapter_list_item.dart`
  - Row dengan:
    - **Kiri**: Badge nomor bulat (warna hijau `#51C878`)
    - **Tengah**: Title chapter (bold), subtitle: `{verseCount} bait | {category}`
    - **Kanan**: Teks Arab (`description`) dengan font Scheherazade

### Step 4 — Buat `MuhudListPage`

**File baru:**
- `lib/features/muhud/presentation/pages/muhud_list_page.dart`
  - Scaffold dengan AppBar judul "Muhud"
  - `BlocProvider` untuk `ChapterListBloc`, dispatch `load` di init
  - `BlocBuilder`:
    - loading → `CircularProgressIndicator`
    - loaded → `ListView.separated` dengan `ChapterListItem`
    - error → error state dengan tombol retry
  - Setiap item: `onTap` → `context.push('/chapter/${chapter.id}')`

### Step 5 — Refactor `MuhudTab`

**File dimodifikasi:**
- `lib/features/muhud/presentation/pages/muhud_tab.dart`
  - Ganti konten dari `MuhudBloc` + `ChapterReaderBody` menjadi `MuhudListPage`
  - Hapus `_defaultChapterId`, hapus listener `AppState.muhudChapterRequest`

### Step 6 — Update navigasi di beranda

**File dimodifikasi:**
- `lib/features/home/presentation/pages/home_page.dart`
  - `FeaturedChapterCard.onTap`: ganti dari `AppState.muhudChapterRequest.value = id`
    ke `context.push('/chapter/$id')`
  - `ChapterCard.onTap` (dalam `ListView.separated`): sama, pakai `context.push`

### Step 7 — Cleanup

**File dimodifikasi:**
- `lib/core/app_state.dart`
  - Hapus field `muhudChapterRequest`
- `lib/features/scaffold/presentation/pages/main_scaffold.dart`
  - Hapus `_onMuhudChapterRequest()` listener
  - Hapus `initState/dispose` listener untuk `muhudChapterRequest`

---

## Desain UI MuhudListPage

Mengacu pada referensi (Quran surah list):

```
┌─────────────────────────────────────┐
│  ← Muhud                            │  AppBar
├─────────────────────────────────────┤
│  ┌─────────────────────────────────┐│
│  │ ①  Al-Barzanji          البرزنجي ││  Row item
│  │     24 bait | Diwan             ││
│  └─────────────────────────────────┘│
│  ┌─────────────────────────────────┐│
│  │ ②  Al-Diba'i            الدبائع ││
│  │     18 bait | Kasidah           ││
│  └─────────────────────────────────┘│
│  ...                                 │
└─────────────────────────────────────┘
```

Style:
- Background: `#F6F8F7`
- Badge nomor: lingkaran `#51C878`, teks putih, ukuran 36×36
- Title: bold 15sp, `#1C1B1F`
- Subtitle: regular 12sp, `#79747E`
- Arabic text: font Scheherazade 20sp, `#51C878`, align kanan
- Divider halus antar item

---

## File Summary

| Aksi | File |
| --- | --- |
| **Tambah** | `domain/usecases/get_all_chapters.dart` |
| **Tambah** | `presentation/bloc/chapter_list_event.dart` |
| **Tambah** | `presentation/bloc/chapter_list_state.dart` |
| **Tambah** | `presentation/bloc/chapter_list_bloc.dart` |
| **Tambah** | `presentation/widgets/chapter_list_item.dart` |
| **Tambah** | `presentation/pages/muhud_list_page.dart` |
| **Modifikasi** | `domain/repositories/muhud_repository.dart` |
| **Modifikasi** | `data/datasources/muhud_remote_datasource.dart` |
| **Modifikasi** | `data/repositories/muhud_repository_impl.dart` |
| **Modifikasi** | `presentation/pages/muhud_tab.dart` |
| **Modifikasi** | `features/home/presentation/pages/home_page.dart` |
| **Modifikasi** | `core/app_state.dart` |
| **Modifikasi** | `features/scaffold/presentation/pages/main_scaffold.dart` |

---

## Perintah yang Perlu Dijalankan

Setelah semua perubahan selesai:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Catatan Teknis

- `ChapterReaderPage` sudah ada route `/chapter/:chapterId` di GoRouter — tidak perlu tambah route baru
- `context.push('/chapter/$id')` (GoRouter) dari dalam tab akan push full-screen overlay, bottom nav tidak terlihat — sesuai desain
- `ChapterReaderPage` menggunakan `isEmbeddedInTab: false` sehingga sudah ada back button di AppBar
- `@injectable` `ChapterListBloc` perlu di-register — `build_runner` akan handle otomatis via `.config.dart`
