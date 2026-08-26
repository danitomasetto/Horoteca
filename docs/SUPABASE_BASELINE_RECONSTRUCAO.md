# Reconstrução da baseline do Supabase — Fase 1A

## 1. Objetivo e escopo

Este documento identifica, sem preencher lacunas por suposição, o que já pode e
o que ainda não pode ser usado para reconstruir o esquema atual da Horoteca.
Ele não é uma baseline SQL, não autoriza DDL e não registra qualquer consulta
nova ao Supabase.

A classificação usada em toda a matriz é:

- **M — migration:** definição textual confirmada por migration local;
- **R — remoto:** existência ou propriedade confirmada pelo relatório da
  auditoria remota de 26/08/2026, mas não necessariamente seu DDL completo;
- **I — inferência:** nome ou comportamento exigido/consumido pelo código; não
  confirma tipo, nulabilidade, default, constraint nem implementação remota;
- **P — pendência:** definição ausente ou ainda não comprovada com precisão
  suficiente para reconstrução.

“Confirmado por migration” significa que o Git contém a intenção executada por
aquele arquivo. Como a auditoria não registrou o resultado catalogal completo,
isso não prova sozinho que cada detalhe ainda seja idêntico no remoto. Da mesma
forma, a confirmação remota agregada (por exemplo, “14 tabelas com RLS”) não
substitui a captura de definições individuais.

O escopo cobre as 14 tabelas públicas observadas, colunas, tipos, nulabilidade,
defaults, identity/sequences, PKs, FKs, constraints, índices, funções, triggers,
RLS, políticas, grants, views, extensões e o bucket/políticas do Storage. As
criações originais ausentes de `watches` e `maintenance_logs` são tratadas como
lacuna crítica.

## 2. Fontes consultadas

Foram lidos integralmente, sem acesso remoto:

1. `docs/FILA_DE_CADASTRO_PLANO_V2.md`, como plano futuro e não como descrição
   do esquema atual;
2. `docs/SUPABASE_AUDITORIA_BASELINE_2026-08-26.md`, como registro da auditoria
   remota já realizada;
3. as cinco migrations existentes em `supabase/migrations/`;
4. os arquivos Dart de `flutter_app/` que inicializam/autenticam o cliente,
   consultam ou gravam no Supabase e no Storage;
5. os arquivos do aplicativo Android legado, somente para entender nomes e
   compatibilidade histórica, nunca para confirmar o banco.

Nenhum valor padrão do legado foi promovido a fato do banco. Material sensível
encontrado no legado foi deliberadamente omitido deste documento.

## 3. Matriz por tabela

### 3.1. Visão executiva

| Tabela                | Existência atual | Criação reproduzível | Evidência principal                                     | Pendência decisiva                                                           |
| --------------------- | ---------------- | -------------------- | ------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `watches`             | R                | **Não**              | R: tabela remota, 84 colunas; M: alterações posteriores | criação original, colunas originárias e todos os metadados catalogais finais |
| `maintenance_logs`    | R                | **Não**              | R: tabela remota; M: alterações posteriores             | criação original e definições completas dos campos legados                   |
| `brands`              | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar definição efetiva, índices, políticas e grants finais             |
| `watch_photos`        | M + R            | Parcialmente         | M: criação e alterações; R: existência/RLS              | confrontar estado final e sequência                                          |
| `watch_models`        | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final                                                      |
| `movement_calibers`   | M + R            | Parcialmente         | M: criação e extensão; R: existência/RLS                | confrontar estado final                                                      |
| `acquisitions`        | M + R            | Parcialmente         | M: criação e extensão; R: existência/RLS                | confirmar índice de identidade e definição final                             |
| `acquisition_items`   | M + R            | Parcialmente         | M: criação e extensão; R: existência/RLS                | confrontar definição final e GIN                                             |
| `expenses`            | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final                                                      |
| `expense_allocations` | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final                                                      |
| `watch_events`        | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final                                                      |
| `watch_sources`       | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final                                                      |
| `watch_photo_links`   | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final                                                      |
| `watch_claims`        | M + R            | Parcialmente         | M: criação; R: existência/RLS                           | confrontar estado final, sequência e privilégios                             |

