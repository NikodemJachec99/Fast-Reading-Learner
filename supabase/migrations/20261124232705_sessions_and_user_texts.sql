-- Sessions and own texts, one row per user, protected by RLS.
-- Users sign in anonymously on first launch (see docs/adr/0001).

create table public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  exercise text not null,
  level smallint not null default 1 check (level between 1 and 3),
  text_id text not null,
  text_title text not null,
  started_at timestamptz not null default now(),
  reading_ms integer check (reading_ms >= 0),
  word_count integer check (word_count >= 0),
  wpm integer check (wpm >= 0),
  exercise_score real check (exercise_score between 0 and 1),
  questions_correct smallint check (questions_correct >= 0),
  questions_total smallint check (questions_total >= 0),
  passed boolean generated always as (
    questions_total > 0 and questions_correct * 3 >= questions_total * 2
  ) stored,
  completed boolean not null default true,
  self_rating jsonb
);

create index sessions_user_started_idx on public.sessions (user_id, started_at desc);

create table public.user_texts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  title text not null,
  body text not null,
  word_count integer not null check (word_count >= 0),
  times_read integer not null default 0 check (times_read >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index user_texts_user_idx on public.user_texts (user_id, created_at desc);

alter table public.sessions enable row level security;
alter table public.user_texts enable row level security;

create policy "Users read their own sessions" on public.sessions
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users add their own sessions" on public.sessions
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users delete their own sessions" on public.sessions
  for delete to authenticated using ((select auth.uid()) = user_id);

create policy "Users read their own texts" on public.user_texts
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users add their own texts" on public.user_texts
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users update their own texts" on public.user_texts
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "Users delete their own texts" on public.user_texts
  for delete to authenticated using ((select auth.uid()) = user_id);
