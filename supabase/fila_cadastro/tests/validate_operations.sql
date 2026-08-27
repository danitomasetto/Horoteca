\set ON_ERROR_STOP on

begin;

create function pg_temp.assert_true(condition boolean, message text)
returns void language plpgsql as $$
begin
  if condition is not true then
    raise exception 'ASSERTION FAILED: %', message;
  end if;
end;
$$;

create function pg_temp.expect_error(statement text, expected_state text, message text)
returns void language plpgsql as $$
begin
  begin
    execute statement;
  exception when others then
    if sqlstate = expected_state then return; end if;
    raise exception 'ASSERTION FAILED: % (SQLSTATE %, esperado %)',
      message, sqlstate, expected_state;
  end;
  raise exception 'ASSERTION FAILED: % (nenhum erro ocorreu)', message;
end;
$$;

select pg_temp.assert_true(
  (select not rolcanlogin and not rolbypassrls and not rolsuper
   from pg_roles where rolname = 'horoteca_intake_executor'),
  'executor interno deve ser sem login, sem superuser e sem BYPASSRLS'
);

select pg_temp.assert_true(
  has_function_privilege('authenticated',
    'public.finalize_watch_intake(bigint,integer,uuid)', 'EXECUTE')
  and not has_function_privilege('anon',
    'public.finalize_watch_intake(bigint,integer,uuid)', 'EXECUTE'),
  'RPC de finalização deve ser exclusiva de authenticated'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_user_id', true);

insert into public.watch_intakes (user_id, intake_number, title, expected_item_count)
values (:'other_user_id'::uuid, 999999, 'Cenário completo de operações', 2)
returning id as test_intake_id
\gset

insert into public.watch_intake_documents (
  user_id, intake_id, document_role, provider, provider_file_id,
  original_name, display_name, document_version, is_accessible,
  access_checked_at, provider_created_at
) values (
  :'owner_user_id'::uuid, :'test_intake_id', 'source_a', 'test',
  'test-source-a', 'Documento A de teste', 'Documento A', 1, true, now(), now()
) returning id as source_a_id
\gset

insert into public.watch_intake_documents (
  user_id, intake_id, document_role, provider, provider_file_id,
  original_name, display_name, document_version, source_document_id,
  is_accessible, access_checked_at, provider_created_at
) values (
  :'owner_user_id'::uuid, :'test_intake_id', 'working_b', 'test',
  'test-working-b', 'Documento B de teste', 'Documento B', 1,
  :'source_a_id', true, now(), now()
) returning id as working_b_id
\gset

insert into public.watch_intake_acquisitions (
  user_id, intake_id, marketplace, seller_name, order_number,
  purchase_date, payment_method, source_document_id, match_status
) values (
  :'owner_user_id'::uuid, :'test_intake_id', 'Test Market', 'Test Seller',
  'TEST-ORDER-001', date '2026-08-01', 'test', :'source_a_id', 'explicit_new'
) returning id as staging_acquisition_id
\gset

insert into public.watch_intake_items (
  user_id, intake_id, acquisition_id, item_sequence, order_number,
  order_item_number, marketplace_item_id, candidate_horoteca_code,
  candidate_brand, candidate_model, candidate_reference_number,
  brand_match_status, model_match_status, caliber_match_status
) values
  (:'owner_user_id'::uuid, :'test_intake_id', :'staging_acquisition_id', 1,
   'TEST-ORDER-001', 1, 'ITEM-1', 'TEST-ORDER-001-1',
   'Brand A', 'Model A', null, 'explicit_new', 'explicit_new', 'not_applicable'),
  (:'owner_user_id'::uuid, :'test_intake_id', :'staging_acquisition_id', 2,
   'TEST-ORDER-001', 2, 'ITEM-2', 'TEST-ORDER-001-2',
   null, null, null, 'not_applicable', 'not_applicable', 'not_applicable');

select id as item_1_id from public.watch_intake_items
where intake_id = :'test_intake_id' and item_sequence = 1
\gset
select id as item_2_id from public.watch_intake_items
where intake_id = :'test_intake_id' and item_sequence = 2
\gset

insert into public.watch_intake_expenses (
  user_id, intake_id, acquisition_id, item_id, category, description,
  currency, amount_original, amount_brl, is_shared, allocation_method
) values
  (:'owner_user_id'::uuid, :'test_intake_id', :'staging_acquisition_id',
   :'item_1_id', 'product', 'Peça 1', 'BRL', 60, 60, false, 'individual'),
  (:'owner_user_id'::uuid, :'test_intake_id', :'staging_acquisition_id',
   :'item_2_id', 'product', 'Peça 2', 'BRL', 40, 40, false, 'individual');

insert into public.watch_intake_expenses (
  user_id, intake_id, acquisition_id, category, description,
  currency, amount_original, amount_brl, is_shared, allocation_method
) values (
  :'owner_user_id'::uuid, :'test_intake_id', :'staging_acquisition_id',
  'freight', 'Frete compartilhado', 'BRL', 10.01, 10.01, true, 'proportional'
) returning id as shared_expense_id
\gset

insert into public.watch_intake_sources (
  user_id, intake_id, item_id, source_document_id, source_type, title,
  url, evidence_classification, confidence_percent, accessed_at
) values (
  :'owner_user_id'::uuid, :'test_intake_id', :'item_1_id', :'source_a_id',
  'document', 'Fonte de teste', 'https://example.test/source',
  'document_confirmed', 100, now()
) returning id as staging_source_id
\gset

-- Claim sem item provoca uma falha deliberada dentro da promoção, depois de
-- inserts canônicos, para provar rollback integral.
insert into public.watch_intake_claims (
  user_id, intake_id, source_id, field_name, asserted_value,
  asserted_by_type, evidence_classification, verification_status
) values (
  :'owner_user_id'::uuid, :'test_intake_id', :'staging_source_id',
  'test_field', 'test_value', 'document', 'document_confirmed', 'accepted'
) returning id as rollback_claim_id
\gset

insert into public.watch_intake_photos (
  user_id, intake_id, source_document_id, provider, provider_file_id,
  original_url, storage_path, origin_type, visual_position,
  evidence_classification, display_order, is_cover_candidate, copy_status
) values (
  :'owner_user_id'::uuid, :'test_intake_id', :'source_a_id', 'test',
  'test-photo', 'https://example.test/photo',
  :'owner_user_id' || '/TEST-ORDER-001/photo.jpg', 'document', 'front',
  'document_confirmed', 1, true, 'copied'
) returning id as staging_photo_id
\gset

insert into public.watch_intake_photo_links (
  user_id, intake_id, photo_id, item_id, relation_type
) values (
  :'owner_user_id'::uuid, :'test_intake_id', :'staging_photo_id', :'item_1_id', 'cover'
);

select version as setup_version from public.watch_intakes
where id = :'test_intake_id'
\gset

select public.recalculate_watch_intake_allocation(
  :'test_intake_id', :'setup_version', :'shared_expense_id'
);

select version as review_version from public.watch_intakes
where id = :'test_intake_id'
\gset

select pg_temp.assert_true(
  (select sum(final_amount_brl) = 10.01
     and min(reconciliation_adjustment_brl) = -0.01
   from public.watch_intake_expense_allocations
   where expense_id = :'shared_expense_id'),
  'rateio proporcional deve fechar exatamente 10,01 com ajuste separado'
);

select public.transition_watch_intake(
  :'test_intake_id', :'review_version', 'submitted_for_review_01', 'Pronto para revisão 01'
);
select (public.start_watch_intake_revision(
  :'test_intake_id', :'review_version', 1::smallint, :'source_a_id', :'working_b_id',
  'human', 'checklist-v1', '{}'::jsonb
) ->> 'revision_id')::bigint as revision_1_id
\gset

select pg_temp.expect_error(
  format('update public.watch_intake_revisions set status = %L where id = %s',
    'approved', :'revision_1_id'),
  '42501',
  'cliente não pode aprovar revisão por UPDATE direto'
);

select public.complete_watch_intake_revision(
  :'revision_1_id', :'review_version', 'approved', '{"ok":true}',
  'Revisão 01 aprovada', '{"revision":1}'
);

select public.transition_watch_intake(
  :'test_intake_id', :'review_version', 'submitted_for_review_02', 'Pronto para revisão 02'
);
select (public.start_watch_intake_revision(
  :'test_intake_id', :'review_version', 2::smallint, :'source_a_id', :'working_b_id',
  'human', 'checklist-v1', '{}'::jsonb
) ->> 'revision_id')::bigint as revision_2_id
\gset
select public.complete_watch_intake_revision(
  :'revision_2_id', :'review_version', 'approved', '{"ok":true}',
  'Revisão 02 aprovada', '{"revision":2}'
);

select public.transition_watch_intake(
  :'test_intake_id', :'review_version', 'submitted_for_review_03', 'Pronto para revisão 03'
);
select (public.start_watch_intake_revision(
  :'test_intake_id', :'review_version', 3::smallint, :'source_a_id', :'working_b_id',
  'human', 'checklist-v1', '{}'::jsonb
) ->> 'revision_id')::bigint as revision_3_id
\gset
select public.complete_watch_intake_revision(
  :'revision_3_id', :'review_version', 'approved', '{"ok":true}',
  'Revisão 03 aprovada', '{"revision":3}'
);
select public.transition_watch_intake(
  :'test_intake_id', :'review_version', 'awaiting_owner_approval', 'Revisões concluídas'
);

select set_config('request.jwt.claim.sub', :'other_user_id', true);
select pg_temp.expect_error(
  format('select public.transition_watch_intake(%s, %s, %L, %L)',
    :'test_intake_id', :'review_version', 'cancelled', 'tentativa alheia'),
  'P0002',
  'outro usuário não pode operar processo alheio'
);

insert into public.watch_intakes (user_id, intake_number, title)
values (:'owner_user_id'::uuid, 999999, 'Processo de usuário sem papel owner')
returning id as other_intake_id
\gset
select pg_temp.expect_error(
  format('select public.decide_watch_intake(%s, 1, %L, null, %L::jsonb, null)',
    :'other_intake_id', 'cancel', '{}'),
  '42501',
  'usuário autenticado sem papel owner não pode cancelar'
);

select set_config('request.jwt.claim.sub', :'owner_user_id', true);
select public.decide_watch_intake(
  :'test_intake_id', :'review_version', 'approve', :'working_b_id',
  '{"approved":true}', 'Aprovação explícita do proprietário'
);
select public.transition_watch_intake(
  :'test_intake_id', :'review_version', 'finalization_ready', 'Pronto para cadastro final'
);

select public.finalize_watch_intake(
  :'test_intake_id', :'review_version', '33333333-3333-4333-8333-333333333333'
);

select pg_temp.assert_true(
  (select status = 'finalization_failed' from public.watch_intakes
   where id = :'test_intake_id'),
  'claim sem item deve levar a finalization_failed'
);
select pg_temp.assert_true(
  not exists (select 1 from public.acquisitions where order_number = 'TEST-ORDER-001')
  and not exists (select 1 from public.watches where order_number = 'TEST-ORDER-001')
  and not exists (
    select 1 from public.watch_intake_items
    where intake_id = :'test_intake_id' and final_watch_id is not null
  ),
  'falha interna deve reverter toda promoção canônica'
);

-- Simula reparo interno de uma falha operacional sem alterar a versão já
-- aprovada; em produção, apenas uma operação protegida poderá fazer isto.
reset role;
insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current());
update public.watch_intake_claims
set item_id = :'item_1_id'
where id = :'rollback_claim_id';
delete from horoteca_private.operation_context
where backend_pid = pg_backend_pid() and transaction_id = txid_current();
set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_user_id', true);