“Parcialmente” é intencional: o DDL local permite descrever a intenção, mas a
baseline do **esquema atual** só estará pronta após comparar a forma catalogal
remota (inclusive nomes gerados, validação, owners e ACLs).

### 3.2. `watches` — lacuna crítica

**M — confirmado por migrations:**

- A tabela já existia antes do primeiro arquivo local. As migrations apenas a
  alteram.
- `brand` e `model` tiveram `NOT NULL` removido.
- `purchase_date` foi convertido para `date`.
- Foram adicionadas, sem `NOT NULL`/default salvo indicação contrária:
  - catálogo/comercial: `horoteca_code text`, `order_number text`,
    `order_item_number integer`, `marketplace text`, `marketplace_item_id text`,
    `seller_name text`, `purchase_currency text`,
    `purchase_amount_original numeric(14,2)`,
    `purchase_total_brl numeric(14,2)`, `payment_method text`,
    `estimated_value numeric(14,2)`, `estimated_value_date date`,
    `manufacture_year integer`, `movement_caliber text`, `condition text`;
  - relações/identificação: `brand_id bigint` (FK para `brands`, `ON DELETE SET
NULL`), `watch_model_id bigint` (FK para `watch_models`, `ON DELETE SET
NULL`), `movement_caliber_id bigint` (FK para `movement_calibers`, `ON
DELETE SET NULL`), `serial_number`, `case_code`, `dial_code`;
  - técnica: `movement_description text`, `jewels smallint`,
    `complications text[]`, `manufacture_country text`,
    `manufacture_year_is_estimated boolean`, anos inicial/final `smallint`,
    quatro dimensões `numeric(6,2)`, descrições de caixa/mostrador/ponteiros,
    cristal, coroa, fundo, pulseira, fecho e originalidade em `text`, status e
    defeitos em `text`, `accuracy_seconds_per_day numeric(8,2)`,
    `water_resistance text`, `source_document_url text`;
  - listagem: `watch_type`, `display_type`, `intended_audience`, `bezel_type`,
    `bezel_material`, `bezel_color`, `strap_color` em `text`;
    `has_original_box`, `has_original_papers`, `is_customized` em `boolean`;
    `included_accessories`, `features` em `text[]`; e
    `customization_description text`;
  - auditoria: `created_at` e `updated_at` são `timestamptz NOT NULL DEFAULT
now()` quando adicionados.
- Checks locais: joias entre 0 e 200 (ou nulo), período ordenado (ou limites
  nulos) e dimensões positivas (ou nulas).
- Índices locais: único parcial `(user_id, horoteca_code)` quando o código não é
  nulo; único parcial de usuário/marketplace normalizado/pedido/item quando
  pedido e item não são nulos; índices de `brand_id`, `watch_model_id` e
  `movement_caliber_id`.
- Trigger local `watches_set_updated_at`, `BEFORE UPDATE FOR EACH ROW`, chama
  `public.set_updated_at()`.

**R — confirmado pela auditoria:** existe, possui 84 colunas, RLS ativo,
políticas separadas por operação/proprietário e CRUD apenas para
`authenticated`. Não foi identificada constraint `UNIQUE` explícita em
`horoteca_code`; isso não nega o índice único parcial local.

**I — apenas inferido pelo código:** Flutter consome `id`, `user_id` (nas
relações/políticas), `brand`, `model`, `reference_number`, `movement_type`,
`case_material`, `dial_color`, `strap_material`, `purchase_price`, `notes`,
`image_uri`, além dos campos adicionados acima. O legado menciona também
`qr_code`. Esses nomes indicam contrato de consumo histórico, não provam tipos,
nulabilidade, defaults, constraints ou sequer a permanência de `qr_code`.

**P — faltante:** criação original; lista catalogal exata das 84 colunas;
definição completa de `id`, `user_id`, `brand`, `model`, `reference_number`,
`movement_type`, `case_material`, `dial_color`, `strap_material`,
`purchase_date` antes/depois da conversão, `purchase_price`, `notes`,
`image_uri`, possível `qr_code` e qualquer outra coluna originária; PK; identity
ou sequence e seus parâmetros/ownership; FK de `user_id`; todos os defaults,
collations, comentários, checks/uniques originários; RLS forçado ou não;
texto/nome exato das quatro políticas atuais; ACLs de tabela/coluna/sequence;
owner; e confronto dos índices/triggers locais com o remoto.

