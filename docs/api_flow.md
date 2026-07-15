# Fluxo Geral da API — fut-app

## Visão geral

Este documento descreve o **fluxo ponta a ponta** da integração entre o frontend React Native (Expo) e o backend Django REST Framework. Ele complementa `API.md` (contratos de endpoints) e `ingresso.md` (fluxo específico de ingressos), fornecendo uma visão unificada de como as requisições, respostas e estados se desenrolam dentro do app.

---

## 1) Pilares do fluxo

- **Base URL:** `http://localhost:8000/api` (dev) ou `https://api.fut-app.com.br/api` (prod).
- **Formato:** JSON em todas as requisições e respostas.
- **Autenticação:** `TokenAuthentication` via header `Authorization: Token <token>`.
- **Paginação:** `PageNumberPagination` com `PAGE_SIZE = 20`. Respostas paginadas retornam `{ count, next, previous, results }`. O frontend deve normalizar com `data.results ?? data`.
- **Filtros e busca:** disposição de `django-filter`, `SearchFilter` e `OrderingFilter` conforme cada ViewSet.
- **CORS:** origens liberadas em `settings.py` para Expo Go (`localhost:8081`) e web (`localhost:19006`).

---

## 2) Ciclo de vida de uma requisição

```text
Frontend
  │
  │  1) Monta URL relativa e params
  │  2) Interceptor anexa Authorization se houver token
  │  3) Envia JSON, Accept: application/json
  ▼
Backend (Django REST Framework)
  │
  │  4) Rotas de /api/ em app_futebol/urls.py
  │  5) ViewSet resolve método (list / retrieve / create / update)
  │  6) Filtros, ordering e busca aplicados
  │  7) Autenticação e permissões verificadas
  │  8) Serializer valida dados (em writes) e renderiza saída
  ▼
Frontend
  │
  │  9) Response interceptada:
  │     - 200: atualiza telas, caches locais, estados
  │     - 401: redireciona para login / limpa token
  │     - 403: exibe mensagem de permissão
  │     - 4xx: exibe validação retornada pelo serializer
  │     - 5xx: exibe erro genérico e permite retry
  ▼
UI / Estado local
```

### Regras do interceptor (frontend)

- O interceptor **não substitui** o fluxo de UI; ele centraliza o header e o tratamento de `401`.
- `global.userToken` é a única fonte de verdade para o token em memória.
- `timeout: 10000` evita requisições penduradas; o frontend deve exibir estado de loading e cancelar subscrever listeners antigos em telas descartadas.

---

## 3) Fluxo de leitura (Read)

Telas típicas: catálogo, lista de jogos, perfil, histórico de pedidos.

```text
GET /api/<recurso>/?campo=valor&ordering=-campo
```

1. Frontend monta `params` a partir de filtros da UI.
2. Backend aplica `filterset_fields`, `search_fields` e `ordering_fields`.
3. Paginação devolve `results`. O helper `data.results ?? data` garante compatibilidade com endpoints paginados e não paginados.

Exemplos:
- `GET /api/produtos/?categoria_produtos=3&search=ingresso&ordering=-valor_produtos`
- `GET /api/jogos/?ordering=dia_jogo,hora_jogo`
- `GET /api/pedidos/?status=processando&ordering=-data_pedido`
- `GET /api/progresso-fases/?cliente_id=5`

---

## 4) Fluxo de escrita (Write)

Telas típicas: cadastro, checkout, respostas de quiz, recuperação de senha.

```text
POST /api/<recurso>/
Body: JSON validado pelo serializer
```

1. Frontend envia `JSON`, incluindo campos CSRF-independentes no padrão DRF (não depende de cookie de sessão quando usa `TokenAuthentication`).
2. Serializer valida campos obrigatórios, `unique_together`, tipos e regras de negócio.
3. View persiste no banco e retorna `201 Created` com o objeto criado.

Exemplos:
- `POST /api/enderecos/` → cria endereço do cliente.
- `POST /api/respostas/` → registra resposta do quiz.
- `POST /api/recuperacao-senha/` → gera código de recuperação.
- `POST /api/finalizar_compra/` → cria pedido, compras e abate estoque.

### Padrão de resposta em escritas

```json
{
  "id": 42,
  "campo_principal": "valor",
  ...
}
```

Erros de validação retornam `400 Bad Request` com corpo:

