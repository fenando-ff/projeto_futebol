from datetime import datetime
from types import SimpleNamespace

from django.test import SimpleTestCase, override_settings
from django.utils import timezone

from .models import CategoriaProdutos, Produtos
from .serializers import CompraHistoricoSerializer, ProdutoAPISerializer


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
