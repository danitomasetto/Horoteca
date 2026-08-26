# Auditoria técnica somente leitura do Supabase — baseline de 26/08/2026

## 1. Identificação, escopo e origem das evidências

Este relatório versiona a baseline técnica da auditoria **somente leitura**
realizada em 26/08/2026. Os resultados remotos aqui registrados foram fornecidos
como resultados verificados, obtidos por conexão segura com o Supabase; não foi
realizado novo acesso ao banco durante a elaboração deste documento.

| Item              | Resultado              |
| ----------------- | ---------------------- |
| Projeto           | `horoteca`             |
| Project ref       | `nlkhbhgzscpdistzuyod` |
| Região            | `us-east-1`            |
| Situação          | `ACTIVE_HEALTHY`       |
| PostgreSQL        | `17.6`                 |
| Data da auditoria | 26/08/2026             |
| Natureza          | Somente leitura        |

Nenhuma alteração foi feita no Supabase durante a auditoria. Este trabalho
também não alterou aplicativo, site, migrations, esquema, dados, RLS, políticas,
funções, Storage, Auth, configuração de ambiente ou o Plano V2 aprovado.
Credenciais, chaves, UUID de usuário e outros dados secretos foram
deliberadamente omitidos.

Para contextualizar os resultados, foram lidos integralmente:

- `docs/FILA_DE_CADASTRO_PLANO_V2.md`;
- todos os arquivos SQL existentes em `supabase/migrations/`;
- os arquivos Dart do Flutter que inicializam, autenticam ou acessam o
  Supabase, em especial o repositório da coleção e o fluxo de fotografias.

## 2. Sumário executivo

O projeto remoto está saudável e apresenta uma base de segurança consistente:
as 14 tabelas públicas da Horoteca têm RLS ativo, políticas por operação e por
proprietário, e privilégios da Data API limitados ao papel `authenticated`. O
bucket de fotos também é privado e isolado por pasta do usuário.

É essencial separar duas conclusões:

1. **Capacidade do esquema:** o catálogo atual é rico. `watches` possui 84
   campos e é apoiada por entidades próprias para marcas, modelos, calibres,
   aquisições, itens, despesas, rateios, eventos, fontes, fotos e claims.
2. **Completude dos dados:** o único relógio utilizou apenas parte dessa
   capacidade: 32 campos estão preenchidos e 52 estão nulos, não há calibre nem
   fotos vinculados e todos os seis claims aguardam revisão.

Portanto, a principal falha observada não é uma ausência generalizada de campos
no esquema. Ela está no processo atual de preparação, revisão e gravação, que
ainda não materializa de forma completa e controlada a informação disponível.
O Plano V2 trata justamente dessa separação entre staging e catálogo, mas suas
tabelas de Fila de Cadastro ainda não existem.

Há dois pontos críticos para a evolução: o Git não contém uma baseline integral
capaz de recriar `watches` e `maintenance_logs` em um banco vazio; e `H001`, já
presente no nome do documento-fonte, ainda não existe como processo estruturado
de intake. Ele deve ser importado ou reservado como processo histórico antes de
se iniciar a sequência nova em `H002`.

## 3. Estrutura remota verificada

### 3.1. Tabelas, RLS e políticas

Foram encontradas 14 tabelas públicas da Horoteca:

1. `watches`;
2. `maintenance_logs`;
3. `brands`;
4. `watch_photos`;
5. `watch_models`;
6. `movement_calibers`;
7. `acquisitions`;
8. `acquisition_items`;
9. `expenses`;
10. `expense_allocations`;
11. `watch_events`;
12. `watch_sources`;
13. `watch_photo_links`;
14. `watch_claims`.

Todas possuem RLS ativo. Cada tabela possui políticas separadas de `SELECT`,
`INSERT`, `UPDATE` e `DELETE` para `authenticated`, restringindo os registros ao
proprietário. As políticas de `UPDATE` incluem tanto `USING` quanto
`WITH CHECK`.

As tabelas públicas concedem somente `SELECT`, `INSERT`, `UPDATE` e `DELETE` ao
papel `authenticated`. Não foram encontrados grants equivalentes para `anon`.
Esse detalhe é relevante para a Fila de Cadastro: **RLS e políticas não concedem
privilégios por si sós**. Cada nova tabela exposta pela Data API precisará também
de grants explícitos e mínimos para os papéis autorizados, além de RLS e das
políticas por operação.

Não existem views no schema `public`.

### 3.2. Função e triggers

