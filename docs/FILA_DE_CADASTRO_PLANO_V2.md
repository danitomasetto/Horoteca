# Fila de Cadastro — Plano V2 definitivo

## 1. Objetivo e escopo

Este documento define o plano funcional e técnico aprovado para a **Fila de
Cadastro** da Horoteca. A fila será implementada futuramente no aplicativo
Flutter canônico (`flutter_app/`) e controlará a preparação, as três revisões,
a aprovação do proprietário e a promoção transacional ao catálogo.

Este plano não autoriza alterações imediatas no aplicativo ou no Supabase. A
auditoria do esquema remoto, o backup e a validação das migrations continuam
sendo pré-requisitos obrigatórios.

### Princípios permanentes

- Uma entrada da fila representa um processo documental e pode conter um ou
  vários relógios.
- `intake_code` identifica o processo; não identifica diretamente uma peça.
- Cada relógio possui um item de intake e, após a finalização, seu próprio
  registro e identificador canônico.
- Informação desconhecida permanece `NULL`; zero só representa um valor
  documentalmente conhecido como zero.
- Documento, alegação de vendedor e extração de agente não se tornam fatos
  confirmados automaticamente.
- Documento A, versões do Documento B, revisões, aprovações e transições são
  preservados e auditáveis.
- Somente o proprietário pode aprovar, cancelar e executar a finalização.
- Nenhuma chave `service_role`, segredo de agente ou credencial administrativa
  será distribuída no Flutter.

## 2. Arquitetura

### 2.1. Componentes e responsabilidades

#### Flutter

O aplicativo deverá:

- listar e filtrar os processos da fila;
- criar um processo a partir do link do Documento A;
- mostrar o código `Hxxx` retornado pelo banco;
- abrir os Documentos A e B;
- apresentar itens, custos, fotos, fontes, claims e pendências;
- conduzir separadamente as Revisões 01, 02 e 03;
- registrar checklists, pareceres e correções;
- apresentar as ações exclusivas do proprietário;
- solicitar a finalização por uma única RPC;
- tratar conflitos de versão e chamadas repetidas;
- mostrar os relógios e demais registros criados.

O Flutter não deverá gerar códigos, guardar tokens do Drive, executar uma
finalização por vários inserts independentes nem decidir sozinho permissões ou
validade de revisões.

#### Supabase

O Supabase será a fonte oficial para:

- o estado da fila e sua sequência global;
- dados estruturados de intake;
- metadados e vínculos dos documentos;
- execuções de extração;
- revisões, checklists, snapshots e pendências;
- aprovação e cancelamento pelo proprietário;
- controle de versão e auditoria;
- RLS e autorização;
- rateios e reconciliação;
- finalização transacional e idempotente;
- vínculos entre processo, itens e registros canônicos.

#### Google Drive

O Drive continuará armazenando os Documentos A e B e os arquivos originais,
inclusive fotografias. Nomes de arquivos são apresentação, não fonte de estado,
aprovação ou sequência. Nenhum original será apagado, movido ou substituído
durante a finalização.

#### Agentes

Na primeira versão, revisões poderão ser executadas com auxílio externo, mas o
aplicativo controlará estados, versões, documentos, checklists, snapshots,
pareceres e aprovações. Cada uso de agente deverá registrar provedor, agente,
modelo, versão, prompt e data.

Uma integração automática futura deverá rodar em serviço seguro no servidor,
com OAuth do Drive de escopo mínimo, segredos fora do Flutter, limites, logs e
idempotência. Agentes não poderão aprovar como proprietário nem promover dados
automaticamente ao catálogo.

### 2.2. Separação entre preparação e catálogo

Os processos ficarão em tabelas de staging. `watches` continuará representando
somente o catálogo canônico. Registros finais serão criados apenas após as três
revisões e a aprovação explícita de Dani.

## 3. Identidades e sequência

### 3.1. Código do processo

`H001` já pertence a um processo real e deverá ser importado ou preservado como
processo histórico antes da abertura da fila para novos cadastros. A sequência
global nova começará em `H002`.

A criação deverá usar uma sequence global no banco (ou mecanismo transacional
equivalente), nunca `max + 1`, nomes do Drive ou geração no cliente. O número e
o código serão armazenados separadamente:

