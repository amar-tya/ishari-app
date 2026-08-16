-- Database Webhook (AMA-62): fires the notify-new-audio Edge Function on every
-- INSERT into verse_media. Equivalent to what Dashboard > Database > Webhooks
-- generates automatically.
--
-- NOT applied via `supabase db push` — this project's remote migration
-- history predates local CLI-managed migrations (21 versions applied via
-- Dashboard, never captured as local files), so push rejects with a history
-- mismatch. Applied manually once via Dashboard > SQL Editor instead. This
-- file is kept as a reference/reproducibility record, not a pending migration.
--
-- supabase_functions.http_request is bundled in every Supabase project
-- (backed by pg_net) — no extension setup needed.
-- Replace __NOTIFY_WEBHOOK_SECRET__ with the value of the NOTIFY_WEBHOOK_SECRET
-- secret (see supabase/functions/notify-new-audio) before running this SQL
-- anywhere. Never commit the real value — this file is version-controlled.
create trigger "notify_new_audio_on_insert"
after insert on "public"."verse_media"
for each row
execute function "supabase_functions"."http_request"(
  'https://dloeobybslgiiwsitvoa.supabase.co/functions/v1/notify-new-audio',
  'POST',
  '{"Content-type":"application/json","Authorization":"Bearer __NOTIFY_WEBHOOK_SECRET__"}',
  '{}',
  '5000'
);
