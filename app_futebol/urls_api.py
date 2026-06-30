from rest_framework.routers import DefaultRouter
from .views.viewsets import (
    CategoriaProdutosViewSet,
    CategoriaClienteViewSet,
    ClientesViewSet,
    CompraViewSet,
    EnderecoClienteViewSet,
    FuncionariosViewSet,
    JogosViewSet,
    PedidoViewSet,
    ProgressoFasesViewSet,
    ProdutosViewSet,
    QuestoesViewSet,
    RespostasViewSet,
    RecuperacaoSenhaViewSet,
    TimesViewSet
    
)

router = DefaultRouter()
router.register(r'categorias-produtos', CategoriaProdutosViewSet)
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

urlpatterns = router.urls
