\set ON_ERROR_STOP on

-- Operações protegidas da Fila de Cadastro.
-- Este arquivo complementa foundation_prototype.sql e ainda NÃO é migration.

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'horoteca_intake_executor') then
    create role horoteca_intake_executor
      nologin noinherit nosuperuser nocreatedb nocreaterole noreplication nobypassrls;
  end if;
end;
$$;

grant usage on schema public, horoteca_private to horoteca_intake_executor;

grant select, insert, update, delete on
  public.watch_intakes,
  public.watch_intake_documents,
  public.watch_intake_extractions,
  public.watch_intake_items,
  public.watch_intake_acquisitions,
  public.watch_intake_expenses,
  public.watch_intake_expense_allocations,
  public.watch_intake_sources,
  public.watch_intake_claims,
  public.watch_intake_photos,
  public.watch_intake_photo_links,
  public.watch_intake_revisions,
  public.watch_intake_findings,
  public.watch_intake_owner_decisions,
  public.watch_intake_transitions,
  public.watch_intake_finalizations,
  public.acquisitions,
  public.acquisition_items,
  public.expenses,
  public.expense_allocations,
  public.watches,
  public.watch_sources,
  public.watch_claims,
  public.watch_photos,
  public.watch_photo_links
to horoteca_intake_executor;

grant select on public.horoteca_user_roles to horoteca_intake_executor;
grant select on horoteca_private.allowed_intake_transitions to horoteca_intake_executor;

create table horoteca_private.operation_context (
  backend_pid integer not null,
  transaction_id bigint not null,
  primary key (backend_pid, transaction_id)
);

revoke all on horoteca_private.operation_context from public, anon, authenticated;
grant select, insert, delete on horoteca_private.operation_context
to horoteca_intake_executor;

grant usage, select on
  public.watch_intake_number_seq,
  public.watch_intakes_id_seq,
  public.watch_intake_documents_id_seq,
  public.watch_intake_extractions_id_seq,
  public.watch_intake_items_id_seq,
  public.watch_intake_acquisitions_id_seq,
  public.watch_intake_expenses_id_seq,
  public.watch_intake_expense_allocations_id_seq,
  public.watch_intake_sources_id_seq,
  public.watch_intake_claims_id_seq,
  public.watch_intake_photos_id_seq,
  public.watch_intake_photo_links_id_seq,
  public.watch_intake_revisions_id_seq,
  public.watch_intake_findings_id_seq,
  public.watch_intake_owner_decisions_id_seq,
  public.watch_intake_transitions_id_seq,
  public.watch_intake_finalizations_id_seq,
  public.acquisitions_id_seq,
  public.acquisition_items_id_seq,
  public.expenses_id_seq,
  public.expense_allocations_id_seq,
  public.watches_id_seq,
  public.watch_sources_id_seq,
  public.watch_claims_id_seq,
  public.watch_photos_id_seq,
  public.watch_photo_links_id_seq
to horoteca_intake_executor;

-- O executor não possui BYPASSRLS. Políticas dedicadas mantêm auth.uid() como
-- fronteira de propriedade mesmo dentro das RPCs SECURITY DEFINER.
do $policies$
declare
  target_table text;
begin
  foreach target_table in array array[
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
    'watch_intake_finalizations',
    'acquisitions',
    'acquisition_items',
    'expenses',
    'expense_allocations',
    'watches',
    'watch_sources',
    'watch_claims',
    'watch_photos',
    'watch_photo_links'
  ]
  loop
    execute format(
      'create policy intake_executor_select on public.%I for select to horoteca_intake_executor using ((select auth.uid()) = user_id)',
      target_table
    );
  end loop;

  foreach target_table in array array[
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
    'watch_intake_finalizations',
    'acquisitions',
    'acquisition_items',
    'expenses',
    'expense_allocations',
    'watches',
    'watch_sources',
    'watch_claims',
    'watch_photos',
    'watch_photo_links'
  ]
  loop
    execute format(
      'create policy intake_executor_insert on public.%I for insert to horoteca_intake_executor with check ((select auth.uid()) = user_id)',
      target_table
    );
    execute format(
      'create policy intake_executor_update on public.%I for update to horoteca_intake_executor using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id)',
      target_table
    );
    execute format(
      'create policy intake_executor_delete on public.%I for delete to horoteca_intake_executor using ((select auth.uid()) = user_id)',
      target_table
    );
  end loop;
end;
$policies$;

create policy intake_executor_select on horoteca_private.allowed_intake_transitions
for select to horoteca_intake_executor using (true);