```json
{
  "campo": ["mensagem de erro"]
}
```

---

## 5) Fluxo de autenticação

1. Login com email/senha retorna token (endpoint a ser definido em `accounts`).
2. Token é armazenado em memória (`global.userToken`).
3. Requisições subsequentes reutilizam o token via interceptor.
4. `401 Unauthorized` indica token ausente, inválido ou expirado. O interceptor deve:
   - limpar `global.userToken`;
   - navegar para login;
   - evitar chamadas duplicadas (debounce por rota).

---

## 6) Fluxo de compra e carrinho

Para detalhes visuais e regras específicas, consulte `docs/ingresso.md`. Abaixo, o fluxo resumido em chamadas de API:

```text
1) GET /api/produtos/?categoria_produtos=10     → lista ingressos disponíveis
2) GET /api/jogos/                               → próximos jogos para destaque
3) POST /api/adicionar/<produto_id>/             → adiciona item ao carrinho de sessão
4) POST /api/remover/<produto_id>/               → remove item do carrinho
5) POST /api/finalizar_compra/                   → cria pedido + compras
6) GET /baixar_ingresso/<pedido_id>/             → gera PDF do ingresso
```

### Estados importantes
- **Carrinho:** residência server-side (sessão). Cada ação retorna confirmação e novo total.
- **Estoque:** abatido apenas no `POST /finalizar_compra/`. Antes disso o item fica reservado visualmente.
- **Desconto de sócio:** aplicado no backend em milestone de carrinho (se houver rota separada).

---

## 7) Fluxo de gamificação (quiz)

```text
1) GET /api/questoes/?id_questao=<id>          → carrega questão específica
2) POST /api/respostas/                         → envia resposta do cliente
3) GET /api/progresso-fases/?cliente_id=<id>    → retorna progresso do jogador
4) GET /api/titulos/                            → títulos disponíveis para conquista
   GET /api/historico-titulos/?cliente_id=<id> → histórico de títulos do jogador
```

- `cliente_id` é derivado do usuário autenticado em views protegidas.
- O frontend deve recalcular `score_rank`, `total_acertos` e `precisao` após cada resposta, conforme regras do backend.

---

## 8) Fluxo de recuperação de senha

```text
1) POST /api/recuperacao-senha/  { "email": "cliente@email.com" }
   → backend valida email, gera código salvo em `recuperacao_senha`.
2) Frontend envia código + nova senha para uma rota de confirmação (a ser definida).
3) Backend valida código, atualiza senha, limpa código usado.
```

---

## 9) Tratamento de erros global

```javascript
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      global.userToken = null;
      // redirecionar para login (sem loop)
    }
    if (error.response?.status === 403) {
      // exibir aviso de permissão
    }
    if (error.response?.status >= 500) {
      // exibir erro genérico + botão de retry
    }
    return Promise.reject(error);
  }
);
```

### Mapeamento sugerido

| Status | Significado | Ação |
|---|---|---|
| `200 OK` | Sucesso em leitura | Atualiza estado/localStorage |
| `201 Created` | Sucesso em escrita | Avança fluxo, limpa formulário |
| `400 Bad Request` | Validação serializer | Exibir erros por campo |
| `401 Unauthorized` | Token ausente/inválido | Limpar token + login |
| `403 Forbidden` | Permissão negada | Aviso de permissão |
| `404 Not Found` | Recurso inexistente | Exibir mensagem amigável |
| `429 Too Many Requests` | Rate limit | Backoff exponencial + retry |
| `500/502/503` | Erro interno | Aviso genérico + retry |

---

## 10) Convenções de URL e versamento

- Base path: `/api/` (planejar migração para `/api/v1/` futuramente).
- Recursos no plural: `/api/produtos/`, `/api/jogos/`, `/api/pedidos/`.
- Ações customizadas usam path extra: `/baixar_ingresso/<id>/`, `/adicionar/<id>/`.

---

## 11) Checklist de integração por endpoint

Para cada recurso novo:

1. Confirmar `filterset_fields`, `search_fields` e `ordering_fields` no backend.
2. Validar campos do `serializer` contra o que o frontend consome.
3. Garantir resposta com `results` quando paginada.
4. Criar helper no frontend (`fetch<NomeRecurso>(params)`) com `data.results ?? data`.
5. Tratar `401` no interceptor, não por tela.
6. Adicionar `@swagger_auto_schema` na view para documentação.
