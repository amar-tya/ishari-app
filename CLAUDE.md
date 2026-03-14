# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Environment Setup
Switch environments before running (generates `lib/core/env/env.g.dart`):
```bash
scripts/use_dev.bat   # development
scripts/use_prod.bat  # production
```

### Run & Build
```bash
flutter run --dart-define-from-file=env/dev.json
flutter build apk --dart-define-from-file=env/prod.json
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

This is an Islamic shalawat (salutations on the Prophet) reading and audio app. Users can browse shalawat chapters, listen to preachers (Hadi), and bookmark content. Supports Google Sign-In via Supabase OAuth and guest mode.

### Clean Architecture

Features follow strict three-layer separation under `lib/features/<feature>/`:
- **domain/** — pure Dart: entities, repository interfaces, use cases
- **data/** — concrete: datasources (remote/local), models (Freezed + JSON), repository implementations
- **presentation/** — Flutter: BLoC, pages, widgets

Current features: `auth`, `home`, `introduction` (onboarding), `scaffold` (bottom nav shell).

### State Management

BLoC pattern (`flutter_bloc`) with Freezed-generated sealed event/state classes. BLoCs are registered via GetIt/Injectable and provided at the route level.

### Routing

GoRouter (`lib/core/router/app_router.dart`) with two root routes:
- `/introduction` — 5-slide onboarding; unauthenticated users are redirected here
- `/home` — shell with 5-tab `IndexedStack` (MainScaffold); authenticated and guest users land here

Redirect logic reads from `AuthBloc` state and `AppState.isGuestMode`.

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
- **Tables:** `chapters` (shalawat content), `hadi` (preachers)
- **Auth:** Google Sign-In OAuth — uses `google_sign_in` with `serverClientId` to obtain `idToken`, then exchanges with Supabase

### Code Generation Files

Never manually edit `*.freezed.dart`, `*.g.dart`, or `*.config.dart`. Re-run `build_runner` after changes to annotated classes.

### Linting

Uses `very_good_analysis`. Key rules: prefer single quotes, no public member docs required. Generated files are excluded from analysis.
