---
planStatus:
  planId: plan-chapter-reader-header-scroll
  title: Refactor Chapter Reader Header with Scroll-to-Cover Effect
  status: draft
  planType: refactor
  priority: medium
  owner: aamar
  stakeholders: []
  tags:
    - ui
    - flutter
    - scroll
    - refactor
  created: "2026-03-15"
  updated: "2026-03-15T00:00:00.000Z"
  progress: 0
---
# Refactor Chapter Reader Header with Scroll-to-Cover Effect

## Objective

Refactor `_ShalawatHeader` and the overall `ChapterReaderBody` layout so that:

1. **AppBar** — strip the chapter title, keep back button + quick tools icon, adjust colors
2. **`_ShalawatHeader`** — becomes a full header showing chapter title, meta info (category, verse count), and Arabic description (title use chapter.description -> arabic text)
3. **VerseList** — wrapped in a white container with **rounded top corners**
4. **Scroll behavior** — as the user scrolls the verse list upward, it covers/overlaps the `_ShalawatHeader`

Reference screenshot:
- AppBar: `<` back | [spacer] | gear icon (quick tools) — **no bookmark icon**
- Below AppBar: chapter title ("Al-Fatihah"), subtitle ("Mekah • 7 Ayat")
- Below that: verse list with rounded top

---

## Files to Change

| File | Change |
| --- | --- |
| `chapter_reader_body.dart` | Restructure layout to use `CustomScrollView` |
| `chapter_app_bar.dart` | Remove title, adjust colors |

---

## Detailed Plan

### 1. `ChapterAppBar` changes

- **Remove**: chapter title text + `Icons.keyboard_arrow_down_rounded` + dropdown arrow
- **Remove**: bookmark icon (not needed)
- **Keep**: back button (when `!isEmbeddedInTab`) + quick tools (`Icons.tune_rounded`)
- **Color**: background `Color(0xFF51C878)` (primary green), icons `Colors.white`
- Row simplifies to: `[BackButton?] [Spacer] [QuickToolsButton]`

### 2. `_ShalawatHeader` changes (inside `chapter_reader_body.dart`)

Full green header content:

```
_ShalawatHeader  (background: Color(0xFF51C878))
├── chapter.title        — e.g. "Al-Fatihah"  (white, large bold)
├── subtitle             — "${chapter.category} • ${chapter.verseCount} Ayat"  (white, smaller)
└── chapter.description  — Arabic text  (white, large, centered, if not empty)
```

Note: separate category badge removed since category is now part of the subtitle.

Background color: `Color(0xFF51C878)` (primary green).

### 3. Layout restructure in `ChapterReaderBody`

**Current structure:**
```
Column
├── ChapterAppBar (fixed)
├── _ShalawatHeader (fixed)
└── Expanded → VerseList (scrollable)
```

**New structure using \****`CustomScrollView`**\*\*:**
```
Column
├── ChapterAppBar (fixed — always visible)
└── Expanded → CustomScrollView
    ├── SliverToBoxAdapter: _ShalawatHeader (scrolls away)
    ├── SliverToBoxAdapter: _RoundedTopClip (white container, rounded top 20px)
    └── SliverList.builder: verse items (white background)
```

The `_RoundedTopClip` is a thin white `Container` with `BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))`. It sits between the header and the verse list so that:
- When at rest, the verse list appears with rounded top corners attached to the header
- When scrolled up, the entire header (including this clip) scrolls away under the AppBar

**Scaffold background color**: `Color(0xFF51C878)` — matches header, so AppBar + header blend seamlessly.

The `_RoundedTopClip` between header and verse list:
```dart
Container(
  height: 24,
  decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  ),
)
```
This creates a clean green→white visual transition with rounded corners.

### 4. QuickToolsPanel overlay

No change — remains a `Positioned.fill` in the `Stack` wrapping the whole body.

---

## Decisions Made

| Question | Answer |
| --- | --- |
| AppBar background | `Color(0xFF51C878)` green, white icons |
| Bookmark icon | Not added |
| Header background | `Color(0xFF51C878)` green |
| Subtitle format | `"${chapter.category} • ${chapter.verseCount} Ayat"` |

---

## Implementation Steps

1. Update `ChapterAppBar` — remove title/dropdown, set green bg + white icons
2. Update `_ShalawatHeader` — add `chapter.title`, subtitle, keep Arabic description; change to green bg + white text; remove standalone category badge
3. Restructure `ChapterReaderBody.build()` — replace `Column` + `Expanded(VerseList)` with `CustomScrollView` slivers
4. Add `_RoundedTopClip` between header sliver and verse list sliver
5. Set `Scaffold.backgroundColor` to `Color(0xFF51C878)`
