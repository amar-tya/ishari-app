# Spec: Notify on chapter_media upload

## Objective
Upload `chapter_media` (full-chapter recording) wajib trigger push notif sama kayak `verse_media` upload sekarang. User pegang app (guest/auth, subscribe topic `new_audio` on launch) dapet notif "Audio Baru" pas hadi upload full-muhud recording baru, sama seperti pas upload per-verse audio. Tap notif navigate ke `/chapter/:chapterId` (tanpa verseId, karena chapter_media ga terikat 1 verse).

Konsumer: admin/CMS insert row langsung ke `chapter_media` (lewat Dashboard atau tool lain di luar repo Flutter ini) — bukan lewat app. App cuma consumer notif.

## Tech Stack
- Supabase Postgres trigger (`supabase_functions.http_request`, pg_net-backed) — no new extension
- Deno Edge Function (existing `notify-new-audio`)
- FCM HTTP v1 API, topic-based send (topic `new_audio`, sama kayak verse_media — no new topic/channel)
- Client: `lib/features/push_notification/data/services/fcm_service.dart` — **no changes needed**, already navigates with `chapterId` + optional `verseId`

## Commands
```bash
# deploy edge function after editing index.ts
supabase functions deploy notify-new-audio

# local test
supabase start
supabase secrets set --env-file supabase/.env.local FCM_SERVICE_ACCOUNT='...' NOTIFY_WEBHOOK_SECRET='...'
curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/notify-new-audio' \
  --header 'Authorization: Bearer <NOTIFY_WEBHOOK_SECRET>' \
  --header 'Content-Type: application/json' \
  --data '{"type":"INSERT","table":"chapter_media","record":{"id":1},"schema":"public","old_record":null}'
```

## Project Structure
```
supabase/functions/notify-new-audio/index.ts        → extend: handle table === "chapter_media" (in addition to verse_media)
supabase/migrations/<timestamp>_create_notify_new_chapter_media_webhook.sql
                                                      → new trigger, AFTER INSERT on chapter_media, same function URL
```
No `lib/` changes — client-side payload shape (`chapterId`, `verseId` optional, `type`) already handles `verseId` absent.

## Code Style
Extend `resolveChapter` (or add sibling resolver) matching existing pattern — re-query DB with service role instead of trusting webhook record fields, same as verse_media does now:

```ts
if (payload.table !== "verse_media" && payload.table !== "chapter_media") {
  return Response.json({ skipped: true });
}
if (payload.type !== "INSERT") {
  return Response.json({ skipped: true });
}

const chapter = payload.table === "verse_media"
  ? await resolveChapterFromVerseMedia(recordId)
  : await resolveChapterFromChapterMedia(recordId);
```

`resolveChapterFromChapterMedia` queries `chapter_media` joined to `chapters` + `hadi`, returns `ChapterInfo` dengan `verseId: null` (ubah field jadi optional). `sendFcmTopicMessage` — body text sama persis ("Audio baru dari '{hadi}' di '{chapter}'"), `data.verseId` cuma di-include kalau non-null biar client ga terima string `"null"`.

Single quotes, no doc comments beyond existing `///` non-obvious-reasoning style already in file.

## Testing Strategy
No automated test suite ada di `supabase/functions/` sekarang (verse_media path juga ga ada). Verifikasi manual:
- `supabase functions serve notify-new-audio` + curl payload `chapter_media` INSERT (contoh command di atas) → cek response `{sent:true, chapterId:...}` dan FCM call ga error
- `flutter analyze` — no Dart touched, tapi run buat mastiin ga ada regression accidental
- Manual: insert row test ke `chapter_media` di local Supabase → confirm FCM console/log terima kirim → app (foreground + background) terima notif → tap navigate ke `/chapter/:id` bener

## Boundaries
- **Always:** re-query DB by id (jangan trust webhook payload record fields selain `id`), pertahanin service-role client pattern, jangan expose `NOTIFY_WEBHOOK_SECRET`
- **Ask first:** ganti topic FCM / bikin channel notif baru, ubah copy notif jadi beda dari verse_media, nambah field baru ke FCM `data` payload yang butuh app update buat dibaca
- **Never:** commit real `NOTIFY_WEBHOOK_SECRET` atau service account JSON, jalanin `supabase db push` buat trigger baru (project ini history mismatch — apply manual via Dashboard SQL Editor, sama kayak trigger verse_media, dan migration file cuma jadi reference record)

## Success Criteria
- Insert row baru ke `chapter_media` (production) → subscriber topic `new_audio` terima push "Audio Baru" / "Audio baru dari '{hadi}' di '{chapter}'" dalam <5 detik (existing FCM latency)
- Tap notif (foreground/background/terminated) → app buka `/chapter/:chapterId`
- Insert ke `verse_media` tetep jalan sama persis kayak sebelumnya (no regression) — verseId masih muncul di data payload & deep link `/chapter/:id?verseId=:id`
- Insert ke table lain (bukan verse_media/chapter_media) tetep `{skipped:true}`, ga misfire

## Open Questions
None — resolved via user confirmation:
1. Extend existing `notify-new-audio` function (not a separate function) — same FCM topic `new_audio`, no client changes.
2. Notification copy identical to verse_media's ("Audio Baru" / "Audio baru dari '{hadi}' di '{chapter}'") — no visual distinction between verse vs full-chapter recording notifs.
