# Horoteca Web

Página estática da coleção Horoteca, com login, acesso à ficha completa, custos
estruturados, histórico, fontes e inclusão de fotografias de cada peça.

Publicacao inicial:

```text
https://danitomasetto.github.io/Horoteca/
```

A pagina usa GitHub Pages para hospedar a interface e Supabase para carregar os dados da colecao.

## Autenticacao

A pagina permite entrar com e-mail e senha, solicitar recuperacao por e-mail e
definir uma nova senha quando o Supabase redireciona com uma sessao de
recuperacao. No Supabase, `Authentication > URL Configuration` deve usar:

```text
Site URL: https://danitomasetto.github.io/Horoteca/
Redirect URL: https://danitomasetto.github.io/Horoteca/
```

O navegador usa somente a chave publica (`sb_publishable_...`). Nunca publicar
`service_role` ou secret keys.

## Fotografias

Na coleção, o botão `+ Adicionar fotos` permite selecionar uma ou várias imagens
JPEG, PNG, WebP, HEIC ou HEIF, com limite de 15 MB por arquivo. A primeira foto
adicionada à peça passa a ser sua capa.

Os arquivos ficam no bucket privado `watch-photos`, dentro da pasta do usuário
autenticado. A página mostra as imagens por links temporários assinados e respeita
as políticas RLS do banco e do Storage. Nenhuma chave administrativa é usada no
navegador.

Depois, quando o dominio estiver pronto, adicionar o arquivo `CNAME` nesta pasta e configurar o DNS do dominio para GitHub Pages.
