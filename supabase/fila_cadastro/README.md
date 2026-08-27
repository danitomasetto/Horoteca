# Fila de Cadastro — fundação executável

Esta pasta preserva a **especificação executável e os testes locais** que deram
origem à migration da Fila de Cadastro. A migration ainda não foi aplicada ao
Supabase oficial.

O objetivo desta etapa é validar o modelo, a segurança e a importação histórica
de H001 em uma instância descartável antes de qualquer aplicação remota.

## Arquivos

- `../migrations/20260827094104_fila_cadastro.sql`: migration gerada pela
  Supabase CLI a partir da fundação e das operações aprovadas.

- `foundation_prototype.sql`: cria a fundação relacional, a máquina de estados,
  RLS, grants, trilhas append-only e proteções de identidade.
- `operations_prototype.sql`: implementa transições otimistas, revisões,
  invalidação por mudança de conteúdo, rateio reconciliado, decisão exclusiva do
  proprietário e finalização transacional/idempotente com papel interno sem
  `BYPASSRLS`.
- `import_h001_prototype.sql`: importa H001 de forma idempotente, recebendo o
  UUID do proprietário por variável do `psql`; nenhum UUID real fica no Git.
- `tests/validate_foundation.sql`: prova estrutura, RLS, isolamento, H001,
  geração atômica de H002, H1000, imutabilidade e preservação dos grants
  canônicos.
- `tests/validate_operations.sql`: percorre um lote de duas peças pelas três
  revisões, testa autorização, reconcilia centavos, força uma falha após o início
  da promoção, comprova rollback integral e repete a mesma finalização sem
  duplicar dados.

## Decisões congeladas nesta etapa

- `Hxxx` identifica o processo e vem de uma sequência global no servidor.
- H001 é histórico; a próxima criação é H002. O preenchimento mínimo é de três
  dígitos, sem limitar H1000 ou números posteriores.
- O Documento A preserva provedor, ID, nome e datas originais e é logicamente
  imutável.
- O Documento B histórico de H001 permanece `working_b`. O texto antigo
  `FICHA APROVADA` é metadado histórico e não substitui as três revisões nem a
  aprovação explícita do proprietário no fluxo V2.
- Dados desconhecidos continuam `NULL`; alegações do vendedor ficam separadas
  de fatos validados.
- As 17 tabelas públicas têm RLS. `anon` não recebe privilégios. Usuários
  autenticados só acessam as próprias linhas, e chaves compostas impedem
  vínculos entre proprietários.
- Não existem políticas diretas de `DELETE`. Cancelamento é estado, não
  exclusão.
- Decisões do proprietário, transições e finalizações são append-only.
- `watches` continua sendo o catálogo publicado. O staging não publica peças
  diretamente.

## Operações protegidas do protótipo

- `transition_watch_intake`: aplica somente transições catalogadas, com controle
  de versão e cancelamento exclusivo do proprietário.
- `start_watch_intake_revision` e `complete_watch_intake_revision`: preservam
  passagens, checklist, snapshot e hash; conclusão direta por `UPDATE` é
  bloqueada.
- `recalculate_watch_intake_allocation`: usa proporção quando todas as peças têm
  valores individuais, divisão igual quando não têm, arredonda para cima e
  registra o ajuste de reconciliação separadamente.
- `decide_watch_intake`: exige papel `owner`, três revisões válidas para a mesma
  versão e Documento B acessível.
- `finalize_watch_intake`: promove aquisição, peças, despesas, rateios, fontes,
  claims e fotos copiadas em uma subtransação; falha não deixa cadastro parcial
  e a chave idempotente devolve o mesmo resultado.

`version` representa a versão do conteúdo. Transições não a alteram. Qualquer
mudança relevante aumenta a versão, retorna o processo a `draft` e torna
revisões/decisões antigas incompatíveis com a versão atual.

## Deliberadamente fora desta etapa

- aplicação da promoção transacional no catálogo canônico oficial;
- integração do aplicativo Flutter;
- movimentação, cópia ou renomeação de arquivos no Google Drive;
- aplicação no Supabase oficial.

Esses itens dependem da aprovação desta fundação. A finalização deverá ser uma
operação única, idempotente e transacional, liberada somente após três revisões
válidas e decisão explícita do proprietário.

## Validação local/CI

O workflow `Validate Fila de Cadastro migration`:

1. inicia uma stack Supabase descartável;
2. aplica a baseline canônica uma vez;
3. valida a baseline;
4. cria dois usuários fictícios locais;
5. aplica a migration uma vez e importa H001 duas vezes para provar
   idempotência;
6. executa as assertions de segurança, domínio e operações transacionais;
7. roda `supabase db lint --local --level error`;
8. destrói todos os recursos locais, mesmo em caso de falha.

Nenhum token, project ref ou credencial remota é usado.

A migration foi criada com a Supabase CLI e precisa permanecer verde nesta
branch antes de qualquer aplicação oficial. A aplicação remota continua sendo
uma etapa separada e depende de aprovação explícita.