- `intake_number bigint`;
- `intake_code text`.

O formato terá padding mínimo de três dígitos: `H002`, ..., `H999`, `H1000`.
Códigos cancelados ou consumidos por uma transação não serão reutilizados;
lacunas são aceitáveis.

### 3.2. Identificador da peça

`intake_code` nunca será confundido com `horoteca_code` ou outro identificador
canônico da peça. Quando houver número de pedido:

- uma peça: usar o número do pedido;
- várias peças: usar `PEDIDO-01`, `PEDIDO-02`, `PEDIDO-03` etc., na ordem
  documental aprovada.

Sem número de pedido, o identificador permanecerá pendente até decisão explícita;
o código `Hxxx` não será usado automaticamente como substituto.

## 4. Documentos

### 4.1. Documento A — fonte original

Ao criar o processo, registrar separadamente:

- provedor;
- ID do arquivo no Google Drive;
- URL;
- nome original;
- última modificação conhecida;
- data de inclusão na fila;
- `intake_code` do processo;
- observações;
- versão do prompt aplicado pelo Gemini;
- data da extração.

O Documento A contém anúncios, comprovantes, textos, imagens e a extração
estruturada. A extração é auxiliar e permanece sujeita às revisões. O banco
guardará identificadores, links, metadados, snapshots estruturados e evidências,
mas não binários grandes.

O acesso a A será verificado ao iniciar ou concluir cada revisão e antes da
finalização. Se estiver inacessível, o processo ficará bloqueado até o acesso
ser restabelecido. Alterações externas detectadas pela revisão/horário do Drive
ou por hash deverão sinalizar ou invalidar revisões afetadas.

### 4.2. Documento B — ficha de trabalho e aprovada

Existirá um único Documento B por processo. Em lotes, ele conterá uma ficha
completa, claramente separada, para cada relógio. Correções criarão novas versões
do mesmo Documento B, sem alterar o código H e sem apagar versões anteriores.

Antes da aprovação, o nome seguirá a forma de ficha em preparação. Depois da
aprovação explícita do proprietário, poderá receber:

```text
[Hxxx] - HOROTECA - [PEDIDO] - [IDENTIFICAÇÃO] - FICHA APROVADA
```

Quando houver várias peças, `[IDENTIFICAÇÃO]` será `LOTE`. A expressão
`FICHA APROVADA` não poderá ser usada antes da aprovação do proprietário, e o
estado oficial nunca será inferido apenas do nome.

O Documento B sempre permanecerá vinculado ao Documento A. A e todas as versões
anteriores de B nunca serão apagados ou substituídos.

## 5. Máquina de estados

### 5.1. Progresso apresentado

```text
Novo → Revisão 01 → Revisão 02 → Revisão 03
     → Aprovação do proprietário → Cadastro final → Concluído
```

### 5.2. Estados internos

```text
new
draft
submitted_for_review_01
review_01_in_progress
review_01_corrections_requested
review_01_approved
submitted_for_review_02
review_02_in_progress
review_02_corrections_requested
review_02_approved
submitted_for_review_03
review_03_in_progress
review_03_corrections_requested
review_03_approved
awaiting_owner_approval
owner_corrections_requested
owner_approved
finalization_ready
finalizing
finalization_failed
completed
cancelled
```

Dani poderá cancelar em qualquer estado. O cancelamento será uma transição
auditada e preservará código, documentos, itens, extrações, revisões, snapshots,
pendências, decisões e histórico. Não haverá exclusão em cascata dos artefatos
do processo nem reutilização do código.

Correções retornarão à etapa adequada e criarão nova versão de B quando o seu
conteúdo mudar. Uma alteração relevante invalidará ou sinalizará a revisão
afetada e todas as posteriores. Cada processo terá `version` para controle de
concorrência; operações sensíveis exigirão `expected_version`.

## 6. Modelo de dados proposto

Os nomes são definitivos para planejamento, mas o DDL só será preparado após a
auditoria da baseline.

### 6.1. `watch_intakes`

- `id`, `user_id`;
- `intake_number`, `intake_code` (ambos únicos globalmente);
- `status`, `current_stage`, `version`;
- `title`, `notes`;
- `expected_item_count`, `identified_item_count`;
- datas de inclusão, submissão, aprovação, finalização e cancelamento;
- `finalization_key`, datas e código de erro da finalização;
- `created_at`, `updated_at`.

