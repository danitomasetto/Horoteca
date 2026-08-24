-- Harden cross-table ownership and complete foreign-key indexing.

create index if not exists maintenance_logs_user_id_idx
  on public.maintenance_logs (user_id);
create index if not exists watch_events_expense_id_idx
  on public.watch_events (expense_id);
create index if not exists watch_photos_watch_id_idx
  on public.watch_photos (watch_id);

-- Remove the older duplicate set. The owner_* policies also validate user_id.
drop policy if exists owners_select_maintenance_logs on public.maintenance_logs;
drop policy if exists owners_insert_maintenance_logs on public.maintenance_logs;
drop policy if exists owners_update_maintenance_logs on public.maintenance_logs;
drop policy if exists owners_delete_maintenance_logs on public.maintenance_logs;

-- Photos may belong to an individual watch or to the acquisition/lot.
drop policy if exists owner_insert_watch_photos on public.watch_photos;
create policy owner_insert_watch_photos on public.watch_photos
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and (
    (watch_id is not null and exists (
      select 1 from public.watches watch
      where watch.id = watch_id and watch.user_id = (select auth.uid())
    ))
    or (acquisition_id is not null and exists (
      select 1 from public.acquisitions acquisition
      where acquisition.id = acquisition_id
        and acquisition.user_id = (select auth.uid())
    ))
  )
);

drop policy if exists owner_update_watch_photos on public.watch_photos;
create policy owner_update_watch_photos on public.watch_photos
for update to authenticated
using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and (
    (watch_id is not null and exists (
      select 1 from public.watches watch
      where watch.id = watch_id and watch.user_id = (select auth.uid())
    ))
    or (acquisition_id is not null and exists (
      select 1 from public.acquisitions acquisition
      where acquisition.id = acquisition_id
        and acquisition.user_id = (select auth.uid())
    ))
  )
);

drop policy if exists owner_insert on public.acquisition_items;
create policy owner_insert on public.acquisition_items
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid()))
  and exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid()))
);
drop policy if exists owner_update on public.acquisition_items;
create policy owner_update on public.acquisition_items
for update to authenticated using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid()))
  and exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid()))
);

drop policy if exists owner_insert on public.expenses;
create policy owner_insert on public.expenses
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and (watch_id is null or exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid())))
  and (acquisition_id is null or exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid())))
);
drop policy if exists owner_update on public.expenses;
create policy owner_update on public.expenses
for update to authenticated using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and (watch_id is null or exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid())))
  and (acquisition_id is null or exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid())))
);

drop policy if exists owner_insert on public.expense_allocations;
create policy owner_insert on public.expense_allocations
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and exists (select 1 from public.expenses expense
    where expense.id = expense_id and expense.user_id = (select auth.uid()))
  and exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid()))
);
drop policy if exists owner_update on public.expense_allocations;
create policy owner_update on public.expense_allocations
for update to authenticated using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and exists (select 1 from public.expenses expense
    where expense.id = expense_id and expense.user_id = (select auth.uid()))
  and exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid()))
);

drop policy if exists owner_insert on public.watch_events;
create policy owner_insert on public.watch_events
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and (watch_id is null or exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid())))
  and (acquisition_id is null or exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid())))
  and (expense_id is null or exists (select 1 from public.expenses expense
    where expense.id = expense_id and expense.user_id = (select auth.uid())))
);
drop policy if exists owner_update on public.watch_events;
create policy owner_update on public.watch_events
for update to authenticated using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and (watch_id is null or exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid())))
  and (acquisition_id is null or exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid())))
  and (expense_id is null or exists (select 1 from public.expenses expense
    where expense.id = expense_id and expense.user_id = (select auth.uid())))
);

drop policy if exists owner_insert on public.watch_sources;
create policy owner_insert on public.watch_sources
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and (watch_id is null or exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid())))
  and (acquisition_id is null or exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid())))
);
drop policy if exists owner_update on public.watch_sources;
create policy owner_update on public.watch_sources
for update to authenticated using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and (watch_id is null or exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid())))
  and (acquisition_id is null or exists (select 1 from public.acquisitions acquisition
    where acquisition.id = acquisition_id
      and acquisition.user_id = (select auth.uid())))
);

drop policy if exists owner_insert on public.watch_photo_links;
create policy owner_insert on public.watch_photo_links
for insert to authenticated with check (
  (select auth.uid()) = user_id
  and exists (select 1 from public.watch_photos photo
    where photo.id = photo_id and photo.user_id = (select auth.uid()))
  and exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid()))
);
drop policy if exists owner_update on public.watch_photo_links;
create policy owner_update on public.watch_photo_links
for update to authenticated using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and exists (select 1 from public.watch_photos photo
    where photo.id = photo_id and photo.user_id = (select auth.uid()))
  and exists (select 1 from public.watches watch
    where watch.id = watch_id and watch.user_id = (select auth.uid()))
);
