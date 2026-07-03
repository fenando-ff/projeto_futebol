from rest_framework import viewsets, filters, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from django_filters import rest_framework as django_filters
from django.shortcuts import get_object_or_404
from django.db import transaction
from ..models import (
    CategoriaCliente,
    CategoriaProdutos,
    Clientes,
    Compra,
    EnderecoCliente,
    Funcionarios,
    HistoricoTitulos,
    Jogos,
    Pedido,
    Produtos,
    ProgressoFases,
    Questoes,
    Respostas,
    RecuperacaoSenha,
    Times,
    Titulos,
)
from ..serializers import (
    CategoriaClienteSerializer,
    CategoriaProdutosSerializer,
    CarrinhoItemSerializer,
    ClientesSerializer,
    CompraSerializer,
    EnderecoClienteSerializer,
    FuncionariosSerializer,
    HistoricoTitulosSerializer,
    JogosSerializer,
    PedidoSerializer,
    ProdutosSerializer,
    ProgressoFasesSerializer,
    QuestoesSerializer,
    RespostasSerializer,
    RecuperacaoSenhaSerializer,
    TimesSerializer,
    TitulosSerializer
)


class ProdutosFilter(django_filters.FilterSet):
    categoria_produtos = django_filters.NumberFilter(
        field_name="categoria_produtos_id_categoria_produtos"
    )

    class Meta:
        model = Produtos
        fields = ["categoria_produtos"]


class PedidoFilter(django_filters.FilterSet):
    cliente_id_cliente = django_filters.NumberFilter(
        field_name="clientes_id_clientes"
    )

    class Meta:
        model = Pedido
        fields = ["cliente_id_cliente", "status"]

class ClientesViewSet(viewsets.ModelViewSet):
    queryset = Clientes.objects.all()
    serializer_class = ClientesSerializer
    permission_classes = [permissions.IsAdminUser]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ["categoria_cliente_id_categoria_cliente"]
    search_fields = ["nome_clientes", "email_clientes"]
    ordering_fields = ["nome_clientes", "email_clientes"]


class CategoriaProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaProdutos.objects.all().order_by("nome_categoria_produtos")
    serializer_class = CategoriaProdutosSerializer
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ["nome_categoria_produtos"]

    @action(detail=False, methods=["get"], url_path="public")
    def public(self, request, *args, **kwargs):
        return super().list(request, *args, **kwargs)


class MeuPerfilView(viewsets.ViewSet):

    def list(self, request):
        cliente = getattr(request, "user", None)

        if not isinstance(cliente, Clientes):
            cliente_id = request.session.get("cliente_id")
            if cliente_id:
                try:
                    cliente = Clientes.objects.get(pk=cliente_id)
                except Clientes.DoesNotExist:
                    cliente = None

        if not isinstance(cliente, Clientes):
            return Response({"detail": "Não autenticado."}, status=status.HTTP_401_UNAUTHORIZED)

        serializer = ClientesSerializer(cliente)
        return Response(serializer.data)

    @action(detail=False, methods=["get"], url_path="carrinho")
    def carrinho(self, request):
        return Response({"carrinho": request.session.get("carrinho", {})})


class TitulosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Titulos.objects.all()
    serializer_class = TitulosSerializer


class HistoricoTitulosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = HistoricoTitulos.objects.select_related("cliente", "titulo").all()
    serializer_class = HistoricoTitulosSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente", "titulo", "ativo"]


class CategoriaClienteViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaCliente.objects.all()
    serializer_class = CategoriaClienteSerializer


class TimesViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Times.objects.all()
    serializer_class = TimesSerializer


class ProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Produtos.objects.all()
    serializer_class = ProdutosSerializer


class EnderecoClienteViewSet(viewsets.ModelViewSet):
    queryset = EnderecoCliente.objects.all()
    serializer_class = EnderecoClienteSerializer


class PedidoViewSet(viewsets.ModelViewSet):
    queryset = Pedido.objects.all()
    serializer_class = PedidoSerializer


class CompraViewSet(viewsets.ModelViewSet):
    queryset = Compra.objects.all()
    serializer_class = CompraSerializer


class JogosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Jogos.objects.all()
    serializer_class = JogosSerializer


class FuncionariosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Funcionarios.objects.all()
    serializer_class = FuncionariosSerializer


class QuestoesViewSet(viewsets.ModelViewSet):
    queryset = Questoes.objects.all()
    serializer_class = QuestoesSerializer


class RespostasViewSet(viewsets.ModelViewSet):
    queryset = Respostas.objects.all()
    serializer_class = RespostasSerializer


class RecuperacaoSenhaViewSet(viewsets.ModelViewSet):
    queryset = RecuperacaoSenha.objects.all()
    serializer_class = RecuperacaoSenhaSerializer


class ProgressoFasesViewSet(viewsets.ModelViewSet):
    queryset = ProgressoFases.objects.all()
    serializer_class = ProgressoFasesSerializer