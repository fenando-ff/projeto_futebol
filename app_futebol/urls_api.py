from rest_framework.routers import DefaultRouter
from django.urls import path
from .views.viewsets import (
    CategoriaProdutosViewSet,
    CategoriaClienteViewSet,
    ClientesViewSet,
    CompraViewSet,
    EnderecoClienteViewSet,
    FuncionariosViewSet,
    HistoricoTitulosViewSet,
    JogosViewSet,
    PedidoViewSet,
    ProgressoFasesViewSet,
    ProdutosViewSet,
    QuestoesViewSet,
    RespostasViewSet,
    RecuperacaoSenhaViewSet,
    TimesViewSet,
    TitulosViewSet,
    MeuPerfilView
)
from .views.api import (
    CadastroAPIView,
    CartAPIView,
    AssinarPlanoAPIView,
    EsqueciSenhaAPIView,
    LoginAPIView,
    LogoutAPIView,
    MinhaAssinaturaAPIView,
    RedefinirSenhaAPIView,
    ValidarCodigoAPIView,
    CheckoutAPIView,
    CheckoutPreviewAPIView,
)

router = DefaultRouter()
router.register(r'categorias-produtos', CategoriaProdutosViewSet)
router.register(r'public/categorias-produtos', CategoriaProdutosViewSet, basename='public-categorias-produtos')
router.register(r'produtos', ProdutosViewSet)
router.register(r'planos', CategoriaClienteViewSet)
router.register(r'enderecos', EnderecoClienteViewSet)
router.register(r'pedidos', PedidoViewSet)
router.register(r'compras', CompraViewSet)
router.register(r'jogos', JogosViewSet)
router.register(r'funcionarios', FuncionariosViewSet)
router.register(r'questoes', QuestoesViewSet)
router.register(r'respostas', RespostasViewSet)
router.register(r'recuperacao-senha', RecuperacaoSenhaViewSet)
router.register(r'progresso-fases', ProgressoFasesViewSet)
router.register(r'clientes', ClientesViewSet)
router.register(r'times', TimesViewSet)
router.register(r'titulos', TitulosViewSet)
router.register(r'historico-titulos', HistoricoTitulosViewSet)

urlpatterns = router.urls + [
    path('esqueci-senha/', EsqueciSenhaAPIView.as_view(), name='api-esqueci-senha'),
    path('validar-codigo/', ValidarCodigoAPIView.as_view(), name='api-validar-codigo'),
    path('redefinir-senha/', RedefinirSenhaAPIView.as_view(), name='api-redefinir-senha'),
    path('cadastro/', CadastroAPIView.as_view(), name='api-cadastro'),
    path('login/', LoginAPIView.as_view(), name='api-login'),
    path('logout/', LogoutAPIView.as_view(), name='api-logout'),
    path('checkout/', CheckoutAPIView.as_view(), name='api-checkout'),
    path('checkout-preview/', CheckoutPreviewAPIView.as_view(), name='api-checkout-preview'),
    path('minha-assinatura/', MinhaAssinaturaAPIView.as_view(), name='api-minha-assinatura'),
    path('assinar-plano/', AssinarPlanoAPIView.as_view(), name='api-assinar-plano'),
    path('meu-perfil/', MeuPerfilView.as_view({'get': 'list', 'put': 'update'}), name='meu-perfil'),
    path('meu-perfil/upload-foto/', MeuPerfilView.as_view({'post': 'upload_foto'}), name='meu-perfil-upload-foto'),
    path('cart/', CartAPIView.as_view(), name='api-cart'),
]
