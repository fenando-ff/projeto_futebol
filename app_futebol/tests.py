from datetime import datetime
from types import SimpleNamespace
from unittest.mock import patch

from django.contrib.sessions.backends.db import SessionStore
from django.test import RequestFactory, SimpleTestCase, override_settings
from django.urls import reverse
from django.utils import timezone

from .models import CategoriaProdutos, Produtos
from .serializers import CompraHistoricoSerializer, ProdutoAPISerializer
from .views.views import adicionar_carrinho, cancelar_socio


class ProdutoAPISerializerImageUrlTests(SimpleTestCase):
    @override_settings(R2_PUBLIC_URL="https://cdn.example.com")
    def test_url_imagem_produtos_uses_cloudflare_public_base_for_relative_paths(self):
        categoria = CategoriaProdutos(nome_categoria_produtos="Camisas")
        produto = Produtos(
            id_produtos=1,
            nome_produtos="Camisa teste",
            valor_produtos=99.90,
            descricao_produtos="Descrição do produto",
            quantidade_estoque_produtos=10,
            categoria_produtos_id_categoria_produtos=categoria,
            imagem_produtos="img/produtos/camisas/teste.webp",
        )
        produto.imagens = SimpleNamespace(all=lambda: [])

        data = ProdutoAPISerializer(produto).data

        self.assertEqual(
            data["url_imagem_produtos"],
            "https://cdn.example.com/img/produtos/camisas/teste.webp",
        )

    @override_settings(R2_PUBLIC_URL="https://cdn.example.com")
    def test_serializer_exposes_gallery_images(self):
        categoria = CategoriaProdutos(nome_categoria_produtos="Camisas")
        produto = Produtos(
            id_produtos=1,
            nome_produtos="Camisa teste",
            valor_produtos=99.90,
            descricao_produtos="Descrição do produto",
            quantidade_estoque_produtos=10,
            categoria_produtos_id_categoria_produtos=categoria,
            imagem_produtos="img/produtos/camisas/principal.webp",
        )
        produto.imagens = SimpleNamespace(
            all=lambda: [
                SimpleNamespace(
                    id_imagem_produto=10,
                    imagem_imagem="img/produtos/camisas/thumb-1.webp",
                    ordem_imagem=1,
                ),
                SimpleNamespace(
                    id_imagem_produto=11,
                    imagem_imagem="img/produtos/camisas/thumb-2.webp",
                    ordem_imagem=2,
                ),
            ]
        )

        data = ProdutoAPISerializer(produto).data

        self.assertEqual(len(data["imagens"]), 2)
        self.assertEqual(data["imagens"][0]["imagem"], "https://cdn.example.com/img/produtos/camisas/thumb-1.webp")
        self.assertEqual(data["imagens"][1]["imagem"], "https://cdn.example.com/img/produtos/camisas/thumb-2.webp")

    @override_settings(R2_PUBLIC_URL="https://cdn.example.com")
    def test_serializer_falls_back_to_gallery_image_when_main_image_is_missing(self):
        categoria = CategoriaProdutos(nome_categoria_produtos="Camisas")
        produto = Produtos(
            id_produtos=2,
            nome_produtos="Camisa sem imagem principal",
            valor_produtos=79.90,
            descricao_produtos="Descrição do produto",
            quantidade_estoque_produtos=5,
            categoria_produtos_id_categoria_produtos=categoria,
            imagem_produtos=None,
        )
        produto.imagens = SimpleNamespace(
            all=lambda: [
                SimpleNamespace(
                    id_imagem_produto=20,
                    imagem_imagem="img/produtos/camisas/thumb-1.webp",
                    ordem_imagem=1,
                )
            ]
        )

        data = ProdutoAPISerializer(produto).data

        self.assertEqual(data["url_imagem_produtos"], "https://cdn.example.com/img/produtos/camisas/thumb-1.webp")
        self.assertEqual(data["imagem_principal"], "https://cdn.example.com/img/produtos/camisas/thumb-1.webp")


