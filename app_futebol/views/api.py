from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from django.contrib.auth.hashers import check_password
from django.db import transaction
from django.utils import timezone
from ..models import Clientes, Pedido, Produtos, Compra
from ..serializers import ClientesSerializer
from ..auth import gerar_token, validar_token


class LoginAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        email = request.data.get("email", "").strip().lower()
        senha = request.data.get("senha", "")
        if not email or not senha:
            return Response({"erro": "Email e senha são obrigatórios"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            cliente = Clientes.objects.get(email_clientes=email)
        except Clientes.DoesNotExist:
            return Response({"erro": "Credenciais inválidas"}, status=status.HTTP_401_UNAUTHORIZED)

        if not check_password(senha, cliente.senha_clientes):
            return Response({"erro": "Credenciais inválidas"}, status=status.HTTP_401_UNAUTHORIZED)

        token = gerar_token(cliente.id_clientes)
        serializer = ClientesSerializer(cliente)
        return Response({"token": token, "cliente": serializer.data})


class CheckoutAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        token = request.headers.get("Authorization", "").replace("Token ", "")
        client_id = validar_token(token)
        if client_id is None:
            return Response({"erro": "Token inválido ou expirado"}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            cliente = Clientes.objects.get(pk=client_id)
        except Clientes.DoesNotExist:
            return Response({"erro": "Usuário não encontrado"}, status=status.HTTP_401_UNAUTHORIZED)

        itens = request.data.get("itens", [])
        if not itens:
            return Response({"erro": "Carrinho vazio"}, status=status.HTTP_400_BAD_REQUEST)

        valor_total = 0
        compras = []

        with transaction.atomic():
            pedido = Pedido.objects.create(
                data_pedido=timezone.now(),
                clientes_id_clientes=cliente,
                funcionarios_id_funcionarios=None,
                status="a caminho",
            )

            for item in itens:
                try:
                    produto = Produtos.objects.get(pk=item["produto_id"])
                except Produtos.DoesNotExist:
                    return Response({"erro": f"Produto {item.get('produto_id')} não encontrado"}, status=status.HTTP_404_NOT_FOUND)

                quantidade = int(item.get("quantidade", 1))
                if quantidade <= 0:
                    return Response({"erro": "Quantidade inválida"}, status=status.HTTP_400_BAD_REQUEST)
                if quantidade > produto.quantidade_estoque_produtos:
                    return Response({"erro": f"Estoque insuficiente para {produto.nome_produtos}. Disponível: {produto.quantidade_estoque_produtos}"}, status=status.HTTP_400_BAD_REQUEST)

                valor_item = float(produto.valor_produtos) * quantidade
                valor_total += valor_item
                compras.append(Compra(
                    produtos_id_produtos=produto,
                    pedido_id_pedido=pedido,
                    quantidade_pedido=quantidade,
                    valor_compra=valor_item,
                ))
                produto.quantidade_estoque_produtos -= quantidade

            Compra.objects.bulk_create(compras)
            Produtos.objects.bulk_update([c.produtos_id_produtos for c in compras], ["quantidade_estoque_produtos"])

        return Response({
            "sucesso": True,
            "pedido_id": pedido.id_pedido,
            "valor_total": float(valor_total),
            "mensagem": "Compra finalizada com sucesso!"
        }, status=status.HTTP_201_CREATED)