### 3.3. `maintenance_logs` — lacuna crítica

**M — confirmado por migrations:** a tabela era preexistente. Foram adicionados
`user_id uuid` (FK para `auth.users(id)`, depois `NOT NULL DEFAULT auth.uid()`),
`event_type text NOT NULL DEFAULT 'manutencao'`, `expense_category text`,
`currency text NOT NULL DEFAULT 'BRL'`, `amount_original numeric(14,2)`,
`amount_brl numeric(14,2)`, `event_date date`, `notes text`, e `created_at` /
`updated_at timestamptz NOT NULL DEFAULT now()`. `service_date` teve `NOT NULL`
removido e foi convertido para `date`. Há índice local em `user_id` e trigger
`maintenance_logs_set_updated_at`.

**R — confirmado pela auditoria:** existe, tem RLS ativo, quatro políticas por
operação/proprietário e CRUD somente para `authenticated`.

**I — apenas inferido pelo código:** o fallback Flutter lê `watch_id`,
`event_date`/`service_date`, `description`, `service_provider`, `cost`,
`amount_original`, `amount_brl`, `currency` e `notes`. O legado menciona também
`id` e `next_service_due`. Isso não confirma definições do banco.

**P — faltante:** criação original; conjunto final de colunas; tipos,
nulabilidade e defaults originários de `id`, `watch_id`, `service_date`,
`description`, `service_provider`, `cost`, `next_service_due` e quaisquer outros;
PK/identity/sequence; FK de `watch_id` e ação de deleção; índices originários;
checks/uniques; políticas exatas; owner/ACLs; estado do trigger e demais
metadados finais.

### 3.4. Tabelas cuja criação existe em migration

A tabela abaixo registra a definição **local confirmada**. Tudo deve ser
confrontado com o catálogo remoto; “identity PK” significa `bigint GENERATED BY
DEFAULT AS IDENTITY PRIMARY KEY` na migration.

