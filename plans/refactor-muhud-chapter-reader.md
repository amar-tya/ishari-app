---
planStatus:
  planId: plan-muhud-chapter-reader-refactor
  title: Refactor Muhud Chapter Reader UI
  status: draft
  planType: refactor
  priority: medium
  owner: aamar
  stakeholders: []
  tags:
    - flutter
    - ui
    - muhud
    - scroll
  created: "2026-03-15"
  updated: "2026-03-15T00:00:00.000Z"
  progress: 0
---
# Refactor Muhud Chapter Reader UI

## Referensi Mockup

![Chapter Reader Mockup](screenshot.png){mockup:plans/mockups/muhud-chapter-reader.mockup.html}

---

## Tujuan

Refactor tampilan chapter reader agar sesuai dengan mockup, dengan fokus utama:

1. **Chapter header layout** — judul Arab rata kanan, subtitle rata kiri
2. **Scroll coverage effect** — verse list menutupi chapter header saat di-scroll ke atas
3. **App bar dynamic title** — title muncul di app bar ketika chapter header tertutup penuh

---

## Analisis Kondisi Saat Ini

### File yang relevan

| File | Fungsi |
| --- | --- |
| `lib/features/muhud/presentation/widgets/chapter_reader_body.dart` | Layout utama reader (perlu refactor terbesar) |
| `lib/features/muhud/presentation/widgets/chapter_app_bar.dart` | App bar dengan animated title |

### Masalah yang ada

**1. Layout chapter header (baris 86–113, \****`chapter_reader_body.dart`**\*\*)**
- Title `chapter.description` (teks Arab) saat ini ditampilkan dengan `textAlign: TextAlign.center`
- `CrossAxisAlignment.center` pada `Column`
- Mockup: title rata kanan (RTL), subtitle rata kiri
- Font size 48px terlalu besar dibanding mockup (24px)

**2. Scroll behavior (baris 79–148, \****`chapter_reader_body.dart`**\*\*)**
- Struktur saat ini: `CustomScrollView` dengan semua sliver (header + rounded cap + verse list) scroll bersama
- Efek yang terjadi: header ikut scroll ke atas dan menghilang di atas layar
- Efek yang diinginkan: header **tetap di tempatnya**, verse list (white sheet) **bergerak naik menutupi** header dari bawah

**3. App bar title trigger (baris 49–54, \****`chapter_reader_body.dart`**\*\*)**
- Saat ini trigger pada `scrollOffset > 80` — nilai hardcoded yang tidak mengacu ke tinggi header sesungguhnya
- Target: trigger ketika white sheet benar-benar menutupi chapter header sepenuhnya

---

## Rencana Implementasi

### Strategi: Stack + Scroll-Driven Overlay

Ganti arsitektur dari flat `CustomScrollView` menjadi `Stack` layout:

```
Stack
├── [layer 1] Green background (full height) — fixed
├── [layer 2] Chapter header content — fixed, di bawah app bar
├── [layer 3] White scrollable sheet — posisi top dikontrol scroll offset
│   ├── Rounded top decoration
│   └── CustomScrollView (VerseList sliver)
└── [layer 4] ChapterAppBar — always on top
```

**Mekanisme scroll:**
- `_scrollController` terhubung ke `CustomScrollView` di dalam white sheet
- Listener `_onScroll()` membaca `scrollController.offset`
- `_whiteSheetOffset = scrollOffset.clamp(0, _chapterHeaderHeight)`
- `top` dari white sheet = `_appBarTotalHeight + _chapterHeaderHeight - _whiteSheetOffset`
- Saat `scrollOffset >= _chapterHeaderHeight`: header tertutup penuh → tampilkan app bar title

---

### Perubahan File

#### 1. `chapter_reader_body.dart`

**a. State variables baru:**
```dart
double _headerOffset = 0; // 0..chapterHeaderHeight
static const double _chapterHeaderHeight = 90.0; // title + subtitle + padding
static const double _appBarHeight = 56.0;
```

**b. \****`_onScroll()`**\*\* update:**
```dart
void _onScroll() {
  final offset = _scrollController.offset.clamp(0.0, _chapterHeaderHeight);
  final showTitle = _scrollController.offset >= _chapterHeaderHeight;
  if (offset != _headerOffset || showTitle != _showTitle) {
    setState(() {
      _headerOffset = offset;
      _showTitle = showTitle;
    });
  }
}
```