create function horoteca_private.require_authenticated_owner(p_user_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  caller_id uuid := (select auth.uid());
begin
  if caller_id is null then
    raise exception 'Sessão autenticada obrigatória' using errcode = '28000';
  end if;
  if caller_id <> p_user_id then
    raise exception 'Processo não pertence ao usuário autenticado' using errcode = '42501';
  end if;
end;
$$;

create function horoteca_private.require_horoteca_owner(p_user_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  perform horoteca_private.require_authenticated_owner(p_user_id);
  if not exists (
    select 1
    from public.horoteca_user_roles role_assignment
    where role_assignment.user_id = p_user_id
      and role_assignment.role = 'owner'
  ) then
    raise exception 'Operação exclusiva do proprietário' using errcode = '42501';
  end if;
end;
$$;

create function horoteca_private.stage_for_status(p_status text)
returns text
language sql
immutable
security invoker
set search_path = ''
as $$
  select case
    when p_status in ('new', 'draft', 'submitted_for_review_01',
      'review_01_in_progress', 'review_01_corrections_requested') then 'review_01'
    when p_status in ('review_01_approved', 'submitted_for_review_02',
      'review_02_in_progress', 'review_02_corrections_requested') then 'review_02'
    when p_status in ('review_02_approved', 'submitted_for_review_03',
      'review_03_in_progress', 'review_03_corrections_requested') then 'review_03'
    when p_status in ('review_03_approved', 'awaiting_owner_approval',
      'owner_corrections_requested', 'owner_approved') then 'owner'
    when p_status in ('finalization_ready', 'finalizing', 'finalization_failed') then 'finalization'
    when p_status = 'completed' then 'completed'
    when p_status = 'cancelled' then 'cancelled'
    else 'intake'
  end
$$;

create or replace function horoteca_private.protect_source_document_identity()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.document_role = 'source_a' and (
    new.intake_id is distinct from old.intake_id
    or new.user_id is distinct from old.user_id
    or new.document_role is distinct from old.document_role
    or new.provider is distinct from old.provider
    or new.provider_file_id is distinct from old.provider_file_id
    or new.original_name is distinct from old.original_name
    or new.provider_created_at is distinct from old.provider_created_at
  ) then
    raise exception 'Documento A é logicamente imutável' using errcode = '55000';
  end if;

  if new.document_role = 'approved_b'
     and old.document_role <> 'approved_b'
     and current_user <> 'horoteca_intake_executor' then
    raise exception 'approved_b exige operação autorizada do proprietário'
      using errcode = '42501';
  end if;

  return new;
end;
$$;

-- Alterações relevantes feitas pelo cliente incrementam a versão de conteúdo
-- e invalidam o estado revisado. Operações internas suprimem este gatilho e
-- controlam a versão explicitamente.
create function horoteca_private.mark_intake_content_changed()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  affected_intake_id bigint := coalesce(new.intake_id, old.intake_id);
  caller_id uuid := (select auth.uid());
  intake_record public.watch_intakes%rowtype;
begin
  if caller_id is null or exists (
    select 1
    from horoteca_private.operation_context context
    where context.backend_pid = pg_backend_pid()
      and context.transaction_id = txid_current()
  ) then
    return coalesce(new, old);
  end if;

  select * into intake_record
  from public.watch_intakes
  where id = affected_intake_id
  for update;

  if not found or intake_record.user_id <> caller_id then
    raise exception 'Processo não pertence ao usuário autenticado' using errcode = '42501';
  end if;
  if intake_record.status in ('finalizing', 'completed', 'cancelled') then
    raise exception 'Processo em estado terminal não aceita alterações'
      using errcode = '55000';
  end if;

  update public.watch_intakes
  set version = version + 1,
      status = case
        when intake_record.status like 'review\_%\_in\_progress' escape '\'
          then intake_record.status
        else 'draft'
      end,
      current_stage = case
        when intake_record.status like 'review\_%\_in\_progress' escape '\'
          then intake_record.current_stage
        else 'review_01'
      end,
      owner_approved_at = null,
      finalization_error_code = null
  where id = intake_record.id;

  if intake_record.status <> 'draft'
     and intake_record.status not like 'review\_%\_in\_progress' escape '\' then
    insert into public.watch_intake_transitions (
      user_id, intake_id, from_status, to_status, intake_version,
      actor_id, actor_type, reason
    ) values (
      intake_record.user_id, intake_record.id, intake_record.status, 'draft',
      intake_record.version + 1, caller_id, 'user',
      'Conteúdo relevante alterado; revisões e aprovação anteriores ficaram desatualizadas'
    );
  end if;

  return coalesce(new, old);
end;
$$;

do $triggers$
declare
  target_table text;
begin
  foreach target_table in array array[
    'watch_intake_documents',
    'watch_intake_items',
    'watch_intake_acquisitions',
    'watch_intake_expenses',
    'watch_intake_expense_allocations',
    'watch_intake_sources',
    'watch_intake_claims',
    'watch_intake_photos',
    'watch_intake_photo_links'
  ]
  loop
    execute format(
      'create trigger %I_content_changed after insert or update or delete on public.%I for each row execute function horoteca_private.mark_intake_content_changed()',
      target_table, target_table
    );
  end loop;
end;
$triggers$;

create function horoteca_private.protect_revision_control_fields()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if current_user = 'authenticated' and (
    new.status is distinct from old.status
    or new.reviewed_intake_version is distinct from old.reviewed_intake_version
    or new.checklist_result is distinct from old.checklist_result
    or new.opinion is distinct from old.opinion
    or new.immutable_snapshot is distinct from old.immutable_snapshot
    or new.snapshot_hash is distinct from old.snapshot_hash
    or new.completed_at is distinct from old.completed_at
    or new.decision_at is distinct from old.decision_at
  ) then
    raise exception 'Conclusão de revisão exige operação autorizada'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

create trigger watch_intake_revisions_protect_control_fields
before update on public.watch_intake_revisions
for each row execute function horoteca_private.protect_revision_control_fields();

create function public.transition_watch_intake(
  p_intake_id bigint,
  p_expected_version integer,
  p_to_status text,
  p_reason text default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  intake_record public.watch_intakes%rowtype;
  caller_id uuid := (select auth.uid());
begin
  insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current())
  on conflict do nothing;
  select * into intake_record
  from public.watch_intakes
  where id = p_intake_id
  for update;

  if not found then
    raise exception 'Processo não encontrado' using errcode = 'P0002';
  end if;
  perform horoteca_private.require_authenticated_owner(intake_record.user_id);
  if intake_record.version <> p_expected_version then
    raise exception 'Versão desatualizada: atual %, recebida %',
      intake_record.version, p_expected_version using errcode = '40001';
  end if;
  if intake_record.status in ('completed', 'cancelled') then
    raise exception 'Processo já encerrado' using errcode = '55000';
  end if;
  if p_to_status = 'cancelled' then
    perform horoteca_private.require_horoteca_owner(intake_record.user_id);
  elsif not exists (
    select 1
    from horoteca_private.allowed_intake_transitions allowed
    where allowed.from_status = intake_record.status
      and allowed.to_status = p_to_status
  ) then
    raise exception 'Transição inválida: % -> %', intake_record.status, p_to_status
      using errcode = '22023';
  end if;
  if p_to_status in ('owner_approved', 'finalization_ready', 'finalizing', 'completed') then
    perform horoteca_private.require_horoteca_owner(intake_record.user_id);
  end if;

  update public.watch_intakes
  set status = p_to_status,
      current_stage = horoteca_private.stage_for_status(p_to_status),
      submitted_at = case
        when p_to_status like 'submitted_for_review_%' then now()
        else submitted_at
      end,
      cancelled_at = case when p_to_status = 'cancelled' then now() else cancelled_at end
  where id = intake_record.id;

  insert into public.watch_intake_transitions (
    user_id, intake_id, from_status, to_status, intake_version,
    actor_id, actor_type, reason
  ) values (
    intake_record.user_id, intake_record.id, intake_record.status, p_to_status,
    intake_record.version, caller_id,
    case when public.is_horoteca_owner() then 'owner' else 'user' end,
    p_reason
  );

  delete from horoteca_private.operation_context
  where backend_pid = pg_backend_pid() and transaction_id = txid_current();
  return jsonb_build_object(
    'intake_id', intake_record.id,
    'from_status', intake_record.status,
    'to_status', p_to_status,
    'version', intake_record.version
  );
end;
$$;

create function public.start_watch_intake_revision(
  p_intake_id bigint,
  p_expected_version integer,
  p_revision_type smallint,
  p_source_document_id bigint,
  p_working_document_id bigint,
  p_execution_mode text,
  p_checklist_version text,
  p_agent_metadata jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  intake_record public.watch_intakes%rowtype;
  expected_status text := format('submitted_for_review_%s', lpad(p_revision_type::text, 2, '0'));
  progress_status text := format('review_%s_in_progress', lpad(p_revision_type::text, 2, '0'));
  next_pass integer;
  revision_id bigint;
  caller_id uuid := (select auth.uid());
begin
  insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current())
  on conflict do nothing;
  if p_revision_type not between 1 and 3 then
    raise exception 'Tipo de revisão inválido' using errcode = '22023';
  end if;

  select * into intake_record from public.watch_intakes
  where id = p_intake_id for update;
  if not found then raise exception 'Processo não encontrado' using errcode = 'P0002'; end if;
  perform horoteca_private.require_authenticated_owner(intake_record.user_id);
  if intake_record.version <> p_expected_version then
    raise exception 'Versão desatualizada' using errcode = '40001';
  end if;
  if intake_record.status <> expected_status then
    raise exception 'Revisão % não pode iniciar em %', p_revision_type, intake_record.status
      using errcode = '22023';
  end if;
  if not exists (
    select 1 from public.watch_intake_documents document
    where document.id = p_source_document_id
      and document.intake_id = intake_record.id
      and document.user_id = intake_record.user_id
      and document.document_role = 'source_a'
      and document.is_accessible
      and document.access_checked_at >= now() - interval '24 hours'
  ) then
    raise exception 'Documento A não está acessível ou não foi verificado nas últimas 24 horas'
      using errcode = '55000';
  end if;
  if p_working_document_id is not null and not exists (
    select 1 from public.watch_intake_documents document
    where document.id = p_working_document_id
      and document.intake_id = intake_record.id
      and document.user_id = intake_record.user_id
      and document.document_role = 'working_b'
      and document.is_accessible
      and document.access_checked_at >= now() - interval '24 hours'
  ) then
    raise exception 'Documento B de trabalho não está acessível' using errcode = '55000';
  end if;

  select coalesce(max(pass_number), 0) + 1 into next_pass
  from public.watch_intake_revisions
  where intake_id = intake_record.id and revision_type = p_revision_type;

  insert into public.watch_intake_revisions (
    user_id, intake_id, revision_type, pass_number, status,
    initial_intake_version, source_document_id, working_document_id,
    reviewer_id, execution_mode, agent_name, model_name, model_version,
    prompt_name, prompt_version, checklist_version
  ) values (
    intake_record.user_id, intake_record.id, p_revision_type, next_pass, 'started',
    intake_record.version, p_source_document_id, p_working_document_id,
    caller_id, p_execution_mode,
    p_agent_metadata ->> 'agent_name', p_agent_metadata ->> 'model_name',
    p_agent_metadata ->> 'model_version', p_agent_metadata ->> 'prompt_name',
    p_agent_metadata ->> 'prompt_version', p_checklist_version
  ) returning id into revision_id;

  update public.watch_intakes
  set status = progress_status,
      current_stage = format('review_%s', lpad(p_revision_type::text, 2, '0'))
  where id = intake_record.id;

  insert into public.watch_intake_transitions (
    user_id, intake_id, from_status, to_status, intake_version,
    actor_id, actor_type, reason, metadata
  ) values (
    intake_record.user_id, intake_record.id, intake_record.status, progress_status,
    intake_record.version, caller_id, 'user', 'Início de revisão',
    jsonb_build_object('revision_id', revision_id, 'revision_type', p_revision_type, 'pass_number', next_pass)
  );

  delete from horoteca_private.operation_context
  where backend_pid = pg_backend_pid() and transaction_id = txid_current();
  return jsonb_build_object('revision_id', revision_id, 'pass_number', next_pass,
    'status', progress_status, 'version', intake_record.version);
end;
$$;

create function public.complete_watch_intake_revision(
  p_revision_id bigint,
  p_expected_version integer,
  p_decision text,
  p_checklist_result jsonb,
  p_opinion text,
  p_snapshot jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  revision_record public.watch_intake_revisions%rowtype;
  intake_record public.watch_intakes%rowtype;
  target_status text;
  caller_id uuid := (select auth.uid());
begin
  insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current())
  on conflict do nothing;
  if p_decision not in ('approved', 'corrections_requested') then
    raise exception 'Decisão técnica inválida' using errcode = '22023';
  end if;
  if p_checklist_result is null or p_snapshot is null then
    raise exception 'Checklist e snapshot são obrigatórios' using errcode = '23502';
  end if;

  select * into revision_record from public.watch_intake_revisions
  where id = p_revision_id for update;
  if not found then raise exception 'Revisão não encontrada' using errcode = 'P0002'; end if;
  select * into intake_record from public.watch_intakes
  where id = revision_record.intake_id for update;
  perform horoteca_private.require_authenticated_owner(intake_record.user_id);
  if intake_record.version <> p_expected_version then
    raise exception 'Versão desatualizada' using errcode = '40001';
  end if;
  if revision_record.status <> 'started' then
    raise exception 'Revisão já concluída' using errcode = '55000';
  end if;
  if intake_record.status <> format('review_%s_in_progress', lpad(revision_record.revision_type::text, 2, '0')) then
    raise exception 'Estado do processo não corresponde à revisão' using errcode = '55000';
  end if;

  target_status := format(
    'review_%s_%s',
    lpad(revision_record.revision_type::text, 2, '0'),
    case when p_decision = 'approved' then 'approved' else 'corrections_requested' end
  );

  update public.watch_intake_revisions
  set status = p_decision,
      reviewed_intake_version = intake_record.version,
      checklist_result = p_checklist_result,
      opinion = p_opinion,
      immutable_snapshot = p_snapshot,
      snapshot_hash = md5(p_snapshot::text),
      completed_at = now(),
      decision_at = now()
  where id = revision_record.id;

  update public.watch_intakes
  set status = target_status,
      current_stage = format('review_%s', lpad(revision_record.revision_type::text, 2, '0'))
  where id = intake_record.id;

  insert into public.watch_intake_transitions (
    user_id, intake_id, from_status, to_status, intake_version,
    actor_id, actor_type, reason, metadata
  ) values (
    intake_record.user_id, intake_record.id, intake_record.status, target_status,
    intake_record.version, caller_id, 'user', p_opinion,
    jsonb_build_object('revision_id', revision_record.id, 'decision', p_decision)
  );

  delete from horoteca_private.operation_context
  where backend_pid = pg_backend_pid() and transaction_id = txid_current();
  return jsonb_build_object('revision_id', revision_record.id, 'status', target_status,
    'version', intake_record.version, 'snapshot_hash', md5(p_snapshot::text));
end;
$$;

create function public.recalculate_watch_intake_allocation(
  p_intake_id bigint,
  p_expected_version integer,
  p_expense_id bigint
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  intake_record public.watch_intakes%rowtype;
  expense_record public.watch_intake_expenses%rowtype;
  item_count integer;
  priced_item_count integer;
  individual_total numeric;
  rounded_total numeric;
  reconciliation_id bigint;
  old_status text;
  caller_id uuid := (select auth.uid());
begin
  insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current())
  on conflict do nothing;
  select * into intake_record from public.watch_intakes
  where id = p_intake_id for update;
  if not found then raise exception 'Processo não encontrado' using errcode = 'P0002'; end if;
  perform horoteca_private.require_authenticated_owner(intake_record.user_id);
  if intake_record.version <> p_expected_version then
    raise exception 'Versão desatualizada' using errcode = '40001';
  end if;
  if intake_record.status in ('finalizing', 'completed', 'cancelled') then
    raise exception 'Processo não aceita novo rateio' using errcode = '55000';
  end if;

  select * into expense_record from public.watch_intake_expenses
  where id = p_expense_id
    and intake_id = intake_record.id
    and user_id = intake_record.user_id
  for update;
  if not found then raise exception 'Despesa não encontrada' using errcode = 'P0002'; end if;
  if expense_record.amount_brl is null then
    raise exception 'Total documental em BRL é obrigatório para rateio' using errcode = '23502';
  end if;
  if expense_record.amount_brl < 0 then
    raise exception 'Total documental não pode ser negativo' using errcode = '22023';
  end if;

  delete from public.watch_intake_expense_allocations
  where expense_id = expense_record.id;

  select count(*) into item_count
  from public.watch_intake_items where intake_id = intake_record.id;
  if item_count = 0 then
    raise exception 'Processo sem itens' using errcode = '23514';
  end if;

  if not expense_record.is_shared then
    if expense_record.item_id is null then
      raise exception 'Despesa individual exige item' using errcode = '23514';
    end if;
    insert into public.watch_intake_expense_allocations (
      user_id, intake_id, expense_id, item_id, allocation_basis,
      allocation_weight, unrounded_amount_brl, rounded_up_amount_brl,
      reconciliation_adjustment_brl, final_amount_brl
    ) values (
      intake_record.user_id, intake_record.id, expense_record.id,
      expense_record.item_id, 'individual', 1, expense_record.amount_brl,
      expense_record.amount_brl, 0, expense_record.amount_brl
    );
  else
    select count(*), coalesce(sum(item_value), 0)
    into priced_item_count, individual_total
    from (
      select item.id,
        sum(coalesce(individual_expense.amount_brl, 0)) as item_value
      from public.watch_intake_items item
      left join public.watch_intake_expenses individual_expense
        on individual_expense.item_id = item.id
       and individual_expense.intake_id = item.intake_id
       and not individual_expense.is_shared
       and individual_expense.category = 'product'
      where item.intake_id = intake_record.id
      group by item.id
      having sum(coalesce(individual_expense.amount_brl, 0)) > 0
    ) priced;

    insert into public.watch_intake_expense_allocations (
      user_id, intake_id, expense_id, item_id, allocation_basis,
      allocation_weight, unrounded_amount_brl, rounded_up_amount_brl,
      reconciliation_adjustment_brl, final_amount_brl
    )
    select
      intake_record.user_id,
      intake_record.id,
      expense_record.id,
      item.id,
      case when priced_item_count = item_count and individual_total > 0
        then 'proportional' else 'equal' end,
      case when priced_item_count = item_count and individual_total > 0
        then item_values.item_value / individual_total else 1::numeric / item_count end,
      case when priced_item_count = item_count and individual_total > 0
        then expense_record.amount_brl * item_values.item_value / individual_total
        else expense_record.amount_brl / item_count end,
      ceil((case when priced_item_count = item_count and individual_total > 0
        then expense_record.amount_brl * item_values.item_value / individual_total
        else expense_record.amount_brl / item_count end) * 100) / 100,
      0,
      ceil((case when priced_item_count = item_count and individual_total > 0
        then expense_record.amount_brl * item_values.item_value / individual_total
        else expense_record.amount_brl / item_count end) * 100) / 100
    from public.watch_intake_items item
    left join lateral (
      select coalesce(sum(individual_expense.amount_brl), 0) as item_value
      from public.watch_intake_expenses individual_expense
      where individual_expense.item_id = item.id
        and individual_expense.intake_id = item.intake_id
        and not individual_expense.is_shared
        and individual_expense.category = 'product'
    ) item_values on true
    where item.intake_id = intake_record.id;

    select coalesce(sum(rounded_up_amount_brl), 0) into rounded_total
    from public.watch_intake_expense_allocations
    where expense_id = expense_record.id;

    select allocation.id into reconciliation_id
    from public.watch_intake_expense_allocations allocation
    join public.watch_intake_items item on item.id = allocation.item_id
    where allocation.expense_id = expense_record.id
    order by allocation.unrounded_amount_brl desc, item.item_sequence desc
    limit 1;

    update public.watch_intake_expense_allocations
    set reconciliation_adjustment_brl = expense_record.amount_brl - rounded_total,
        final_amount_brl = rounded_up_amount_brl + expense_record.amount_brl - rounded_total
    where id = reconciliation_id;
  end if;

  if (select sum(final_amount_brl)
      from public.watch_intake_expense_allocations
      where expense_id = expense_record.id) <> expense_record.amount_brl then
    raise exception 'Rateio não reconciliou com o total documental' using errcode = '23514';
  end if;

  old_status := intake_record.status;
  update public.watch_intakes
  set version = version + 1,
      status = 'draft',
      current_stage = 'review_01',
      owner_approved_at = null,
      finalization_error_code = null
  where id = intake_record.id;

  if old_status <> 'draft' then
    insert into public.watch_intake_transitions (
      user_id, intake_id, from_status, to_status, intake_version,
      actor_id, actor_type, reason, metadata
    ) values (
      intake_record.user_id, intake_record.id, old_status, 'draft',
      intake_record.version + 1, caller_id, 'user',
      'Rateio recalculado; revisões anteriores ficaram desatualizadas',
      jsonb_build_object('expense_id', expense_record.id)
    );
  end if;

  delete from horoteca_private.operation_context
  where backend_pid = pg_backend_pid() and transaction_id = txid_current();
  return jsonb_build_object(
    'expense_id', expense_record.id,
    'version', intake_record.version + 1,
    'allocation_method', (select min(allocation_basis)
      from public.watch_intake_expense_allocations where expense_id = expense_record.id),
    'allocated_total_brl', (select sum(final_amount_brl)
      from public.watch_intake_expense_allocations where expense_id = expense_record.id)
  );
end;
$$;

create function public.decide_watch_intake(
  p_intake_id bigint,
  p_expected_version integer,
  p_action text,
  p_document_b_id bigint,
  p_snapshot jsonb,
  p_notes text default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  intake_record public.watch_intakes%rowtype;
  target_status text;
  decision_id bigint;
  caller_id uuid := (select auth.uid());
begin
  insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current())
  on conflict do nothing;
  if p_action not in ('approve', 'request_correction', 'cancel') then
    raise exception 'Ação do proprietário inválida' using errcode = '22023';
  end if;
  if p_snapshot is null then
    raise exception 'Snapshot da decisão é obrigatório' using errcode = '23502';
  end if;

  select * into intake_record from public.watch_intakes
  where id = p_intake_id for update;
  if not found then raise exception 'Processo não encontrado' using errcode = 'P0002'; end if;
  perform horoteca_private.require_horoteca_owner(intake_record.user_id);
  if intake_record.version <> p_expected_version then
    raise exception 'Versão desatualizada' using errcode = '40001';
  end if;
  if intake_record.status in ('completed', 'cancelled') then
    raise exception 'Processo já encerrado' using errcode = '55000';
  end if;

  if p_action = 'cancel' then
    target_status := 'cancelled';
  else
    if intake_record.status <> 'awaiting_owner_approval' then
      raise exception 'Decisão exige awaiting_owner_approval' using errcode = '22023';
    end if;
    if p_action = 'approve' then
      if p_document_b_id is null or not exists (
        select 1 from public.watch_intake_documents document
        where document.id = p_document_b_id
          and document.intake_id = intake_record.id
          and document.user_id = intake_record.user_id
          and document.document_role = 'working_b'
          and document.is_accessible
          and document.access_checked_at >= now() - interval '24 hours'
      ) then
        raise exception 'Documento B acessível e atual é obrigatório' using errcode = '55000';
      end if;
      if exists (
        select required.revision_type
        from unnest(array[1, 2, 3]) required(revision_type)
        where not exists (
          select 1 from public.watch_intake_revisions revision
          where revision.intake_id = intake_record.id
            and revision.revision_type = required.revision_type
            and revision.status = 'approved'
            and revision.reviewed_intake_version = intake_record.version
        )
      ) then
        raise exception 'As três revisões válidas são obrigatórias' using errcode = '55000';
      end if;
      if exists (
        select 1 from public.watch_intake_findings finding
        where finding.intake_id = intake_record.id
          and finding.severity = 'blocking'
          and finding.status not in ('resolved', 'superseded')
      ) then
        raise exception 'Existem findings bloqueantes' using errcode = '55000';
      end if;
      target_status := 'owner_approved';
    else
      if nullif(btrim(coalesce(p_notes, '')), '') is null then
        raise exception 'Motivo da correção é obrigatório' using errcode = '23502';
      end if;
      target_status := 'owner_corrections_requested';
    end if;
  end if;

  insert into public.watch_intake_owner_decisions (
    user_id, intake_id, action, decided_by, intake_version,
    document_b_id, immutable_snapshot, snapshot_hash, notes
  ) values (
    intake_record.user_id, intake_record.id, p_action, caller_id,
    intake_record.version, p_document_b_id, p_snapshot, md5(p_snapshot::text), p_notes
  ) returning id into decision_id;

  if p_action = 'approve' then
    update public.watch_intake_documents
    set document_role = 'approved_b',
        display_name = coalesce(display_name, original_name)
    where id = p_document_b_id;
  end if;

  update public.watch_intakes
  set status = target_status,
      current_stage = horoteca_private.stage_for_status(target_status),
      owner_approved_at = case when p_action = 'approve' then now() else null end,
      cancelled_at = case when p_action = 'cancel' then now() else cancelled_at end
  where id = intake_record.id;

  insert into public.watch_intake_transitions (
    user_id, intake_id, from_status, to_status, intake_version,
    actor_id, actor_type, reason, metadata
  ) values (
    intake_record.user_id, intake_record.id, intake_record.status, target_status,
    intake_record.version, caller_id, 'owner', p_notes,
    jsonb_build_object('decision_id', decision_id, 'action', p_action)
  );

  delete from horoteca_private.operation_context
  where backend_pid = pg_backend_pid() and transaction_id = txid_current();
  return jsonb_build_object('decision_id', decision_id, 'status', target_status,
    'version', intake_record.version, 'snapshot_hash', md5(p_snapshot::text));
end;
$$;

create function public.finalize_watch_intake(
  p_intake_id bigint,
  p_expected_version integer,
  p_idempotency_key uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  intake_record public.watch_intakes%rowtype;
  existing_finalization public.watch_intake_finalizations%rowtype;
  acquisition_record public.watch_intake_acquisitions%rowtype;
  item_record public.watch_intake_items%rowtype;
  expense_record public.watch_intake_expenses%rowtype;
  allocation_record public.watch_intake_expense_allocations%rowtype;
  source_record public.watch_intake_sources%rowtype;
  claim_record public.watch_intake_claims%rowtype;
  photo_record public.watch_intake_photos%rowtype;
  photo_link_record public.watch_intake_photo_links%rowtype;
  staging_acquisition_id bigint;
  canonical_acquisition_id bigint;
  canonical_watch_id bigint;
  canonical_expense_id bigint;
  canonical_source_id bigint;
  canonical_photo_id bigint;
  finalization_id bigint;
  final_code text;
  result_payload jsonb := jsonb_build_object('intake_id', p_intake_id, 'watches', '[]'::jsonb);
  failure_state text;
  failure_message text;
  finalization_from_status text;
  caller_id uuid := (select auth.uid());
begin
  if p_idempotency_key is null then
    raise exception 'Chave de idempotência é obrigatória' using errcode = '23502';
  end if;
  insert into horoteca_private.operation_context values (pg_backend_pid(), txid_current())
  on conflict do nothing;
  select * into existing_finalization
  from public.watch_intake_finalizations
  where idempotency_key = p_idempotency_key;
  if found and existing_finalization.intake_id <> p_intake_id then
    raise exception 'Chave de idempotência já pertence a outro processo'
      using errcode = '23505';
  end if;
  if found and existing_finalization.status = 'completed' then
    delete from horoteca_private.operation_context
    where backend_pid = pg_backend_pid() and transaction_id = txid_current();
    return existing_finalization.result;
  end if;

  select * into intake_record from public.watch_intakes
  where id = p_intake_id for update;
  if not found then raise exception 'Processo não encontrado' using errcode = 'P0002'; end if;
  perform horoteca_private.require_horoteca_owner(intake_record.user_id);

  -- Uma segunda chamada concorrente aguarda o lock e então reutiliza o mesmo resultado.
  select * into existing_finalization
  from public.watch_intake_finalizations
  where idempotency_key = p_idempotency_key;
  if found and existing_finalization.status = 'completed' then
    delete from horoteca_private.operation_context
    where backend_pid = pg_backend_pid() and transaction_id = txid_current();
    return existing_finalization.result;
  end if;
  if intake_record.version <> p_expected_version then
    raise exception 'Versão desatualizada' using errcode = '40001';
  end if;
  if intake_record.status not in ('finalization_ready', 'finalization_failed') then
    raise exception 'Processo não está pronto para finalização' using errcode = '22023';
  end if;

  if not exists (
    select 1 from public.watch_intake_documents document
    where document.intake_id = intake_record.id
      and document.document_role = 'source_a'
      and document.is_accessible
      and document.access_checked_at >= now() - interval '24 hours'
  ) or not exists (
    select 1 from public.watch_intake_documents document
    where document.intake_id = intake_record.id
      and document.document_role = 'approved_b'
      and document.is_accessible
      and document.access_checked_at >= now() - interval '24 hours'
  ) then
    raise exception 'Documentos A e B aprovados precisam estar acessíveis e verificados'
      using errcode = '55000';
  end if;
  if exists (
    select required.revision_type
    from unnest(array[1, 2, 3]) required(revision_type)
    where not exists (
      select 1 from public.watch_intake_revisions revision
      where revision.intake_id = intake_record.id
        and revision.revision_type = required.revision_type
        and revision.status = 'approved'
        and revision.reviewed_intake_version = intake_record.version
    )
  ) then
    raise exception 'Finalização exige três revisões válidas para a versão atual'
      using errcode = '55000';
  end if;
  if not exists (
    select 1 from public.watch_intake_owner_decisions decision
    where decision.intake_id = intake_record.id
      and decision.action = 'approve'
      and decision.intake_version = intake_record.version
  ) then
    raise exception 'Aprovação do proprietário não corresponde à versão atual'
      using errcode = '55000';
  end if;
  if exists (
    select 1 from public.watch_intake_findings finding
    where finding.intake_id = intake_record.id
      and finding.severity = 'blocking'
      and finding.status not in ('resolved', 'superseded')
  ) then
    raise exception 'Existem findings bloqueantes' using errcode = '55000';
  end if;
  if not exists (select 1 from public.watch_intake_items item where item.intake_id = intake_record.id) then
    raise exception 'Processo sem itens' using errcode = '23514';
  end if;
  if exists (
    select 1 from public.watch_intake_items item
    where item.intake_id = intake_record.id
      and ('ambiguous' in (item.brand_match_status, item.model_match_status, item.caliber_match_status)
        or item.final_watch_id is not null)
  ) then
    raise exception 'Item ambíguo ou já finalizado' using errcode = '55000';
  end if;
  if exists (
    select 1 from public.watch_intake_acquisitions acquisition
    where acquisition.intake_id = intake_record.id
      and (
        acquisition.match_status not in ('exact_match', 'explicit_new')
        or acquisition.match_status = 'exact_match' and acquisition.candidate_acquisition_id is null
        or nullif(btrim(acquisition.order_number), '') is null
      )
  ) then
    raise exception 'Aquisições exigem pedido e decisão explícita de match'
      using errcode = '55000';
  end if;
  if not exists (
    select 1 from public.watch_intake_acquisitions acquisition
    where acquisition.intake_id = intake_record.id
  ) then
    raise exception 'Processo sem aquisição estruturada' using errcode = '23514';
  end if;
  if exists (
    select 1 from public.watch_intake_expenses expense
    where expense.intake_id = intake_record.id
      and (expense.currency is null or expense.amount_original is null)
  ) then
    raise exception 'Despesas exigem moeda e valor documental original'
      using errcode = '23514';
  end if;
  if exists (
    select 1 from public.watch_intake_expenses expense
    where expense.intake_id = intake_record.id
      and expense.is_shared
      and (
        expense.amount_brl is null
        or expense.amount_brl <> coalesce((
          select sum(allocation.final_amount_brl)
          from public.watch_intake_expense_allocations allocation
          where allocation.expense_id = expense.id
        ), -1)
      )
  ) then
    raise exception 'Rateio compartilhado não reconcilia com o total documental'
      using errcode = '23514';
  end if;
  if exists (
    select 1
    from public.watch_intake_photo_links link
    join public.watch_intake_photos photo on photo.id = link.photo_id
    where link.intake_id = intake_record.id
      and link.relation_type in ('display', 'cover')
      and (photo.copy_status <> 'copied' or photo.storage_path is null)
  ) then
    raise exception 'Foto de exibição precisa de cópia confirmada no Storage'
      using errcode = '55000';
  end if;

  if existing_finalization.id is not null and existing_finalization.status = 'failed' then
    update public.watch_intake_finalizations
    set status = 'running', started_at = now(), completed_at = null,
        result = null, error_code = null, error_summary = null
    where id = existing_finalization.id
    returning id into finalization_id;
  else
    insert into public.watch_intake_finalizations (
      user_id, intake_id, idempotency_key, requested_intake_version,
      status, requested_by, started_at
    ) values (
      intake_record.user_id, intake_record.id, p_idempotency_key,
      intake_record.version, 'running', caller_id, now()
    ) returning id into finalization_id;
  end if;

  finalization_from_status := intake_record.status;
  if intake_record.status = 'finalization_failed' then
    insert into public.watch_intake_transitions (
      user_id, intake_id, from_status, to_status, intake_version,
      actor_id, actor_type, reason, metadata
    ) values (
      intake_record.user_id, intake_record.id, 'finalization_failed',
      'finalization_ready', intake_record.version, caller_id, 'owner',
      'Repetição autorizada da mesma finalização idempotente',
      jsonb_build_object('finalization_id', finalization_id)
    );
    finalization_from_status := 'finalization_ready';
  end if;

  update public.watch_intakes
  set status = 'finalizing', current_stage = 'finalization',
      finalization_key = p_idempotency_key,
      finalization_started_at = now(), finalization_error_code = null
  where id = intake_record.id;

  insert into public.watch_intake_transitions (
    user_id, intake_id, from_status, to_status, intake_version,
    actor_id, actor_type, reason, metadata
  ) values (
    intake_record.user_id, intake_record.id, finalization_from_status, 'finalizing',
    intake_record.version, caller_id, 'owner', 'Finalização transacional iniciada',
    jsonb_build_object('finalization_id', finalization_id, 'idempotency_key', p_idempotency_key)
  );

  begin
    create temporary table if not exists pg_temp.intake_acquisition_map (
      staging_id bigint primary key,
      canonical_id bigint not null
    ) on commit drop;
    create temporary table if not exists pg_temp.intake_watch_map (
      staging_id bigint primary key,
      canonical_id bigint not null
    ) on commit drop;
    create temporary table if not exists pg_temp.intake_source_map (
      staging_id bigint primary key,
      canonical_id bigint not null
    ) on commit drop;
    truncate pg_temp.intake_acquisition_map, pg_temp.intake_watch_map, pg_temp.intake_source_map;

    for acquisition_record in
      select * from public.watch_intake_acquisitions
      where intake_id = intake_record.id order by id
    loop
      if acquisition_record.match_status = 'exact_match' then
        if not exists (
          select 1 from public.acquisitions canonical
          where canonical.id = acquisition_record.candidate_acquisition_id
            and canonical.user_id = intake_record.user_id
        ) then
          raise exception 'Aquisição canônica candidata não pertence ao usuário';
        end if;
        canonical_acquisition_id := acquisition_record.candidate_acquisition_id;
      else
        insert into public.acquisitions (
          user_id, marketplace, seller_name, order_number, purchase_date,
          purchase_payment_date, taxes_payment_date, shipped_date,
          estimated_delivery_date, received_date, payment_method, carrier,
          tracking_number, source_document_url, source_document_name, notes
        )
        select
          intake_record.user_id, acquisition_record.marketplace,
          acquisition_record.seller_name, acquisition_record.order_number,
          acquisition_record.purchase_date, acquisition_record.purchase_payment_date,
          acquisition_record.taxes_payment_date, acquisition_record.shipped_date,
          acquisition_record.estimated_delivery_date, acquisition_record.received_date,
          acquisition_record.payment_method, acquisition_record.carrier,
          acquisition_record.tracking_number, document.url, document.original_name,
          acquisition_record.notes
        from public.watch_intake_documents document
        where document.id = acquisition_record.source_document_id
        union all
        select intake_record.user_id, acquisition_record.marketplace,
          acquisition_record.seller_name, acquisition_record.order_number,
          acquisition_record.purchase_date, acquisition_record.purchase_payment_date,
          acquisition_record.taxes_payment_date, acquisition_record.shipped_date,
          acquisition_record.estimated_delivery_date, acquisition_record.received_date,
          acquisition_record.payment_method, acquisition_record.carrier,
          acquisition_record.tracking_number, null, null, acquisition_record.notes
        where acquisition_record.source_document_id is null
        returning id into canonical_acquisition_id;
      end if;
      insert into pg_temp.intake_acquisition_map values (
        acquisition_record.id, canonical_acquisition_id
      );
    end loop;

    for item_record in
      select * from public.watch_intake_items
      where intake_id = intake_record.id order by item_sequence
    loop
      staging_acquisition_id := item_record.acquisition_id;
      if staging_acquisition_id is null then
        select case when count(*) = 1 then min(id) end into staging_acquisition_id
        from public.watch_intake_acquisitions where intake_id = intake_record.id;
      end if;
      if staging_acquisition_id is null then
        raise exception 'Item % não possui aquisição inequívoca', item_record.item_sequence;
      end if;
      select canonical_id into canonical_acquisition_id
      from pg_temp.intake_acquisition_map where staging_id = staging_acquisition_id;
      if canonical_acquisition_id is null then
        raise exception 'Aquisição do item % não foi promovida', item_record.item_sequence;
      end if;

      select case
        when count(*) = 1 then min(acquisition.order_number)
        else min(acquisition.order_number) || '-' ||
          coalesce(item_record.order_item_number, item_record.item_sequence)::text
      end into final_code
      from public.watch_intake_items sibling
      join public.watch_intake_acquisitions acquisition
        on acquisition.id = coalesce(sibling.acquisition_id, staging_acquisition_id)
      where sibling.intake_id = intake_record.id
        and coalesce(sibling.acquisition_id, staging_acquisition_id) = staging_acquisition_id;

      if nullif(btrim(final_code), '') is null then
        raise exception 'Item % não possui identificador canônico por pedido', item_record.item_sequence;
      end if;
      if item_record.candidate_horoteca_code is not null
         and item_record.candidate_horoteca_code <> final_code then
        raise exception 'Código candidato % diverge do código derivado %',
          item_record.candidate_horoteca_code, final_code;
      end if;

      select * into acquisition_record
      from public.watch_intake_acquisitions where id = staging_acquisition_id;

      insert into public.watches (
        user_id, horoteca_code, brand, model, reference_number, movement_type,
        serial_number, case_code, dial_code, brand_id, watch_model_id,
        movement_caliber_id, movement_caliber, order_number, order_item_number,
        marketplace, marketplace_item_id, seller_name, purchase_date,
        payment_method, source_document_url, notes
      ) values (
        intake_record.user_id, final_code, item_record.candidate_brand,
        item_record.candidate_model, item_record.candidate_reference_number,
        item_record.candidate_movement_type, item_record.candidate_serial_number,
        item_record.candidate_case_code, item_record.candidate_dial_code,
        case when item_record.brand_match_status = 'exact_match'
          then item_record.candidate_brand_id end,
        case when item_record.model_match_status = 'exact_match'
          then item_record.candidate_watch_model_id end,
        case when item_record.caliber_match_status = 'exact_match'
          then item_record.candidate_movement_caliber_id end,
        item_record.candidate_watch_data ->> 'movement_caliber',
        acquisition_record.order_number, item_record.order_item_number,
        acquisition_record.marketplace, item_record.marketplace_item_id,
        acquisition_record.seller_name, acquisition_record.purchase_date,
        acquisition_record.payment_method,
        (select url from public.watch_intake_documents
          where intake_id = intake_record.id and document_role = 'source_a'),
        item_record.candidate_watch_data ->> 'notes'
      ) returning id into canonical_watch_id;

      insert into public.acquisition_items (
        user_id, acquisition_id, watch_id, item_sequence,
        marketplace_item_id, visual_position, notes
      ) values (
        intake_record.user_id, canonical_acquisition_id, canonical_watch_id,
        item_record.item_sequence, item_record.marketplace_item_id,
        item_record.visual_position, item_record.candidate_watch_data ->> 'listing_notes'
      );

      update public.watch_intake_items
      set final_watch_id = canonical_watch_id,
          final_horoteca_code = final_code,
          finalized_at = now()
      where id = item_record.id;

      insert into pg_temp.intake_watch_map values (item_record.id, canonical_watch_id);
      result_payload := jsonb_set(
        result_payload,
        '{watches}',
        (result_payload -> 'watches') || jsonb_build_array(jsonb_build_object(
          'item_id', item_record.id,
          'watch_id', canonical_watch_id,
          'horoteca_code', final_code,
          'acquisition_id', canonical_acquisition_id
        ))
      );
    end loop;

    for expense_record in
      select * from public.watch_intake_expenses
      where intake_id = intake_record.id order by id
    loop
      canonical_acquisition_id := null;
      canonical_watch_id := null;
      if expense_record.acquisition_id is not null then
        select canonical_id into canonical_acquisition_id
        from pg_temp.intake_acquisition_map where staging_id = expense_record.acquisition_id;
      end if;
      if expense_record.item_id is not null then
        select canonical_id into canonical_watch_id
        from pg_temp.intake_watch_map where staging_id = expense_record.item_id;
      end if;
      insert into public.expenses (
        user_id, acquisition_id, watch_id, category, description, expense_date,
        currency, amount_original, exchange_rate, amount_brl, is_shared,
        allocation_method, source_reference, notes
      ) values (
        intake_record.user_id, canonical_acquisition_id, canonical_watch_id,
        expense_record.category, expense_record.description, expense_record.expense_date,
        expense_record.currency, expense_record.amount_original,
        expense_record.exchange_rate, expense_record.amount_brl,
        expense_record.is_shared, expense_record.allocation_method,
        expense_record.source_reference, expense_record.notes
      ) returning id into canonical_expense_id;

      for allocation_record in
        select * from public.watch_intake_expense_allocations
        where expense_id = expense_record.id order by id
      loop
        select canonical_id into canonical_watch_id
        from pg_temp.intake_watch_map where staging_id = allocation_record.item_id;
        insert into public.expense_allocations (
          user_id, expense_id, watch_id, amount_brl_allocated,
          rounding_adjustment_brl, allocation_basis
        ) values (
          intake_record.user_id, canonical_expense_id, canonical_watch_id,
          allocation_record.final_amount_brl,
          allocation_record.reconciliation_adjustment_brl,
          allocation_record.allocation_basis
        );
      end loop;
    end loop;

    for source_record in
      select * from public.watch_intake_sources
      where intake_id = intake_record.id order by id
    loop
      canonical_watch_id := null;
      if source_record.item_id is not null then
        select canonical_id into canonical_watch_id
        from pg_temp.intake_watch_map where staging_id = source_record.item_id;
      end if;
      insert into public.watch_sources (
        user_id, watch_id, source_type, source_name, source_url,
        evidence_classification, confidence_percent, excerpt, notes, accessed_at
      ) values (
        intake_record.user_id, canonical_watch_id, source_record.source_type,
        source_record.title, source_record.url, source_record.evidence_classification,
        source_record.confidence_percent, source_record.excerpt,
        source_record.notes, source_record.accessed_at::date
      ) returning id into canonical_source_id;
      insert into pg_temp.intake_source_map values (source_record.id, canonical_source_id);
    end loop;

    for claim_record in
      select * from public.watch_intake_claims
      where intake_id = intake_record.id order by id
    loop
      if claim_record.item_id is null then
        raise exception 'Claim % precisa estar vinculada a um item', claim_record.id;
      end if;
      select canonical_id into canonical_watch_id
      from pg_temp.intake_watch_map where staging_id = claim_record.item_id;
      canonical_source_id := null;
      if claim_record.source_id is not null then
        select canonical_id into canonical_source_id
        from pg_temp.intake_source_map where staging_id = claim_record.source_id;
      end if;
      insert into public.watch_claims (
        user_id, watch_id, source_id, field_name, asserted_value,
        normalized_value, evidence_classification, verification_status,
        confidence_percent, claim_context, reviewed_at
      ) values (
        intake_record.user_id, canonical_watch_id, canonical_source_id,
        claim_record.field_name, claim_record.asserted_value,
        claim_record.normalized_value::text, claim_record.evidence_classification,
        claim_record.verification_status, claim_record.confidence_percent,
        claim_record.context, now()
      );
    end loop;

    for photo_record in
      select * from public.watch_intake_photos
      where intake_id = intake_record.id
        and copy_status = 'copied' and storage_path is not null
      order by id
    loop
      select map.canonical_id into canonical_watch_id
      from public.watch_intake_photo_links link
      join pg_temp.intake_watch_map map on map.staging_id = link.item_id
      where link.photo_id = photo_record.id
      order by link.id limit 1;
      insert into public.watch_photos (
        user_id, watch_id, storage_path, caption, is_cover, sort_order,
        photo_type, source_type, source_url, evidence_classification, notes
      ) values (
        intake_record.user_id, canonical_watch_id, photo_record.storage_path,
        photo_record.notes,
        exists (select 1 from public.watch_intake_photo_links link
          where link.photo_id = photo_record.id and link.relation_type = 'cover'),
        coalesce(photo_record.display_order, 0), photo_record.origin_type,
        photo_record.provider, photo_record.original_url,
        photo_record.evidence_classification, photo_record.notes
      ) returning id into canonical_photo_id;

      for photo_link_record in
        select * from public.watch_intake_photo_links
        where photo_id = photo_record.id order by id
      loop
        select canonical_id into canonical_watch_id
        from pg_temp.intake_watch_map where staging_id = photo_link_record.item_id;
        insert into public.watch_photo_links (
          user_id, photo_id, watch_id, visual_position, notes
        ) values (
          intake_record.user_id, canonical_photo_id, canonical_watch_id,
          photo_record.visual_position, photo_link_record.relation_type
        );
      end loop;
    end loop;

    result_payload := result_payload || jsonb_build_object(
      'finalization_id', finalization_id,
      'idempotency_key', p_idempotency_key,
      'completed_at', now()
    );

    update public.watch_intake_finalizations
    set status = 'completed', completed_at = now(), result = result_payload
    where id = finalization_id;
    update public.watch_intakes
    set status = 'completed', current_stage = 'completed', finalized_at = now(),
        finalization_error_code = null
    where id = intake_record.id;
    insert into public.watch_intake_transitions (
      user_id, intake_id, from_status, to_status, intake_version,
      actor_id, actor_type, reason, metadata
    ) values (
      intake_record.user_id, intake_record.id, 'finalizing', 'completed',
      intake_record.version, caller_id, 'owner', 'Finalização transacional concluída',
      result_payload
    );
    delete from horoteca_private.operation_context
    where backend_pid = pg_backend_pid() and transaction_id = txid_current();
    return result_payload;
  exception
    when others then
      get stacked diagnostics failure_state = returned_sqlstate,
        failure_message = message_text;
  end;

  update public.watch_intake_finalizations
  set status = 'failed', completed_at = now(), error_code = failure_state,
      error_summary = left(failure_message, 500)
  where id = finalization_id;
  update public.watch_intakes
  set status = 'finalization_failed', current_stage = 'finalization',
      finalization_error_code = failure_state
  where id = intake_record.id;
  insert into public.watch_intake_transitions (
    user_id, intake_id, from_status, to_status, intake_version,
    actor_id, actor_type, reason, metadata
  ) values (
    intake_record.user_id, intake_record.id, 'finalizing', 'finalization_failed',
    intake_record.version, caller_id, 'owner', 'Finalização revertida integralmente',
    jsonb_build_object('finalization_id', finalization_id, 'error_code', failure_state)
  );
  delete from horoteca_private.operation_context
  where backend_pid = pg_backend_pid() and transaction_id = txid_current();
  return jsonb_build_object(
    'intake_id', intake_record.id,
    'finalization_id', finalization_id,
    'status', 'failed',
    'error_code', failure_state,
    'error_summary', left(failure_message, 500)
  );
end;
$$;

-- As RPCs públicas executam com um papel interno de privilégio mínimo. Esse
-- papel não ignora RLS, não faz login e não possui CREATE após a instalação.
grant horoteca_intake_executor to postgres;
grant create on schema public to horoteca_intake_executor;
alter function public.transition_watch_intake(bigint, integer, text, text)
  owner to horoteca_intake_executor;
alter function public.start_watch_intake_revision(
  bigint, integer, smallint, bigint, bigint, text, text, jsonb
) owner to horoteca_intake_executor;
alter function public.complete_watch_intake_revision(
  bigint, integer, text, jsonb, text, jsonb
) owner to horoteca_intake_executor;
alter function public.recalculate_watch_intake_allocation(bigint, integer, bigint)
  owner to horoteca_intake_executor;
alter function public.decide_watch_intake(bigint, integer, text, bigint, jsonb, text)
  owner to horoteca_intake_executor;
alter function public.finalize_watch_intake(bigint, integer, uuid)
  owner to horoteca_intake_executor;
revoke create on schema public from horoteca_intake_executor;
revoke horoteca_intake_executor from postgres;

revoke all on function public.transition_watch_intake(bigint, integer, text, text)
  from public, anon;
revoke all on function public.start_watch_intake_revision(
  bigint, integer, smallint, bigint, bigint, text, text, jsonb
) from public, anon;
revoke all on function public.complete_watch_intake_revision(
  bigint, integer, text, jsonb, text, jsonb
) from public, anon;
revoke all on function public.recalculate_watch_intake_allocation(bigint, integer, bigint)
  from public, anon;
revoke all on function public.decide_watch_intake(bigint, integer, text, bigint, jsonb, text)
  from public, anon;
revoke all on function public.finalize_watch_intake(bigint, integer, uuid)
  from public, anon;

grant execute on function public.transition_watch_intake(bigint, integer, text, text)
  to authenticated;
grant execute on function public.start_watch_intake_revision(
  bigint, integer, smallint, bigint, bigint, text, text, jsonb
) to authenticated;
grant execute on function public.complete_watch_intake_revision(
  bigint, integer, text, jsonb, text, jsonb
) to authenticated;
grant execute on function public.recalculate_watch_intake_allocation(bigint, integer, bigint)
  to authenticated;
grant execute on function public.decide_watch_intake(bigint, integer, text, bigint, jsonb, text)
  to authenticated;
grant execute on function public.finalize_watch_intake(bigint, integer, uuid)
  to authenticated;

grant execute on function public.is_horoteca_owner() to horoteca_intake_executor;
revoke all on all functions in schema horoteca_private from public, anon, authenticated;
grant execute on function horoteca_private.require_authenticated_owner(uuid),
  horoteca_private.require_horoteca_owner(uuid),
  horoteca_private.stage_for_status(text)
to horoteca_intake_executor;
