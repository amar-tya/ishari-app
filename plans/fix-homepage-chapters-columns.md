---
planStatus:
  planId: plan-fix-homepage-chapters-columns
  title: Fix Homepage - chapters column name mismatch
  status: draft
  planType: bug-fix
  priority: high
  owner: aamar
  stakeholders: []
  tags:
    - bug-fix
    - homepage
    - supabase
  created: "2026-03-14"
  updated: "2026-03-14T00:00:00.000Z"
  progress: 0
---
# Fix Homepage - chapters Column Mismatch

## Problem

Homepage crashes with error: **`column chapters.number does not exist`**

The app code references DB columns by wrong names. Three mismatches found between app models and the actual Supabase `chapters` table schema:

| App Code | Actual DB Column |
| --- | --- |
| `number` | `chapter_number` |
| `verse_count` | `total_verses` |
| `id` (String) | `id` (int) |

---

## Files to Change

### 1. `lib/features/home/data/datasources/home_remote_datasource.dart`

Fix both `.order('number')` calls → `.order('chapter_number')`:

- Line 34: `getFeaturedChapter()` method
- Line 51: `getChaptersByCategory()` method

### 2. `lib/features/home/data/models/chapter_model.dart`

Fix three field mappings:

1. `int? number` → add `@JsonKey(name: 'chapter_number')` annotation
2. `@JsonKey(name: 'verse_count')` → change to `@JsonKey(name: 'total_verses')`
3. `required String id` → add `@JsonKey(fromJson: _idToString)` since DB returns int but app uses String

Add a top-level helper outside the class:
```dart
String _idToString(dynamic v) => v.toString();
```

### 3. Regenerate freezed/json code

After model changes, run:
```
dart run build_runner build --delete-conflicting-outputs
```

---

## No Entity Changes Needed

`chapter_entity.dart` uses field names only for Dart logic (no JSON), so no changes needed there.

---

## Steps

1. Edit `home_remote_datasource.dart` — fix 2 `.order()` calls
2. Edit `chapter_model.dart` — fix 3 `@JsonKey` annotations + add `_idToString` helper
3. Run `build_runner` to regenerate `.g.dart` and `.freezed.dart` files