### 6.2. `watch_intake_documents`

- processo e usuário;
- papel (`source_a`, `working_b`, `approved_b`, apoio);
- provedor, ID externo, URL, nomes original e de exibição;
- pasta de destino e última modificação conhecida;
- versão, situação e documento anterior;
- vínculo de B com A;
- responsável ou execução de agente que criou a versão;
- datas de registro e criação.

O papel `approved_b` somente será atribuído por operação autorizada depois da
aprovação do proprietário.

### 6.3. `watch_intake_extractions`

- processo e Documento A;
- provedor, agente, modelo e versões;
- nome e versão do prompt;
- data, estado, erro resumido;
- snapshot estruturado e referência opcional da resposta bruta.

Cada execução será preservada; nenhuma extração atualizará fatos automaticamente.

### 6.4. `watch_intake_items`

- processo, sequência e posição visual;
- pedido, item, marketplace item e identificador candidato;
- campos estruturados candidatos de identificação e ficha técnica;
- IDs candidatos de marca, modelo e calibre;
- estado explícito de correspondência (`unreviewed`, `exact_match`,
  `explicit_new`, `ambiguous`, `not_applicable`);
- `final_watch_id`, código canônico final e data de finalização.

Marca, modelo e calibre desconhecidos poderão permanecer nulos. Não haverá
correspondência aproximada, criação ou merge automático. `ambiguous` bloqueará a
finalização até decisão explícita; desconhecido poderá continuar `NULL`.

### 6.5. `watch_intake_acquisitions`

- marketplace, vendedor e pedido;
- datas de compra, pagamentos, envio, previsão e recebimento;
- pagamento, transportadora e rastreamento;
- vínculo ao documento e observações;
- aquisição canônica candidata e estado explícito do match.

### 6.6. `watch_intake_expenses`

- processo, aquisição/item opcional e categoria;
- descrição, data e moeda;
- valores original e BRL em `numeric` e câmbio, todos anuláveis;
- indicação de compartilhamento e método de rateio;
- referência documental e observações.

### 6.7. `watch_intake_expense_allocations`

- despesa e item;
- base e peso do rateio;
- valor não arredondado;
- valor arredondado para cima em BRL;
- ajuste de reconciliação separado;
- parcela final;
- revisão em que o cálculo foi aprovado.

A soma das parcelas finais será exatamente igual ao total documental.

### 6.8. `watch_intake_sources` e `watch_intake_claims`

As fontes guardarão tipo, documento, URL, classificação, confiança, trecho,
acesso e observações. Claims guardarão campo, texto literal, valor normalizado,
autor/origem (documento, vendedor, Gemini, outro agente, pesquisa ou observação),
classificação, estado, confiança, contexto e revisão.

### 6.9. `watch_intake_photos` e `watch_intake_photo_links`

Fotos guardarão provedor, ID externo, URL, `storage_path` opcional, Documento A,
origem, posição, classificação, ordem, observações e candidatura a capa. A tabela
de links permitirá relacionar a foto a uma ou várias peças.

O original permanecerá no Drive. Uma foto escolhida para exibição no aplicativo
será copiada também para o Supabase Storage, com vínculo ao original; a cópia não
autorizará exclusão ou alteração do arquivo do Drive.

### 6.10. `watch_intake_revisions`

Cada passagem terá:

- tipo e número sequencial da revisão;
- estado e versões inicial/revisada do processo;
- versões de A e B examinadas;
- responsável;
- modo humano, assistido ou agente no servidor;
- agente, modelo e prompt com versões;
- início, conclusão, decisão e parecer;
- versão e resultado do checklist;
- snapshot imutável e hash.

Revisões concluídas não serão sobrescritas; uma nova passagem cria nova linha.

### 6.11. `watch_intake_findings`

Pendências guardarão revisão, peça/campo afetado, categoria, severidade,
descrição, fonte, estado, resolução, responsável e versão de resolução. Categorias
abrangerão omissão, troca de peças, invenção, identificador, data, valor, rateio,
fonte, classificação, imagem, duplicidade, técnica e escopo histórico.