| Tabela                | Colunas/estrutura M (resumo fiel)                                                                                                                                                                                                                                                     | Constraints, índices e automação M                                                                                                                         |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `brands`              | identity PK; `user_id uuid NOT NULL DEFAULT auth.uid()` FK auth; `name text NOT NULL`; perfil histórico em textos; `founded_year integer`; timestamps não nulos com `now()`                                                                                                           | `UNIQUE(user_id,name)`; sem trigger criado nas migrations consultadas                                                                                      |
| `watch_photos`        | identity PK; `watch_id bigint` passou a nulo; `acquisition_id bigint`; `user_id uuid NOT NULL DEFAULT auth.uid()`; `storage_path text NOT NULL`; caption/tipos/fontes/evidência/notas; `is_cover boolean NOT NULL DEFAULT false`; `sort_order integer NOT NULL DEFAULT 0`; timestamps | FKs watches/acquisitions cascade; unique usuário/caminho; check ao menos um dono; check de classificação; índices watch/acquisition; trigger de updated_at |
| `watch_models`        | identity PK; user/brand; `model_name text NOT NULL`; identidade e história do modelo; anos `smallint`; fontes `jsonb`; revisão `date`; timestamps                                                                                                                                     | FK auth cascade, brand set null; check de anos; índice único por identidade normalizada; índices user/brand; trigger                                       |
| `movement_calibers`   | identity PK; user; `caliber_code text NOT NULL`; técnica/história; extensões de frequência `integer`, medidas/reserva `numeric(6,2)`, booleanos e arrays; timestamps                                                                                                                  | FK auth cascade; checks de joias, anos e medidas positivas; identidade única normalizada; índice user; trigger                                             |
| `acquisitions`        | identity PK; user; marketplace/vendedor/pedido; datas; pagamento/transporte; origem/notas; entrega estimada e nome do documento; timestamps                                                                                                                                           | FK auth cascade; índice único parcial local de usuário/marketplace normalizado/pedido; índice user; trigger                                                |
| `acquisition_items`   | identity PK; user, aquisição e relógio não nulos; sequência `integer NOT NULL`; preços `numeric(14,2)`; metadados de listagem; `listing_specifics jsonb NOT NULL DEFAULT '{}'`; timestamps                                                                                            | FKs auth/aquisição/relógio cascade; sequência positiva e quantidade positiva/nula; uniques aquisição+sequência e relógio; índices user/FK e GIN; trigger   |
| `expenses`            | identity PK; user; aquisição/relógio opcionais; categoria/moeda/valor original obrigatórios; valores `numeric`; compartilhada `boolean NOT NULL DEFAULT false`; timestamps                                                                                                            | FKs cascade; exige aquisição ou relógio; enumeração de categoria; valores não negativos/câmbio positivo; índices user/FKs; trigger                         |
| `expense_allocations` | identity PK; user/despesa/relógio não nulos; parcelas `numeric(14,2)`; BRL obrigatório; ajuste `NOT NULL DEFAULT 0`; `created_at`                                                                                                                                                     | FKs cascade; checks não negativos; unique despesa+relógio; índices user/FKs; nenhuma trigger local                                                         |
| `watch_events`        | identity PK; user; relógio/aquisição opcionais; tipo/data/descrição obrigatórios; despesa opcional; detalhes; timestamps                                                                                                                                                              | FKs cascade e despesa set null; exige relógio ou aquisição; enumeração de tipo; índices user/FKs/data; trigger                                             |
| `watch_sources`       | identity PK; user; relógio/aquisição opcionais; tipo e classificação obrigatórios; confiança `smallint`; conteúdo e datas; `created_at`                                                                                                                                               | FKs cascade; exige relógio ou aquisição; classificação enumerada; confiança 0–100; índices user/FKs; nenhuma trigger local                                 |
| `watch_photo_links`   | identity PK; user/foto/relógio não nulos; posição/notas; `created_at`                                                                                                                                                                                                                 | FKs cascade; unique foto+relógio; índices user/FKs; nenhuma trigger local                                                                                  |
| `watch_claims`        | identity PK; user/relógio; fonte opcional; campo/valor/classificação obrigatórios; status `NOT NULL DEFAULT 'pending'`; confiança, contexto, notas, revisão; timestamps                                                                                                               | FKs auth/watch cascade, source set null; checks de não vazio/classificação/status/confiança; quatro índices; trigger                                       |

Para essas 12 tabelas, **R** confirma apenas existência, RLS e políticas por
operação/proprietário no recorte auditado. **P** permanece para definição
catalogal final de cada coluna, identity/sequences e parâmetros, nomes/estado de
constraints, índices (incluindo validade), triggers, políticas, owners e ACLs.

## 4. Definições confirmadas fora das tabelas

### 4.1. Função e triggers

- **M:** `public.set_updated_at()` retorna `trigger`, linguagem `plpgsql`, usa
  `SET search_path = ''`, atribui `new.updated_at = now()` e retorna `new`.
  Execução foi revogada de `public`, `anon` e `authenticated`.
- **R:** é a única função pública própria, `SECURITY INVOKER`, sem execução para
  `anon` ou `authenticated`.
- **M:** nove triggers de atualização são declarados: em `watches`,
  `maintenance_logs`, `watch_models`, `movement_calibers`, `acquisitions`,
  `acquisition_items`, `expenses`, `watch_events` e `watch_claims`.
- **R:** a auditoria confirma nove triggers, sem transcrever cada definição.
- **P:** OID/owner, configuração completa, ACL catalogal, corpo remoto exato e
  definições remotas individuais dos triggers.

### 4.2. RLS, políticas e grants

- **R:** RLS está ativo nas 14 tabelas. Há políticas separadas de `SELECT`,
  `INSERT`, `UPDATE` e `DELETE` para `authenticated`, por `user_id`; as de
  atualização têm `USING` e `WITH CHECK`.
- **M:** as 12 tabelas criadas/alteradas localmente têm políticas nomeadas nas
  migrations. Relações sensíveis ganharam checks de ownership cruzado em
  `INSERT`/`UPDATE`; `watch_claims` também valida relógio e fonte. Políticas de
  `watches` e a configuração inicial de `maintenance_logs` não foram criadas
  pelas migrations disponíveis.
