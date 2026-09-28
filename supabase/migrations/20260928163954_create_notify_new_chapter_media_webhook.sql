-- Database trigger + SECURITY DEFINER function: fires the notify-new-audio
-- Edge Function on every INSERT into chapter_media (full-chapter recordings).
--
-- Mirrors the live verse_media wiring — notify.notify_new_audio() (see
-- notify.notify_new_chapter_audio() below) — NOT the older direct
-- `supabase_functions.http_request(...)` trigger shape documented in
-- 20260816173710_create_notify_new_audio_webhook.sql. That file predates a
-- refactor to a `notify` schema SECURITY DEFINER function wrapping
-- `net.http_post` and no longer reflects the live trigger body — discovered
-- by diffing pg_get_triggerdef()/pg_get_functiondef() against production
-- while building this migration. This file documents the current reality.
--
-- No WHEN clause (unlike verse_media's `WHEN (media_type = 'audio')`) —
-- chapter_media has no media_type/type column, every row is an audio
-- recording, so every INSERT should notify.
--
-- Applied directly to production via Supabase MCP (apply_migration), not
-- `supabase db push` — this project's remote migration history predates
-- local CLI-managed migrations, so push rejects with a history mismatch.
-- This file is a reference/reproducibility record.
--
-- Replace __NOTIFY_WEBHOOK_SECRET__ with the value of the NOTIFY_WEBHOOK_SECRET
-- secret (see supabase/functions/notify-new-audio) before running this SQL
-- anywhere. Never commit the real value — this file is version-controlled.

create or replace function "notify"."notify_new_chapter_audio"()
returns trigger
language plpgsql
security definer
set search_path to ''
as $function$
declare
  request_id bigint;
begin
  select net.http_post(
    url := 'https://dloeobybslgiiwsitvoa.supabase.co/functions/v1/notify-new-audio',
    body := jsonb_build_object(
      'type', 'INSERT',
      'table', 'chapter_media',
      'schema', 'public',
      'record', to_jsonb(NEW),
      'old_record', null
    ),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer __NOTIFY_WEBHOOK_SECRET__'
    ),
    timeout_milliseconds := 5000
  ) into request_id;
  return NEW;
end;
$function$;

create trigger "notify_new_chapter_audio_on_insert"
after insert on "public"."chapter_media"
for each row
execute function "notify"."notify_new_chapter_audio"();
