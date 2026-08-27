# Teste automatizado da baseline Supabase

`validate_baseline.sql` é uma fotografia executável do catálogo verificado em
26/08/2026. O teste consulta `pg_catalog` e `information_schema` e interrompe a
execução quando encontra qualquer divergência nas tabelas, 292 colunas,
constraints, índices, função, triggers, RLS, políticas, grants ou configuração
do Storage. Ele também confirma que as tabelas públicas e `storage.objects` não
contêm dados operacionais.

As definições de primary keys, foreign keys e constraints `UNIQUE` são
comparadas textualmente. Para constraints `CHECK`, o teste cria somente tabelas
temporárias em `pg_temp` com `LIKE` da tabela pública correspondente, reaplica a
expressão esperada e lê novamente `pg_get_constraintdef`. Assim, a definição
esperada e a reconstruída são renderizadas pelo mesmo parser PostgreSQL local,
eliminando diferenças cosméticas de parênteses entre versões sem ignorar ou
reescrever a semântica do `CHECK`.

Os 60 índices reais são validados sem as duplicações que foreign keys podem
produzir ao apontar `conindid` para índices da tabela referenciada. O vínculo
com uma constraint exige também a mesma tabela e apenas tipos PK, `UNIQUE` ou
exclusion. Para comparar definições, o teste recria cada índice sobre uma tabela
`LIKE` exclusivamente em `pg_temp` e extrai, com o PostgreSQL local, método de
acesso, posições e expressões, predicado, opclasses, collations, opções e
unicidade. Isso preserva a validação sem depender da renderização textual
integral de `pg_get_indexdef` entre versões.

O projeto remoto verificado registra `storage.buckets.versioning_status` como
`disabled`, mas essa coluna ainda não existe na stack local estável usada pela
CI. A baseline detecta a coluna pelo catálogo: quando disponível, grava e exige
o valor desativado; quando ausente, cria o mesmo bucket sem referenciar a coluna
e o teste emite um `NOTICE` sobre essa limitação local. Esse caminho compatível
mantém o versionamento desativado e não cria colunas nem modifica o schema
`storage`, que é gerenciado pelo Supabase.

A rotina oficial está em
`.github/workflows/validate-supabase-baseline.yml`. Ela cria uma configuração
Supabase nova dentro de `$RUNNER_TEMP`, inicia apenas os serviços locais, aplica
a baseline uma única vez com `ON_ERROR_STOP`, executa este teste e roda
`supabase db lint --local --level error`. A etapa final usa `always()` para parar
o stack sem backup e remover os arquivos e volumes descartáveis.

O workflow não executa `supabase link` nem `supabase db push`, não usa secrets e
não precisa de `SUPABASE_ACCESS_TOKEN`, `PROJECT_ID` ou project ref. A conexão
PostgreSQL usada é exclusivamente a porta local padrão do stack descartável
(`127.0.0.1:54322`). Não execute este teste contra o projeto oficial ou outro
banco remoto.

Para diagnóstico local, somente em um ambiente descartável compatível já
iniciado, use:

```sh
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" \
  --no-psqlrc --set=ON_ERROR_STOP=1 \
  --file=supabase/baseline/tests/validate_baseline.sql
```

O teste não insere dados: as únicas estruturas temporárias criadas pertencem a
`pg_temp` e desaparecem ao encerrar a sessão.
