# Validação da baseline Supabase — 26/08/2026

## Escopo e evidências

A baseline foi construída sem conexão com o Supabase e sem executar SQL no
projeto oficial. Foram lidos integralmente o catálogo verificado, a auditoria,
o plano da Fila de Cadastro, o documento de reconstrução e as cinco migrations
existentes. O catálogo verificado é a evidência principal do estado remoto; as
migrations foram usadas somente para preservar modificadores de precisão que a
representação de colunas do catálogo reduz à família `numeric`.

## Confronto estrutural

A validação estática confronta, por nome, os 14 objetos de cada grupo abaixo:

| Grupo | Resultado esperado e verificado estaticamente |
| --- | --- |
| Tabelas | 14 `CREATE TABLE` em `public`, sem tabelas da Fila de Cadastro |
| Colunas | 14 listas completas; `watches` com 84 e `maintenance_logs` com 17 |
| Metadados de coluna | ordem, tipo, nulabilidade, default e identity reproduzidos |
| Constraints | 81 PKs, FKs, uniques e checks com nomes e definições catalogais |
| Índices | 40 índices não vinculados a constraints; outros 42 índices são criados pelas constraints |
| Automação | uma função `public.set_updated_at()` e nove triggers catalogais |
| Segurança pública | RLS nas 14 tabelas e 56 políticas (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) |
| Grants públicos | `authenticated`: CRUD nas 14 tabelas e somente `USAGE` nas 14 sequences; `service_role`: todos os privilégios nas 14 tabelas, somente `USAGE` nas 14 sequences e `EXECUTE` em `set_updated_at()`; nenhum privilégio desses objetos para `anon` |
| Storage | bucket privado `watch-photos`, limite de 15 MiB, cinco MIME types, tipo standard, versionamento desativado e quatro políticas por pasta do usuário |

Foram preservados os índices `UNIQUE` parciais
`watches_user_horoteca_code_uidx`, `acquisitions_user_order_uidx` e
`watches_user_order_item_uidx` como índices, sem convertê-los em constraints.
As ações de foreign keys, expressões de checks, predicados, métodos e expressões
de índices provêm das definições catalogais, sem simplificação.

## Segurança e ausência de dados

A SQL contém somente DDL, revogações/concessões de privilégios e o `INSERT` da
configuração do bucket. Não contém registros de negócio, objetos do Storage,
usuários, UUIDs, relógios, credenciais, chaves ou valores atuais de sequences.
A baseline revoga previamente os papéis da API e restabelece explicitamente os
grants catalogais, sem depender dos default privileges do projeto de destino.
A varredura estática também rejeita comandos `DROP`, `TRUNCATE`, `DELETE` e
`UPDATE`. O `INSERT` do bucket é metadado estrutural indispensável e não é dado
operacional.

## Limites e riscos pendentes

- A validação realizada nesta tarefa é estática: por proibição expressa, a SQL
  não foi aplicada nem ao projeto oficial nem a outro banco Supabase.
- A prova final de reconstrução sem drift ainda exige execução futura em projeto
  descartável compatível, seguida de nova extração catalogal somente leitura.
- `auth` e `storage` são dependências fornecidas pela plataforma Supabase; a
  baseline não tenta recriar schemas internos da plataforma.
- O conjunto de colunas de `storage.buckets` deve ser compatível com o catálogo
  verificado (incluindo `type`, `versioning_status` e `avif_autodetection`).
- Owners, timestamps internos do bucket e valores correntes das sequences são
  deliberadamente excluídos: não definem o esquema solicitado e poderiam
  transportar estado operacional.
- A Fila de Cadastro e `H001` continuam fora desta baseline porque são trabalho
  futuro e não integram as 14 tabelas atuais.

## Condição de uso

Não aplicar em produção, não fazer merge automático e não tratar esta baseline
como migration incremental. Antes de qualquer adoção, Dani Tomasetto deve
aprovar a revisão e uma reconstrução descartável deve demonstrar ausência de
drift catalogal.
