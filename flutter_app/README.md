# Horoteca Flutter

Aplicativo canônico da Horoteca para Android e iOS. A implementação Android
antiga permanece em `app/` apenas como legado.

## Recursos atuais

- Android e iOS a partir do mesmo código;
- autenticação por e-mail e senha no Supabase;
- sessão persistente;
- leitura da coleção protegida por RLS;
- saída segura da conta;
- ficha completa de identificação, aquisição e procedência;
- custos individuais e rateados por peça;
- especificações da caixa, mostrador, pulseira e movimento;
- história da marca, do modelo e do calibre;
- fontes classificadas por grau de evidência;
- linha do tempo, manutenções e fotografias.

Os cadastros são preparados e revisados fora do aplicativo antes da gravação.
Informação desconhecida permanece vazia no banco e aparece como “Não
informado” na interface.

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
