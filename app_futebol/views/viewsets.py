from rest_framework import viewsets, filters, permissions, status, exceptions
from rest_framework.decorators import action
from rest_framework.response import Response
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from django_filters.rest_framework import DjangoFilterBackend
from django_filters import rest_framework as django_filters
from django.shortcuts import get_object_or_404
from django.db import transaction

from .helpers import upload_image_to_r2
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
    CategoriaClientePlanoSerializer,
    CategoriaProdutosSerializer,
    CarrinhoItemSerializer,
    ClientesSerializer,
    CompraSerializer,
    CompraHistoricoSerializer,
    EnderecoClienteSerializer,
    FuncionariosSerializer,
    HistoricoTitulosSerializer,
    JogosSerializer,
    ProdutoAPISerializer,
    PedidoSerializer,
    ProdutosSerializer,
    ProgressoFasesSerializer,
    QuestoesSerializer,
    RespostasSerializer,
    RecuperacaoSenhaSerializer,
    TimesSerializer,
    TitulosSerializer,
)
from ..auth import ClienteTokenAuthentication


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


class ClienteTokenAuthenticationSilenciosa(ClienteTokenAuthentication):
    def authenticate(self, request):
        try:
            return super().authenticate(request)
        except exceptions.AuthenticationFailed:
            return None


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
    authentication_classes = [ClienteTokenAuthenticationSilenciosa]
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                "Authorization",
                openapi.IN_HEADER,
                description="Token no formato `Token <token>`.",
                type=openapi.TYPE_STRING,
                required=False,
            )
        ],
        responses={
            200: ClientesSerializer(),
            401: openapi.Response("Não autenticado."),
        },
        operation_summary="Perfil do cliente autenticado",
        operation_description="Retorna o cliente autenticado a partir do token HMAC enviado no header Authorization.",
    )
    def list(self, request):
        cliente = getattr(request, "user", None)

        if not isinstance(cliente, Clientes):
            return Response({"detail": "Não autenticado."}, status=status.HTTP_401_UNAUTHORIZED)

        serializer = ClientesSerializer(cliente)
        return Response(serializer.data)

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                "Authorization",
                openapi.IN_HEADER,
                description="Token no formato `Token <token>`.",
                type=openapi.TYPE_STRING,
                required=False,
            )
        ],
        request_body=ClientesSerializer,
        responses={
            200: ClientesSerializer(),
            400: openapi.Response("Dados inválidos."),
            401: openapi.Response("Não autenticado."),
        },
        operation_summary="Atualiza o perfil do cliente autenticado",
        operation_description="Atualiza os dados do cliente autenticado a partir do token HMAC enviado no header Authorization.",
    )
    def update(self, request):
        cliente = getattr(request, "user", None)

        if not isinstance(cliente, Clientes):
            return Response({"detail": "Não autenticado."}, status=status.HTTP_401_UNAUTHORIZED)

        serializer = ClientesSerializer(cliente, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data)

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                "Authorization",
                openapi.IN_HEADER,
                description="Token no formato `Token <token>`.",
                type=openapi.TYPE_STRING,
                required=False,
            )
        ],
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            required=["foto"],
            properties={
                "foto": openapi.Schema(type=openapi.TYPE_STRING, format=openapi.FORMAT_BINARY),
            },
        ),
        responses={
            200: openapi.Response(
                "URL pública da foto.",
                openapi.Schema(
                    type=openapi.TYPE_OBJECT,
                    properties={"url_foto_clientes": openapi.Schema(type=openapi.TYPE_STRING)},
                ),
            ),
            400: openapi.Response("Dados inválidos."),
            401: openapi.Response("Não autenticado."),
        },
        operation_summary="Upload de foto de perfil",
        operation_description="Recebe uma imagem, faz upload para o R2 e retorna a URL pública. Reutiliza a mesma integração Cloudflare do web.",
    )
    @action(detail=False, methods=["post"], url_path="upload-foto")
    def upload_foto(self, request):
        cliente = getattr(request, "user", None)

        if not isinstance(cliente, Clientes):
            return Response({"detail": "Não autenticado."}, status=status.HTTP_401_UNAUTHORIZED)

        foto = request.FILES.get("foto")
        if not foto:
            return Response(
                {"detail": "Nenhuma imagem enviada."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            public_url = upload_image_to_r2(foto, folder="perfis")
        except ValueError as exc:
            return Response({"detail": "Arquivo de imagem invalido."}, status=status.HTTP_400_BAD_REQUEST)
        except Exception:
            import logging

            logging.exception("Erro ao enviar imagem para R2")
            return Response(
                {"detail": "Falha ao enviar a imagem. Tente novamente mais tarde."},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

        cliente.url_foto_clientes = public_url
        cliente.save(update_fields=["url_foto_clientes"])

        return Response({"url_foto_clientes": public_url})

    @action(detail=False, methods=["get"], url_path="carrinho")
    def carrinho(self, request):
        return Response({"carrinho": request.session.get("carrinho", {})})


class TitulosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Titulos.objects.all()
    serializer_class = TitulosSerializer


class HistoricoTitulosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = HistoricoTitulos.objects.select_related("cliente", "titulo").all()
    serializer_class = HistoricoTitulosSerializer
    authentication_classes = [ClienteTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["cliente", "titulo", "ativo"]

    def get_queryset(self):
        queryset = super().get_queryset()
        cliente = getattr(self.request, "user", None)

        if isinstance(cliente, Clientes):
            if getattr(cliente, "is_staff", False) or getattr(cliente, "is_superuser", False):
                return queryset
            return queryset.filter(cliente=cliente)

        return queryset.none()


class CategoriaClienteViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = CategoriaCliente.objects.all().order_by("id_categoria_cliente")
    serializer_class = CategoriaClientePlanoSerializer
    permission_classes = [permissions.AllowAny]


class TimesViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Times.objects.all()
    serializer_class = TimesSerializer
    permission_classes = [permissions.AllowAny]


class ProdutosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Produtos.objects.select_related("categoria_produtos_id_categoria_produtos").all()
    serializer_class = ProdutoAPISerializer
    permission_classes = [permissions.AllowAny]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_class = ProdutosFilter
    search_fields = ["nome_produtos", "descricao_produtos"]
    ordering_fields = ["valor_produtos", "nome_produtos", "id_produtos"]

    def get_queryset(self):
        return super().get_queryset().filter(quantidade_estoque_produtos__gt=0).order_by("id_produtos")


class EnderecoClienteViewSet(viewsets.ModelViewSet):
    queryset = EnderecoCliente.objects.all()
    serializer_class = EnderecoClienteSerializer
    authentication_classes = [ClienteTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        queryset = super().get_queryset()
        cliente = getattr(self.request, "user", None)

        if isinstance(cliente, Clientes):
            if getattr(cliente, "is_staff", False) or getattr(cliente, "is_superuser", False):
                return queryset
            return queryset.filter(cliente_id_cliente=cliente)

        return queryset.none()

    def perform_create(self, serializer):
        cliente = getattr(self.request, "user", None)
        serializer.save(cliente_id_cliente=cliente)


class PedidoViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Pedido.objects.select_related("clientes_id_clientes", "funcionarios_id_funcionarios").all()
    serializer_class = PedidoSerializer
    authentication_classes = [ClienteTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    filterset_class = PedidoFilter
    ordering_fields = ["data_pedido", "id_pedido"]

    def get_queryset(self):
        queryset = super().get_queryset()
        cliente = getattr(self.request, "user", None)

        if isinstance(cliente, Clientes):
            return queryset.filter(clientes_id_clientes=cliente).order_by("-data_pedido", "-id_pedido")

        return queryset.none()


class CompraViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Compra.objects.select_related(
        "produtos_id_produtos",
        "produtos_id_produtos__categoria_produtos_id_categoria_produtos",
        "pedido_id_pedido",
        "pedido_id_pedido__clientes_id_clientes",
    ).all()
    serializer_class = CompraHistoricoSerializer
    authentication_classes = [ClienteTokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    filterset_fields = ["pedido_id_pedido", "produtos_id_produtos", "tamanho"]
    ordering_fields = ["pedido_id_pedido__data_pedido", "id_compra"]

    def get_queryset(self):
        queryset = super().get_queryset()
        cliente = getattr(self.request, "user", None)

        if isinstance(cliente, Clientes):
            return queryset.filter(
                pedido_id_pedido__clientes_id_clientes=cliente
            ).order_by("-pedido_id_pedido__data_pedido", "-id_compra")

        return queryset.none()


class JogosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Jogos.objects.select_related('times_id_times').all().order_by('dia_jogo')
    serializer_class = JogosSerializer
    permission_classes = [permissions.AllowAny]


class FuncionariosViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Funcionarios.objects.all()
    serializer_class = FuncionariosSerializer
    permission_classes = [permissions.IsAdminUser]


class QuestoesViewSet(viewsets.ModelViewSet):
    queryset = Questoes.objects.all()
    serializer_class = QuestoesSerializer
    permission_classes = [permissions.IsAdminUser]


class RespostasViewSet(viewsets.ModelViewSet):
    queryset = Respostas.objects.all()
    serializer_class = RespostasSerializer
    permission_classes = [permissions.IsAdminUser]


class RecuperacaoSenhaViewSet(viewsets.ModelViewSet):
    queryset = RecuperacaoSenha.objects.all()
    serializer_class = RecuperacaoSenhaSerializer
    permission_classes = [permissions.IsAdminUser]


class ProgressoFasesViewSet(viewsets.ModelViewSet):
    queryset = ProgressoFases.objects.all()
    serializer_class = ProgressoFasesSerializer
    permission_classes = [permissions.IsAdminUser]
