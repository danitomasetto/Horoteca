# Horoteca Flutter

Nova base multiplataforma do Horoteca. O aplicativo Android anterior permanece na raiz do repositório enquanto esta versão é validada.

## Primeira entrega

- Android e iOS a partir do mesmo código;
- autenticação por e-mail e senha no Supabase;
- sessão persistente;
- leitura da coleção protegida por RLS;
- saída segura da conta;
- teste do mapeamento de dados.

## Executar

```sh
flutter create --platforms android,ios --org br.com.tomasetto --project-name horoteca .
flutter pub get
flutter run
```

As configurações públicas do cliente podem ser substituídas no build:

```sh
flutter run \
  --dart-define=SUPABASE_URL=https://SEU-PROJETO.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

Nunca use uma chave `service_role` ou `sb_secret_` no aplicativo.
