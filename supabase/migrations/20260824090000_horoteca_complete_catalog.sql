-- Complete structured catalog for Horoteca.
-- Project: nlkhbhgzscpdistzuyod
-- Existing user, storage objects and legacy tables are preserved.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

revoke all on function public.set_updated_at() from public, anon, authenticated;

-- The collection rules allow unknown brand/model values.
alter table public.watches alter column brand drop not null;
alter table public.watches alter column model drop not null;

alter table public.watches
  add column if not exists brand_id bigint references public.brands(id) on delete set null,
  add column if not exists watch_model_id bigint,
  add column if not exists movement_caliber_id bigint,
  add column if not exists serial_number text,
  add column if not exists case_code text,
  add column if not exists dial_code text,
  add column if not exists movement_description text,
  add column if not exists jewels smallint,
  add column if not exists complications text[],
  add column if not exists manufacture_country text,
  add column if not exists manufacture_year_is_estimated boolean,
  add column if not exists production_period_start_year smallint,
  add column if not exists production_period_end_year smallint,
  add column if not exists diameter_mm numeric(6,2),
  add column if not exists case_thickness_mm numeric(6,2),
  add column if not exists lug_to_lug_mm numeric(6,2),
  add column if not exists lug_width_mm numeric(6,2),
  add column if not exists case_finish text,
  add column if not exists case_color text,
  add column if not exists case_shape text,
  add column if not exists dial_description text,
  add column if not exists dial_inscriptions text,
  add column if not exists indices_description text,
  add column if not exists hands_description text,
  add column if not exists crystal_material text,
  add column if not exists crystal_condition text,
  add column if not exists crown_description text,
  add column if not exists caseback_description text,
  add column if not exists caseback_inscriptions text,
  add column if not exists strap_description text,
  add column if not exists clasp_type text,
  add column if not exists strap_originality text,
  add column if not exists dial_originality text,
  add column if not exists component_originality text,
  add column if not exists function_status text,
  add column if not exists accuracy_seconds_per_day numeric(8,2),
  add column if not exists accuracy_notes text,
  add column if not exists known_defects text,
  add column if not exists water_resistance text,
  add column if not exists source_document_url text,
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now();

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'watches_jewels_check') then
    alter table public.watches add constraint watches_jewels_check
      check (jewels is null or jewels between 0 and 200);
  end if;
  if not exists (select 1 from pg_constraint where conname = 'watches_year_period_check') then
    alter table public.watches add constraint watches_year_period_check check (
      production_period_start_year is null or production_period_end_year is null
      or production_period_start_year <= production_period_end_year
    );
  end if;
  if not exists (select 1 from pg_constraint where conname = 'watches_dimensions_check') then
    alter table public.watches add constraint watches_dimensions_check check (
      (diameter_mm is null or diameter_mm > 0) and
      (case_thickness_mm is null or case_thickness_mm > 0) and
      (lug_to_lug_mm is null or lug_to_lug_mm > 0) and
      (lug_width_mm is null or lug_width_mm > 0)
    );
  end if;
end $$;

-- Convert legacy text dates while accepting the two formats previously used.
alter table public.watches
  alter column purchase_date type date using (
    case
      when purchase_date is null or btrim(purchase_date) = '' then null
      when purchase_date ~ '^\d{4}-\d{2}-\d{2}$' then purchase_date::date
      when purchase_date ~ '^\d{2}/\d{2}/\d{4}$'
        then to_date(purchase_date, 'DD/MM/YYYY')
      else null
    end
  );

alter table public.maintenance_logs
  alter column service_date drop not null,
  alter column service_date type date using (
    case
      when service_date is null or btrim(service_date) = '' then null
      when service_date ~ '^\d{4}-\d{2}-\d{2}$' then service_date::date
      when service_date ~ '^\d{2}/\d{2}/\d{4}$'
        then to_date(service_date, 'DD/MM/YYYY')
      else null
    end
  ),
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now();

update public.maintenance_logs
set event_date = service_date
where event_date is null and service_date is not null;

