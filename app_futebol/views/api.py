import os
import random

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from django.contrib.auth.hashers import check_password, make_password
from django.db import transaction
from django.utils import timezone
from django.core.mail import send_mail
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from ..models import Clientes, Compra, Pedido, Produtos, RecuperacaoSenha
from ..serializers import (
    CadastroSerializer,
    EsqueciSenhaSerializer,
    LoginResponseSerializer,
    LoginSerializer,
    RedefinirSenhaSerializer,
    ValidarCodigoSerializer,
)
from ..auth import ClienteTokenAuthentication, gerar_token, validar_token


def _buscar_ultima_recuperacao(email):
    cliente = Clientes.objects.filter(email_clientes=email).first()
    if not cliente:
        return None, None

    recuperacao = (
        RecuperacaoSenha.objects.filter(cliente_id=cliente.id_clientes)
        .order_by("-criado_em")
        .first()
    )
    return cliente, recuperacao


def _payload_copy(data):
    if hasattr(data, "copy"):
        return data.copy()
    return dict(data or {})


def _first_value(data, *keys, default=None):
    for key in keys:
        value = data.get(key)
        if value not in (None, ""):
            return value
    return default


def _normalize_recovery_payload(data):
    payload = _payload_copy(data)
    return {
        "email": _first_value(payload, "email", "email_cliente", "emailCliente", "mail"),
        "codigo": _first_value(
            payload,
            "codigo",
            "code",
            "otp",
            "verification_code",
            "verificationCode",
        ),
        "senha": _first_value(
            payload,
            "senha",
            "password",
            "nova_senha",
            "novaSenha",
            "new_password",
            "newPassword",
        ),
        "confirmar_senha": _first_value(
            payload,
            "confirmar_senha",
            "confirmarSenha",
            "confirm_password",
            "confirmPassword",
            "senha_confirmacao",
            "senhaConfirmacao",
        ),
    }


def _validation_message(errors, fallback):
    if isinstance(errors, dict):
        for value in errors.values():
            message = _validation_message(value, None)
            if message:
                return message
        return fallback

    if isinstance(errors, list):
        for value in errors:
            message = _validation_message(value, None)
            if message:
                return message
        return fallback

    if isinstance(errors, str):
        message = errors.strip()
        return message or fallback

    return fallback


def _response(message, *, status_code=status.HTTP_200_OK, success=True, **extra):
    payload = {
        "success": success,
        "message": message,
        "detail": message,
    }
    payload.update(extra)
    return Response(payload, status=status_code)


class EsqueciSenhaAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        request_body=EsqueciSenhaSerializer,
        responses={
            201: openapi.Response("Código enviado."),
            404: openapi.Response("Email não encontrado."),
            500: openapi.Response("Erro ao enviar email."),
        },
        operation_summary="Solicitar recuperação de senha",
        operation_description="Gera um código de recuperação, persiste o registro e envia o email com o código, como no fluxo atual.",
    )
    def post(self, request):
        print("[RECOVERY][esqueci-senha] start", request.path, request.get_host(), list(request.data.keys()))
        serializer = EsqueciSenhaSerializer(data=_normalize_recovery_payload(request.data))
        if not serializer.is_valid():
            print("[RECOVERY][esqueci-senha] validation_error", serializer.errors)
            return _response(
                _validation_message(serializer.errors, "Dados inválidos."),
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
                errors=serializer.errors,
            )

        email = serializer.validated_data["email"]
        print("[RECOVERY][esqueci-senha] email", email)

        cliente = Clientes.objects.filter(email_clientes=email).first()
        if not cliente:
            print("[RECOVERY][esqueci-senha] client_not_found", email)
            return _response(
                "Email não encontrado!",
                status_code=status.HTTP_404_NOT_FOUND,
                success=False,
            )

        codigo = str(random.randint(100000, 999999))
        print("[RECOVERY][esqueci-senha] code_generated", email, codigo)

        RecuperacaoSenha.objects.create(
            cliente_id=cliente.id_clientes,
            codigo=codigo,
            criado_em=timezone.now(),
        )
        print("[RECOVERY][esqueci-senha] recovery_saved", email)

        try:
            print("[RECOVERY][esqueci-senha] send_mail_start", email)
            send_mail(
                "Código de recuperação de senha",
                f"Seu código: {codigo}",
                os.environ.get("EMAIL_HOST_USER"),
                [email],
                fail_silently=False,
            )
            print("[RECOVERY][esqueci-senha] send_mail_ok", email)
        except Exception:
            print("[RECOVERY][esqueci-senha] send_mail_failed", email)
            return _response(
                "Erro ao enviar email.",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                success=False,
            )

        print("[RECOVERY][esqueci-senha] response_ok", email)
        return _response(
            "Código enviado com sucesso.",
            status_code=status.HTTP_201_CREATED,
            email=email,
        )


class ValidarCodigoAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        request_body=ValidarCodigoSerializer,
        responses={
            200: openapi.Response("Código válido."),
            400: openapi.Response("Código inválido ou expirado."),
            404: openapi.Response("Email não encontrado."),
        },
        operation_summary="Validar código de recuperação",
        operation_description="Confere se o código informado é o último gerado para o email e se ainda está dentro do prazo de expiração.",
    )
    def post(self, request):
        print("[RECOVERY][validar-codigo] start", request.path, request.get_host(), list(request.data.keys()))
        serializer = ValidarCodigoSerializer(data=_normalize_recovery_payload(request.data))
        if not serializer.is_valid():
            print("[RECOVERY][validar-codigo] validation_error", serializer.errors)
            return _response(
                _validation_message(serializer.errors, "Dados inválidos."),
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
                errors=serializer.errors,
            )

        email = serializer.validated_data["email"]
        codigo_digitado = serializer.validated_data["codigo"]
        print("[RECOVERY][validar-codigo] payload", email, codigo_digitado)

        cliente, recuperacao = _buscar_ultima_recuperacao(email)
        if not cliente:
            print("[RECOVERY][validar-codigo] client_not_found", email)
            return _response(
                "Email não encontrado!",
                status_code=status.HTTP_404_NOT_FOUND,
                success=False,
            )

        if not recuperacao:
            print("[RECOVERY][validar-codigo] no_code_found", email)
            return _response(
                "Código inválido!",
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
            )

        if recuperacao.expirado():
            print("[RECOVERY][validar-codigo] expired", email, recuperacao.codigo)
            return _response(
                "Código expirado! Solicite outro.",
                status_code=status.HTTP_410_GONE,
                success=False,
            )

        if recuperacao.codigo != codigo_digitado:
            print("[RECOVERY][validar-codigo] mismatch", email, codigo_digitado, recuperacao.codigo)
            return _response(
                "Código incorreto!",
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
            )

        print("[RECOVERY][validar-codigo] response_ok", email)
        return _response("Código válido.")


class RedefinirSenhaAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        request_body=RedefinirSenhaSerializer,
        responses={
            200: openapi.Response("Senha alterada com sucesso."),
            400: openapi.Response("Dados inválidos."),
            404: openapi.Response("Email não encontrado."),
        },
        operation_summary="Redefinir senha",
        operation_description="Valida o código mais recente do email, aplica a nova senha e remove os registros de recuperação utilizados.",
    )
    def post(self, request):
        print("[RECOVERY][redefinir-senha] start", request.path, request.get_host(), list(request.data.keys()))
        serializer = RedefinirSenhaSerializer(data=_normalize_recovery_payload(request.data))
        if not serializer.is_valid():
            print("[RECOVERY][redefinir-senha] validation_error", serializer.errors)
            return _response(
                _validation_message(serializer.errors, "Dados inválidos."),
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
                errors=serializer.errors,
            )

        email = serializer.validated_data["email"]
        codigo_digitado = serializer.validated_data["codigo"]
        nova_senha = serializer.validated_data["senha"]
        print("[RECOVERY][redefinir-senha] payload", email, codigo_digitado)

        cliente, recuperacao = _buscar_ultima_recuperacao(email)
        if not cliente:
            print("[RECOVERY][redefinir-senha] client_not_found", email)
            return _response(
                "Email não encontrado!",
                status_code=status.HTTP_404_NOT_FOUND,
                success=False,
            )

        if not recuperacao:
            print("[RECOVERY][redefinir-senha] no_code_found", email)
            return _response(
                "Código inválido!",
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
            )

        if recuperacao.expirado():
            print("[RECOVERY][redefinir-senha] expired", email, recuperacao.codigo)
            return _response(
                "Código expirado! Solicite outro.",
                status_code=status.HTTP_410_GONE,
                success=False,
            )

        if recuperacao.codigo != codigo_digitado:
            print("[RECOVERY][redefinir-senha] mismatch", email, codigo_digitado, recuperacao.codigo)
            return _response(
                "Código incorreto!",
                status_code=status.HTTP_400_BAD_REQUEST,
                success=False,
            )

        print("[RECOVERY][redefinir-senha] updating_password", email)
        with transaction.atomic():
            cliente.senha_clientes = make_password(nova_senha)
            cliente.save(update_fields=["senha_clientes"])
            RecuperacaoSenha.objects.filter(cliente_id=cliente.id_clientes).delete()
        print("[RECOVERY][redefinir-senha] password_updated", email)

        print("[RECOVERY][redefinir-senha] response_ok", email)
        return _response(
            "Senha alterada com sucesso!",
            email=email,
        )


class CadastroAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        request_body=CadastroSerializer,
        responses={
            201: LoginResponseSerializer(),
            400: openapi.Response("Dados inválidos."),
            409: openapi.Response("Conflito de cadastro."),
            500: openapi.Response("Erro ao cadastrar."),
        },
        operation_summary="Cadastro de cliente",
        operation_description="Cria o cliente e, se informado, o endereço. Retorna token stateless no mesmo contrato do login.",
    )
    def post(self, request):
        serializer = CadastroSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        try:
            cliente = serializer.save()
        except ValueError as exc:
            return Response({"detail": str(exc)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        except Exception as exc:
            return Response({"detail": f"Erro ao cadastrar: {str(exc)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        token = gerar_token(cliente.id_clientes)
        response_serializer = LoginResponseSerializer({"token": token, "cliente": cliente})
        return Response(response_serializer.data, status=status.HTTP_201_CREATED)


class LoginAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        request_body=LoginSerializer,
        responses={
            200: LoginResponseSerializer(),
            400: openapi.Response("Dados inválidos."),
            401: openapi.Response("Credenciais inválidas."),
        },
        operation_summary="Login de cliente",
        operation_description="Autentica o cliente e retorna o token HMAC consumido pelo React Native.",
    )
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data["email"]
        senha = serializer.validated_data["senha"]

        try:
            cliente = Clientes.objects.get(email_clientes=email)
        except Clientes.DoesNotExist:
            return Response({"detail": "Credenciais inválidas."}, status=status.HTTP_401_UNAUTHORIZED)

        if not check_password(senha, cliente.senha_clientes):
            return Response({"detail": "Credenciais inválidas."}, status=status.HTTP_401_UNAUTHORIZED)

        token = gerar_token(cliente.id_clientes)
        response_serializer = LoginResponseSerializer({"token": token, "cliente": cliente})
        return Response(response_serializer.data, status=status.HTTP_200_OK)


class LogoutAPIView(APIView):
    permission_classes = [permissions.AllowAny]

    @swagger_auto_schema(
        responses={
            200: openapi.Response("Logout realizado."),
        },
        operation_summary="Logout de cliente",
        operation_description="Logout stateless para o token HMAC. O cliente deve descartar o token localmente.",
    )
    def post(self, request):
        return Response({"detail": "Logout realizado."}, status=status.HTTP_200_OK)


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
    authentication_classes = [ClienteTokenAuthentication]

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
