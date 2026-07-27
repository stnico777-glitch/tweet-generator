-- Harden subscribers: no anon SELECT/UPDATE; check-in via SECURITY DEFINER RPC

drop policy if exists "Anyone can subscribe" on public.subscribers;
drop policy if exists "Anyone can update subscriber by email" on public.subscribers;
drop policy if exists "Users can read own subscriber row" on public.subscribers;
drop policy if exists "subscribers_insert_anon" on public.subscribers;
drop policy if exists "subscribers_select_anon" on public.subscribers;
drop policy if exists "subscribers_update_anon" on public.subscribers;

do $$
declare r record;
begin
  for r in select policyname from pg_policies where schemaname='public' and tablename='subscribers' loop
    execute format('drop policy if exists %I on public.subscribers', r.policyname);
  end loop;
end $$;

alter table public.subscribers enable row level security;

create policy "read_own_subscriber"
  on public.subscribers for select to authenticated
  using (lower(email) = lower(coalesce(auth.jwt()->>'email','')));

create or replace function public.check_in_subscriber(p_email text, p_name text default null, p_source text default 'slide-generator')
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_email is null or length(trim(p_email)) < 3 or position('@' in p_email) = 0 then
    raise exception 'invalid email';
  end if;
  insert into public.subscribers (email, name, source, last_seen_at)
  values (lower(trim(p_email)), nullif(trim(coalesce(p_name,'')), ''), coalesce(p_source,'slide-generator'), now())
  on conflict (email) do update set
    name = coalesce(excluded.name, public.subscribers.name),
    last_seen_at = now(),
    source = coalesce(excluded.source, public.subscribers.source);
end;
$$;

revoke all on function public.check_in_subscriber(text, text, text) from public;
grant execute on function public.check_in_subscriber(text, text, text) to anon, authenticated;

revoke all on table public.subscribers from anon;
revoke insert, update, delete on table public.subscribers from authenticated;
grant select on table public.subscribers to authenticated;
