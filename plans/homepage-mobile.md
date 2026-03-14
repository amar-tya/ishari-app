---
planStatus:
  planId: plan-homepage-mobile
  title: Homepage Mobile — Ishari App
  status: draft
  planType: feature
  priority: high
  owner: aamar
  stakeholders: []
  tags:
    - homepage
    - mobile
    - flutter
    - ui
  created: "2026-03-13"
  updated: "2026-03-13T00:00:00.000Z"
  progress: 0
---
# Homepage Mobile — Ishari App

## Ringkasan

Membangun `HomePage` yang sesungguhnya untuk aplikasi mobile Ishari. Saat ini `HomePage` hanya
placeholder (menampilkan avatar + email user atau teks "Halo, Tamu!"). Halaman ini akan menjadi
dashboard utama yang memudahkan pengguna mengakses konten shalawat (kitab, chapter, audio) serta
menyediakan personalisasi berbeda antara **user login** dan **mode guest**.

---

## Konteks & Data

### Data dari Supabase

| Entitas | Jumlah | Catatan |
| --- | --- | --- |
| Books | 2 | "Diwan Al-Hadrah", "Maulid Syaroful Anam" |
| Chapters | 71 | 3 kategori aktif: Diwan (15), Diba (15), Muradah (41) |
| Verses | 729 | Tiap chapter berisi ~10 bait |
| Verse Media | 15 | audio & image, tipe: Joz, Yahum, Terem, Inat, Rojazz |
| Hadi | 3 | Pimpinan Shalawat (nama + foto) |
| Bookmarks | — | Hanya user login; guest tidak bisa bookmark |

Kategori chapter dari DB constraint: `Diwan`, `Syaraful Anam`, `Muhud`, `Rowi`, `Diba`, `Muradah`

### User Modes

| Mode | Akses Konten | Bookmark | Profil |
| --- | --- | --- | --- |
| **Guest** | Semua chapter & verse | Tampil, terkunci (lock + CTA login) | Nama "Tamu", icon person |
| **User Login** | Semua chapter & verse | Penuh (simpan, hapus) | Avatar + nama dari Google |

---

## Arsitektur Layar

### Bottom Navigation Bar (5 tab)

```
[ Beranda ] [ Kitab ] [ Hadi ] [ Bookmark 🔒 ] [ Profil ]
```

- **Beranda** — Homepage dashboard (halaman ini)
- **Kitab** — Browse semua buku & chapter
- **Hadi** — 3 Pimpinan Shalawat (audio by hadi)
- **Bookmark** — Tersedia untuk semua; guest melihat lock screen + CTA login
- **Profil** — Info user (login) atau ajakan daftar (guest)

### Routing (GoRouter)

Saat ini hanya ada `/introduction` dan `/home`. Setelah homepage dibangun, perlu menambahkan:
- `/home` → `HomePage` (scaffold dengan bottom nav)
- `/kitab` → `KitabPage`
- `/hadi` → `HadiPage`
- `/bookmarks` → `BookmarksPage`
- `/profil` → `ProfilPage`

Namun **scope plan ini** hanya pada `/home` (tab Beranda). Tab lain adalah placeholder
sementara untuk membangun bottom nav.

---

## Layout Homepage (Tab Beranda)

### Wireframe Konsep

```
┌─────────────────────────────┐
│ [Avatar]  Halo, [Nama]!     │  ← Header (greeting, dinamis)
│           Assalamu'alaikum  │
├─────────────────────────────┤
│ 🔍 Cari shalawat...         │  ← Search bar
├─────────────────────────────┤
│ ▶ Featured / Lanjut Baca    │  ← Chapter terakhir dibaca (login)
│   [Chapter Card besar]      │     atau chapter pertama (guest)
├─────────────────────────────┤
│ Jelajahi Kategori           │
│ [Diwan] [Diba] [Muradah]    │  ← Chips horizontal scroll
│ [Muhud] [Rowi] [Syr.Anam]   │
│                             │
│ ← chapter cards scroll →   │  ← Card chapter horizontal
│ [Card] [Card] [Card]        │
├─────────────────────────────┤
│ Bookmark Saya               │  ← Login: preview 3 bookmark
│ [Bookmark card] ...         │     Guest: banner "Masuk untuk bookmark"
├─────────────────────────────┤
│ Pimpinan Shalawat           │
│ [Hadi 1] [Hadi 2] [Hadi 3]  │  ← 3 avatar card horizontal
└─────────────────────────────┘
[ Beranda ][ Kitab ][ Hadi ][ 🔒 ][ Profil ]
```

---

## Komponen Detail

### 1. Header / Greeting

**User Login:**
```
[Avatar foto] Halo, Ahmad!
              Assalamu'alaikum
```

**Guest Mode:**
```
[Icon person] Halo, Tamu!
              Assalamu'alaikum
```

- Avatar dari `UserEntity.avatarUrl` (nullable), fallback ke icon
- Salam tetap sama untuk semua mode
- Tombol notifikasi (opsional, fase 2)

---

### 2. Search Bar

- Full-width, rounded, background surface
- Placeholder: "Cari shalawat, bait, atau kitab..."
- Tap → navigate ke SearchPage (di-scope di luar plan ini, bisa dummy dulu)
- Guest & login: sama-sama bisa search

---

### 3. Featured / Lanjut Baca

**User Login:**
- Simpan `lastReadChapterId` di local storage (SharedPrefs/SecureStorage)
- Tampilkan chapter terakhir dibaca
- Label: "Lanjutkan Membaca"

