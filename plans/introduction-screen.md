---
planStatus:
  planId: plan-introduction-screen
  title: Introduction Screen (Onboarding)
  status: draft
  planType: feature
  priority: high
  owner: aamar
  stakeholders: []
  tags:
    - flutter
    - clean-architecture
    - onboarding
    - auth
  created: "2026-03-12"
  updated: "2026-03-12T10:00:00.000Z"
  progress: 0
---
# Introduction Screen (Onboarding)

## Tujuan

Membuat halaman pengenalan (onboarding) yang ditampilkan hanya pada **pertama kali** pengguna membuka aplikasi. Layar ini menjelaskan 5 fitur utama aplikasi ISHARI dan diakhiri dengan pilihan login (Google atau Guest).

---

## Referensi

- Aplikasi web: https://ishari.vercel.app/
- Arsitektur: Clean Architecture (Uncle Bob) — https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

---

## Desain Visual

![Introduction Screen Mockup](screenshot.png){mockup:plans/mockups/introduction-screen.mockup.html}{800x1000}

---

## Konten 5 Slide

| # | Judul | Ikon | Deskripsi |
| --- | --- | --- | --- |
| 1 | Baca Shalawat Mudah & Kapanpun | `menu_book` | Akses ratusan bait shalawat dari kitab Diwan, Syaraful Anam, Diba', dan lainnya — kapan saja, di mana saja. |
| 2 | Dengarkan dari Guru Terpercaya | `headphones` | Nikmati audio shalawat yang dilantunkan oleh Hadi (guru) terpercaya dari berbagai talaqqi. |
| 3 | Sarana Belajar Shalawat ISHARI | `school` | Pelajari shalawat lengkap dengan teks Arab, transliterasi, dan terjemahan. |
| 4 | Melestarikan Budaya Ulama | `auto_stories` | Jaga dan teruskan khazanah shalawat para Ulama dan Masyayikh terdahulu kepada generasi berikutnya. |
| 5 | Masuk untuk Mulai | *(login UI)* | Login dengan Google untuk mengaktifkan bookmark dan fitur personal, atau lanjutkan sebagai Tamu. |

---

## Arsitektur (Clean Architecture)

### Struktur Folder Baru

```
lib/features/introduction/
├── domain/
│   ├── repositories/
│   │   └── introduction_repository.dart         # abstract interface
│   └── usecases/
│       ├── check_intro_seen.dart                 # UseCase → bool
│       └── mark_intro_seen.dart                  # UseCase → void
├── data/
│   ├── datasources/
│   │   └── introduction_local_datasource.dart    # SharedPreferences
│   └── repositories/
│       └── introduction_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── introduction_bloc.dart
    │   ├── introduction_event.dart               # CheckIntroSeen, MarkIntroSeen
    │   └── introduction_state.dart               # initial, loading, notSeen, alreadySeen
    ├── pages/
    │   └── introduction_page.dart                # PageView container
    └── widgets/
        ├── intro_slide.dart                      # Reusable slide widget
        ├── intro_page_indicator.dart             # Dot indicator
        └── intro_login_slide.dart                # Slide ke-5 khusus (login)
```

### Modifikasi pada Fitur Auth

```
lib/features/auth/
├── domain/usecases/
│   └── sign_in_as_guest.dart                     # BARU: UseCase untuk mode tamu
├── presentation/bloc/
│   ├── auth_event.dart                           # TAMBAH: signInAsGuest event
│   └── auth_bloc.dart                            # TAMBAH: _onSignInAsGuest handler
```

### Modifikasi Core

```
lib/injection_container.dart                      # Daftarkan SharedPreferences
lib/core/router/app_router.dart                   # Tambah route + redirect logic intro
```

---

## Layer Detail

### Domain Layer

#### `introduction_repository.dart`
```dart
abstract interface class IntroductionRepository {
  Future<Either<Failure, bool>> hasSeenIntroduction();
  Future<Either<Failure, Unit>> markIntroductionSeen();
}
```

#### `check_intro_seen.dart`
```dart
// UseCase<bool, NoParams>
// Calls repository.hasSeenIntroduction()
```

#### `mark_intro_seen.dart`
```dart
// UseCase<Unit, NoParams>
// Calls repository.markIntroductionSeen()
```

---

### Data Layer

#### `introduction_local_datasource.dart`
- Gunakan `shared_preferences` package (perlu ditambahkan ke `pubspec.yaml`)
- Key: `'intro_seen'` (bool)
- Dua method: `hasSeenIntroduction()` dan `markIntroductionSeen()`

#### `introduction_repository_impl.dart`
- `@LazySingleton(as: IntroductionRepository)`
- Wrap datasource calls dengan try/catch → return `Left(CacheFailure)` atau `Right(value)`

---

### Presentation Layer

