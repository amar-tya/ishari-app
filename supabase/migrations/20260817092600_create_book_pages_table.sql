-- book_pages (AMA-65): pre-rendered per-halaman page images for Kitab
-- books, ordered by page_number within a chapter. Additive only —
-- chapters.book_id already existed and needed no change (spec correction,
-- see the Linear doc linked on AMA-64).
create table "public"."book_pages" (
  "id" serial primary key,
  "book_id" integer not null references "public"."books"("id"),
  "chapter_id" integer references "public"."chapters"("id"),
  "page_number" integer not null,
  "image_url" text not null,
  "created_at" timestamptz not null default now()
);

create index "book_pages_book_id_idx" on "public"."book_pages" ("book_id");
create index "book_pages_chapter_id_idx" on "public"."book_pages" ("chapter_id");
create unique index "book_pages_chapter_page_number_key"
  on "public"."book_pages" ("chapter_id", "page_number")
  where "chapter_id" is not null;

alter table "public"."book_pages" enable row level security;

-- Same shape as books/chapters/verses: full access for authenticated users,
-- read-only for anon (guest mode).
create policy "book_pages_all_auth_policy" on "public"."book_pages"
  for all to authenticated using (true);

create policy "book_pages_select_anon_policy" on "public"."book_pages"
  for select to anon using (true);
