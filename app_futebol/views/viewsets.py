from rest_framework import viewsets, filters
from django_filters.rest_framework import DjangoFilterBackend
from ..models import (
    CategoriaCliente,
    CategoriaProdutos,
    Clientes,
    Compra,
    EnderecoCliente,
    Funcionarios,
    Jogos,
    Pedido,
    Produtos,
    ProgressoFases,
    Questoes,
    Respostas,
    RecuperacaoSenha,
    Times,
)
from ..serializers import (
    CategoriaClienteSerializer,
    CategoriaProdutosSerializer,
    ClientesSerializer,
    CompraSerializer,
    EnderecoClienteSerializer,
    FuncionariosSerializer,
    JogosSerializer,
    PedidoSerializer,
    ProdutosSerializer,
    ProgressoFasesSerializer,
    QuestoesSerializer,
    RespostasSerializer,
    RecuperacaoSenhaSerializer,
    TimesSerializer
)

class ClientesViewSet(viewsets.ModelViewSet):
    queryset = Clientes.objects.all()
    serializer_class = ClientesSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ["categoria_cliente_id_categoria_cliente"]
    search_fields = ["nome_clientes", "email_clientes"]
    ordering_fields = ["nome_clientes", "email_clientes"]


class CategoriaProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaProdutos.objects.all().order_by("nome_categoria_produtos")
    serializer_class = CategoriaProdutosSerializer
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ["nome_categoria_produtos"]


class ProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Produtos.objects.all()
    serializer_class = ProdutosSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ["categoria_produtos_id_categoria_produtos"]
    search_fields = ["nome_produtos", "descricao_produtos"]
    ordering_fields = ["valor_produtos", "nome_produtos"]


class CategoriaClienteViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaCliente.objects.all()
    serializer_class = CategoriaClienteSerializer
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ["preco_categ"]


class EnderecoClienteViewSet(viewsets.ModelViewSet):
    queryset = EnderecoCliente.objects.all()
    serializer_class = EnderecoClienteSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id_cliente"]


class PedidoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Pedido.objects.all()
    serializer_class = PedidoSerializer
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    filterset_fields = ["status", "clientes_id_clientes"]
    ordering_fields = ["-data_pedido"]


class CompraViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Compra.objects.all()
    serializer_class = CompraSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["pedido_id_pedido"]


class JogosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Jogos.objects.select_related("times_id_times").all()
    serializer_class = JogosSerializer
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ["dia_jogo", "hora_jogo"]


class FuncionariosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Funcionarios.objects.select_related("setor_funcionarios_id_setor_funcionarios").all()
    serializer_class = FuncionariosSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["setor_funcionarios_id_setor_funcionarios"]


class QuestoesViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Questoes.objects.all()
    serializer_class = QuestoesSerializer
    filterset_fields = ["id_questao"]


class RespostasViewSet(viewsets.ModelViewSet):
    queryset = Respostas.objects.all()
    serializer_class = RespostasSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id", "questao_id"]


class RecuperacaoSenhaViewSet(viewsets.ModelViewSet):
    queryset = RecuperacaoSenha.objects.all()
    serializer_class = RecuperacaoSenhaSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id"]


class ProgressoFasesViewSet(viewsets.ModelViewSet):
    queryset = ProgressoFases.objects.all()
    serializer_class = ProgressoFasesSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente_id"]


class TimesViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Times.objects.all()
    serializer_class = TimesSerializer
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ["nome_times"]