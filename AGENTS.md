# Horoteca — orientação permanente

## Fonte oficial e escopo

- O repositório oficial é `danitomasetto/Horoteca`.
- A aplicação canônica instalada no tablet é `flutter_app/`.
- `app/` é a implementação Android legada e não deve receber novas funcionalidades.
- `horoteca-web/` é a consulta web publicada no GitHub Pages.
- O Supabase oficial é o projeto `nlkhbhgzscpdistzuyod`.
- O GitHub é a fonte permanente; ambientes de execução podem ser temporários.

## Regras de produto

- Dani Tomasetto é o responsável pelo produto e aprova decisões funcionais.
- Não inventar dados de relógios. Informação desconhecida deve permanecer `NULL`.
- Preservar exatamente pedidos, itens, referências, calibres, números de série,
  códigos de caixa e rastreamentos.
- Datas são exibidas como `DD/MM/AAAA` e armazenadas como `date` ou
  `timestamptz` em formato ISO.
- Valores monetários usam `numeric`; nunca `float` no banco.
- Compras em lote devem preservar o valor documental total, o critério de
  rateio, as parcelas por relógio e a diferença de arredondamento.
- Não misturar história da marca, história do modelo e história do calibre.
- Não concentrar dados estruturados no campo `notes`.

## Banco e segurança

- Nunca expor `service_role`, secret keys ou credenciais no aplicativo.
- Toda tabela exposta deve ter RLS e políticas limitadas por `user_id`.
- Políticas de `UPDATE` precisam de `USING` e `WITH CHECK`.
- Usar `(select auth.uid())` nas políticas e indexar `user_id` e FKs.
- Mudanças de esquema devem ser registradas em `supabase/migrations/`.
- Não apagar usuários, buckets, arquivos ou dados sem autorização explícita.
- Antes de aplicar DDL, revisar dependências e testar em transação com rollback.

## Verificação obrigatória

- Executar `dart format`, `flutter analyze`, `flutter test` e build Android após
  mudanças no Flutter.
- Validar a migração no banco, consultar o esquema resultante e executar os
  advisors de segurança e desempenho do Supabase.
- Uma tarefa só termina após conferir o diff e registrar o resultado no Git.