**Guest Mode:**
- Tampilkan chapter pertama Diwan (Ibtida')
- Label: "Mulai Baca"

Card design:
```
┌─────────────────────────────────────┐
│  [Gradient BG hijau]                │
│  Lanjutkan Membaca           → ▶   │
│  Ibtida' · Diwan                    │
│  7 bait                             │
└─────────────────────────────────────┘
```

---

### 4. Jelajahi Kategori

- Chips filter horizontal scroll: `Diwan`, `Diba`, `Muradah`, `Muhud`, `Rowi`, `Syaraful Anam`
- State aktif: chip berwarna primary (#51C878), chip lain outlined
- Di bawah chips: horizontal scroll chapter cards yang difilter

**Chapter Card:**
```
┌──────────┐
│ [No.]    │
│ Ibtida'  │
│ 7 bait   │
│ Diwan    │
└──────────┘
```
- Tap card → navigate ke `ChapterDetailPage` (placeholder)

---

### 5. Bookmark Section

**User Login:**
- Fetch 3 bookmark terakhir dari Supabase (`bookmarks` table join `verses`)
- Card mini menampilkan arabic text + chapter
- "Lihat semua" → navigate ke BookmarksPage

**Guest Mode:**
- Banner card dengan lock icon:
```
┌─────────────────────────────────────┐
│  🔒  Masuk untuk menyimpan          │
│       shalawat favoritmu            │
│                  [Masuk Sekarang]   │
└─────────────────────────────────────┘
```
- Tap "Masuk Sekarang" → navigate ke IntroductionPage (last slide)

---

### 6. Pimpinan Shalawat (Hadi)

- Horizontal scroll 3 card hadi
- Tiap card: foto + nama
- Fetch dari `hadi` table (3 data)
- Tap → navigate ke HadiDetailPage (placeholder)

---

## State Management

### Bloc yang dibutuhkan

| Bloc | Bertanggung Jawab |
| --- | --- |
| `AuthBloc` *(existing)* | Status login vs guest |
| `HomeBloc` *(baru)* | Fetch data homepage: featured chapter, categories, hadi |
| `BookmarkBloc` *(baru)* | Fetch bookmark milik user (skip jika guest) |

### HomeBloc States

```dart
// HomeBlocState
sealed class HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required Chapter featuredChapter,
    required List<Chapter> chapters,
    required String selectedCategory,
    required List<Hadi> hadiList,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
```

---

## Perbedaan Guest vs Login — Ringkasan

| Section | Guest | Login |
| --- | --- | --- |
| Greeting | "Halo, Tamu!" + person icon | "Halo, [Nama]!" + avatar |
| Search | ✅ Aktif | ✅ Aktif |
| Featured | Chapter pertama (Ibtida') | Chapter terakhir dibaca |
| Kategori + Chapter | ✅ Semua | ✅ Semua |
| Bookmark section | Lock banner + CTA login | Preview 3 bookmark |
| Hadi section | ✅ Semua | ✅ Semua |
| Bottom Nav - Bookmark | 🔒 Lock screen | ✅ Full access |

---

## Mockup

![Homepage Mobile Mockup](screenshot.png){mockup:plans/mockups/homepage-mobile.mockup.html}{375x812}

---

## File yang Perlu Dibuat / Dimodifikasi

### Baru
```
lib/
  features/
    home/
      data/
        datasources/
          home_remote_datasource.dart
        repositories/
          home_repository_impl.dart
      domain/
        entities/
          chapter_entity.dart
          hadi_entity.dart
        repositories/
          home_repository.dart
        usecases/
          get_featured_chapter.dart
          get_chapters_by_category.dart
          get_hadi_list.dart
      presentation/
        bloc/
          home_bloc.dart
          home_event.dart
          home_state.dart
        pages/
          home_page.dart          ← REPLACE existing placeholder
        widgets/
          home_header.dart
          home_search_bar.dart
          featured_chapter_card.dart
          category_chips.dart
          chapter_card.dart
          bookmark_section.dart
          hadi_section.dart
    scaffold/
      presentation/
        pages/
          main_scaffold.dart      ← Bottom nav shell
```

### Dimodifikasi
```
lib/
  core/
    router/
      app_router.dart             ← Tambah bottom nav routes
  features/
    auth/
      presentation/
        pages/
          home_page.dart          ← Ganti isi body
```

---

## Tahapan Implementasi

### Fase 1 — Scaffold & Navigasi (Bottom Nav)
1. Buat `MainScaffold` dengan `NavigationBar` (5 tab)
2. Update `app_router.dart` agar `/home` menggunakan `MainScaffold`
3. Tabs Kitab, Hadi, Bookmark, Profil = placeholder screen

### Fase 2 — Domain & Data Layer
4. Buat entities: `ChapterEntity`, `HadiEntity`
5. Buat repository + datasource untuk fetch chapters (by category) & hadi list
6. Buat usecases

### Fase 3 — HomeBloc
7. Implementasi `HomeBloc`, `HomeEvent`, `HomeState` (freezed)
8. Register di injection container

### Fase 4 — UI Widgets
9. `HomeHeader` — greeting dinamis
10. `HomeSearchBar` — dummy tap
11. `FeaturedChapterCard` — gradient card
12. `CategoryChips` — filter horizontal
13. `ChapterCard` — card per chapter
14. `BookmarkSection` — guest vs login
15. `HadiSection` — 3 pimpinan shalawat

### Fase 5 — Integrasi & Polish
16. Hubungkan semua widget ke HomeBloc
17. Animasi loading skeleton
18. Pull-to-refresh
19. Error state
