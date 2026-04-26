# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## graphify — Knowledge Graph

A pre-built knowledge graph lives in `graphify-out/`. Use it to navigate unfamiliar parts of the codebase — it shows which files connect to which without reading each one.

### When to USE graphify

- Exploring an unfamiliar feature area ("how does auth flow work?")
- Finding which files are relevant to a concept you don't know yet
- Starting work on a cross-cutting refactor spanning multiple features

```bash
/graphify query "<question>"      # BFS — broad context, nearest neighbors first
/graphify path "ConceptA" "ConceptB"  # shortest dependency path between two nodes
/graphify explain "NodeName"      # all connections for a single node
```

### When to SKIP graphify

- Task already specifies exact file paths to edit (e.g. scheduled tasks, bug reports with file names)
- You already know the relevant files from prior context in the session
- Single-file fix or trivial edit

**Graphify points to files — you still need `Read` to write correct code.**

### When to update the graph

Only after **significant** changes — adding a new feature, end of sprint, major refactor. Do NOT run after every small edit.

```bash
/graphify . --update
```

If `graphify-out/` does not exist, build it first: `/graphify .`

### Windows PowerShell — inline Python escape fix

Inline Python with f-strings inside PowerShell `-c` args often fails with `SyntaxError: unterminated string literal`. When this happens, write to a temp script file instead:

```powershell
# Write script to file, run, then delete
@'
import json, sys
from networkx.readwrite import json_graph
from pathlib import Path
# ... your Python code here (no escaping needed)
'@ | Out-File -FilePath .tmp_script.py -Encoding utf8
python .tmp_script.py
Remove-Item .tmp_script.py
```

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)

## Commands

### Environment Setup
Wajib dijalankan sebelum run/build. Script ini copy `dev.env`/`prod.env` ke `current.env` lalu jalankan `build_runner` untuk generate `lib/core/env/env.g.dart`:
```bash
scripts/use_dev.bat   # development
scripts/use_prod.bat  # production
```

File env ada di `env/` — copy dari contoh lalu isi nilainya:
```bash
# env/dev.env  (copy dari env/dev.env.example)
APP_ENV=development
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
GOOGLE_WEB_CLIENT_ID=xxx.apps.googleusercontent.com
```

### Run & Build
Setelah `use_dev.bat` / `use_prod.bat` dijalankan, **tidak perlu** `--dart-define-from-file`:
```bash
flutter run             # development
flutter build apk       # production APK
```

### Code Generation
Required after modifying any `@freezed`, `@injectable`, or `@JsonSerializable` class:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Lint & Analyze
```bash
flutter analyze
```

## Architecture

This is an Islamic shalawat (salutations on the Prophet) reading and audio app. Users can browse shalawat chapters, read verses with translations, listen to audio by preachers (Hadi), and bookmark content. Supports Google Sign-In via Supabase OAuth and guest mode.

### Clean Architecture

Features follow strict three-layer separation under `lib/features/<feature>/`:
- **domain/** — pure Dart: entities, repository interfaces, use cases
- **data/** — concrete: datasources (remote/local), models (Freezed + JSON), repository implementations
- **presentation/** — Flutter: BLoC, pages, widgets

Current features:
- `auth` — Google Sign-In, guest mode, session management
- `home` — shalawat chapter list with categories, featured chapters, Hadi section
- `introduction` — 5-slide onboarding carousel
- `scaffold` — bottom nav shell (`MainScaffold`)
- `splash` — animated splash screen during auth initialization
- `muhud` — chapter reader with verse display, audio playback, split panel, bookmarking
- `search` — full-text search across chapters
- `bookmark` — view and manage bookmarked verses
- `kitab` — Islamic books catalog browsing

Shared reusable widgets live in `lib/shared/widgets/` (e.g., `FilterChipsRow`, `SearchBarField`).

### State Management

BLoC pattern (`flutter_bloc`) with Freezed-generated sealed event/state classes. BLoCs are registered via GetIt/Injectable and provided at the route level. Cubits are used for simpler local state (e.g., `SplitPanelCubit`).

### Routing

GoRouter (`lib/core/router/app_router.dart`) with these routes:

| Path | Name | Component |
|------|------|-----------|
| `/splash` | splash | `SplashPage` — initial location; manages its own exit |
| `/introduction` | introduction | `IntroductionPage` — 5-slide onboarding |
| `/home` | home | `HomePage` — shell with 5-tab `IndexedStack` (MainScaffold) |
| `/chapter/:chapterId` | chapter-reader | `ChapterReaderPage` — verse reader with audio |

Redirect logic reads from `AuthBloc` state and `AppState.isGuestMode`:
- Unauthenticated non-guest users → `/introduction`
- Authenticated or guest users on `/introduction` → `/home`

### Dependency Injection

GetIt + Injectable. Call `configureDependencies()` in `main()`. External packages (SupabaseClient, InternetConnection, FlutterSecureStorage) are manually registered in `RegisterModule`. All `@injectable`-annotated classes are auto-registered.

### Error Handling

Uses `fpdart` `Either<Failure, T>` throughout domain and data layers. Exception hierarchy (`ServerException`, `CacheException`, `NetworkFailure`) is caught in repository implementations and mapped to sealed `Failure` subclasses (`ServerFailure`, `CacheFailure`, `NetworkFailure`, `UnknownFailure`).

Repository pattern:
1. Check connectivity via `NetworkInfo`
2. On connected: call remote datasource, cache result on success
3. On disconnected: read from local cache
4. Wrap all results in `Either`

### Backend

Supabase is the sole backend:
- **Tables:** `chapters`, `verses`, `translations`, `hadi`, `hadi_media`, `books`
- **Auth:** Google Sign-In OAuth — uses `google_sign_in` with `serverClientId` to obtain `idToken`, then exchanges with Supabase

### Key Packages

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `get_it` + `injectable` | Dependency injection |
| `fpdart` | Functional error handling (`Either`) |
| `freezed` | Immutable models, sealed events/states |
| `go_router` | Navigation |
| `supabase_flutter` | Backend & auth |
| `google_sign_in` | OAuth |
| `just_audio` | Audio playback in chapter reader |
| `wakelock_plus` | Keep screen on during reading |
| `internet_connection_checker_plus` | Network connectivity |
| `flutter_secure_storage` | Secure local storage |
| `envied` | Environment variable generation |

### Code Generation Files

Never manually edit `*.freezed.dart`, `*.g.dart`, or `*.config.dart`. Re-run `build_runner` after changes to annotated classes.

### Linting

Uses `very_good_analysis`. Key rules: prefer single quotes, no public member docs required. Generated files are excluded from analysis.