select public.finalize_watch_intake(
  :'test_intake_id', :'review_version', '33333333-3333-4333-8333-333333333333'
);
select public.finalize_watch_intake(
  :'test_intake_id', :'review_version', '33333333-3333-4333-8333-333333333333'
);

select pg_temp.assert_true(
  (select status = 'completed' and finalized_at is not null
   from public.watch_intakes where id = :'test_intake_id'),
  'processo válido deve ser concluído'
);
select pg_temp.assert_true(
  (select count(*) = 1 from public.acquisitions where order_number = 'TEST-ORDER-001')
  and (select count(*) = 2 from public.watches where order_number = 'TEST-ORDER-001')
  and (select count(*) = 2 from public.acquisition_items item
       join public.acquisitions acquisition on acquisition.id = item.acquisition_id
       where acquisition.order_number = 'TEST-ORDER-001')
  and (select count(*) = 3 from public.expenses expense
       join public.acquisitions acquisition on acquisition.id = expense.acquisition_id
       where acquisition.order_number = 'TEST-ORDER-001')
  and (select count(*) = 2 from public.expense_allocations allocation
       join public.expenses expense on expense.id = allocation.expense_id
       join public.acquisitions acquisition on acquisition.id = expense.acquisition_id
       where acquisition.order_number = 'TEST-ORDER-001'),
  'promoção deve criar aquisição, relógios, itens, despesas e rateios uma única vez'
);
select pg_temp.assert_true(
  (select array_agg(horoteca_code order by horoteca_code)
     = array['TEST-ORDER-001-1', 'TEST-ORDER-001-2']::text[]
   from public.watches where order_number = 'TEST-ORDER-001'),
  'cada peça deve receber identificador canônico distinto'
);
select pg_temp.assert_true(
  (select count(*) = 1 and min(status) = 'completed'
   from public.watch_intake_finalizations
   where idempotency_key = '33333333-3333-4333-8333-333333333333'),
  'repetições devem retornar a mesma finalização sem duplicar dados'
);

select pg_temp.expect_error(
  format('update public.watch_intake_claims set asserted_value = %L where id = %s',
    'alteração tardia', :'rollback_claim_id'),
  '55000',
  'conteúdo de processo concluído deve ser imutável'
);

rollback;

\echo 'OK: transições, revisões, owner, rateio, rollback e idempotência validados'