- **R:** tabelas públicas concedem apenas CRUD a `authenticated`, sem grants
  equivalentes para `anon`.
- **M:** a migration de restrição revoga tudo de ambos os papéis nas 13 tabelas
  então existentes e concede CRUD a `authenticated`; a migration seguinte faz
  o mesmo para `watch_claims`. Revoga sequences de `anon` e concede
  `USAGE, SELECT` nas sequences a `authenticated`.
- **P:** nomes, qualificadores, expressões exatas e flags (`permissive`) das 56
  políticas atuais; `relforcerowsecurity`; grants por coluna; ACLs implícitas,
  owner e privilégios de outros papéis; ACL de cada sequence e função.

### 4.3. Views e extensões

- **R:** não existem views no schema `public`.
- **P:** materialized views e views em outros schemas relevantes; lista exata,
  schemas, versões e relocabilidade das extensões; dependências que a baseline
  deverá habilitar ou pressupor. Nenhuma migration local declara extensão.

### 4.4. Storage

- **M:** bucket `watch-photos`, privado, limite `15728640` bytes, MIME types
  JPEG, PNG, WebP, HEIC e HEIF; quatro políticas em `storage.objects` restringem
  `authenticated` ao bucket e à primeira pasta igual ao UID, com `USING` e/ou
  `WITH CHECK` conforme a operação.
- **R:** confirma bucket privado, 15 MB, mesmos MIME types, versionamento
  desativado, zero objetos e quatro políticas isoladas pela pasta do usuário.
- **I:** Flutter cria URL assinada, envia sem upsert para
  `<user>/<watch>/<timestamp>.<ext>` e grava o caminho em `watch_photos`.
- **P:** linha catalogal completa do bucket (inclusive owner/demais opções),
  definição remota exata e flags das políticas, grants/ACLs e RLS efetivos nas
  relações Storage, e confirmação técnica de como o “versionamento desativado”
  é representado na versão instalada.

## 5. Definições apenas inferidas

Inferências úteis para testar compatibilidade, mas proibidas como DDL de
baseline sem confirmação:

1. o Flutter exige que os nomes de tabelas e campos usados em `select()` sejam
   visíveis ao papel autenticado;
2. os casts Dart sugerem famílias de tipos (`num`, `String`, `bool`, listas),
   mas não distinguem `integer` de `bigint`, `numeric` de outros números,
   `text[]` de JSON, nem provam nulabilidade/default;
3. o fallback para `maintenance_logs` demonstra dependência de compatibilidade,
   não prioridade canônica nem definição da tabela;
4. o legado sugere nomes das criações antigas, porém suas entidades Room,
   defaults, `Double` e DTOs não são especificação PostgreSQL;
5. o plano da Fila descreve entidades futuras. Nenhuma delas, nenhuma sequence
   global e nenhuma RPC de finalização existe hoje segundo a auditoria; portanto
   não entram na baseline atual.

## 6. Lacunas reais

### 6.1. Bloqueadoras

1. DDL original de `watches` e `maintenance_logs`.
2. Inventário catalogal completo das colunas das 14 tabelas, com ordem, tipo
   formatado, nulabilidade, default, identity/generated, collation e comentários.
3. PKs, FKs (ações, match e deferrability), uniques e checks exatamente como
   estão, inclusive validação.
4. Todas as sequences/identity: vínculo à coluna, owner, tipo, início,
   incremento, mínimo, máximo, cache, ciclo e ACL.
5. Índices remotos exatos: definição, predicado, método, collation/opclass,
   inclusão, unicidade, validade e vínculo a constraint.
6. Políticas/RLS e grants exatos, não apenas o resumo agregado.
7. Função e triggers extraídos do remoto.
8. Extensões e dependências de schemas.
9. Configuração e políticas catalogais completas do Storage.

### 6.2. Não autorizadas a virar “solução” nesta fase

- escolher tipos ou defaults para campos originais a partir do Flutter/legado;
- converter os índices parciais de identidade em constraints sem decisão de
  produto e reconciliação remota;
