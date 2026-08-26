# Teste automatizado da baseline Supabase

`validate_baseline.sql` é uma fotografia executável do catálogo verificado em
26/08/2026. O teste consulta `pg_catalog` e `information_schema` e interrompe a
execução quando encontra qualquer divergência nas tabelas, 292 colunas,
constraints, índices, função, triggers, RLS, políticas, grants ou configuração
do Storage. Ele também confirma que as tabelas públicas e `storage.objects` não
contêm dados operacionais.

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