### 6.12. `watch_intake_owner_decisions`

Cada ação `approve`, `request_correction` ou `cancel` guardará proprietário,
versão do processo, Documento B, snapshot, hash, observações e data. Decisões são
imutáveis; mudanças relevantes exigem nova aprovação.

### 6.13. `watch_intake_transitions`

Log imutável com estado anterior/novo, versão, ator, tipo de ator, motivo,
metadados e data. O Flutter não terá permissão direta de update/delete.

### 6.14. `watch_intake_finalizations`

Guardará processo, chave idempotente, versão solicitada, estado, proprietário,
datas, resultado com IDs criados e erro seguro. Um vínculo único relacionará cada
item ao relógio final e preservará o `intake_code`.

## 7. Revisões

### 7.1. Revisão 01 — criação da ficha estruturada

Deverá ler A integralmente, usar a extração Gemini apenas como auxílio, conferir
anúncios, comprovantes, textos e imagens, identificar e separar todas as peças,
preservar identificadores, estruturar aquisição, datas, custos, rateios, fontes,
claims, fotos e ficha técnica e criar a primeira versão do Documento B.

Registrará data, responsável, agente/modelo, prompt, checklist, parecer, versão,
snapshot e hash. Alegações do vendedor ou agente não serão confirmadas por padrão.

### 7.2. Revisão 02 — comparação independente entre A e B

Deverá reabrir e reler integralmente A e B, procurando omissões, trocas entre
peças, invenções, classificações erradas e erros em datas, valores, rateios,
imagens e identificadores. Pesquisa será feita somente quando necessária e suas
fontes serão registradas.

Todas as correções e pendências serão estruturadas, sem modificar o histórico da
Revisão 01. Mesmo quando executada pelo mesmo usuário, será uma nova passagem,
com datas, checklist, parecer e snapshot próprios.

### 7.3. Revisão 03 — crítica final e consolidação

Deverá reler A e B, analisar integralmente o parecer e os findings da Revisão 02,
confirmar as resoluções e revisar por peça identificação, técnica, custos,
rateios, fontes, claims, fotos, histórias, correspondências e duplicidades.

Produzirá a versão final de B, executará checklist final por peça e registrará
aprovação técnica ou devolução. Aprovação técnica não autoriza o cadastro final.

## 8. Aprovação e cancelamento pelo proprietário

Depois da Revisão 03, o estado será `awaiting_owner_approval`. Dani poderá:

- **APROVAR FICHA**: registrar usuário, data, versão, Documento B, snapshot e
  hash aprovado;
- **SOLICITAR CORREÇÃO**: registrar motivo, pendências, itens/campos e etapa de
  retorno;
- **CANCELAR PROCESSO**: encerrar sem apagar nenhum artefato.

Cancelar também estará disponível a Dani em qualquer etapa. A identidade de
proprietário será validada no servidor por papel protegido, não por campo
editável no cliente. Mudança relevante após aprovação invalida a aprovação e
exige nova decisão.

## 9. Custos e rateios

- Valores usam `numeric`; desconhecido fica `NULL`.
- O total original e o total documental em BRL nunca serão alterados para fechar
  rateio.
- Com valores individuais, despesas compartilhadas serão proporcionais aos
  valores individuais.
- Sem valores individuais, a divisão será em partes iguais.
- Antes da aprovação, o proprietário poderá corrigir manualmente parcelas ou
  critério, com justificativa e novo snapshot.
- Parcelas serão arredondadas para cima ao centavo em BRL.
- A diferença será registrada em `reconciliation_adjustment_brl` separado.
- A soma das parcelas finais deverá ser exatamente igual ao total documental.

Como padrão seguro, o ajuste será aplicado à maior parcela; em empate, ao último
item pela sequência documental. O valor arredondado e o ajuste permanecerão
visíveis, e uma correção manual poderá alterar o item de reconciliação antes da
aprovação.

## 10. Fotos e evidências

Fotos poderão inicialmente pertencer ao Documento A/lote e depois ser vinculadas
a uma ou várias peças. Serão preservados origem, Documento A, posição visual,
peças relacionadas, classificação, observações, ordem e capa.

