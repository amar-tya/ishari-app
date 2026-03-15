---
planStatus:
  planId: plan-muhud-page-refactor
  title: Muhud Page Refactor & Nav Connection
  status: draft
  planType: feature
  priority: high
  owner: aamar
  stakeholders: []
  tags:
    - ui
    - flutter
    - muhud
  created: "2026-03-14"
  updated: "2026-03-14T00:00:00.000Z"
  progress: 0
---
# Muhud Page Refactor & Nav Connection

## Objective

1. Refactor chapter reader UI to match the mockup design (`plans/mockups/muhud-chapter-reader.mockup.html`)
2. Connect the Muhud bottom nav tab to the chapter reader page
3. Arabic text use font Amiri from google fonts

---

## Current State

- **Tab 1 (Muhud)** in `main_scaffold.dart` shows `_PlaceholderTab` — just a "coming soon" message
- Chapter reader (`ChapterReaderPage`) is accessible only via route `/chapter/:chapterId` (pushed from `HomeTab` chapter cards) — this opens full-screen without the bottom nav
- Current `VerseCard` uses a card style (rounded border box), not the flat-item style from mockup
- Current AppBar has a translate toggle icon, not the Quick Tools hamburger
- No Quick Tools side panel exists

## Mockup Reference

![Chapter Reader Mockup](screenshot.png){mockup:plans/mockups/muhud-chapter-reader.mockup.html}

---

## Design Diff: Current vs Mockup

### AppBar (Screen 1)
| Current | Mockup |
| --- | --- |
| Back button + title + translate toggle | Back button + title + chevron + **hamburger icon (Quick Tools)** |

