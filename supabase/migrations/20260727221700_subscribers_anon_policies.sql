-- Allow anon/authenticated check-in upserts on subscribers
drop policy if exists "Anyone can subscribe" on public.subscribers;
drop policy if exists "Anyone can update subscriber by email" on public.subscribers;
drop policy if exists "Users can read own subscriber row" on public.subscribers;
drop policy if exists "subscribers_insert_anon" on public.subscribers;
drop policy if exists "subscribers_update_anon" on public.subscribers;
drop policy if exists "subscribers_select_anon" on public.subscribers;

create policy "subscribers_insert_anon"
  on public.subscribers
  for insert
  to anon, authenticated
  with check (true);

create policy "subscribers_update_anon"
  on public.subscribers
  for update
  to anon, authenticated
  using (true)
  with check (true);

create policy "subscribers_select_anon"
  on public.subscribers
  for select
  to anon, authenticated
  using (true);

grant select, insert, update on public.subscribers to anon, authenticated;
