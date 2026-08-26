# Baseline do esquema Supabase da Horoteca

Este diretório contém uma fotografia SQL integral do esquema verificado em
26/08/2026. O arquivo `20260826_horoteca_schema_baseline.sql` destina-se
**exclusivamente à reconstrução de um projeto Supabase vazio e compatível**.
Ele não é uma migration incremental, não pertence a `supabase/migrations/` e
não deve ser aplicado ao projeto oficial `nlkhbhgzscpdistzuyod`.

## Conteúdo

A baseline reconstrói as 14 tabelas de `public`, suas identities e sequences,
constraints, índices, a função `set_updated_at()`, nove triggers, RLS, quatro
políticas por tabela, grants mínimos para `authenticated` e o bucket privado
`watch-photos` com suas quatro políticas. Não contém usuários, UUIDs, relógios,
dados operacionais, segredos nem valores correntes das sequences.

As definições vêm prioritariamente do catálogo sanitizado em
`docs/SUPABASE_CATALOGO_VERIFICADO_2026-08-26.md`. As precisões de `numeric`
que a representação de colunas do catálogo apresenta apenas como `numeric`
foram preservadas a partir das migrations já aplicadas; os campos legados que
o catálogo registra sem modificador continuam como `numeric`, sem inferência.

## Uso seguro e reprodução

1. Revise o SQL e a validação documentada antes de qualquer uso.
2. Crie um projeto Supabase **descartável, vazio e compatível**.
3. Execute o arquivo uma única vez nesse ambiente descartável com um papel
   administrativo apto a criar objetos em `public` e configurar Storage.
4. Extraia novamente o catálogo com as consultas somente leitura documentadas
   em `docs/SUPABASE_BASELINE_RECONSTRUCAO.md`.
5. Compare tabelas, colunas, nulabilidade, defaults, identities, constraints,
   índices, função, triggers, RLS, políticas, grants, sequences e Storage com o
   catálogo verificado.
6. Descarte o ambiente de teste. Não promova automaticamente o resultado e não
   aplique a baseline sobre um banco que já contenha o esquema.

A execução em um banco não vazio falhará intencionalmente em vez de substituir
objetos. O arquivo não contém `DROP`, `TRUNCATE`, `DELETE` ou alteração de dados
existentes.