### Verse Layout
| Current | Mockup |
| --- | --- |
| Card with rounded border (`border-radius: 12`, all-around border) | Flat item with bottom divider |
| Playing state: full green border + green background | Playing state: **left border accent** (3px green) + `#FAFFFE` background |
| 2 actions: play + bookmark | 4 actions: play + copy + bookmark + more (…) |
| Translation label: grey | Translation label: **green** (#51C878) |

### New: Quick Tools Panel (Screen 2)
- Side panel slides from right (~82% screen width)
- Dark overlay on left
- Tabs: **Bait, Hadi, Kategori, Kitab**
- Content toggles: Arab, Transliterasi, Terjemahan,
- Font settings: Arab font selector + Arab font size slider + translation font size slider

### New: Shalawat Header
- Centered Arabic prayer text above the verse list (currently missing from `ChapterReaderBody`)

---

## Implementation Plan

### Step 1 — Extend BLoC State & Events

**`muhud_state.dart`** — Add new display fields to `_Loaded`:
```dart
@Default(true) bool showArabic,
@Default(true) bool showTransliteration,
```

**`muhud_event.dart`** — Add new toggle events:
```dart
const factory MuhudEvent.toggleArabic() = _ToggleArabic;
const factory MuhudEvent.toggleTransliteration() = _ToggleTransliteration;
```

**`muhud_bloc.dart`** — Handle new events in `_onToggleArabic` and `_onToggleTransliteration` (same pattern as `_onToggleTranslation`).

> Re-run `build_runner` after all Freezed annotation changes.

---

### Step 2 — Create MuhudTab

**New file:** `lib/features/muhud/presentation/pages/muhud_tab.dart`

```dart
class MuhudTab extends StatelessWidget {
  const MuhudTab({super.key});
}
```

- Provides `MuhudBloc` via `BlocProvider` (same as `ChapterReaderPage`)
- On create, dispatches `MuhudEvent.loadChapter(chapterId: 1)` (first chapter by default)
- Shows loading / error / loaded states
- In loaded state, renders `ChapterReaderBody` with `isEmbeddedInTab: true`
- **No back button** when embedded in tab (use `isEmbeddedInTab` flag)

**`main_scaffold.dart`** — Replace placeholder:
```dart
// Before:
_PlaceholderTab(icon: Icons.menu_book, label: 'Muhud'),
// After:
const MuhudTab(),
```

---

### Step 3 — Refactor `chapter_app_bar.dart`

- Add `isEmbeddedInTab` param (bool, default false)
- Show back button only when `!isEmbeddedInTab` (uses `context.pop()`)
- Add dropdown chevron (`Icons.keyboard_arrow_down`) next to title
- Replace translate `IconButton` with a **hamburger icon** (`Icons.tune` or menu lines icon)
- Tapping hamburger calls a new `onOpenQuickTools` callback

---

### Step 4 — Refactor `chapter_reader_body.dart`

- Accept `isEmbeddedInTab` and pass it down to `ChapterAppBar`
- Add `onOpenQuickTools` callback that shows `QuickToolsPanel` as a side overlay
- Add `ShalawatHeader` widget above the verse list:
```dart
  Container(
    padding: EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(border: Border(bottom: ...)),
    child: Text(shalawatText, style: ..., textDirection: TextDirection.rtl),
  )
```
- Wrap scroll area + quick tools panel in a `Stack` for the overlay
- Remove extra padding from `VerseList` (list now flush within scroll area)

---

### Step 5 — Refactor `verse_list.dart`

- Remove `separatorBuilder` and card-style gap
- Use `ListView.builder` with no padding
- Each `VerseCard` handles its own bottom divider
- Pass `showArabic` and `showTransliteration` from BLoC state down to `VerseCard`

---

### Step 6 — Refactor `verse_card.dart` (Major)

**New layout structure (matching mockup):**
**\*tombol play button tampil jika verse memiliki audio.**

```
┌────────────────────────────────────────────┐ ← flat (no rounded border)
│ [●1] (num badge)      [▶][copy][🔖][...] │ ← verse-header row
│                                            │
│   الْأَلِفُ اوَّلَ الْكَلَامِ يَا مَجِيدُ  │ ← Arabic RTL, full width
│                                            │
│  ālālifu awwala l-kalāmi yā majīdu         │ ← transliteration (italic)
│  TERJEMAHAN                                │ ← label in green
│  Huruf Alif...                             │ ← translation text
├────────────────────────────────────────────┤ ← divider
```

**Style changes:**
- Background: `white` normally, `#FAFFFE` when playing
- Left border: `3px solid #51C878` when playing (use `BoxDecoration` with `border: Border(left: ...)`)
- Playing verse number badge: pulse ring animation (keep existing `_VerseNumberBadge`)
- **4 action buttons** in `verse-header`:
  1. **Play/Pause** (`_PlayPauseButton`) — keep existing
  2. **Copy** — `Icons.copy_outlined`, taps clipboard copy of Arabic text
  3. **Bookmark** — existing icon, filled when bookmarked
  4. **More (…)** — `Icons.more_horiz`, taps to show a context menu (no action required yet, scaffold only)
- Translation label style: `color: Color(0xFF51C878)` (was grey)
- Conditionally show Arabic based on `showArabic` param
- Conditionally show transliteration based on `showTransliteration` param

---

### Step 7 — New `quick_tools_panel.dart`

**File:** `lib/features/muhud/presentation/widgets/quick_tools_panel.dart`

This is a widget shown as a side overlay. It reads/writes BLoC state.

**Layout:**
```
[dark overlay, left 18%] | [panel, right 82%]
                          | ┌──────────────────┐
                          | │ [×] Quick Tools  │ ← header
                          | │─────────────────│
                          | │ Bait Hadi Kat.. │ ← tab chips
                          | │─────────────────│
                          | │ Konten          │ ← section label
                          | │ Arab         [■]│ ← toggle
                          | │ Transliterasi[■]│
                          | │ Terjemahan   [□]│
                          | │─────────────────│
                          | │ Pengaturan Font │ ← section label
                          | │ Font Arab  Uth >│ ← font row
                          | │ Ukuran Arab  22 │ ← slider
                          | │ Ukuran Terj. 14 │ ← slider
                          └──────────────────┘
```

**Implementation approach:**
- Shown/hidden via `AnimatedContainer` or `OverlayEntry` (prefer simpler `Stack` in `ChapterReaderBody`)
- `isOpen` bool controlled by local state in `ChapterReaderBody`
- Toggle switches dispatch `toggleArabic`, `toggleTransliteration`, `toggleTranslation` BLoC events
- Font size sliders: local state only (no BLoC for now)
- Tabs (Bait, Hadi, Kategori, Kitab): local state for selected tab; only "Bait" tab content is implemented

---

## Files Changed

| File | Change Type |
| --- | --- |
| `lib/features/muhud/presentation/bloc/muhud_state.dart` | Add `showArabic`, `showTransliteration` fields |
| `lib/features/muhud/presentation/bloc/muhud_event.dart` | Add `toggleArabic`, `toggleTransliteration` events |
| `lib/features/muhud/presentation/bloc/muhud_bloc.dart` | Handle new events |
| `lib/features/muhud/presentation/pages/muhud_tab.dart` | **NEW** — MuhudTab widget for bottom nav |
| `lib/features/muhud/presentation/pages/chapter_reader_page.dart` | Pass `isEmbeddedInTab: false` |
| `lib/features/muhud/presentation/widgets/chapter_app_bar.dart` | Hamburger icon + `isEmbeddedInTab` |
| `lib/features/muhud/presentation/widgets/chapter_reader_body.dart` | Shalawat header + Quick Tools Stack |
| `lib/features/muhud/presentation/widgets/verse_list.dart` | Flat list, pass `showArabic`/`showTransliteration` |
| `lib/features/muhud/presentation/widgets/verse_card.dart` | Flat style, 4 action buttons, green label |
| `lib/features/muhud/presentation/widgets/quick_tools_panel.dart` | **NEW** — side panel widget |
| `lib/features/scaffold/presentation/pages/main_scaffold.dart` | Replace Muhud placeholder with `MuhudTab` |

> After `muhud_state.dart` and `muhud_event.dart` changes, run:
> ```bash
> dart run build_runner build --delete-conflicting-outputs
> ```

---

## Out of Scope

- Kitab / Hadi / Kategori tabs inside Quick Tools panel (scaffold only, no content)
- Per Kata word-by-word highlighting (toggle exists, no logic)
- Font Arab selector dropdown (scaffold only)
- More (…) context menu actions
- `getBookmarkedVerseIds` persistence (currently not wired up in bloc's `_onLoadChapter`)