- presumir que a ordem dos arquivos locais equivale integralmente ao histórico
  remoto, cujos nomes/timestamps divergem;
- acrescentar tabelas da Fila, `H001`, sequences ou RPCs futuras à baseline do
  estado atual.

## 7. Riscos de criar uma baseline incompleta

- banco vazio estruturalmente diferente do oficial, embora a migration “passe”;
- perda de nulabilidade/defaults e preenchimento implícito de fatos
  desconhecidos;
- geração de IDs incompatível ou sequences sem ownership/ACL corretos;
- deleções em cascata indevidas ou FKs ausentes;
- duplicidades aceitas ou registros legítimos rejeitados por regra inventada;
- exposição pela Data API por RLS, política ou grant incompleto;
- uploads acessíveis fora da pasta do usuário;
- triggers ausentes, timestamps desatualizados e divergência de auditoria;
- falha de restauração por extensão, função ou dependência não declarada;
- falsa confiança: reproduzir migrations locais não equivale a reproduzir o
  remoto enquanto existir drift não medido.

## 8. CONSULTAS SOMENTE LEITURA NECESSÁRIAS

As consultas abaixo são exclusivamente de leitura. Devem ser executadas depois,
pela conexão segura aprovada, com resultados sanitizados antes de versionar.
Elas não devem ser executadas nesta fase.

### 8.1. Relações, colunas, tipos, defaults, identity e RLS

```sql
SELECT
  n.nspname AS schema_name,
  c.relname AS relation_name,
  c.relkind,
  pg_get_userbyid(c.relowner) AS owner_name,
  c.relrowsecurity,
  c.relforcerowsecurity,
  c.relpersistence,
  obj_description(c.oid, 'pg_class') AS relation_comment
FROM pg_catalog.pg_class AS c
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname IN ('public', 'storage')
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY n.nspname, c.relkind, c.relname;
```

```sql
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  a.attnum AS ordinal_position,
  a.attname AS column_name,
  pg_catalog.format_type(a.atttypid, a.atttypmod) AS formatted_type,
  NOT a.attnotnull AS is_nullable,
  pg_get_expr(ad.adbin, ad.adrelid) AS column_default,
  a.attidentity AS identity_kind,
  a.attgenerated AS generated_kind,
  coll.collname AS collation_name,
  col_description(c.oid, a.attnum) AS column_comment
FROM pg_catalog.pg_attribute AS a
JOIN pg_catalog.pg_class AS c ON c.oid = a.attrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_attrdef AS ad
  ON ad.adrelid = a.attrelid AND ad.adnum = a.attnum
LEFT JOIN pg_catalog.pg_collation AS coll ON coll.oid = a.attcollation
WHERE n.nspname IN ('public', 'storage')
  AND c.relkind IN ('r', 'p')
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY n.nspname, c.relname, a.attnum;
```

### 8.2. Constraints e foreign keys

```sql
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  con.conname AS constraint_name,
  con.contype AS constraint_type,
  con.condeferrable,
  con.condeferred,
  con.convalidated,
  rn.nspname AS referenced_schema,
  rc.relname AS referenced_table,
  pg_get_constraintdef(con.oid, true) AS definition
FROM pg_catalog.pg_constraint AS con
JOIN pg_catalog.pg_class AS c ON c.oid = con.conrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
LEFT JOIN pg_catalog.pg_class AS rc ON rc.oid = con.confrelid
LEFT JOIN pg_catalog.pg_namespace AS rn ON rn.oid = rc.relnamespace
WHERE n.nspname IN ('public', 'storage')
ORDER BY n.nspname, c.relname, con.contype, con.conname;
```

### 8.3. Índices

