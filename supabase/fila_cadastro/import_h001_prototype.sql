\set ON_ERROR_STOP on

-- Importação histórica controlada de H001 para o protótipo local.
-- Exige: psql --set=owner_user_id=<auth.users.id>
-- Este arquivo NÃO é uma migration e não deve ser executado isoladamente.

\if :{?owner_user_id}
\else
  \echo 'owner_user_id é obrigatório'
  \quit 3
\endif

select set_config('horoteca.seed_owner_user_id', :'owner_user_id', false);

do $$
declare
  owner_id uuid := current_setting('horoteca.seed_owner_user_id')::uuid;
begin
  if not exists (select 1 from auth.users where id = owner_id) then
    raise exception 'owner_user_id não existe em auth.users';
  end if;
end;
$$;

insert into public.horoteca_user_roles (user_id, role, granted_by, notes)
values (
  current_setting('horoteca.seed_owner_user_id')::uuid,
  'owner',
  current_setting('horoteca.seed_owner_user_id')::uuid,
  'Proprietário inicial verificado para a Horoteca'
)
on conflict (user_id) do nothing;

insert into public.watch_intakes (
  user_id,
  intake_number,
  status,
  current_stage,
  version,
  title,
  notes,
  expected_item_count,
  identified_item_count
)
values (
  current_setting('horoteca.seed_owner_user_id')::uuid,
  1,
  'draft',
  'review_01',
  1,
  'H001 — Seiko 5 — pedido 02-14381-05007',
  'Importação histórica: Documento B antigo contém aprovação para a Etapa 3, mas o processo ainda precisa cumprir Revisões 01, 02 e 03 e nova aprovação explícita no fluxo V2.',
  1,
  1
)
on conflict (intake_number) do nothing;

insert into public.watch_intake_documents (
  user_id,
  intake_id,
  document_role,
  provider,
  provider_file_id,
  url,
  original_name,
  display_name,
  provider_modified_at,
  document_version,
  status,
  created_by,
  is_accessible,
  access_checked_at,
  provider_created_at,
  metadata,
  notes
)
select
  intake.user_id,
  intake.id,
  'source_a',
  'google_drive',
  '1M_8j6GtTDC4S6Wpsb_kUP2_flQE7XKTpcNq0Hq8caWQ',
  'https://docs.google.com/document/d/1M_8j6GtTDC4S6Wpsb_kUP2_flQE7XKTpcNq0Hq8caWQ/edit',
  'H001 - REVISADO -05-08-2026 - Número do pedido: 02-14381-05007 - RECEBIDO - 15-03-2026 - Relógio de pulso masculino Seiko vintage automático 6309 8940 GWO',
  'Documento A — fonte original H001',
  '2026-08-25 17:58:24.001+00'::timestamptz,
  1,
  'active',
  intake.user_id,
  true,
  now(),
  '2026-03-30 11:22:51.714+00'::timestamptz,
  jsonb_build_object(
    'drive_parent_id', '12yL7IDlAlMCZem0jEgUwPci3WVe1iIYQ',
    'shared', true,
    'mime_type', 'application/vnd.google-apps.document'
  ),
  'Metadados conferidos no Google Drive antes da especificação executável.'
from public.watch_intakes intake
where intake.intake_number = 1
on conflict (intake_id, document_role, provider, provider_file_id, document_version)
do nothing;

insert into public.watch_intake_documents (
  user_id,
  intake_id,
  document_role,
  provider,
  provider_file_id,
  url,
  original_name,
  display_name,
  provider_modified_at,
  document_version,
  status,
  source_document_id,
  created_by,
  is_accessible,
  access_checked_at,
  provider_created_at,
  metadata,
  notes
)
select
  intake.user_id,
  intake.id,
  'working_b',
  'google_drive',
  '1PM2F7u0QBBr2dSNpne5HCj3RQITvFY1MpDvzdR_X-ak',
  'https://docs.google.com/document/d/1PM2F7u0QBBr2dSNpne5HCj3RQITvFY1MpDvzdR_X-ak/edit',
  'H001 - HOROTECA - 02-14381-05007 - SEIKO-5-IDENTIFICACAO-PENDENTE - FICHA APROVADA',
  'Documento B histórico — requer validação V2',
  '2026-08-25 21:25:20.835+00'::timestamptz,
  1,
  'active',
  source_a.id,
  intake.user_id,
  true,
  now(),
  '2026-08-25 21:10:27.735+00'::timestamptz,
  jsonb_build_object(
    'drive_parent_id', '1UXRhESIlfRkMsh37FnDb5u-NciwIkEvb',
    'shared', false,
    'mime_type', 'application/vnd.google-apps.document',
    'legacy_label', 'FICHA APROVADA',
    'legacy_approved_date', '2026-08-25',
    'requires_v2_owner_approval', true
  ),
  'O nome histórico não substitui o estado oficial nem a aprovação explícita do fluxo V2.'
from public.watch_intakes intake
join public.watch_intake_documents source_a
  on source_a.intake_id = intake.id
 and source_a.user_id = intake.user_id
 and source_a.document_role = 'source_a'
where intake.intake_number = 1
on conflict (intake_id, document_role, provider, provider_file_id, document_version)
do nothing;

insert into public.watch_intake_items (
  user_id,
  intake_id,
  item_sequence,
  order_number,
  marketplace_item_id,
  candidate_horoteca_code,
  candidate_brand,
  candidate_model,
  candidate_watch_data
)
select
  intake.user_id,
  intake.id,
  1,
  '02-14381-05007',
  '206120876079',
  '02-14381-05007',
  'Seiko',
  'Seiko 5',
  jsonb_build_object(
    'marketplace', 'eBay',
    'tracking_number', 'LE407766954GB',
    'reference_claim', '6309-8940',
    'caliber_claim', '6309',
    'claim_status', 'pending'
  )
from public.watch_intakes intake
where intake.intake_number = 1
on conflict (intake_id, item_sequence) do nothing;

insert into public.watch_intake_transitions (
  user_id,
  intake_id,
  from_status,
  to_status,
  intake_version,
  actor_id,
  actor_type,
  reason,
  metadata
)
select
  intake.user_id,
  intake.id,
  null,
  'draft',
  intake.version,
  intake.user_id,
  'historical_import',
  'Preservação de H001 antes da abertura da sequência H002',
  jsonb_build_object(
    'document_a_provider_file_id', '1M_8j6GtTDC4S6Wpsb_kUP2_flQE7XKTpcNq0Hq8caWQ',
    'document_b_provider_file_id', '1PM2F7u0QBBr2dSNpne5HCj3RQITvFY1MpDvzdR_X-ak'
  )
from public.watch_intakes intake
where intake.intake_number = 1
  and not exists (
    select 1
    from public.watch_intake_transitions transition_log
    where transition_log.intake_id = intake.id
      and transition_log.actor_type = 'historical_import'
  );