**c. Layout \****`build()`***\* — ganti \****`Column + CustomScrollView`***\* menjadi \****`Stack`**\*\*:**
```dart
Scaffold(
  backgroundColor: const Color(0xFF51C878),
  body: SafeArea(
    child: Stack(
      children: [
        // Layer 1: Green background
        const Positioned.fill(child: ColoredBox(color: Color(0xFF51C878))),

        // Layer 2: Chapter header (fixed, di bawah app bar)
        Positioned(
          top: _appBarHeight,
          left: 0, right: 0,
          child: _ChapterHeader(chapter: widget.chapter),
        ),

        // Layer 3: White scrollable sheet (slide up as user scrolls)
        Positioned(
          top: _appBarHeight + _chapterHeaderHeight - _headerOffset,
          bottom: 0,
          left: 0, right: 0,
          child: _WhiteVerseSheet(
            scrollController: _scrollController,
            verses: widget.verses,
            // ... other props
          ),
        ),

        // Layer 4: App bar (always on top)
        Positioned(
          top: 0, left: 0, right: 0,
          child: ChapterAppBar(
            isEmbeddedInTab: widget.isEmbeddedInTab,
            onOpenQuickTools: () => setState(() => _showQuickTools = true),
            title: widget.chapter.description,
            showTitle: _showTitle,
          ),
        ),

        // Layer 5: Quick tools overlay (conditional)
        if (_showQuickTools)
          Positioned.fill(child: QuickToolsPanel(...)),
      ],
    ),
  ),
)
```

**d. \****`_ChapterHeader`**\*\* widget baru (internal):**
```dart
// Title (Arab) rata kanan, subtitle rata kiri
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text(chapter.description, textAlign: TextAlign.right, textDirection: TextDirection.rtl,
      style: GoogleFonts.amiri(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
    const SizedBox(height: 4),
    Text('${chapter.category} • ${chapter.verseCount} Ayat',
      style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8))),
  ],
)
```

**e. \****`_WhiteVerseSheet`**\*\* widget baru (internal):**
```dart
// Rounded top + VerseList
ClipRRect(
  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  child: ColoredBox(
    color: Colors.white,
    child: CustomScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      slivers: [
        VerseList(...),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    ),
  ),
)
```

---

#### 2. `chapter_app_bar.dart`

Perubahan kecil:
- Pastikan font Arabic menggunakan `GoogleFonts.amiri` untuk konsistensi dengan chapter header
- Title text-align: `TextAlign.right` + `textDirection: TextDirection.rtl`

---

### Catatan Penting

**Tinggi chapter header dinamis:**
`_chapterHeaderHeight` sebaiknya diukur secara runtime menggunakan `GlobalKey` + `RenderBox.size.height` atau `LayoutBuilder`, karena tinggi bisa bervariasi tergantung panjang teks. Implementasi awal bisa menggunakan nilai konstanta (misal 90px) dan divalidasi di device.

**Padding SafeArea:**
Posisi layer-layer dalam `Stack` harus mempertimbangkan `MediaQuery.of(context).padding.top` untuk notch/status bar agar tidak ada overlap. Gunakan `SafeArea` di lapisan paling atas atau tambahkan `MediaQuery.of(context).padding.top` ke offset.

**Quick tools panel:**
Tidak ada perubahan pada `quick_tools_panel.dart` dan `audio_selection_sheet.dart` — sudah sesuai mockup.

---

## File yang Dimodifikasi

| File | Jenis Perubahan |
| --- | --- |
| `lib/features/muhud/presentation/widgets/chapter_reader_body.dart` | Refactor besar — layout Stack + scroll coverage |
| `lib/features/muhud/presentation/widgets/chapter_app_bar.dart` | Minor — font + RTL title |

## File yang Tidak Diubah

- `verse_card.dart` — sudah sesuai mockup
- `verse_list.dart` — tidak berubah
- `quick_tools_panel.dart` — tidak berubah
- `audio_selection_sheet.dart` — tidak berubah
- `chapter_reader_page.dart` — tidak berubah
- Semua domain/data layer — tidak berubah
