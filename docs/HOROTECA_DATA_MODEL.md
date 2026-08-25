# Modelo de dados da Horoteca

## Princípio

A ficha do relógio é formada por dados técnicos, aquisição, custos, eventos,
fontes, fotografias e contexto histórico. Cada categoria possui estrutura
própria; `notes` é apenas complemento.

## Estruturas principais

- `watches`: identidade física e ficha técnica de cada peça.
- `brands`: história e informações institucionais da marca.
- `watch_models`: história e contexto de uma linha ou modelo.
- `movement_calibers`: história e dados técnicos do calibre.
- `acquisitions`: dados comuns de um pedido ou lote.
- `acquisition_items`: vínculo entre a aquisição e cada relógio do pedido.
- `expenses`: valores documentais de produto, frete, impostos, taxas,
  transportadora, manutenção, peças e outros gastos.
- `expense_allocations`: parcelas de uma despesa atribuídas a cada relógio.
- `watch_events`: linha do tempo de compra, envio, recebimento e manutenção.
- `watch_sources`: documentos e classificação das evidências.
- `watch_claims`: afirmações por campo que ainda precisam ser aceitas, rejeitadas
  ou substituídas; preserva o texto original sem promovê-lo automaticamente a
  dado confirmado do relógio.
- `watch_photos`: arquivos de imagem e seus metadados.
- `watch_photo_links`: permite que uma foto de lote represente várias peças.

## Custos

O valor original de uma despesa nunca é alterado para acomodar arredondamento.
O rateio registra o método, a base, a parcela por peça e o ajuste de
arredondamento. O custo de uma peça é a soma das alocações vinculadas a ela.

## Evidências

As classificações padronizadas são:

- `document_confirmed`
- `seller_statement`
- `visual_observation`
- `researched`
- `estimated`
- `missing`
- `inconsistent`

As alegações usam os estados `pending`, `accepted`, `rejected` e `superseded`.
O valor afirmado é mantido literalmente, ao lado de uma normalização opcional,
da fonte, da classificação, da confiança e da revisão.

## Anúncios e ficha comercial

Os campos mais comuns do anúncio possuem colunas próprias: título, URL,
categoria, condição declarada, quantidade, idioma e data de captura. Os pares
chave/valor específicos de cada marketplace são preservados integralmente em
`acquisition_items.listing_specifics` (`jsonb`). Isso permite guardar novos
atributos sem misturá-los à ficha técnica confirmada.

## Campos ampliados da peça

`watches` também comporta tipo, exibição, público, luneta, cor da pulseira,
caixa e documentos originais, acessórios, personalização e características.
`movement_calibers` comporta frequência, reserva de marcha, dimensões,
corda manual, parada de segundos, correções rápidas, proteção contra choques,
escape e descrição do sistema de corda. Booleanos desconhecidos permanecem
`NULL`.

## Compatibilidade

Os campos legados de `watches` permanecem disponíveis durante a transição. A
aplicação Flutter deve migrar para as estruturas normalizadas antes de qualquer
remoção futura. `maintenance_logs` permanece como tabela legada até que todos os
consumidores usem `watch_events` e `expenses`.
