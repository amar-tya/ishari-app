---
planStatus:
  planId: plan-tag-based-deploy-strategy
  title: Tag-Based Deploy Strategy (Snapshot/Release Tags + Feature Flags)
  status: complete
  planType: infra
  priority: medium
  owner: aamar
  stakeholders: []
  tags:
    - ci-cd
    - github-actions
    - shorebird
    - release
  created: "2026-09-17"
  updated: "2026-09-17T00:00:00.000Z"
  progress: 100
---
# Tag-Based Deploy Strategy

## Status Terkini (2026-09-17)

**Fase 1 — SELESAI.** Detail task-by-task ada di `tasks/tag-deploy-phase1/`
(spec.md/plan.md/todo.md — folder ini `.gitignore`d, cuma lokal). Ringkasan
yang udah live di repo:

- `release-please-config.json` + `.release-please-manifest.json` +
  `.github/workflows/release-please.yml` — jalan, PR-only, tervalidasi
  (`release-type: simple`, gak nyentuh `pubspec.yaml`)
- `.github/workflows/build-staging-android.yml` — jalan, tervalidasi
  end-to-end: tag snapshot → build APK → Firebase App Distribution → install
  sukses di device real yang udah ada build production (gak kena
  downgrade-block, formula build number `1000 + github.run_number`)
- `docs/tag-protection-ruleset.md` — runbook, **dan rulesetnya udah
  diapply** (GitHub Ruleset `protect-release-tags`, lock pattern
  `v*` kecuali `*-snapshot*`)
- `build-and-distribute-android.yml`, `shorebird-patch-android.yml`,
  `sync-develop.yml` — nol perubahan, flow production lama masih jalan
  seperti biasa

**Fase 2 — SELESAI**, dimulai lebih cepat dari rencana awal (kriteria
"≥2-3 fitur asli lewat snapshot-tag dulu" belum tercapai — keputusan
sadar user buat langsung lanjut, bukan lupa checklist). Tervalidasi
end-to-end beneran (bukan dry-run — Play Store production ke-upload
sungguhan, versi live `1.3.0+25`):

- `.github/workflows/release-android.yml` (BARU, file terpisah — bukan
  edit `build-and-distribute-android.yml`) — trigger tag `v*.*.*` exclude
  `*-snapshot*`, build + Shorebird release + upload Play Store production
- `build-and-distribute-android.yml` tetap gak diubah — masih hidup
  sebagai fallback branch-push+paths selama masa transisi
- **Gotcha kepentok & terekam:** `release-please` **gak bisa** auto-tag
  rilis (`vX.Y.Z`) karena ruleset `protect-release-tags` nolak tag
  creation dari identitas bot Actions — cuma bypass buat repo
  admin/deploy-key. Ini **desain yang benar, bukan bug**: sesuai niat
  Fase 1, tag rilis harus sengaja dibuat manusia, gak boleh keselip
  otomatis. Alur sekarang: merge PR rilis `release-please` (cuma bump
  CHANGELOG) → manusia jalanin `git tag vX.Y.Z <sha merge commit> && git
  push origin vX.Y.Z` manual → `release-android.yml` jalan dari situ.
- Dua bug teknis kekoreksi pas nulis workflow (lihat komentar di file):
  pattern glob `v*.*.*` doang ternyata JUGA match tag snapshot (perlu
  exclude eksplisit), dan `paths` filter gak reliable dikombinasi sama
  `tags` filter di trigger yang sama (makanya file dipisah, bukan nambah
  trigger di file lama).

**Fase 3 — SELESAI** (termasuk update susulan: fallback dicabut).
Branch cleanup: 9 branch lama yang udah merged dihapus (local + remote).
`feature/sprint-1-pembelajaran-terbang` (belum merge ke mana pun) sengaja
dibiarin, gak disentuh — kerjaan aktif punya user. `sync-develop.yml`
dihapus. `develop` branch **tetap ada** (masih dipake branch di atas),
cuma gak di-auto-sync lagi.

