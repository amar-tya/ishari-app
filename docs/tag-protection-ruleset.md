# Tag Protection Ruleset — Runbook

Ref: `plans/tag-based-deploy-strategy.md` (Fase 1, komponen 4) dan
`tasks/tag-deploy-phase1/spec.md`.

**Status: SUDAH DITERAPKAN** (2026-09-17, via Opsi A/GitHub UI). Ruleset
`protect-release-tags` aktif — id `23592184`, target `tag`, include
`refs/tags/v*` exclude `refs/tags/*-snapshot*`, rules: creation, update,
deletion. Verifikasi: `gh api repos/amar-tya/ishari-app/rulesets`.

## Kenapa perlu

Tag rilis (`vX.Y.Z` tanpa suffix `-snapshot`) rencananya bakal jadi
trigger langsung production build (Shorebird release + upload Play
Store) di Fase 2. Tanpa proteksi, siapa pun dengan write access ke repo
bisa `git push origin v9.9.9` dari laptop sendiri dan langsung nge-trigger
rilis production tanpa review — sama riskan-nya kayak gak ada branch
protection di `master`.

Tag snapshot (`*-snapshot*`) **sengaja gak diproteksi** — dev mana aja
boleh tag bebas buat testing (lihat `build-staging-android.yml`).

## Opsi A — GitHub UI (paling reliable, rekomendasi)

1. Buka `https://github.com/amar-tya/ishari-app/settings/rules`
2. **New ruleset** → **New tag ruleset**
3. **Ruleset name:** `protect-release-tags`
4. **Enforcement status:** Active
5. **Target tags** → **Add target** → pilih **Include by pattern**:
   - Include: `v*`
   - Exclude: `*-snapshot*`
   (Hasilnya: match `v1.2.10`, TIDAK match `v1.2.10-snapshot.1`)
6. **Rules** → centang **Restrict creations** (dan opsional **Restrict
   deletions**/**Restrict updates** kalau mau tag rilis gak bisa
   dihapus/dipindah sama sekali setelah dibuat — direkomendasikan, tag
   rilis harusnya immutable).
7. **Bypass list** → tambahin identitas yang boleh tetap bikin tag rilis
   (mis. repo admin, atau service account/bot kalau nanti tag release
   dibuat otomatis lewat Actions).
8. Save.

## Opsi B — `gh api` (buat automasi/reproducibility nanti)

GitHub CLI (`gh`) **gak punya subcommand `ruleset` native** — rulesets
diakses lewat REST API langsung via `gh api`. Contoh payload (cek ulang
field-nya terhadap
[dokumentasi resmi](https://docs.github.com/en/rest/repos/rules) sebelum
dipakai — schema ruleset API ini pernah berubah):

```bash
cat <<'EOF' > /tmp/ruleset.json
{
  "name": "protect-release-tags",
  "target": "tag",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/tags/v*"],
      "exclude": ["refs/tags/*-snapshot*"]
    }
  },
  "rules": [
    { "type": "creation" },
    { "type": "update" },
    { "type": "deletion" }
  ],
  "bypass_actors": []
}
EOF

gh api repos/amar-tya/ishari-app/rulesets \
  --method POST \
  --input /tmp/ruleset.json
```

`bypass_actors` kosong di contoh ini — isi manual sesuai
`actor_id`/`actor_type` yang mau di-bypass (lihat response `GET
/repos/{owner}/{repo}/rulesets` buat cari format yang GitHub expect,
lebih gampang setup lewat Opsi A dulu terus `gh api
repos/amar-tya/ishari-app/rulesets` buat lihat JSON hasilnya kalau mau
direplikasi/dicek ke repo lain).

## Verifikasi setelah diterapkan

- Coba `git push origin v0.0.1-test` dari akun **bukan** bypass list —
  harus ditolak GitHub dengan pesan ruleset violation.
- Coba `git push origin v0.0.1-test-snapshot.1` — harus **berhasil**
  (pattern exclude kerja, snapshot tetep bebas).
- Hapus tag test (`git push origin :v0.0.1-test-snapshot.1` dari lokal,
  dan lewat GitHub UI kalau ada tag `v0.0.1-test` yang somehow kebuat).
