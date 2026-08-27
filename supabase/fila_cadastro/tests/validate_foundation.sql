\set ON_ERROR_STOP on

begin;

create function pg_temp.assert_true(condition boolean, message text)
returns void
language plpgsql
as $$
begin
  if condition is not true then
    raise exception 'ASSERTION FAILED: %', message;
  end if;
end;
$$;

create function pg_temp.expect_error(statement text, expected_state text, message text)
returns void
language plpgsql
as $$
begin
  begin
    execute statement;
  exception
    when others then
      if sqlstate = expected_state then
        return;
      end if;
      raise exception 'ASSERTION FAILED: % (SQLSTATE obtido %, esperado %)',
        message, sqlstate, expected_state;
  end;
  raise exception 'ASSERTION FAILED: % (nenhum erro ocorreu)', message;
end;
$$;

select pg_temp.assert_true(
  (select count(*) = 17
   from pg_class relation
   join pg_namespace namespace on namespace.oid = relation.relnamespace
   where namespace.nspname = 'public'
     and relation.relname = any (array[
       'horoteca_user_roles',
       'watch_intakes',
       'watch_intake_documents',
       'watch_intake_extractions',
       'watch_intake_items',
       'watch_intake_acquisitions',
       'watch_intake_expenses',
       'watch_intake_expense_allocations',
       'watch_intake_sources',
       'watch_intake_claims',
       'watch_intake_photos',
       'watch_intake_photo_links',
       'watch_intake_revisions',
       'watch_intake_findings',
       'watch_intake_owner_decisions',
       'watch_intake_transitions',
       'watch_intake_finalizations'
     ])
     and relation.relkind in ('r', 'p')
     and relation.relrowsecurity),
  'as 17 tabelas públicas da fila devem existir com RLS'
);

select pg_temp.assert_true(
  not exists (
    select 1
    from unnest(array[
      'horoteca_user_roles',
      'watch_intakes',
      'watch_intake_documents',
      'watch_intake_extractions',
      'watch_intake_items',
      'watch_intake_acquisitions',
      'watch_intake_expenses',
      'watch_intake_expense_allocations',
      'watch_intake_sources',
      'watch_intake_claims',
      'watch_intake_photos',
      'watch_intake_photo_links',
      'watch_intake_revisions',
      'watch_intake_findings',
      'watch_intake_owner_decisions',
      'watch_intake_transitions',
      'watch_intake_finalizations'
    ]) as expected(table_name)
    where has_table_privilege('anon', format('public.%I', expected.table_name), 'SELECT')
       or has_table_privilege('anon', format('public.%I', expected.table_name), 'INSERT')
       or has_table_privilege('anon', format('public.%I', expected.table_name), 'UPDATE')
       or has_table_privilege('anon', format('public.%I', expected.table_name), 'DELETE')
  ),
  'anon não pode receber privilégios nas tabelas da fila'
);

select pg_temp.assert_true(
  has_table_privilege('authenticated', 'public.watches', 'SELECT'),
  'o protótipo não pode revogar grants das tabelas canônicas'
);

select pg_temp.assert_true(
  not has_schema_privilege('authenticated', 'horoteca_private', 'USAGE')
  and not has_schema_privilege('anon', 'horoteca_private', 'USAGE'),
  'schema privado não pode ser acessível pela API'
);

select pg_temp.assert_true(
  (select count(*) = 25 from horoteca_private.allowed_intake_transitions),
  'a máquina de estados deve conter as 25 transições aprovadas'
);

select pg_temp.assert_true(
  (select count(*) = 1 and min(intake_code) = 'H001'
   from public.watch_intakes where intake_number = 1),
  'H001 deve ser preservado uma única vez'
);

select id as h001_id
from public.watch_intakes
where intake_number = 1
\gset

select pg_temp.assert_true(
  (select status = 'draft' and current_stage = 'review_01'
     and expected_item_count = 1 and identified_item_count = 1
   from public.watch_intakes where intake_number = 1),
  'H001 deve entrar como rascunho da Revisão 01 no fluxo V2'
);

select pg_temp.assert_true(
  (select count(*) = 1
   from public.watch_intake_documents document
   join public.watch_intakes intake on intake.id = document.intake_id
   where intake.intake_number = 1
     and document.document_role = 'source_a'
     and document.provider_file_id = '1M_8j6GtTDC4S6Wpsb_kUP2_flQE7XKTpcNq0Hq8caWQ'),
  'Documento A original de H001 deve ser preservado'
);

