# Documentação da API — fut-app

## Visão geral

Este documento descreve como integrar o **frontend React Native (Expo)** do `fut-app` com uma **API Django** exposta via **Django REST Framework**, utilizando **Swagger (drf-yasg)** para documentação.

Em produção, substitua `http://localhost:8000` pelo domínio real da API (ex.: `https://api.fut-app.com.br`).

---

## 1) Configuração do Backend (Django)

### 1.1 Dependências

Instale os pacotes:

```bash
pip install djangorestframework drf-yasg django-filter
```

### 1.2 `settings.py`

```python
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # terceiros
    "rest_framework",
    "drf_yasg",
    "django_filters",
    # apps do projeto
    "app_futebol",
    "accounts",
    "minigame",
]

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework.authentication.SessionAuthentication",
        "rest_framework.authentication.TokenAuthentication",
    ],
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticatedOrReadOnly",
    ],
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
}

CORS_ALLOWED_ORIGINS = [
    "http://localhost:8000",
    "http://localhost:8081",
    "http://localhost:19006",
    "http://10.20.83.22:8000",
    "http://192.168.61.90:8000",
    "https://projeto-futebol.onrender.com",
]
CORS_ALLOW_CREDENTIALS = True
```

### 1.3 `urls.py` (raiz do projeto)

```python
from django.contrib import admin
from django.urls import path, re_path, include
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from rest_framework import permissions

schema_view = get_schema_view(
    openapi.Info(
        title="API Fut-App",
        default_version="v1",
        description="API backend do aplicativo Fut-App.",
        contact=openapi.Contact(email="contato@fut-app.com.br"),
    ),
    public=True,
    permission_classes=[permissions.AllowAny],
)

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", schema_view.with_ui("swagger", cache_timeout=0), name="schema-swagger-ui"),
    path("api/", include("app_futebol.urls")),
    path("swagger(?P<format>\.json|\.yaml)$", schema_view.without_ui(cache_timeout=0), name="schema-json"),
]
```

---

## 2) Estrutura de apps e domínios

Com base em `db/banco_definitivo_local.sql`, o banco `projeto_futebol_definitivo` contém os seguintes domínios:

- **app_futebol**: loja e operações
- **accounts**: perfis de usuário autenticado
- **minigame**: quiz e gamificação

---

### 2.1 Modelos principais (`app_futebol`)

| Grupo | Tabela | Responsabilidade |
|---|---|---|
| Catálogo | `categoria_produtos` | Categorias de produtos (Acessórios, Camisas FC, Calçados, Ingressos) |
| Catálogo | `produtos` | Produtos da loja |
| Catálogo | `imagem_produto` | Imagens adicionais de produto |
| Loja | `categoria_cliente` | Planos de sócio (Diamante, Ouro, Prata, Não-sócio) |
| Loja | `clientes` | Clientes e dados de jogador/sócio |
| Loja | `endereco_cliente` | Endereço de entrega |
| Loja | `pedido` | Pedidos de compra |
| Loja | `compra` | Itens de um pedido |
| Clube | `jogos` | Jogos da temporada |
| Clube | `times` | Times cadastrados |
| Staff | `funcionarios` | Funcionários do clube |
| Staff | `setor_funcionarios` | Setores (Financeiro, Administrativo, Comercial, TI) |
| Staff | `endereco_funcionarios` | Endereço de funcionários |
| Gamificação | `questoes` | Perguntas do quiz |
| Gamificação | `alternativas` | Alternativas vinculadas a questões |
| Gamificação | `respostas` | Respostas de clientes |
| Gamificação | `progresso_fases` | Progresso do cliente no quiz |
| Gamificação | `historico_titulos` | Histórico de títulos de clientes |
| Gamificação | `titulos` | Títulos disponíveis |
| Recuperação | `recuperacao_senha` | Códigos de recuperação |

---

## 3) Endpoints previstos

### 3.1 Categorias de produtos

```python
# GET /api/categorias-produtos/
class CategoriaProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaProdutos.objects.all().order_by("nome_categoria_produtos")
    serializer_class = CategoriaProdutosSerializer
    filter_backends = [OrderingFilter]
    ordering_fields = ["nome_categoria_produtos"]
```

Exemplo frontend:

```javascript
export async function fetchCategoriasProdutos() {
  const { data } = await api.get("/categorias-produtos/");
  return data.results ?? data;
}
```

---

### 3.2 Produtos

```python
# GET /api/produtos/
class ProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Produtos.objects.all()
    serializer_class = ProdutosSerializer
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ["categoria_produtos"]
    search_fields = ["nome_produtos", "descricao_produtos"]
    ordering_fields = ["valor_produtos", "nome_produtos"]
```

Exemplo frontend:

```javascript
export async function fetchProdutos(params = {}) {
  const { data } = await api.get("/produtos/", { params });
  return data.results ?? data;
}
```

---

### 3.3 Categorias de cliente (planos/sócios)

```python
# GET /api/planos/
class CategoriaClienteViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaCliente.objects.all()
    serializer_class = CategoriaClienteSerializer
    filter_backends = [OrderingFilter]
    ordering_fields = ["preco_categ"]
```

Exemplo frontend:

```javascript
export async function fetchPlanos() {
  const { data } = await api.get("/planos/");
  return data.results ?? data;
}
```

---

### 3.4 Autenticação, perfil e carrinho

```python
# POST /api/login/
class LoginAPIView(APIView):
    permission_classes = [AllowAny]

# GET /api/meu-perfil/
# PUT /api/meu-perfil/
class MeuPerfilView(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

# GET/POST/PATCH/DELETE /api/cart/
class CartAPIView(APIView):
    permission_classes = [IsAuthenticated]
```