create table if not exists public.watch_models (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  brand_id bigint references public.brands(id) on delete set null,
  model_name text not null,
  line_name text,
  reference_family text,
  launch_year smallint,
  production_start_year smallint,
  production_end_year smallint,
  designer text,
  creation_context text,
  history text,
  notable_features text,
  historical_importance text,
  history_sources jsonb,
  reviewed_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint watch_models_years_check check (
    production_start_year is null or production_end_year is null
    or production_start_year <= production_end_year
  )
);

create table if not exists public.movement_calibers (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  manufacturer text,
  caliber_code text not null,
  movement_type text,
  jewels smallint,
  complications text[],
  production_start_year smallint,
  production_end_year smallint,
  technical_description text,
  history text,
  historical_importance text,
  history_sources jsonb,
  reviewed_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint movement_calibers_jewels_check check (jewels is null or jewels between 0 and 200),
  constraint movement_calibers_years_check check (
    production_start_year is null or production_end_year is null
    or production_start_year <= production_end_year
  )
);

alter table public.watches
  add constraint watches_watch_model_id_fkey
    foreign key (watch_model_id) references public.watch_models(id) on delete set null,
  add constraint watches_movement_caliber_id_fkey
    foreign key (movement_caliber_id) references public.movement_calibers(id) on delete set null;

create table if not exists public.acquisitions (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  marketplace text,
  seller_name text,
  order_number text,
  purchase_date date,
  purchase_payment_date date,
  taxes_payment_date date,
  shipped_date date,
  received_date date,
  payment_method text,
  carrier text,
  tracking_number text,
  source_document_url text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.acquisition_items (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  acquisition_id bigint not null references public.acquisitions(id) on delete cascade,
  watch_id bigint not null references public.watches(id) on delete cascade,
  item_sequence integer not null,
  marketplace_item_id text,
  visual_position text,
  individual_price_original numeric(14,2),
  currency text,
  individual_price_brl numeric(14,2),
  allocation_basis text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint acquisition_items_sequence_check check (item_sequence > 0),
  constraint acquisition_items_acquisition_sequence_key unique (acquisition_id, item_sequence),
  constraint acquisition_items_watch_key unique (watch_id)
);

create table if not exists public.expenses (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  acquisition_id bigint references public.acquisitions(id) on delete cascade,
  watch_id bigint references public.watches(id) on delete cascade,
  category text not null,
  description text,
  expense_date date,
  currency text not null,
  amount_original numeric(14,2) not null,
  exchange_rate numeric(18,6),
  amount_brl numeric(14,2),
  is_shared boolean not null default false,
  allocation_method text,
  source_reference text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint expenses_owner_check check (acquisition_id is not null or watch_id is not null),
  constraint expenses_category_check check (category in (
    'product', 'freight', 'tax', 'fee', 'carrier', 'maintenance',
    'parts', 'strap', 'other'
  )),
  constraint expenses_amounts_check check (
    amount_original >= 0 and (amount_brl is null or amount_brl >= 0)
    and (exchange_rate is null or exchange_rate > 0)
  )
);

create table if not exists public.expense_allocations (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  expense_id bigint not null references public.expenses(id) on delete cascade,
  watch_id bigint not null references public.watches(id) on delete cascade,
  amount_original_allocated numeric(14,2),
  amount_brl_allocated numeric(14,2) not null,
  rounding_adjustment_brl numeric(14,2) not null default 0,
  allocation_basis text,
  created_at timestamptz not null default now(),
  constraint expense_allocations_amounts_check check (
    (amount_original_allocated is null or amount_original_allocated >= 0)
    and amount_brl_allocated >= 0
  ),
  constraint expense_allocations_expense_watch_key unique (expense_id, watch_id)
);

create table if not exists public.watch_events (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  watch_id bigint references public.watches(id) on delete cascade,
  acquisition_id bigint references public.acquisitions(id) on delete cascade,
  event_type text not null,
  event_date date not null,
  description text not null,
  provider text,
  expense_id bigint references public.expenses(id) on delete set null,
  parts_replaced text,
  function_before text,
  function_after text,
  next_service_due date,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint watch_events_owner_check check (watch_id is not null or acquisition_id is not null),
  constraint watch_events_type_check check (event_type in (
    'purchase', 'payment', 'shipment', 'customs', 'receipt', 'inspection',
    'maintenance', 'parts_replacement', 'valuation', 'sale', 'retirement', 'other'
  ))
);

create table if not exists public.watch_sources (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  watch_id bigint references public.watches(id) on delete cascade,
  acquisition_id bigint references public.acquisitions(id) on delete cascade,
  source_type text not null,
  source_name text,
  source_url text,
  evidence_classification text not null,
  confidence_percent smallint,
  excerpt text,
  notes text,
  accessed_at date,
  created_at timestamptz not null default now(),
  constraint watch_sources_owner_check check (watch_id is not null or acquisition_id is not null),
  constraint watch_sources_classification_check check (evidence_classification in (
    'document_confirmed', 'seller_statement', 'visual_observation',
    'researched', 'estimated', 'missing', 'inconsistent'
  )),
  constraint watch_sources_confidence_check check (
    confidence_percent is null or confidence_percent between 0 and 100
  )
);

alter table public.watch_photos
  alter column watch_id drop not null,
  add column if not exists acquisition_id bigint references public.acquisitions(id) on delete cascade,
  add column if not exists photo_type text,
  add column if not exists source_type text,
  add column if not exists source_url text,
  add column if not exists evidence_classification text,
  add column if not exists notes text,
  add column if not exists updated_at timestamptz not null default now();

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'watch_photos_owner_check') then
    alter table public.watch_photos add constraint watch_photos_owner_check
      check (watch_id is not null or acquisition_id is not null);
  end if;
  if not exists (select 1 from pg_constraint where conname = 'watch_photos_classification_check') then
    alter table public.watch_photos add constraint watch_photos_classification_check
      check (evidence_classification is null or evidence_classification in (
        'document_confirmed', 'seller_statement', 'visual_observation',
        'researched', 'estimated', 'missing', 'inconsistent'
      ));
  end if;