Existe uma única função pública própria, `set_updated_at()`. Ela é
`SECURITY INVOKER` e não concede execução a `anon` nem a `authenticated`.
Triggers de atualização automática estão presentes em nove tabelas.

### 3.3. Constraints e identidade de negócio

- A auditoria não identificou uma **constraint `UNIQUE` explícita** para
  `watches.horoteca_code`. O repositório contém um índice único parcial composto
  por `(user_id, horoteca_code)`, mas isso não substitui o registro explícito da
  regra de identidade canônica como constraint validada na baseline remota.
- Também não foi confirmada uma constraint de unicidade estruturada para a
  identidade pedido/marketplace em `acquisitions`. Embora uma migration do
  repositório declare um índice único parcial sobre usuário, marketplace
  normalizado e pedido não nulo, a regra não está documentada como constraint
  declarativa de negócio. A futura baseline deve reconciliar o estado remoto,
  a intenção do índice e o comportamento desejado para valores nulos ou vazios.

Esses achados não indicam duplicidade atual: a inspeção dos dados não encontrou
códigos de relógio duplicados nem relógios sem código. Eles indicam que as regras
de identidade precisam ser tornadas inequívocas e reproduzíveis antes da
automação da finalização.

## 4. Migrations e reprodutibilidade

O histórico remoto registrou:

- `20260806024503_secure_horoteca_owner_access`;
- `20260806035700_extend_horoteca_catalog_finance_photos_brands`;
- `20260824101741_harden_horoteca_relationships`;
- `20260824102320_restrict_horoteca_data_api_privileges`;
- `20260825161206_complete_listing_specs_and_claims`.

Os nomes e timestamps locais não formam uma correspondência integral com esse
histórico remoto. Mais importante, o repositório não contém a criação original
completa das tabelas `watches` e `maintenance_logs`: migrations locais posteriores
partem da existência delas e as alteram.

Consequentemente, as migrations versionadas atuais **não são uma baseline
integral** e não conseguem, sozinhas, reconstruir o esquema completo a partir de
um banco vazio. Essa lacuna de infraestrutura como código é crítica, ainda que o
banco remoto em operação esteja saudável. Corrigi-la exigirá uma migration de
baseline cuidadosamente reconciliada com o remoto, sem executar DDL destrutivo
e sem reescrever migrations já aplicadas.

## 5. Dados atuais e integridade

### 5.1. Volumetria

| Entidade           | Quantidade |
| ------------------ | ---------: |
| Relógios           |          1 |
| Aquisições         |          1 |
| Itens de aquisição |          1 |
| Despesas           |          4 |
| Rateios            |          4 |
| Eventos            |          6 |
| Fontes             |          7 |
| Claims             |          6 |
| Marcas             |          1 |
| Modelos            |          1 |
| Calibres           |          0 |
| Fotos              |          0 |

Não foram encontrados códigos duplicados, relógios sem código, vínculos
inválidos entre aquisição, item e relógio, vínculos inválidos entre despesa,
rateio e relógio, nem diferenças financeiras não reconciliadas.

### 5.2. Registro canônico existente

O relógio cadastrado apresenta:

| Campo                      | Valor            |
| -------------------------- | ---------------- |
| `horoteca_code`            | `02-14381-05007` |
| Marca                      | Seiko            |
| Modelo                     | Seiko 5          |
| Pedido                     | `02-14381-05007` |
| Marketplace                | eBay             |
| Data da compra             | 15/03/2026       |
| Total registrado da compra | R$ 393,02        |

Há vínculo estruturado com marca e modelo, mas não com calibre. O campo
`source_document_url` está nulo.

Dos 84 campos de `watches`, 32 estão preenchidos e 52 estão nulos. Entre os
nulos estão referência, número de série, código da caixa, calibre, medidas,
diversos materiais, URL do documento-fonte e dados técnicos. Parte dessas
informações pode ser legitimamente desconhecida. A ausência deve continuar
explícita como `NULL`; não há base para preencher qualquer uma delas por
inferência ou invenção.

Os seis claims existentes estão em `pending`; não há claims `accepted` ou
`rejected`. Isso demonstra preservação de alegações sem promoção automática a
fato, mas também evidencia trabalho de revisão ainda pendente.

### 5.3. Reconciliação financeira

As quatro despesas estão reconciliadas:

| Categoria  | Valor documental/alocado |   Ajuste |
| ---------- | -----------------------: | -------: |
| Produto    |                R$ 288,81 |        — |
| Frete      |    R$ 104,21 / R$ 104,22 | -R$ 0,01 |
| Imposto    |                 R$ 16,00 |        — |
| Manutenção |                R$ 175,00 |        — |