```sql
SELECT
  ns.nspname AS schema_name,
  tbl.relname AS table_name,
  idx.relname AS index_name,
  i.indisprimary,
  i.indisunique,
  i.indisvalid,
  i.indisready,
  i.indisclustered,
  con.conname AS backing_constraint,
  pg_get_indexdef(i.indexrelid, 0, true) AS definition,
  pg_get_expr(i.indpred, i.indrelid, true) AS predicate
FROM pg_catalog.pg_index AS i
JOIN pg_catalog.pg_class AS idx ON idx.oid = i.indexrelid
JOIN pg_catalog.pg_class AS tbl ON tbl.oid = i.indrelid
JOIN pg_catalog.pg_namespace AS ns ON ns.oid = tbl.relnamespace
LEFT JOIN pg_catalog.pg_constraint AS con ON con.conindid = i.indexrelid
WHERE ns.nspname IN ('public', 'storage')
ORDER BY ns.nspname, tbl.relname, idx.relname;
```

### 8.4. Sequences e vínculos de identity/serial

```sql
SELECT
  schemaname AS schema_name,
  sequencename AS sequence_name,
  sequenceowner AS owner_name,
  data_type,
  start_value,
  min_value,
  max_value,
  increment_by,
  cycle,
  cache_size
FROM pg_catalog.pg_sequences
WHERE schemaname IN ('public', 'storage')
ORDER BY schemaname, sequencename;
```

```sql
SELECT
  sn.nspname AS sequence_schema,
  seq.relname AS sequence_name,
  tn.nspname AS table_schema,
  tbl.relname AS table_name,
  att.attname AS column_name,
  dep.deptype
FROM pg_catalog.pg_depend AS dep
JOIN pg_catalog.pg_class AS seq
  ON seq.oid = dep.objid AND seq.relkind = 'S'
JOIN pg_catalog.pg_namespace AS sn ON sn.oid = seq.relnamespace
JOIN pg_catalog.pg_class AS tbl ON tbl.oid = dep.refobjid
JOIN pg_catalog.pg_namespace AS tn ON tn.oid = tbl.relnamespace
JOIN pg_catalog.pg_attribute AS att
  ON att.attrelid = tbl.oid AND att.attnum = dep.refobjsubid
WHERE sn.nspname IN ('public', 'storage')
ORDER BY sn.nspname, seq.relname;
```

### 8.5. Funções e triggers

```sql
SELECT
  n.nspname AS schema_name,
  p.proname AS function_name,
  pg_get_function_identity_arguments(p.oid) AS identity_arguments,
  pg_get_userbyid(p.proowner) AS owner_name,
  p.prosecdef AS security_definer,
  p.proleakproof,
  p.provolatile,
  p.proconfig,
  pg_get_functiondef(p.oid) AS definition
FROM pg_catalog.pg_proc AS p
JOIN pg_catalog.pg_namespace AS n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
ORDER BY p.proname, identity_arguments;
```

```sql
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  t.tgname AS trigger_name,
  t.tgenabled,
  pg_get_triggerdef(t.oid, true) AS definition
FROM pg_catalog.pg_trigger AS t
JOIN pg_catalog.pg_class AS c ON c.oid = t.tgrelid
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname IN ('public', 'storage')
  AND NOT t.tgisinternal
ORDER BY n.nspname, c.relname, t.tgname;
```

### 8.6. Políticas e grants

```sql
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_catalog.pg_policies
WHERE schemaname IN ('public', 'storage')
ORDER BY schemaname, tablename, policyname;
```

```sql
SELECT
  table_schema,
  table_name,
  grantee,
  privilege_type,
  is_grantable
FROM information_schema.role_table_grants
WHERE table_schema IN ('public', 'storage')
ORDER BY table_schema, table_name, grantee, privilege_type;
```

```sql
SELECT
  table_schema,
  table_name,
  column_name,
  grantee,
  privilege_type,
  is_grantable
FROM information_schema.role_column_grants
WHERE table_schema IN ('public', 'storage')
ORDER BY table_schema, table_name, column_name, grantee, privilege_type;
```

```sql
SELECT
  routine_schema,
  routine_name,
  specific_name,
  grantee,
  privilege_type,
  is_grantable
FROM information_schema.role_routine_grants
WHERE routine_schema = 'public'
ORDER BY routine_name, specific_name, grantee, privilege_type;
```

```sql
SELECT
  object_schema,
  object_name,
  object_type,
  grantee,
  privilege_type,
  is_grantable
FROM information_schema.role_usage_grants
WHERE object_schema IN ('public', 'storage')
ORDER BY object_schema, object_name, grantee, privilege_type;
```