Originais permanecem no Drive. Fotos selecionadas para exibição serão também
armazenadas no bucket privado do Supabase, sob caminho do usuário, mantendo o ID
e o link do original. Falha na cópia necessária à exibição deverá bloquear a
finalização daquela foto ou mantê-la explicitamente como pendência, sem apagar o
original.

## 11. Finalização transacional

Somente Dani poderá chamar a operação conceitual:

```text
finalize_watch_intake(intake_id, expected_version, idempotency_key)
```

A RPC deverá:

1. verificar sessão, propriedade, papel, estado e versão;
2. verificar acesso atual aos Documentos A e B;
3. verificar as três revisões válidas;
4. verificar aprovação do proprietário para a mesma versão/snapshot;
5. verificar findings bloqueantes e duplicidades;
6. bloquear matches ambíguos, sem criar ou mesclar entidades automaticamente;
7. criar ou vincular aquisição explicitamente;
8. criar todos os relógios;
9. criar itens de aquisição;
10. registrar despesas e rateios reconciliados;
11. registrar fontes, claims, eventos e fotos;
12. vincular cada item ao relógio final;
13. preservar o vínculo dos relógios com `Hxxx`;
14. registrar a transição e os IDs criados;
15. marcar o processo como concluído e retornar o mesmo resultado em repetições.

Qualquer falha desfará toda a transação no banco. Arquivos externos não serão
apagados, movidos ou substituídos. Marca, modelo ou calibre desconhecidos
permanecerão nulos.

## 12. Interface planejada

Serão necessárias:

1. lista da Fila por estado, com busca por H, pedido e item;
2. criação de processo colando o link de A;
3. detalhe com `Hxxx`, progresso e acesso a A/B;
4. lista e ficha de todos os relógios encontrados;
5. seções de aquisição, custos/rateios, fotos, fontes e claims;
6. tela própria para cada revisão;
7. checklists, findings, pareceres, snapshots e histórico;
8. solicitação e resolução de correções;
9. aprovação/cancelamento exclusivos do proprietário;
10. pré-validação e execução do cadastro final;
11. resultado com IDs e atalhos para os relógios criados.

## 13. Baseline obrigatória

Antes de qualquer migration:

1. capturar o esquema remoto oficial;
2. comparar com todas as migrations no Git;
3. verificar tabelas, dados, constraints e dependências;
4. revisar RLS, políticas, grants, índices, triggers e funções;
5. revisar Storage e seus vínculos;
6. identificar drift, órfãos e duplicidades;
7. executar advisors de segurança e desempenho;
8. preparar backup e estratégia testada de recuperação;
9. importar/preservar H001 e configurar o próximo número como H002;
10. validar DDL futura em transação com rollback.

Nenhuma alteração estrutural será aplicada antes dessa etapa e de nova revisão
do diff de migration.

## 14. Fases de implementação

1. **Baseline e recuperação:** auditoria remota, backup e preservação de H001.
2. **Especificação executável:** ERD, estados, permissões, checklists e contrato
   staging-canônico.
3. **Protótipo local de banco:** concorrência da sequência, RLS, transições,
   rateios, invalidação, idempotência e rollback.
4. **Staging no Supabase:** somente após aprovação da migration e baseline.
5. **Domínio Flutter:** módulo próprio de intake, repositórios e controle de
   versão.
6. **Fila MVP:** lista, criação, A/B, itens, histórico e documentos.
7. **Revisão 01:** estruturação e primeira versão de B.
8. **Revisão 02:** comparação independente e findings.
9. **Revisão 03:** consolidação e B final.
10. **Proprietário:** aprovação, correção e cancelamento em qualquer etapa.
11. **Finalização:** RPC, resultado e abertura dos relógios.
12. **Agentes futuros:** jobs no servidor, OAuth mínimo e auditoria.
13. **Rollout:** ambiente de teste, lotes de uma/várias peças, falhas,
    concorrência, piloto e aplicação controlada.

Após mudanças futuras no Flutter serão obrigatórios `dart format`,
`flutter analyze`, `flutter test` e build Android. Após DDL serão obrigatórios
rollback de teste, inspeção do esquema e advisors.

## 15. Riscos e controles