No frete, a parcela arredondada de R$ 104,22 e o ajuste separado de -R$ 0,01
preservam o total documental de R$ 104,21. Não foi encontrada diferença
financeira não reconciliada. O total da aquisição, R$ 393,02, corresponde a
produto mais frete e não deve ser confundido com imposto ou manutenção
posteriores.

## 6. Fila de Cadastro e preservação de `H001`

Ainda não existem tabelas da Fila de Cadastro descrita no Plano V2. Em
particular, não há entidades `watch_intakes` nem o conjunto proposto para itens,
documentos, extrações, revisões, findings, decisões, transições e finalizações.
O catálogo rico atual não equivale a um processo de staging auditável.

O nome do documento-fonte atual contém `H001`, mas `H001` ainda não está
representado como entidade estruturada de intake. Esse identificador pertence a
um processo real e deve ser preservado: antes de liberar novos cadastros, ele
deverá ser importado ou reservado como processo histórico, mantendo seus
vínculos e sem confundi-lo com o `horoteca_code` da peça. O próximo processo da
sequência global será `H002`.

Nenhuma tabela, sequence, RPC ou transição prevista no Plano V2 foi criada por
esta auditoria ou por este relatório.

## 7. Storage

O bucket privado `watch-photos` apresenta:

| Configuração       | Resultado                    |
| ------------------ | ---------------------------- |
| Público            | Não                          |
| Limite por arquivo | 15 MB                        |
| MIME types         | JPEG, PNG, WebP, HEIC e HEIF |
| Versionamento      | Desativado                   |
| Objetos            | 0                            |

Existem políticas de `SELECT`, `INSERT`, `UPDATE` e `DELETE` para usuários
autenticados. O acesso é restringido ao caminho cuja primeira pasta corresponde
ao usuário autenticado. O Flutter respeita esse desenho ao usar o bucket
privado, gerar URLs assinadas, enviar o arquivo sob a pasta do usuário e então
registrar o metadado em `watch_photos`.

## 8. Uso atual pelo Flutter

O aplicativo canônico inicializa o cliente Supabase com URL e chave pública,
autentica por senha e condiciona a coleção à sessão ativa. Na consulta do
catálogo, ele lê `watches`, modelos, calibres, aquisições, itens, eventos,
fontes, claims, despesas e rateios; há fallback para `maintenance_logs` no
histórico. Também lê marcas e consulta/insere metadados de `watch_photos`, além
de operar o bucket `watch-photos`.

Esse consumo confirma que o esquema já suporta uma apresentação catalográfica
abrangente. Ao mesmo tempo, não há no Flutter acesso a tabelas de intake, pois
elas ainda não existem. A implementação futura da fila não deve ser simulada
por inserts independentes nas tabelas canônicas: deve seguir o fluxo
transacional, versionado e autorizado definido no Plano V2.

## 9. Advisors

### 9.1. Segurança

O único aviso foi a proteção contra senhas vazadas desativada no Supabase Auth.
Não foram fornecidos outros alertas de segurança pelos resultados da auditoria.

### 9.2. Desempenho

Foram observados apenas avisos informativos sobre índices ainda não utilizados.
Com o volume mínimo atual e sem histórico suficiente de uso, isso não comprova
que os índices sejam desnecessários. **Não se recomenda removê-los** com base
nesses avisos.

## 10. Achados classificados

### 10.1. Críticos

| ID   | Achado                                                                                                   | Impacto                                                                                                             |
| ---- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| C-01 | Falta uma baseline integral no Git para a criação original de `watches` e `maintenance_logs`.            | Um banco vazio não pode ser reconstruído fielmente apenas com as migrations atuais.                                 |
| C-02 | A Fila de Cadastro ainda não possui tabelas, sequence, auditoria de estados ou finalização transacional. | O processo atual não oferece as garantias de preparação, três revisões, aprovação e promoção previstas no Plano V2. |
| C-03 | `H001` não existe como intake estruturado.                                                               | Abrir a sequência sem preservá-lo pode perder a identidade histórica ou reutilizar indevidamente o código.          |

### 10.2. Avisos