end $$;

create table if not exists public.watch_photo_links (
  id bigint generated by default as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  photo_id bigint not null references public.watch_photos(id) on delete cascade,
  watch_id bigint not null references public.watches(id) on delete cascade,
  visual_position text,
  notes text,
  created_at timestamptz not null default now(),
  constraint watch_photo_links_photo_watch_key unique (photo_id, watch_id)
);

create unique index if not exists watch_models_user_identity_uidx
  on public.watch_models (
    user_id,
    coalesce(brand_id, 0),
    lower(model_name),
    lower(coalesce(line_name, '')),
    lower(coalesce(reference_family, ''))
  );
create unique index if not exists movement_calibers_user_identity_uidx
  on public.movement_calibers (
    user_id,
    lower(coalesce(manufacturer, '')),
    lower(caliber_code)
  );
create unique index if not exists acquisitions_user_order_uidx
  on public.acquisitions (user_id, lower(coalesce(marketplace, '')), order_number)
  where order_number is not null;
create unique index if not exists watches_user_order_item_uidx
  on public.watches (user_id, lower(coalesce(marketplace, '')), order_number, order_item_number)
  where order_number is not null and order_item_number is not null;

create index if not exists watches_brand_id_idx on public.watches (brand_id);
create index if not exists watches_watch_model_id_idx on public.watches (watch_model_id);
create index if not exists watches_movement_caliber_id_idx on public.watches (movement_caliber_id);
create index if not exists watch_models_user_id_idx on public.watch_models (user_id);
create index if not exists watch_models_brand_id_idx on public.watch_models (brand_id);
create index if not exists movement_calibers_user_id_idx on public.movement_calibers (user_id);
create index if not exists acquisitions_user_id_idx on public.acquisitions (user_id);
create index if not exists acquisition_items_user_id_idx on public.acquisition_items (user_id);
create index if not exists acquisition_items_acquisition_id_idx on public.acquisition_items (acquisition_id);
create index if not exists expenses_user_id_idx on public.expenses (user_id);
create index if not exists expenses_acquisition_id_idx on public.expenses (acquisition_id);
create index if not exists expenses_watch_id_idx on public.expenses (watch_id);
create index if not exists expense_allocations_user_id_idx on public.expense_allocations (user_id);
create index if not exists expense_allocations_expense_id_idx on public.expense_allocations (expense_id);
create index if not exists expense_allocations_watch_id_idx on public.expense_allocations (watch_id);
create index if not exists watch_events_user_id_idx on public.watch_events (user_id);
create index if not exists watch_events_watch_date_idx on public.watch_events (watch_id, event_date desc);
create index if not exists watch_events_acquisition_id_idx on public.watch_events (acquisition_id);
create index if not exists watch_sources_user_id_idx on public.watch_sources (user_id);
create index if not exists watch_sources_watch_id_idx on public.watch_sources (watch_id);
create index if not exists watch_sources_acquisition_id_idx on public.watch_sources (acquisition_id);
create index if not exists watch_photos_acquisition_id_idx on public.watch_photos (acquisition_id);
create index if not exists watch_photo_links_user_id_idx on public.watch_photo_links (user_id);
create index if not exists watch_photo_links_photo_id_idx on public.watch_photo_links (photo_id);
create index if not exists watch_photo_links_watch_id_idx on public.watch_photo_links (watch_id);

