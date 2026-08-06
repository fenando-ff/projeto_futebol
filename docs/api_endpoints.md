# Endpoints da API

Esta documentação descreve os endpoints expostos pela API em `app_futebol.urls_api` e os dados principais retornados por cada endpoint.

## Endpoints de documentação

- `GET /swagger/` - UI Swagger interativa
- `GET /swagger.json` - Esquema OpenAPI em JSON

## Prefixo principal

Todas as rotas abaixo são acessíveis sob o prefixo `api/`, ou seja, `GET /api/...`.

---

## Endpoints automáticos do router DRF

### `/api/categorias-produtos/`
- ViewSet: `CategoriaProdutosViewSet`
- Métodos comuns: `GET /`, `GET /{id}/`
- Dados retornados:
  - `id_categoria_produtos`
  - `nome_categoria_produtos`

### `/api/public/categorias-produtos/`
- Mesma lógica de `CategoriaProdutosViewSet`, rota pública adicional.

### `/api/produtos/`
- ViewSet: `ProdutosViewSet`
- Métodos comuns: `GET /`, `GET /{id}/`
- Dados retornados via `ProdutoAPISerializer`:
  - `id_produtos`
  - `nome_produtos`
  - `setor` (mesmo valor de `nome_produtos`)
  - `descricao_produtos`
  - `preco` (valor do produto)
  - `preco_produtos` (valor do produto)
  - `preco_original`
  - `preco_final`
  - `economia`
  - `desconto_percent`
  - `beneficios_plano`
  - `plano_atual`
  - `estoque_produtos`
  - `categoria_produtos`
  - `url_imagem_produtos`
  - `imagem_principal`
  - `imagens` (lista de imagens)
  - `status_produtos`

### `/api/planos/`
- ViewSet: `CategoriaClienteViewSet`
- Dados retornados via `CategoriaClientePlanoSerializer`:
  - `id_categoria_cliente`
  - `nome_categoria_clientes`
  - `descricao_categ_cli`
  - `preco_categ`
  - campos extras de plano construídos por `build_socio_api_plan`

### `/api/enderecos/`
- ViewSet: `EnderecoClienteViewSet`
- Dados retornados:
  - todos os campos do modelo `EnderecoCliente`

### `/api/pedidos/`
- ViewSet: `PedidoViewSet`
- Autenticação: token HMAC de cliente
- Retorna pedidos do cliente autenticado
- Dados retornados:
  - todos os campos do modelo `Pedido`

### `/api/compras/`
- ViewSet: `CompraViewSet`
- Autenticação: token HMAC de cliente
- Retorna compras associadas ao cliente autenticado
- Dados retornados via `CompraHistoricoSerializer`:
  - `id_compra`
  - `id_pedido`
  - `data_pedido`
  - `status_pedido`
  - `produto_id`
  - `produto_nome`
  - `produto_imagem`
  - `tamanho`
  - `valor`

### `/api/jogos/`
- ViewSet: `JogosViewSet`
- Dados retornados via `JogosSerializer`:
  - `id_jogos`
  - `dia_jogo`
  - `hora_jogo`
  - `local_jogo`
  - `casa_fora`
  - `times_id_times`
  - `times` (dados do time adversário)
  - `ingressos` (lista de produtos de ingresso vinculados ao jogo)

### `/api/funcionarios/`
- ViewSet: `FuncionariosViewSet`
- Dados retornados via `FuncionariosSerializer`:
  - todos os campos do modelo `Funcionarios`, exceto senha

### `/api/questoes/`
- ViewSet: `QuestoesViewSet`
- Dados retornados:
  - todos os campos do modelo `Questoes`

### `/api/respostas/`
- ViewSet: `RespostasViewSet`
- Dados retornados:
  - todos os campos do modelo `Respostas`

### `/api/recuperacao-senha/`
- ViewSet: `RecuperacaoSenhaViewSet`
- Dados retornados:
  - todos os campos do modelo `RecuperacaoSenha`

### `/api/progresso-fases/`
- ViewSet: `ProgressoFasesViewSet`
- Dados retornados via `ProgressoFasesSerializer`:
  - `cliente`
  - `fase2_liberada`

### `/api/clientes/`
- ViewSet: `ClientesViewSet`
- Permissão: admin
- Dados retornados via `ClientesSerializer`:
  - `id_clientes`
  - `nome_clientes`
  - `sobrenome_clientes`
  - `email_clientes`
  - `sexo_clientes`
  - `telefone_clientes`
  - `cpf_clientes`
  - `status_clientes`
  - `url_foto_clientes`
  - `categoria_cliente_id_categoria_cliente`
  - `score_rank`
  - `total_acertos`
  - `total_questoes`
  - `precisao`
  - `tempo`
  - `categoria_clientes`

### `/api/times/`
- ViewSet: `TimesViewSet`
- Dados retornados:
  - todos os campos do modelo `Times`

