-- chapter_media: full-muhud (chapter) song recording, one file per
-- chapter/hadi/rodad_cabang combo. Distinct from verse_media, which stores
-- per-verse audio segments.
create table "public"."chapter_media" (
  "id" serial primary key,
  "chapter_id" integer not null references "public"."chapters"("id"),
  "hadi_id" integer references "public"."hadi"("id"),
  "media_url" text not null,
  "file_size" integer,
  "duration" integer,
  "description" text,
  "rodad_cabang" character varying,
  "deleted_at" timestamptz,
  "created_at" timestamptz not null default now(),
  "updated_at" timestamptz not null default now()
);

create index "chapter_media_chapter_id_idx" on "public"."chapter_media" ("chapter_id");
create index "chapter_media_hadi_id_idx" on "public"."chapter_media" ("hadi_id");

alter table "public"."chapter_media" enable row level security;

-- Same shape as verse_media/book_pages: full access for authenticated users,
-- read-only for anon (guest mode).
create policy "chapter_media_all_auth_policy" on "public"."chapter_media"
  for all to authenticated using (true);

create policy "chapter_media_select_anon_policy" on "public"."chapter_media"
  for select to anon using (true);
