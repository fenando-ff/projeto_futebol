from rest_framework.views import APIView
from restramework.response import Response
from rest_framework import status, permissions
from django.contrib.auth.hashers import check_password
from django.db import transaction
from django.utils import timezone
from django.contrib.auth import login as django_login
from django.shortcuts import get_object_or_404
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
        django_login(request, cliente)
        serializer = ClientesSerializer(cliente)
        return Response({"token": token, "cliente": serializer.data})


class CartAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        carrinho = request.session.get("carrinho", {})
        produto_ids = [int(pid) for pid in carrinho.keys()]
        produtos_db = Produtos.objects.filter(id_produtos__in=produto_ids).select_related("categoria_produtos_id_categoria_produtos")
        produtos_map = {p.id_produtos: p for p in produtos_db}
        itens = []
        valor_total = 0
        quantidade_total = 0
        for pid_str, qtd in carrinho.items():
            produto = produtos_map.get(int(pid_str))
            if not produto:
                continue
            valor_unitario = float(produto.valor_produtos)
            subtotal = valor_unitario * qtd
            valor_total += subtotal
            quantidade_total += qtd
            itens.append({
                "produto_id": produto.id_produtos,
                "nome_produtos": produto.nome_produtos,
                "quantidade": qtd,
                "valor_unitario": valor_unitario,
                "subtotal": subtotal,
                "imagem_produtos": produto.imagem_produtos,
                "categoria_nome": getattr(produto.categoria_produtos_id_categoria_produtos, "nome_categoria_produtos", None),
            })
        return Response({
            "itens": itens,
            "quantidade_total": quantidade_total,
            "valor_total": valor_total,
        })

    def post(self, request):
        produto_id = request.data.get("produto_id")
        quantidade = int(request.data.get("quantidade", 1))
        if not produto_id:
            return Response({"erro": "produto_id é obrigatório"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            produto = Produtos.objects.get(pk=produto_id)
        except Produtos.DoesNotExist:
            return Response({"erro": "Produto não encontrado"}, status=status.HTTP_404_NOT_FOUND)
        if quantidade <= 0:
            return Response({"erro": "Quantidade inválida"}, status=status.HTTP_400_BAD_REQUEST)
        carrinho = request.session.get("carrinho", {})
        carrinho[str(produto_id)] = quantidade
        request.session["carrinho"] = carrinho
        request.session.modified = True
        valor_unitario = float(produto.valor_produtos)
        return Response({
            "sucesso": True,
            "produto_id": produto.id_produtos,
            "nome_produtos": produto.nome_produtos,
            "quantidade": quantidade,
            "valor_unitario": valor_unitario,
            "subtotal": valor_unitario * quantidade,
        }, status=status.HTTP_201_CREATED)

    def delete(self, request):
        produto_id = request.data.get("produto_id")
        if not produto_id:
            return Response({"erro": "produto_id é obrigatório"}, status=status.HTTP_400_BAD_REQUEST)
        carrinho = request.session.get("carrinho", {})
        carrinho.pop(str(produto_id), None)
        request.session["carrinho"] = carrinho
        request.session.modified = True
        return Response({"sucesso": True, "carrinho": carrinho})

    def patch(self, request):
        produto_id = request.data.get("produto_id")
        quantidade = int(request.data.get("quantidade", 1))
        if not produto_id:
            return Response({"erro": "produto_id é obrigatório"}, status=status.HTTP_400_BAD_REQUEST)
        if quantidade <= 0:
            return Response({"erro": "Quantidade inválida"}, status=status.HTTP_400_BAD_REQUEST)
        carrinho = request.session.get("carrinho", {})
        carrinho[str(produto_id)] = quantidade
        request.session["carrinho"] = carrinho
        request.session.modified = True
        try:
            produto = Produtos.objects.get(pk=produto_id)
        except Produtos.DoesNotExist:
            return Response({"erro": "Produto não encontrado"}, status=status.HTTP_404_NOT_FOUND)
        valor_unitario = float(produto.valor_produtos)
        return Response({
            "sucesso": True,
            "produto_id": produto.id_produtos,
            "quantidade": quantidade,
            "valor_unitario": valor_unitario,
            "subtotal": valor_unitario * quantidade,
        })


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
