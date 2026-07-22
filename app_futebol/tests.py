from django.test import SimpleTestCase, override_settings

from .models import CategoriaProdutos, Produtos
from .serializers import ProdutoAPISerializer


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

        data = ProdutoAPISerializer(produto).data

        self.assertEqual(
            data["url_imagem_produtos"],
            "https://cdn.example.com/img/produtos/camisas/teste.webp",
        )