| ID   | Achado                                                                                                                           | Impacto                                                                                                         |
| ---- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| A-01 | Não foi identificada constraint `UNIQUE` explícita para `watches.horoteca_code`; há índice único parcial local por usuário.      | A regra canônica não está expressa de forma inequívoca e reconciliada na baseline.                              |
| A-02 | Não foi confirmada constraint declarativa para unicidade de pedido/marketplace em `acquisitions`; há índice único parcial local. | Casos com nulos, vazios e normalização precisam de regra de negócio explícita antes da finalização automática.  |
| A-03 | 52 dos 84 campos do relógio estão nulos, inclusive identificadores e dados técnicos relevantes.                                  | O cadastro é incompleto, embora alguns valores possam ser genuinamente desconhecidos e devam permanecer `NULL`. |
| A-04 | Todos os seis claims estão `pending`.                                                                                            | Nenhuma alegação foi aceita ou rejeitada por revisão registrada.                                                |
| A-05 | Proteção contra senhas vazadas está desativada no Auth.                                                                          | Uma defesa adicional contra credenciais comprometidas não está habilitada.                                      |
| A-06 | O bucket não tem versionamento.                                                                                                  | Substituições futuras dependeriam de controles de aplicação e histórico externo; atualmente há zero objetos.    |

### 10.3. Informações

| ID   | Achado                                                                                   |
| ---- | ---------------------------------------------------------------------------------------- |
| I-01 | Projeto `ACTIVE_HEALTHY`, PostgreSQL 17.6, região `us-east-1`.                           |
| I-02 | As 14 tabelas têm RLS e políticas separadas por operação e proprietário.                 |
| I-03 | Não há grants de tabela equivalentes para `anon`, nem views públicas.                    |
| I-04 | A função própria é `SECURITY INVOKER` e não é executável pelos papéis cliente.           |
| I-05 | Integridade relacional e reconciliação financeira dos dados atuais foram confirmadas.    |
| I-06 | O bucket é privado, limitado a 15 MB, restringe MIME types e isola caminhos por usuário. |
| I-07 | Avisos de índices não utilizados são inconclusivos devido ao volume mínimo.              |

## 11. Recomendações e próximos passos — não executados

As ações abaixo são propostas para decisão e planejamento. **Nenhuma delas foi
executada nesta tarefa.**

1. Produzir e revisar uma baseline completa do esquema remoto, incluindo a
   criação original de `watches` e `maintenance_logs`; validar dependências e
   testar a reconstrução em ambiente descartável e em transação com rollback.
2. Reconciliar formalmente os nomes/timestamps das migrations locais com o
   histórico remoto, sem editar retroativamente migrations aplicadas.
3. Definir e versionar, após aprovação funcional, a regra inequívoca de
   unicidade de `horoteca_code`, considerando o escopo por proprietário e a
   compatibilidade com os dados existentes.
4. Definir a identidade estruturada de aquisição por pedido e marketplace,
   incluindo normalização, valores nulos/vazios e possíveis marketplaces sem
   número de pedido; só então materializar a constraint apropriada.
5. Importar ou reservar `H001` como processo histórico antes de criar novos
   intakes; inicializar o próximo processo em `H002`, sem usar `Hxxx` como código
   de relógio.
6. Implementar a Fila de Cadastro em migrations futuras conforme o Plano V2,
   com staging, sequência global, controle de versão, revisões imutáveis,
   aprovação do proprietário, transições auditáveis e RPC de finalização
   transacional e idempotente.
7. Para cada nova tabela exposta à Data API, aplicar conjuntamente RLS,
   políticas separadas por operação/proprietário, índices de `user_id` e FKs e
   **grants explícitos e mínimos**; não conceder acesso equivalente a `anon`.
8. Planejar o preenchimento somente a partir de evidência revisada. Manter como
   `NULL` referência, série, caixa, calibre, medidas, materiais e demais campos
   que continuarem desconhecidos; não promover claims automaticamente.
9. Avaliar a ativação da proteção contra senhas vazadas no Supabase Auth,
   considerando o fluxo de autenticação vigente.
10. Manter os índices atuais até existir volume e telemetria representativos;
    reavaliar desempenho posteriormente, sem remoção preventiva.
11. Após qualquer DDL futura, consultar o esquema resultante, validar dados e
    reconciliação, executar advisors de segurança e desempenho e registrar os
    resultados no Git.

## 12. Conclusão e declaração de não alteração

A baseline de 26/08/2026 mostra um esquema catalográfico rico, seguro no recorte
auditado e com dados relacionais e financeiros atuais consistentes. A baixa
ocupação dos campos não reduz a capacidade do esquema; evidencia que o cadastro
existente usou apenas parte dela. A prioridade é fortalecer o processo de
preparação e gravação por meio da Fila de Cadastro aprovada, preservar `H001` e
restaurar a reprodutibilidade completa do esquema no Git.

Este relatório não preenche lacunas com suposições. Valores desconhecidos
continuam desconhecidos, e nenhuma recomendação acima representa alteração já
realizada ou autorização para executá-la.