#### `introduction_bloc.dart`

**Events:**
- `IntroductionEvent.checkStatus()` — dipanggil saat app start
- `IntroductionEvent.markAsSeen()` — dipanggil saat user selesai swipe / klik tombol

**States:**
- `IntroductionState.initial()`
- `IntroductionState.loading()`
- `IntroductionState.notSeen()` — tampilkan intro screen
- `IntroductionState.alreadySeen()` — lewati intro, lanjut ke router

#### `introduction_page.dart`
- `PageController` untuk swipe antar slide
- Slide 1–4: `IntroSlide` widget (ikon + judul + deskripsi)
- Slide 5: `IntroLoginSlide` widget (Google login + Guest button)
- Tombol "Lanjut" / "Lewati" di kanan atas

#### `intro_slide.dart`
```dart
// Props: iconData, title, description, backgroundColor
// Layout: center icon (120px), title (headline), description (body)
```

#### `intro_login_slide.dart`
```dart
// Tampil tombol:
// [G] Masuk dengan Google
// [    Lanjutkan sebagai Tamu    ]
// Note kecil: "Tamu tidak dapat menyimpan bookmark"
```

---

## Routing Logic (GoRouter)

Logika redirect diperbarui menjadi 3 lapis:

```
1. Cek intro → belum pernah lihat? → /introduction
2. Sudah lihat intro, belum login?  → /login
3. Sudah login?                      → /home
```

```dart
// Pseudocode router redirect
final introSeen = introductionBloc.state.maybeWhen(
  alreadySeen: () => true,
  orElse: () => false,
);
final isAuthenticated = authBloc.state.maybeWhen(
  authenticated: (_) => true,
  orElse: () => false,
);

if (!introSeen && location != '/introduction') return '/introduction';
if (introSeen && !isAuthenticated && location != '/login') return '/login';
if (isAuthenticated && location == '/login') return '/home';
return null;
```

Tambah route baru:
```dart
GoRoute(
  path: IntroductionPage.routePath,  // '/introduction'
  name: 'introduction',
  builder: (context, state) => const IntroductionPage(),
),
```

---

## Guest Mode (Auth)

Guest login menggunakan **Supabase anonymous sign-in**:

```dart
// auth_remote_datasource.dart — tambah method:
Future<UserModel> signInAsGuest() async {
  final response = await _supabaseClient.auth.signInAnonymously();
  // map ke UserModel
}
```

- Guest user **tidak bisa** bookmark
- Guest user **bisa** baca dan dengarkan shalawat
- Di UI, tampilkan label "Tamu" jika guest mode

---

## Dependensi Baru

| Package | Versi | Kegunaan |
| --- | --- | --- |
| `shared_preferences` | ^2.3.x | Simpan flag `intro_seen` |

> `flutter_secure_storage` tidak digunakan untuk flag ini karena tidak perlu enkripsi — SharedPreferences lebih tepat.

---

## Urutan Implementasi

1. **Tambah \****`shared_preferences`** ke `pubspec.yaml` + daftarkan di `injection_container.dart`
2. **Buat \****`introduction`**\*\* feature** — domain layer (repository interface + 2 use case)
3. **Buat data layer** — datasource + repository impl + injectable annotations
4. **Buat presentation layer** — BLoC + events + states (freezed)
5. **Buat UI** — `IntroductionPage`, `IntroSlide`, `IntroLoginSlide`, `IntroPageIndicator`
6. **Update \****`app_router.dart`** — tambah route + inject `IntroductionBloc` + update redirect
7. **Tambah Guest Login** ke `auth` feature — use case + event + bloc handler
8. **Update \****`main.dart`** — inject dan provide `IntroductionBloc`
9. **Jalankan \****`build_runner`** — regenerate freezed + injectable files

---

## File yang Diubah / Dibuat

### Dibuat Baru (13 file)
- `lib/features/introduction/domain/repositories/introduction_repository.dart`
- `lib/features/introduction/domain/usecases/check_intro_seen.dart`
- `lib/features/introduction/domain/usecases/mark_intro_seen.dart`
- `lib/features/introduction/data/datasources/introduction_local_datasource.dart`
- `lib/features/introduction/data/repositories/introduction_repository_impl.dart`
- `lib/features/introduction/presentation/bloc/introduction_bloc.dart`
- `lib/features/introduction/presentation/bloc/introduction_event.dart`
- `lib/features/introduction/presentation/bloc/introduction_state.dart`
- `lib/features/introduction/presentation/pages/introduction_page.dart`
- `lib/features/introduction/presentation/widgets/intro_slide.dart`
- `lib/features/introduction/presentation/widgets/intro_login_slide.dart`
- `lib/features/introduction/presentation/widgets/intro_page_indicator.dart`
- `lib/features/auth/domain/usecases/sign_in_as_guest.dart`