**Update susulan (2026-09-17, sore):** fallback path-filter di
`build-and-distribute-android.yml` **udah dicabut** — atas permintaan
eksplisit user buat total pindah ke flow tag, lebih cepat dari rencana
awal ("nunggu beberapa rilis lagi"). Trigger `push` (branch+paths)
dihapus total, tinggal `workflow_dispatch` doang — jadi file ini sekarang
murni **emergency escape hatch manual** (`gh workflow run
build-and-distribute-android.yml`), bukan jalur otomatis lagi. **Mulai
sekarang, satu-satunya jalur production adalah tag `vX.Y.Z` lewat
`release-android.yml`** — push ke `master` (termasuk yang nyentuh
`pubspec.yaml`/`android/**`/dll) TIDAK lagi auto-rilis.

**Fase 4 — SELESAI.** `FeatureFlagsService`
(`lib/core/feature_flags/feature_flags_service.dart`, wrap Firebase
Remote Config) — live di production (`1.4.0+26`, dirilis lewat fallback
lama karena nambah dependency baru = nyentuh `pubspec.yaml` = match
path-filter). Cara pakai didokumentasikan di `CLAUDE.md` ("Feature
Flags" section) biar sesi Claude Code berikutnya otomatis paham
konvensinya pas ngoding.

**Semua 4 fase selesai.** Plan ini closed — bukan berarti gak ada lagi
kerjaan CI/CD ke depan (mis. nanti nyabut fallback beneran), tapi
kerangka besarnya udah lengkap dan tervalidasi nyata (bukan simulasi).

## Alur Bikin Fitur Baru (referensi harian)

Ini yang dipakai tiap kali mau nambah fitur, dari nol sampai live di
Play Store:

1. **Ngoding.** Branch dari `master`:
   ```
   git checkout master && git pull
   git checkout -b feature/nama-fitur
   ```
   Ikutin Clean Architecture (`domain/data/presentation`) di
   `lib/features/<nama>/`. Fitur besar/beresiko yang mau tetap naik
   meski belum 100% yakin → bungkus pake `FeatureFlagsService`
   (`sl<FeatureFlagsService>().isEnabled('feature_xxx_enabled')`, lihat
   `CLAUDE.md`).

2. **PR ke `master`.**
   ```
   git push origin feature/nama-fitur
   gh pr create --base master
   ```
   Review, merge.

3. **(Opsional) Test dulu sebelum yakin rilis** — skip kalau fix
   kecil/udah yakin bener:
   ```
   git checkout master && git pull
   git tag vX.Y.Z-snapshot.N
   git push origin vX.Y.Z-snapshot.N
   ```
   Auto build APK → Firebase App Distribution (`ishari-testers`) →
   install, coba di device real. Nemu bug → ulang dari langkah 1-2, tag
   snapshot baru (`-snapshot.N+1`).

4. **Merge PR rilis.** Tiap commit baru ke `master`, `release-please`
   otomatis buka/update PR `chore(master): release X.X.X` (isinya
   CHANGELOG). Review, merge kalau emang mau rilis.

5. **Tag rilis manual — ini yang beneran nge-trigger Play Store**
   (sengaja manual, ruleset nolak kalau bot yang coba):
   ```
   git fetch origin master
   git tag vX.X.X <sha commit hasil merge PR rilis>
   git push origin vX.X.X
   ```
   `release-android.yml` jalan: build + upload Play Store production.
   Gak ada tombol mundur — mastiin CHANGELOG di PR rilis udah sesuai
   sebelum nge-tag.

6. **Ada masalah abis rilis?**
   - Bug Dart-only, gak ada dependency baru/native code/asset baru →
     `shorebird patch android --release-version X.X.X+build`
   - Fitur dibungkus feature flag → matiin langsung dari Firebase
     Console (Remote Config), gak perlu rilis apa-apa, langsung efek
   - Selain itu → hotfix dari langkah 1, rilis lagi

**Catatan (sudah gak berlaku sejak fallback dicabut):** dulu, dependency
baru di `pubspec.yaml` (kayak `firebase_remote_config` buat Fase 4) ikut
match path-filter fallback lama dan trigger rilis via jalur itu (bukan
tag). Sejak fallback dicabut, itu gak kejadian lagi — perubahan apa pun
di `pubspec.yaml`/`android/**`/dll cuma masuk `master` biasa lewat PR,
gak ada rilis otomatis. Rilis production sekarang murni lewat langkah
5 di atas (tag manual), gak peduli file apa yang berubah.

## Objective

Ganti pola "staging branch nampung banyak fitur campur" jadi tag-based
release, biar satu fitur bisa naik ke production sendirian tanpa nunggu
fitur lain yang belum siap.

## Kondisi Saat Ini

- `master` = trunk produksi. Push ke `master` (path-filtered:
  `android/**`, `ios/**`, `pubspec.yaml`, `assets/**`, `shorebird.yaml`)
  trigger `build-and-distribute-android.yml`.
- Workflow itu auto bump versi (`cider` + conventional commit parsing dari
  commit message terakhir) setiap kali jalan — **tidak ada git tag sama
  sekali** di repo ini sekarang (`git tag -l` kosong). Versi cuma hidup di
  `pubspec.yaml`.
- `sync-develop.yml` auto-merge `master` → `develop` tiap kali build sukses
  (`workflow_run` trigger).
- `develop` jadi tempat numpuk banyak feature branch
  (`feature/*`, `ambrusdevelop/*`, dst) sebelum PR ke `master`. Ini yang
  bikin masalah: kalau cuma 1 fitur siap naik, `develop` gak bisa langsung
  di-merge ke `master` karena fitur lain ikut kebawa.
- Hotfix Dart-only udah ada jalur sendiri: `shorebird-patch-android.yml`
  (manual `workflow_dispatch`, patch ke `--release-version` tertentu, gak
  lewat Play Store review). Ini sudah separuh jalan ke arah "tag rilis
  granular", tinggal disambungin ke git tag beneran.

## Strategi Baru

Trunk-based + tag, bukan staging branch:

1. **Feature branch tetep dari `master`** (bukan dari `develop`). Kecil,
   pendek umur, di-PR ke `master` begitu siap — **bukan digabung ke branch
   integrasi bersama**. Fitur yang belum selesai tapi mau numpang naik
   duluan, dibungkus feature flag (lihat bagian Feature Flags).
2. **Tag snapshot** `vX.Y.Z-snapshot.N` — dipush ke commit di `master` yang
   mau ditest. Trigger build staging (Firebase App Distribution ke grup
   tester), **bukan** ke Play Store.
3. **Tag release** `vX.Y.Z` (tanpa suffix) — dibuat dari commit snapshot
   yang lolos test. Trigger build production (Shorebird release + upload
   Play Store), gantiin trigger path-filter yang sekarang.
4. **Build number tambahan** kalau perlu iterasi kecil tanpa naikin semver:
   `vX.Y.Z+1`, `vX.Y.Z+2` (dipetakan ke build number `pubspec.yaml`, bukan
   bikin semver baru).
5. **`develop` branch dan `sync-develop.yml` dipensiunkan** setelah migrasi
   selesai — gak perlu lagi kalau `master` sendiri udah selalu deployable.

## Perubahan Konkret

### 1. Workflow baru: `build-staging-android.yml`

- Trigger: `push: tags: ['v*.*.*-snapshot*']`.
- Reuse langkah dari `build-and-distribute-android.yml` (setup env, keystore,
  google-services) tapi build lewat `flutter build apk` biasa (gak perlu
  masuk Shorebird release channel buat snapshot — snapshot gak butuh
  patchable release, cukup APK biasa).
- **Distribusi: Firebase App Distribution** (`wzieba/Firebase-Distribution-Github-Action@v1`,
  action + secret `FIREBASE_ANDROID_APP_ID`/`FIREBASE_TOKEN` yang sudah ada
  di `build-and-distribute-android.yml`, tinggal reuse). Grup tester tetep
  `ishari-testers` atau bikin grup baru khusus staging kalau mau pisahin
  dari build production lama.
- Versi diambil dari nama tag (`GITHUB_REF_NAME`) lewat
  `cider version <semver>+<build>` (set eksak, bukan `cider bump`), bukan
  auto-bump — snapshot gak boleh nulis balik ke `pubspec.yaml` di `master`.

### 2. Ubah trigger `build-and-distribute-android.yml`

- Trigger sekarang: `push: branches:[master], paths:[...]`.
- Ganti/tambah: `push: tags: ['v*.*.*']` (tanpa `-snapshot`) sebagai trigger
  utama produksi. Path-filter branch-push bisa dipertahankan sementara
  sebagai fallback selama masa transisi, lalu dicabut di Fase 3.
- Versi build production diambil dari tag (`vX.Y.Z` → `cider version
  X.Y.Z+<build>`), bukan dari `cider bump` + commit message parsing.
  `cider` masih dipakai — cuma ganti sub-command (`version` set eksak,
  bukan `bump` auto-detect dari commit message). Commit message parsing
  (`feat`/`fix`/`BREAKING CHANGE`) gak reliable buat nentuin bump type
  kalau 1 tag bisa mewakili banyak commit — diganti `release-please`
  (bagian 3) yang baca *semua* commit sejak tag terakhir, bukan cuma
  commit terakhir.
- Step "Distribute to Firebase App Distribution" di production workflow
  tetep dipertahankan seperti sekarang (dipakai buat testers build
  production juga, terpisah dari staging tag di atas).

### 3. Otomatisasi versi/tag — `release-please` (bukan skrip manual)

Skrip manual (`tag_snapshot.sh`/`tag_release.sh`, hitung bump type sendiri)
diganti pakai [`release-please`](https://github.com/googleapis/release-please)
(GitHub Action `googleapis/release-please-action`):
- Jalan tiap push ke `master`. Baca conventional commits sejak tag rilis
  terakhir, otomatis tentuin bump type (`feat`→minor, `fix`→patch,
  `BREAKING CHANGE`/`!`→major) — logic ini sama persis kayak yang sekarang
  ada di `build-and-distribute-android.yml` (`Detect Commit Message & Bump
  Version`), tinggal dipindah dari "jalan tiap push, auto-tag" ke
  "release-please buka/update PR rilis, generate CHANGELOG, baru pas PR
  itu di-merge → tag `vX.Y.Z` dibuat & dipush otomatis oleh action".
- Snapshot (`vX.Y.Z-snapshot.N`) tetep manual/on-demand — release-please
  scope-nya rilis resmi aja. Snapshot tag cukup 1 command pendek
  (`git tag vX.Y.Z-snapshot.$(date +%s) && git push --tags`) atau skrip
  kecil, gak perlu logic bump semver (snapshot gak naikin semver, cuma
  nempel di versi yang lagi disiapkan).
- Keuntungan vs skrip manual: gak ada human error nentuin major/minor/patch,
  CHANGELOG.md auto-generated (repo ini udah punya `CHANGELOG.md`, cocok),
  dan versi eksak (`cider version X.Y.Z+<build>`) tinggal dibaca dari tag
  yang release-please buat.

### 4. Tag protection — cegah tag `v*` dipush sembarangan

Tag rilis (`v*.*.*` tanpa suffix) trigger langsung Shorebird release +
upload Play Store — harus dilindungi kayak branch protection:
- Setup **GitHub Ruleset** (Settings → Rules → Rulesets, tag target)
  buat pattern `v[0-9]*.[0-9]*.[0-9]*` (release, bukan snapshot):
  restrict siapa yang boleh create tag (idealnya cuma
  `github-actions[bot]` via `release-please-action` di atas, bukan push
  manual dari laptop dev manapun).
- Snapshot tag (`*-snapshot*`) boleh lebih longgar (dev mana aja boleh
  tag buat testing), gak perlu proteksi seketat release tag.
- Tanpa ini, siapa pun dengan write access bisa `git push origin
  v9.9.9` dari laptop sendiri dan langsung nge-trigger rilis production
  tanpa review — sama riskan-nya kayak gak ada branch protection di
  `master`.

### 5. Feature Flags

- Fitur besar yang belum full-ready tapi kodenya udah mau nempel di
  `master` (biar gak numpuk di branch lama), bungkus flag on/off.
- ADR `0001-shorebird-ota-updates.md` udah nyebut Firebase Remote Config
  sebagai opsi "out of scope" — sekarang relevan: dipakai gabungan sama
  Shorebird patch buat kill-switch instan tanpa nunggu patch/release baru.
- Scope awal: flag sederhana (bool key di Remote Config + local
  `FeatureFlags` service di `lib/core/`), bukan full A/B testing platform.

## Fase Migrasi

1. **Fase 1 — Additive, gak ganggu flow lama**
   - Tambah `build-staging-android.yml` + tag convention.
   - Setup `release-please-action` di `master` (mode: buka PR rilis dulu,
     belum auto-tag — validasi CHANGELOG & bump type yang dihasilkan bener
     sebelum dipercaya full-auto).
   - Setup GitHub Ruleset buat tag pattern `v[0-9]*.[0-9]*.[0-9]*`
     (release protection) dari awal, sebelum ada workflow yang gantung ke
     tag — biar gak ada window kosong tanpa proteksi.
   - Belum ubah trigger `build-and-distribute-android.yml`.
   - Tim coba tagging snapshot buat 1-2 fitur manual, validasi flow-nya.
2. **Fase 2 — Pindah trigger production ke tag**
   - Ubah `build-and-distribute-android.yml` trigger ke tag `v*.*.*`.
   - Matiin auto `cider bump`, ganti `cider version` baca dari tag yang
     dibuat `release-please` (bukan lagi skrip manual/dari commit message
     terakhir).
   - Path-filter branch-push tetep hidup sebagai fallback 2-4 minggu.
3. **Fase 3 — Retire `develop`**
   - Feature branch baru wajib dari `master`.
   - Hapus/nonaktifkan `sync-develop.yml`.
   - Branch `develop` + feature branch lama di-merge/di-PR habis atau
     di-abandon sesuai kebutuhan masing-masing (bukan bagian workflow
     otomatis — cek manual per branch).
   - Cabut path-filter branch-push trigger dari langkah 2, tag jadi
     satu-satunya trigger produksi.
4. **Fase 4 — Feature flags**
   - Setup Remote Config key convention + `FeatureFlags` service.
   - Terapkan ke 1 fitur berikutnya yang perlu ship partial.

## Risiko

- **`release-please` butuh disiplin conventional commits** yang lebih
  ketat dari sekarang (logic lama cuma cek commit terakhir; release-please
  cek semua commit sejak tag terakhir, jadi commit yang salah format ikut
  mempengaruhi bump type/CHANGELOG). Mitigasi: commitlint/commit template,
  atau tim review PR rilis yang dibikin release-please sebelum merge.
- **Tag ruleset butuh setup manual sekali** di GitHub (Settings → Rules) —
  bukan sesuatu yang bisa di-commit sebagai kode, gampang kelewat kalau
  yang setup lupa. Catat di sini biar gak kelewat pas eksekusi Fase 1.
- **`develop` branch retirement** bisa timpa kerjaan yang nyangkut di
  branch lama (`feature/sprint-1-pembelajaran-terbang`,
  `feature/ama-64-*`, dst) — perlu audit manual dulu, jangan dihapus
  paksa.
- **Dua workflow production-trigger aktif bersamaan** (branch-push +
  tag-push) selama Fase 2-3 bisa double-build kalau gak hati-hati
  urutan tag vs merge. Mitigasi: tag hanya dibuat setelah merge ke
  `master` selesai, bukan bareng.
- Snapshot build ke Firebase harus jelas dipisah App Distribution *group*
  dari production track — App Distribution setup existing (dipakai release
  workflow) perlu dicek grup testernya cukup buat staging juga atau perlu
  grup baru.

## Out of Scope

- Multi-staging environment (staging 1, staging 2) — belum perlu, tim
  masih kecil & fitur paralel dikit. Revisit kalau paralelisme fitur naik.
- iOS pipeline — belum ada CI iOS di repo ini (dicatat juga di ADR 0001).