| Risco | Controle obrigatório |
| --- | --- |
| Confundir H com código da peça | Campos, relações e rótulos distintos |
| Colisão de sequência | Sequence global/RPC atômica; H001 reservado |
| Inferir aprovação pelo nome | Estado e decisão oficiais no Supabase |
| Perder A ou B anterior | Versionamento imutável e nenhuma exclusão |
| Documento A inacessível | Bloqueio de revisão e finalização |
| Extração virar fato | Origem/classificação e revisão explícitas |
| Revisões virarem uma confirmação única | Passagens, datas e snapshots separados |
| Aprovação desatualizada | Versão, hash e invalidação automática |
| Cancelamento destrutivo | Transição auditada sem apagar artefatos |
| Merge técnico incorreto | Sem correspondência automática; ambiguidade bloqueia |
| Cadastro parcial | Uma RPC e uma transação |
| Clique repetido | Chave idempotente e vínculos únicos |
| Soma de rateio divergente | Ajuste separado e constraint de reconciliação |
| Desconhecido virar zero | Campos anuláveis e validação |
| Foto perdida no Drive | Original intocado; cópia adicional no Storage |
| Segredo no Flutter | Credenciais somente em backend seguro |
| Esquema não reproduzível | Baseline remota obrigatória antes de DDL |

## 16. Critérios de aceite

### Processo e documentos

- H001 é preservado/importado e o primeiro código novo é H002.
- A sequência é global, concorrente e continua em H1000.
- Um processo contém uma ou várias peças sem confundir identidades.
- A e todas as versões de B são preservadas.
- B é único por processo, com fichas separadas por peça.
- Lotes usam `LOTE` no nome de B.
- `FICHA APROVADA` só aparece após aprovação de Dani.
- A inacessível bloqueia revisões e finalização.

### Revisões e proprietário

- As três revisões possuem passagens, datas, responsáveis, modelos/prompts,
  checklists, pareceres, snapshots e hashes próprios.
- Revisão 02 relê e compara A/B; Revisão 03 trata o parecer e findings.
- Alteração relevante invalida revisões e aprovação afetadas.
- Dani pode cancelar em qualquer estado sem perda histórica.
- Apenas Dani aprova e finaliza.

### Dados, custos e fotos

- Identificadores documentais são preservados literalmente.
- Desconhecidos permanecem nulos.
- Marca, modelo e calibre não são criados ou mesclados automaticamente.
- Rateio é proporcional quando há valores individuais e igualitário quando não
  há, com correção manual auditada.
- Arredondamento para cima e ajuste de reconciliação ficam separados.
- A soma final preserva exatamente o total documental.
- Originais permanecem no Drive e imagens de exibição têm cópia no Storage.

### Segurança e finalização

- Todas as tabelas expostas possuem RLS por `user_id`, índices adequados e
  políticas de update com `USING` e `WITH CHECK`.
- O papel de proprietário é protegido no servidor.
- Flutter não contém segredos administrativos ou do Drive.
- A finalização exige A/B acessíveis, revisões e aprovação válidas para a mesma
  versão.
- Falha faz rollback total; repetição retorna os mesmos IDs.
- Cada item fica ligado a exatamente um relógio e o vínculo com H é preservado.

## 17. Pendências realmente bloqueantes

As decisões abaixo precisam ser resolvidas antes da migration ou da respectiva
fase indicada; as demais adotarão os padrões seguros deste documento.

1. **Identidade de Dani no ambiente oficial:** definir o `auth.users.id` inicial
   e o mecanismo protegido de papel `owner` antes de criar políticas e RPCs.
2. **Importação de H001:** localizar e validar Documento A, itens, estado e
   metadados do processo real para criar o registro histórico sem inventar dados.
3. **Identificador sem pedido:** definir a regra canônica antes de finalizar o
   primeiro relógio que não possua número de pedido; até lá ele permanece
   pendente e não bloqueia outros processos.
4. **Acesso técnico ao Google Drive:** antes de automatizar verificação, cópia ou
   versionamento de B, escolher a conta, as pastas e o fluxo OAuth. A primeira
   versão poderá abrir links e registrar operações assistidas, mas deverá ter um
   método verificável para bloquear quando A estiver inacessível.
5. **Baseline remota e recuperação:** capturar o esquema e validar backup antes
   de escrever ou aplicar qualquer migration, pois o Git não contém a criação
   original completa de `watches` e `maintenance_logs`.