### `/api/titulos/`
- ViewSet: `TitulosViewSet`
- Dados retornados:
  - todos os campos do modelo `Titulos`

### `/api/historico-titulos/`
- ViewSet: `HistoricoTitulosViewSet`
- Autenticação requerida
- Dados retornados via `HistoricoTitulosSerializer`:
  - `id_historico`
  - `titulo` (dados do título)
  - `cliente` (dados do cliente)
  - `ativo`

---

## Endpoints customizados

### `POST /api/esqueci-senha/`
- Descrição: solicita envio de código de recuperação de senha
- Entrada:
  - `email`
- Resposta:
  - `success`
  - `message`
  - `detail`
  - `email`

### `POST /api/validar-codigo/`
- Descrição: valida o código de recuperação enviado por email
- Entrada:
  - `email`
  - `codigo`
- Resposta:
  - `success`
  - `message`
  - `detail`

### `POST /api/redefinir-senha/`
- Descrição: redefine a senha do cliente usando código de recuperação
- Entrada:
  - `email`
  - `codigo`
  - `senha`
  - `confirmar_senha`
- Resposta:
  - `success`
  - `message`
  - `detail`

### `POST /api/cadastro/`
- Descrição: cadastra novo cliente
- Entrada:
  - `nome`
  - `sobrenome`
  - `email`
  - `telefone` (opcional)
  - `cpf`
  - `senha`
  - `sexo` (opcional)
  - `rua`, `casa_numero`, `bairro`, `cep`, `complemento` (opcionais)
- Resposta:
  - `success`
  - `message`
  - `detail`
  - `cliente` (dados do cliente criado)

### `POST /api/login/`
- Descrição: autentica cliente e retorna token
- Entrada:
  - `email`
  - `senha`
- Resposta:
  - `token`
  - `cliente` (dados do cliente)

### `POST /api/logout/`
- Descrição: logout stateless para o token HMAC
- Resposta:
  - `detail`

### `POST /api/checkout-preview/`
- Descrição: calcula resumo da compra antes de finalizar
- Entrada:
  - `itens`: lista de objetos com:
    - `produto_id`
    - `quantidade`
    - `tamanho` (apenas para camisas)
- Resposta:
  - `success`
  - `message`
  - `detail`
  - `itens` (resumo)
  - `subtotal_original`
  - `economia_total`
  - `total_final`
  - `desconto_total`
  - `desconto_percent`
  - `plano_atual`
  - `beneficios_plano`

### `POST /api/checkout/`
- Descrição: finaliza a compra e cria pedido + itens
- Entrada: mesma de `checkout-preview`
- Resposta:
  - `success`
  - `message`
  - `detail`
  - `pedido_id`
  - `total`
  - `total_bruto`
  - `desconto_percent`
  - `desconto`
  - `plano_atual`
  - `beneficios_plano`
  - `itens`
  - `status`

### `GET /api/cart/`
- Descrição: lê carrinho da sessão do cliente autenticado
- Resposta:
  - `itens` (lista de itens no carrinho)
  - `quantidade_total`
  - `valor_total`
  - `desconto_percent`
  - `desconto`
  - `total_com_desconto`
  - `plano_atual`

### `GET /api/minha-assinatura/`
- Descrição: retorna o plano atual do cliente autenticado
- Resposta:
  - `assinatura`
  - `plano`
  - `plano_atual`

### `POST /api/assinar-plano/`
- Descrição: atualiza o plano/assinatura do cliente autenticado
- Entrada:
  - `plano_id`
- Resposta:
  - `assinatura`
  - `plano`
  - `plano_atual`

### `/api/meu-perfil/`
- `GET` - retorna dados do cliente autenticado
- `PUT` - atualiza dados parciais do cliente autenticado
- Dados retornados via `ClientesSerializer`

### `POST /api/meu-perfil/upload-foto/`
- Descrição: upload de foto de perfil para R2
- Entrada:
  - `foto` (arquivo)
- Resposta:
  - `url_foto_clientes`

### `GET /api/minhas-compras/`
- Descrição: lista pedidos e itens do cliente autenticado
- Resposta:
  - `pedidos` com:
    - `id_pedido`
    - `data_pedido`
    - `status`
    - `valor_total`
    - `quantidade_total`
    - `itens`
      - `id_compra`
      - `produto_id`
      - `produto_nome`
      - `produto_imagem`
      - `quantidade`
      - `valor`
      - `tamanho`
      - `subtotal`

---

## Notas específicas

- Os endpoints de `produtos` e `jogos` agora retornam dados suficientes para consumo do app mobile de venda de ingressos:
  - `jogos` inclui `times` e `ingressos`
  - `ingressos` traz `setor` e `preco`
- A autenticação de cliente usa token HMAC para as rotas protegidas.