### 8.7. Views, extensões e dependências

```sql
SELECT
  n.nspname AS schema_name,
  c.relname AS view_name,
  c.relkind,
  pg_get_viewdef(c.oid, true) AS definition
FROM pg_catalog.pg_class AS c
JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
WHERE c.relkind IN ('v', 'm')
ORDER BY n.nspname, c.relname;
```

```sql
SELECT
  e.extname AS extension_name,
  e.extversion AS extension_version,
  n.nspname AS schema_name,
  e.extrelocatable
FROM pg_catalog.pg_extension AS e
JOIN pg_catalog.pg_namespace AS n ON n.oid = e.extnamespace
ORDER BY e.extname;
```

```sql
SELECT
  dependent_ns.nspname AS dependent_schema,
  dependent.relname AS dependent_object,
  source_ns.nspname AS source_schema,
  source.relname AS source_object,
  d.deptype
FROM pg_catalog.pg_depend AS d
JOIN pg_catalog.pg_class AS dependent ON dependent.oid = d.objid
JOIN pg_catalog.pg_namespace AS dependent_ns
  ON dependent_ns.oid = dependent.relnamespace
JOIN pg_catalog.pg_class AS source ON source.oid = d.refobjid
JOIN pg_catalog.pg_namespace AS source_ns ON source_ns.oid = source.relnamespace
WHERE dependent_ns.nspname IN ('public', 'storage')
   OR source_ns.nspname IN ('public', 'storage')
ORDER BY dependent_ns.nspname, dependent.relname,
         source_ns.nspname, source.relname;
```

### 8.8. Bucket e metadados do Storage

A primeira consulta descobre as colunas realmente instaladas, evitando supor a
versão do Storage; a segunda lê a linha do bucket sem tocar em objetos.

```sql
SELECT
  ordinal_position,
  column_name,
  data_type,
  udt_schema,
  udt_name,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'storage'
  AND table_name IN ('buckets', 'objects')
ORDER BY table_name, ordinal_position;
```

```sql
SELECT *
FROM storage.buckets
WHERE id = 'watch-photos';
```

As políticas de `storage.objects`, RLS, constraints, índices e grants são
cobertos pelas consultas gerais anteriores. Não é necessário listar nomes ou
metadados de objetos para reconstruir o esquema.

## 9. Critérios para considerar a baseline pronta

A baseline só poderá ser considerada pronta quando:

1. todas as consultas acima tiverem resultados capturados por conexão segura,
   revisados e sanitizados;
2. cada célula **P** bloqueadora tiver sido resolvida por evidência catalogal,
   não por código ou legado;
3. as 84 colunas de `watches` e todas as de `maintenance_logs` estiverem
   enumeradas com definições exatas;
4. tabelas, sequences, constraints, índices, função, triggers, RLS, políticas,
   grants, views, extensões e Storage tiverem comparação Git × remoto;
5. divergências entre histórico local e remoto estiverem explicadas sem editar
   retroativamente migrations aplicadas;
6. a futura SQL reproduzir o estado atual em banco descartável e passar uma
   comparação estrutural sem drift;
7. restauração e rollback tiverem plano testado; e
8. o diff, a segurança, o desempenho e as regras de produto tiverem revisão e
   aprovação antes de qualquer aplicação.

## 10. Próximos passos — não executados

1. Executar somente as consultas da seção 8 pela conexão segura autorizada.
2. Armazenar resultados sem dados de negócio, credenciais, identificadores de
   usuário ou outros valores privados.
3. Produzir o confronto catalogal campo a campo e resolver primeiro
   `watches`/`maintenance_logs`.
4. Submeter as regras ainda ambíguas de identidade a Dani; não convertê-las
   automaticamente em constraints.
5. Só depois elaborar, em tarefa separada, uma baseline SQL e validá-la em
   ambiente descartável/transação com rollback.
6. Manter a Fila de Cadastro, a preservação estruturada de `H001` e a sequence
   iniciando em `H002` para fases posteriores, sem executá-las agora.

Nenhuma migration, baseline SQL, alteração de aplicativo/site/banco ou consulta
remota foi realizada nesta Fase 1A.