class CarrinhoTamanhoTests(SimpleTestCase):
    def setUp(self):
        self.factory = RequestFactory()

    def test_adicionar_carrinho_exige_tamanho_para_categoria_2(self):
        request = self.factory.post(
            "/adicionar/1/",
            {"tamanho": ""},
            HTTP_X_REQUESTED_WITH="XMLHttpRequest",
        )
        request.session = SessionStore()
        request.session["cliente_id"] = 1
        produto = SimpleNamespace(
            id_produtos=1,
            nome_produtos="Camisa teste",
            categoria_produtos_id_categoria_produtos=SimpleNamespace(id_categoria_produtos=2),
        )

        with patch("app_futebol.views.views.models.Produtos.objects.get", return_value=produto):
            response = adicionar_carrinho(request, 1)

        self.assertEqual(response.status_code, 400)
        self.assertEqual(request.session.get("tamanhos_carrinho"), {})

    def test_adicionar_carrinho_redireciona_para_produto_se_tamanho_faltar(self):
        request = self.factory.post(
            "/adicionar/1/",
            {"tamanho": ""},
        )
        request.session = SessionStore()
        request.session["cliente_id"] = 1
        produto = SimpleNamespace(
            id_produtos=1,
            nome_produtos="Camisa teste",
            categoria_produtos_id_categoria_produtos=SimpleNamespace(id_categoria_produtos=2),
        )

        with patch("app_futebol.views.views.models.Produtos.objects.get", return_value=produto):
            with patch("django.contrib.messages.error"):
                response = adicionar_carrinho(request, 1)

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.url, "/loja_detalhe/1/")

    def test_categoria_2_requer_tamanho_na_listagem(self):
        request = self.factory.post(
            "/adicionar/5/",
            {},
            HTTP_X_REQUESTED_WITH="XMLHttpRequest",
        )
        request.session = SessionStore()
        request.session["cliente_id"] = 1
        produto = SimpleNamespace(
            id_produtos=5,
            nome_produtos="Camisa da lista",
            categoria_produtos_id_categoria_produtos=SimpleNamespace(id_categoria_produtos=2),
        )

        with patch("app_futebol.views.views.models.Produtos.objects.get", return_value=produto):
            response = adicionar_carrinho(request, 5)

        self.assertEqual(response.status_code, 400)

    def test_adicionar_carrinho_registra_tamanho_para_categoria_2(self):
        request = self.factory.post(
            "/adicionar/1/",
            {"tamanho": "M"},
            HTTP_X_REQUESTED_WITH="XMLHttpRequest",
        )
        request.session = SessionStore()
        request.session["cliente_id"] = 1
        produto = SimpleNamespace(
            id_produtos=1,
            nome_produtos="Camisa teste",
            categoria_produtos_id_categoria_produtos=SimpleNamespace(id_categoria_produtos=2),
        )

        with patch("app_futebol.views.views.models.Produtos.objects.get", return_value=produto):
            response = adicionar_carrinho(request, 1)

        self.assertEqual(response.status_code, 200)
        self.assertEqual(request.session.get("tamanhos_carrinho"), {"1": "M"})


class CancelarSocioTests(SimpleTestCase):
    def setUp(self):
        self.factory = RequestFactory()

    def test_cancelar_socio_define_categoria_nao_socio(self):
        request = self.factory.get(reverse("cancelar_socio"))
        request.session = SessionStore()
        request.session["cliente_id"] = 1

        class FakeCliente(SimpleNamespace):
            def save(self):
                self.saved = True

        cliente = FakeCliente(
            id_clientes=1,
            categoria_cliente_id_categoria_cliente=SimpleNamespace(id_categoria_cliente=2, nome_categoria_clientes="Platinum"),
        )
        categoria_nao_socio = SimpleNamespace(id_categoria_cliente=5, nome_categoria_clientes="nao socio")

        class FakeQuerySet:
            def __init__(self, result):
                self.result = result

            def first(self):
                return self.result

        with patch("app_futebol.views.views.models.Clientes.objects.get", return_value=cliente):
            with patch("app_futebol.views.views.models.CategoriaCliente.objects.filter", return_value=FakeQuerySet(categoria_nao_socio)):
                with patch("app_futebol.views.views.messages.success"):
                    response = cancelar_socio(request)

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.url, reverse("socio"))
        self.assertEqual(request.session["plano_socio_id"], 5)
        self.assertEqual(request.session["plano_socio_nome"], "nao socio")
        self.assertEqual(cliente.categoria_cliente_id_categoria_cliente.id_categoria_cliente, 5)
        self.assertTrue(cliente.saved)


class CompraHistoricoSerializerTests(SimpleTestCase):
    @override_settings(R2_PUBLIC_URL="https://cdn.example.com")
    def test_compra_historico_serializer_exposes_purchase_details(self):
        categoria = CategoriaProdutos(nome_categoria_produtos="Camisas")
        produto = Produtos(
            id_produtos=7,
            nome_produtos="Camisa teste",
            valor_produtos=149.9,
            descricao_produtos="Descricao",
            quantidade_estoque_produtos=12,
            categoria_produtos_id_categoria_produtos=categoria,
            imagem_produtos="img/produtos/camisas/teste.webp",
        )
        pedido = SimpleNamespace(
            id_pedido=44,
            data_pedido=timezone.make_aware(datetime(2026, 7, 27, 10, 30)),
            status="a caminho",
        )
        compra = SimpleNamespace(
            id_compra=10,
            pedido_id_pedido=pedido,
            produtos_id_produtos=produto,
            quantidade_pedido=2,
            tamanho="M",
            valor_compra=299.8,
        )

        data = CompraHistoricoSerializer(compra).data

        self.assertEqual(data["id_pedido"], 44)
        self.assertEqual(data["status_pedido"], "a caminho")
        self.assertEqual(data["produto_nome"], "Camisa teste")
        self.assertEqual(data["produto_imagem"], "https://cdn.example.com/img/produtos/camisas/teste.webp")
        self.assertEqual(data["quantidade"], 2)
        self.assertEqual(data["tamanho"], "M")
        self.assertEqual(data["valor"], 299.8)
