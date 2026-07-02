# Passo a passo para testar a API — fut-app

## Rápido

```bash
python manage.py runserver
```

Acesse:
- API web: `http://localhost:8000/`
- Swagger: `http://localhost:8000/swagger/`
- Admin: `http://localhost:8000/admin/`

> Importante: antes de usar o Postman, mantenha o terminal do `runserver` aberto e verifique se aparece a mensagem `Starting development server at http://127.0.0.1:8000/`. Sem isso, qualquer requisição do Postman retornará `Error: connect ECONNREFUSED 127.0.0.1:8000`.

---

## Pré-requisito no Postman

1. Crie um novo ambiente clicando em `Environments > +` e nomeie-o como `fut-app-local`
2. Adicione uma variável com as configurações:
   - **Variável**: `base_url`
   - **Valor inicial**: `http://localhost:8000`
3. Selecione o ambiente `fut-app-local` no canto superior direito do Postman antes de fazer as requisições

### Pós-configuração no Postman
- Na requisição, use exatamente: `{{base_url}}/api/...`
- Não adicione `http://127.0.0.1:8000` manualmente junto com a variável, pois isso duplica o host
- Se o erro `ECONNREFUSED` persistir, vá em **File > Settings > General** e desative **SSL certificate verification** se estiver usando HTTPS por engano
- Teste primeiro com uma URL simples no navegador ou no próprio Postman: `{{base_url}}/` para confirmar que o servidor responde

---

## Solução rápida para ECONNREFUSED

- Verifique no terminal se o servidor está ativo.
- Confira se a porta é realmente `8000` e não outra porta exibida no terminal.
- No Postman, confira se o ambiente ativo é `fut-app-local` e se `base_url` está com `http://localhost:8000`.
- Teste primeiro pelo navegador: `http://localhost:8000/`.
- Se ainda falhar, pare o servidor (`Ctrl + C`) e suba novamente com `python manage.py runserver`.

---

## 1. Configurar variáveis de ambiente

Copie o `.env.example` para `.env.local` e preencha:

```env
SECRET_KEY=sua-chave-secreta
DEBUG=True
DB_ENGINE=django.db.backends.mysql
DB_NAME_LOCAL=projeto_futebol
DB_USER_LOCAL=root
DB_PASSWORD_LOCAL=sua-senha
DB_HOST_LOCAL=127.0.0.1
DB_PORT_LOCAL=3306
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend
```

> Em produção (Render): use apenas variáveis de ambiente no painel, nunca `.env`.

---

## 2. Testar endpoints públicos

### 2.1 Listar categorias públicas
1. Clique em `New > Request` para criar uma nova requisição
2. Defina o método como `GET`
3. Cole a URL: `{{base_url}}/api/public/categorias-produtos/`
4. Clique em `Send`
5. Verifique se o status da resposta é `200 OK` e o JSON com a lista de categorias é retornado

---

### 2.2 Listar jogos ordenados
1. Crie uma nova requisição `GET`
2. Cole a URL: `{{base_url}}/api/jogos/?ordering=dia_jogo,hora_jogo`
3. Vá para a aba `Headers`
4. Adicione um novo cabeçalho:
   - **Key**: `Accept`
   - **Value**: `application/json`
5. Clique em `Send`
6. Verifique se os jogos são retornados ordenados por data e hora

---

### 2.3 Buscar produtos por categoria e texto
1. Crie uma nova requisição `GET`
2. Cole a URL: `{{base_url}}/api/produtos/?categoria_produtos=3&search=ingresso&ordering=-valor_produtos`
3. Vá para a aba `Headers`
4. Adicione o cabeçalho:
   - **Key**: `Accept`
   - **Value**: `application/json`
5. Clique em `Send`
6. Verifique se a resposta retorna produtos da categoria 3 que contenham "ingresso" ordenados por valor decrescente

---

## 3. Fluxo completo de teste no Postman

Recomenda-se salvar todas as requisições abaixo em uma mesma Collection para reaproveitar cabeçalhos e variáveis.

---

### 3.1 Configurar autenticação básica

Alguns endpoints exigem usuário autenticado. Como ainda não temos token JWT cadastrado, siga:

1. Abra qualquer requisição
2. Na aba **Authorization**
3. No campo **Type**, selecione **Basic Auth**
4. Preencha:
   - **Username**: `admin` (ou outro usuário staff)
   - **Password**: a senha definida no ambiente local
5. Clique em **Send**

> Se o endpoint retornar `401 Unauthorized`, verifique se esse usuário realmente existe no banco local.

---

### 3.2 Acessar endpoint protegido: meu perfil

1. Crie uma nova requisição `GET`
2. URL: `{{base_url}}/api/meu-perfil/`
3. Na aba **Authorization**, escolha **Basic Auth** e preencha usuário e senha
4. Clique em **Send**
5. Verifique se retorna `200 OK` com os dados do cliente logado

---

### 3.3 Adicionar produto ao carrinho

1. Crie uma nova requisição `POST`
2. URL: `{{base_url}}/api/cart/`
3. Vá para a aba **Body** > **raw** > **JSON**
4. Cole o JSON:
```json
{
  "produto_id": 1,
  "quantidade": 2
}
```
5. Clique em **Send**
6. Verifique se retorna `200 OK` e o item aparece no carrinho

---

### 3.4 Visualizar carrinho

1. Nova requisição `GET`
2. URL: `{{base_url}}/api/cart/`
3. Clique em **Send**
4. Verifique se o item adicionado anteriormente está listado

---

### 3.5 Fazer checkout

1. Nova requisição `POST`
2. URL: `{{base_url}}/api/checkout/`
3. Vá para a aba **Body** > **raw** > **JSON**
4. Cole o JSON:
```json
{
  "endereco_id": 1,
  "forma_pagamento": "cartao"
}
```
5. Clique em **Send**
6. Verifique se retorna `201 Created` ou `200 OK` com o pedido criado

---

### 3.6 Criar um novo cliente (somente admin)

1. Nova requisição `POST`
2. URL: `{{base_url}}/api/clientes/`
3. Na aba **Headers**, adicione:
   - **Key**: `Content-Type`
   - **Value**: `application/json`
4. Na aba **Body** > **raw** > **JSON**, cole:
```json
{
  "nome_clientes": "João",
  "sobrenome_clientes": "Silva",
  "email_clientes": "joao@example.com",
  "cpf_clientes": "12345678900",
  "sexo_clientes": "M",
  "telefone_clientes": "11999999999",
  "categoria_cliente_id_categoria_cliente": 1
}
```
5. Clique em **Send**
6. Verifique se retorna `201 Created`

---

### 3.7 Listar pedidos de um cliente

1. Nova requisição `GET`
2. URL: `{{base_url}}/api/pedidos/?cliente_id_cliente=1`
3. Na aba **Headers**, adicione `Accept: application/json`
4. Clique em **Send`
5. Verifique se retorna lista de pedidos do cliente informado

---

## 4. Dicas para testar no Postman

- Use a aba **Tests** para automatizar verificações após cada requisição
- Habilite **Settings > General > Send no-cache header** para evitar respostas cacheadas
- Para debug, use a aba **Console** do Postman (`View > Show Postman Console`)
- Salve a Collection para compartilhar configurações com a equipe