### Dimodifikasi (5 file)
- `pubspec.yaml` — tambah `shared_preferences`
- `lib/injection_container.dart` — daftarkan `SharedPreferences`
- `lib/core/router/app_router.dart` — tambah route + redirect logic
- `lib/main.dart` — provide `IntroductionBloc`
- `lib/features/auth/presentation/bloc/auth_bloc.dart` + event/state — tambah guest login

---

## Desain System

### Warna (Material Design 3 — Green Seed #51c878)

| Token MD3 | Nilai | Penggunaan |
| --- | --- | --- |
| `primary` | `#51c878` | Tombol utama, ikon aktif, dot aktif |
| `primaryDark` | `#3DAF5E` | State pressed/hover |
| `primaryContainer` | `#E8F8EE` | Background ikon, surface tint |
| `onPrimary` | `#FFFFFF` | Teks/ikon di atas primary |
| `onSurface` | `#1C1B1F` | Teks utama (judul) |
| `onSurfaceVariant` | `#49454F` | Teks sekunder (deskripsi) |
| `outline` | `#79747E` | Caption, border outlined button |
| `surface` | `#FAFAFA` | Background halaman |

Update `ThemeData` di `main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF51c878),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

### Komponen MD3

| Komponen | Spesifikasi |
| --- | --- |
| **FilledButton** (CTA utama) | `borderRadius: 100px`, tinggi 52px, full-width |
| **OutlinedButton** (Tamu) | `borderRadius: 100px`, border 1px primary, tinggi 52px, full-width |
| **TextButton** (Lewati) | Tanpa border/background, warna primary |
| **PageIndicator** | Dot inactive 8px outlined, dot active pill 24×8 filled primary |
| **Icon container** | Lingkaran 120px, `primaryContainer` bg, `primary` icon color |

### Tipografi MD3

| Peran | MD3 Scale | Size | Weight |
| --- | --- | --- | --- |
| Judul slide | Display Small | 36sp | Bold |
| Deskripsi slide | Body Large | 16sp | Regular |
| Caption login | Body Small | 12sp | Regular |
| Skip button | Label Large | 14sp | Medium |

### Ilustrasi (Flat Vector SVG)

Setiap slide menggunakan **ilustrasi SVG flat vector** yang menempati 55% atas layar:

| Slide | Objek Ilustrasi | Warna Utama |
| --- | --- | --- |
| 1 | Buku terbuka dengan garis Arab dekoratif | `#51c878`, `#B2DFDB` |
| 2 | Headphone dengan not musik melayang | `#51c878`, `#FFD54F` |
| 3 | Layar/tablet dengan teks Arab + pensil | `#51c878`, `#64B5F6` |
| 4 | Tangan memegang lentera/manuskrip | `#51c878`, `#FF8A65` |
| 5 | Kunci dengan perisai dan bintang | `#51c878`, `#E8F8EE` |

**Prinsip ilustrasi:**
- Solid flat colors — tanpa gradient pada shape ilustrasi
- Aksen sparkle/bintang kecil berwarna `#FFD54F`
- Latar area ilustrasi: `#F0FAF4` (light mint)
- Wave curve putih memisahkan area ilustrasi dan area konten
- Style referensi: Undraw.co / Material Design Illustrations

### Layout Layar

```
┌─────────────────────────────────┐
│  [Status Bar]          [Lewati] │  ← MD3 TextButton
│                                 │
│   ┌─────────────────────────┐   │
│   │   SVG Flat Illustration  │   │  55% tinggi layar
│   │   (buku / headphone dll) │   │  BG: #F0FAF4
│   └─────────────────────────┘   │
│    ──── wave curve divider ───── │
│                                 │
│     Judul Slide (22px bold)     │  ← MD3 Display Small
│    Deskripsi singkat (14px)     │  ← MD3 Body Large
│                                 │
│         ○ ● ○ ○ ○               │  ← Page indicator
│                                 │
│  ╔═════════════════════════╗    │
│  ║  Selanjutnya / G Login  ║    │  ← MD3 FilledButton
│  ╚═════════════════════════╝    │
│  ┌─────────────────────────┐    │
│  │  Lanjutkan sebagai Tamu │    │  ← MD3 OutlinedButton (slide 5)
│  └─────────────────────────┘    │
│    caption kecil (slide 5)      │
│         ─────────               │  ← Home indicator
└─────────────────────────────────┘
```

### Animasi & UX
- `PageView` dengan `physics: BouncingScrollPhysics()`
- Dot indicator animasi via `AnimatedContainer` (pill ↔ circle)
- Swipe gesture natural + tombol "Selanjutnya" / "Lewati"
- Aksesibilitas: semua teks mendukung font scaling
- Teks Arab menggunakan `TextDirection.rtl`