select pg_temp.assert_true(
  (select count(*) = 1
   from public.watch_intake_documents document
   join public.watch_intakes intake on intake.id = document.intake_id
   where intake.intake_number = 1
     and document.document_role = 'working_b'
     and document.provider_file_id = '1PM2F7u0QBBr2dSNpne5HCj3RQITvFY1MpDvzdR_X-ak'
     and document.metadata ->> 'requires_v2_owner_approval' = 'true'),
  'Documento B histórico não pode fingir aprovação no fluxo V2'
);

select pg_temp.assert_true(
  not exists (
    select 1 from public.watch_intake_documents document
    join public.watch_intakes intake on intake.id = document.intake_id
    where intake.intake_number = 1 and document.document_role = 'approved_b'
  ),
  'H001 não pode possuir Documento B aprovado antes das três revisões'
);

select pg_temp.assert_true(
  (select count(*) = 1
   from public.watch_intake_items item
   join public.watch_intakes intake on intake.id = item.intake_id
   where intake.intake_number = 1
     and item.order_number = '02-14381-05007'
     and item.marketplace_item_id = '206120876079'
     and item.candidate_reference_number is null
     and item.candidate_movement_type is null),
  'H001 deve ter um item e manter desconhecidos como NULL'
);

insert into public.watch_intakes (user_id, intake_number, title)
values (:'owner_user_id'::uuid, 1000, 'Teste de padding H1000');

select pg_temp.assert_true(
  (select intake_code = 'H1000' from public.watch_intakes where intake_number = 1000),
  'a numeração deve continuar válida depois de H999'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_user_id', true);

select pg_temp.assert_true(public.is_horoteca_owner(), 'Dani deve ser proprietário no protótipo');
select pg_temp.assert_true(
  (select count(*) = 1 from public.watch_intakes where intake_number = 1),
  'o proprietário deve enxergar H001'
);

insert into public.watch_intakes (user_id, intake_number, status, current_stage, version, title)
values (:'other_user_id'::uuid, 999999, 'completed', 'completed', 99, 'Teste atômico H002');

select pg_temp.assert_true(
  (select intake_code = 'H002'
      and user_id = :'owner_user_id'::uuid
      and status = 'new'
      and current_stage = 'intake'
      and version = 1
   from public.watch_intakes where title = 'Teste atômico H002'),
  'servidor deve atribuir H002, usuário e estado inicial sem confiar no cliente'
);

select pg_temp.expect_error(
  $$update public.watch_intakes set status = 'completed' where intake_number = 1$$,
  '42501',
  'mudança direta de estado deve ser bloqueada'
);

select pg_temp.expect_error(
  $$update public.watch_intake_documents
      set original_name = 'nome adulterado'
    where document_role = 'source_a'$$,
  '55000',
  'identidade do Documento A deve ser imutável'
);

select pg_temp.expect_error(
  format(
    $sql$insert into public.watch_intake_documents
      (user_id, intake_id, document_role, provider, provider_file_id, original_name)
      select %L::uuid, id, 'approved_b', 'test', 'forbidden', 'Aprovação direta'
      from public.watch_intakes where intake_number = 1$sql$,
    :'owner_user_id'
  ),
  '42501',
  'approved_b não pode ser inserido diretamente'
);

do $$
declare
  affected integer;
begin
  delete from public.watch_intakes where intake_number = 1;
  get diagnostics affected = row_count;
  if affected <> 0 then
    raise exception 'ASSERTION FAILED: processos não podem ser excluídos diretamente';
  end if;
end;
$$;

select set_config('request.jwt.claim.sub', :'other_user_id', true);

select pg_temp.assert_true(
  (select count(*) = 0 from public.watch_intakes),
  'outro usuário não pode enxergar os processos do proprietário'
);

select pg_temp.expect_error(
  format(
    $sql$insert into public.watch_intake_items
      (user_id, intake_id, item_sequence)
      values (%L::uuid, %s, 77)$sql$,
    :'other_user_id',
    :'h001_id'
  ),
  '23503',
  'outro usuário não pode vincular dados ao processo do proprietário'
);

reset role;

select pg_temp.assert_true(
  (select count(*) = 1
   from public.watch_intake_transitions transition_log
   join public.watch_intakes intake on intake.id = transition_log.intake_id
   where intake.intake_number = 1
     and transition_log.actor_type = 'historical_import'),
  'importação idempotente deve produzir um único evento histórico'
);

rollback;

\echo 'OK: fundação da Fila de Cadastro, H001, H002, RLS e imutabilidade validados'
