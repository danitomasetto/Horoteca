-- Ativa RLS na tabela privada que possui uma política para o executor interno.

alter table horoteca_private.allowed_intake_transitions
  enable row level security;