drop trigger if exists watches_set_updated_at on public.watches;
create trigger watches_set_updated_at before update on public.watches
for each row execute function public.set_updated_at();
drop trigger if exists maintenance_logs_set_updated_at on public.maintenance_logs;
create trigger maintenance_logs_set_updated_at before update on public.maintenance_logs
for each row execute function public.set_updated_at();

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'watch_models', 'movement_calibers', 'acquisitions', 'acquisition_items',
    'expenses', 'watch_events'
  ] loop
    execute format('drop trigger if exists %I_set_updated_at on public.%I', table_name, table_name);
    execute format(
      'create trigger %I_set_updated_at before update on public.%I for each row execute function public.set_updated_at()',
      table_name, table_name
    );
  end loop;
end $$;

alter table public.watch_models enable row level security;
alter table public.movement_calibers enable row level security;
alter table public.acquisitions enable row level security;
alter table public.acquisition_items enable row level security;
alter table public.expenses enable row level security;
alter table public.expense_allocations enable row level security;
alter table public.watch_events enable row level security;
alter table public.watch_sources enable row level security;
alter table public.watch_photo_links enable row level security;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'watch_models', 'movement_calibers', 'acquisitions', 'acquisition_items',
    'expenses', 'expense_allocations', 'watch_events', 'watch_sources',
    'watch_photo_links'
  ] loop
    execute format('drop policy if exists owner_select on public.%I', table_name);
    execute format('drop policy if exists owner_insert on public.%I', table_name);
    execute format('drop policy if exists owner_update on public.%I', table_name);
    execute format('drop policy if exists owner_delete on public.%I', table_name);
    execute format(
      'create policy owner_select on public.%I for select to authenticated using ((select auth.uid()) = user_id)',
      table_name
    );
    execute format(
      'create policy owner_insert on public.%I for insert to authenticated with check ((select auth.uid()) = user_id)',
      table_name
    );
    execute format(
      'create policy owner_update on public.%I for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id)',
      table_name
    );
    execute format(
      'create policy owner_delete on public.%I for delete to authenticated using ((select auth.uid()) = user_id)',
      table_name
    );
  end loop;
end $$;

grant select, insert, update, delete on
  public.watch_models,
  public.movement_calibers,
  public.acquisitions,
  public.acquisition_items,
  public.expenses,
  public.expense_allocations,
  public.watch_events,
  public.watch_sources,
  public.watch_photo_links
to authenticated;

grant usage, select on sequence
  public.watch_models_id_seq,
  public.movement_calibers_id_seq,
  public.acquisitions_id_seq,
  public.acquisition_items_id_seq,
  public.expenses_id_seq,
  public.expense_allocations_id_seq,
  public.watch_events_id_seq,
  public.watch_sources_id_seq,
  public.watch_photo_links_id_seq
to authenticated;

comment on table public.acquisitions is 'Order or lot level purchase information.';
comment on table public.acquisition_items is 'One physical watch within an acquisition or lot.';
comment on table public.expenses is 'Documentary expense totals before allocation.';
comment on table public.expense_allocations is 'Per-watch allocation preserving rounding differences.';
comment on table public.watch_events is 'Chronological lifecycle and maintenance events.';
comment on table public.watch_sources is 'Documentary, visual and researched evidence.';