Exemplo frontend:

```javascript
export async function login(email, senha) {
  const { data } = await api.post("/login/", { email, senha });
  return data;
}

export async function fetchMeuPerfil() {
  const { data } = await api.get("/meu-perfil/");
  return data;
}

export async function atualizarMeuPerfil(payload) {
  const { data } = await api.put("/meu-perfil/", payload);
  return data;
}

export async function fetchCarrinho() {
  const { data } = await api.get("/cart/");
  return data;
}

export async function addCarrinho(produto_id, quantidade = 1) {
  const { data } = await api.post("/cart/", { produto_id, quantidade });
  return data;
}
```

---

### 3.5 Endereços do cliente

```python
# GET/POST /api/enderecos/
class EnderecoClienteViewSet(viewsets.ModelViewSet):
    serializer_class = EnderecoClienteSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id_cliente"]
```

Exemplo frontend:

```javascript
export async function fetchMeusEnderecos() {
  const { data } = await api.get("/enderecos/");
  return data.results ?? data;
}
```

---

### 3.6 Pedidos, compras e checkout

```python
# GET /api/pedidos/
class PedidoViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = PedidoSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = ["status", "cliente_id_cliente"]
    ordering_fields = ["-data_pedido"]

# GET /api/pedidos/{id}/ingressos/
class PedidoViewSet(viewsets.ViewSet):
    @action(detail=True, methods=["get"])
    def ingressos(self, request, pk=None):
        ...

# POST /api/checkout/
class CheckoutAPIView(APIView):
    permission_classes = [AllowAny]
```

Exemplo frontend:

```javascript
export async function fetchMeusPedidos() {
  const { data } = await api.get("/pedidos/");
  return data.results ?? data;
}

export async function fetchIngressosPedido(pedidoId) {
  const { data } = await api.get(`/pedidos/${pedidoId}/ingressos/`);
  return data;
}

export async function finalizarCompra(itens) {
  const { data } = await api.post("/checkout/", { itens });
  return data;
}
```

---

### 3.7 Jogos e ingressos

As tabelas `jogos` e `times` viram produtos na categoria Ingressos.

```python
# GET /api/jogos/
class JogosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Jogos.objects.select_related("times_id_times").all()
    serializer_class = JogosSerializer
    filter_backends = [OrderingFilter]
    ordering_fields = ["dia_jogo", "hora_jogo"]
```

Exemplo frontend:

```javascript
export async function fetchJogos() {
  const { data } = await api.get("/jogos/");
  return data.results ?? data;
}
```

---

### 3.8 Funcionários (app interno)

```python
# GET /api/funcionarios/
class FuncionariosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Funcionarios.objects.select_related("setor_funcionarios_id_setor_funcionarios").all()
    serializer_class = FuncionariosSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["setor_funcionarios_id_setor_funcionarios"]
```

---

### 3.9 Quiz e gamificação

```python
# GET /api/questoes/
class QuestoesViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Questoes.objects.all()
    serializer_class = QuestoesSerializer
    filterset_fields = ["id_questao"]

# POST /api/respostas/
class RespostasViewSet(viewsets.ModelViewSet):
    serializer_class = RespostasSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id", "questao_id"]

# GET/POST /api/progresso-fases/
class ProgressoFasesViewSet(viewsets.ModelViewSet):
    serializer_class = ProgressoFasesSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id"]
```

Exemplo frontend:

```javascript
export async function fetchQuestao() {
  const { data } = await api.get("/questoes/", { params: { pergunta: "..." } });
  return data.results?.[0] ?? data;
}
```

---

### 3.10 Recuperação de senha

```python
# POST /api/recuperacao-senha/
class RecuperacaoSenhaViewSet(viewsets.ViewSet):
    ...
```

Exemplo frontend:

```javascript
export async function solicitarRecuperacao(email) {
  await api.post("/recuperacao-senha/", { email });
}
```

---

## 4) Integração no Frontend (React Native)

### 4.1 Configuração base (`src/services/api.js`)

```javascript
import Axios from "axios";

export const API_BASE_URL = __DEV__
  ? "http://localhost:8000/api"
  : "https://api.fut-app.com.br/api";

export const api = Axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

api.interceptors.request.use((config) => {
  const token = global.userToken;
  if (token) {
    config.headers.Authorization = `Token ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // redirecionar para login
    }
    return Promise.reject(error);
  }
);
```

---

## 5) Testando a API antes de consumir no app

1. Execute o servidor Django: `python manage.py runserver`
2. Abra `http://localhost:8000/`
3. Teste endpoints diretamente no Swagger UI antes de implementar no React Native.
4. Copie a resposta de exemplo para criar o mock em `src/data/data<NomeTela>.js`.

---

## 6) Estrutura esperada

```
backend/
├─ manage.py
├─ projeto/
│  ├─ settings.py
│  └─ urls.py
├─ app_futebol/
│  ├─ models.py
│  ├─ serializers.py
│  ├─ views.py
│  └─ urls.py
├─ accounts/
│  └─ models.py
└─ minigame/
   ├─ models.py
   └─ ...
```

---

## 7) Boas práticas

- Nunca commite `SECRET_KEY` ou credenciais.
- Use HTTPS em produção.
- Revise permissões por view; por padrão o backend exige autenticação.
- Tokens expiram? Implemente rota de renovação.
- Versionar a API (`/api/v1/`) planejando atualizações.
- Documente novos endpoints com `@swagger_auto_schema`.
- Garanta que os campos do serializer coincidam com o que o app espera.
