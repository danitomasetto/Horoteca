# Horoteca Web

Página estática de consulta da coleção Horoteca, com login e acesso à ficha
completa, custos estruturados, histórico e fontes de cada peça.

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

Depois, quando o dominio estiver pronto, adicionar o arquivo `CNAME` nesta pasta e configurar o DNS do dominio para GitHub Pages.
