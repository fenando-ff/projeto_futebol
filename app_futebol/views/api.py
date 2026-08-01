import os
import random
from decimal import Decimal

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from django.contrib.auth.hashers import check_password, make_password
from django.db import transaction
from django.utils import timezone
from django.core.mail import send_mail
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from ..models import CategoriaCliente, Clientes, Compra, Pedido, Produtos, RecuperacaoSenha
from ..serializers import (
    CadastroSerializer,
    AssinarPlanoSerializer,
    CheckoutSerializer,
    CategoriaClienteSerializer,
    CategoriaClienteAssinaturaSerializer,
    EsqueciSenhaSerializer,
    LoginResponseSerializer,
    LoginSerializer,
    RedefinirSenhaSerializer,
    ValidarCodigoSerializer,
)
from ..auth import ClienteTokenAuthentication, gerar_token
from .socio_catalog import build_pricing_snapshot, build_socio_api_plan, get_socio_desconto_percent


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


def _normalize_checkout_payload(data):
    payload = _payload_copy(data)
    raw_items = _first_value(payload, "itens", "items", "cartItems", default=[])
    if raw_items in (None, ""):
        raw_items = []

    normalized_items = []
    for item in raw_items:
        item_data = _payload_copy(item)
        normalized_items.append({
            "produto_id": _first_value(
                item_data,
                "produto_id",
                "produtoId",
                "product_id",
                "productId",
                "id",
            ),
            "quantidade": _first_value(
                item_data,
                "quantidade",
                "quantity",
                "qtd",
                "amount",
                default=1,
            ),
            "tamanho": _first_value(
                item_data,
                "tamanho",
                "size",
                "tam",
            ),
        })

    return {"itens": normalized_items}


def _categoria_nome_normalizada(produto):
    categoria = getattr(produto, "categoria_produtos_id_categoria_produtos", None)
    nome = getattr(categoria, "nome_categoria_produtos", "") or ""
    return nome.strip().lower()


def _categoria_nao_socio(categoria):
    if not categoria:
        return True

    nome = getattr(categoria, "nome_categoria_clientes", "") or ""
    nome_normalizado = nome.strip().lower()
    categoria_id = getattr(categoria, "id_categoria_cliente", None)

    return categoria_id == 5 or nome_normalizado == "nao socio"


def _serializar_assinatura(cliente):
    categoria = getattr(cliente, "categoria_cliente_id_categoria_cliente", None)
    if _categoria_nao_socio(categoria):
        return None

    return CategoriaClienteAssinaturaSerializer(categoria).data


def _get_desconto_assinatura(cliente):
    categoria = getattr(cliente, "categoria_cliente_id_categoria_cliente", None)
    if _categoria_nao_socio(categoria):
        return 0

    return get_socio_desconto_percent(categoria)


def _build_purchase_preview(cliente, itens_checkout, produtos_lock):
    categoria = getattr(cliente, "categoria_cliente_id_categoria_cliente", None)
    beneficios_plano = _serializar_assinatura(cliente)

    itens_resumo = []
    subtotal_original = 0.0
    economia_total = 0.0
    total_final = 0.0

    for item in itens_checkout:
        produto = produtos_lock[item["produto_id"]]
        quantidade = int(item["quantidade"])
        pricing = build_pricing_snapshot(produto.valor_produtos, categoria, quantidade)

        subtotal_original += pricing["preco_original_total"]
        economia_total += pricing["economia_total"]
        total_final += pricing["preco_final_total"]

        itens_resumo.append(
            {
                "produto_id": produto.id_produtos,
                "nome_produtos": produto.nome_produtos,
                "imagem_produtos": produto.imagem_produtos,
                "quantidade": quantidade,
                "tamanho": item.get("tamanho"),
                "categoria_nome": getattr(
                    getattr(produto, "categoria_produtos_id_categoria_produtos", None),
                    "nome_categoria_produtos",
                    None,
                ),
                "preco_original_unitario": pricing["preco_original_unitario"],
                "preco_final_unitario": pricing["preco_final_unitario"],
                "economia_unitaria": pricing["economia_unitaria"],
                "preco_original_total": pricing["preco_original_total"],
                "preco_final_total": pricing["preco_final_total"],
                "economia_total": pricing["economia_total"],
                "desconto_percent": pricing["desconto_percent"],
            }
        )

    desconto_total = round(subtotal_original - total_final, 2)
    desconto_percent = _get_desconto_assinatura(cliente)

    return {
        "itens": itens_resumo,
        "subtotal_original": round(subtotal_original, 2),
        "economia_total": round(economia_total, 2),
        "total_final": round(total_final, 2),
        "desconto_total": round(desconto_total, 2),
        "desconto_percent": desconto_percent,
        "plano_atual": beneficios_plano,
        "beneficios_plano": (beneficios_plano or {}).get("beneficios", []),
    }


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

        desconto_percent = _get_desconto_assinatura(request.user) if isinstance(request.user, Clientes) else 0
        desconto_valor = round(valor_total * (desconto_percent / 100), 2) if desconto_percent else 0.0
        total_com_desconto = round(valor_total - desconto_valor, 2)

        return Response({
            "itens": itens,
            "quantidade_total": quantidade_total,
            "valor_total": valor_total,
            "desconto_percent": desconto_percent,
            "desconto": desconto_valor,
            "total_com_desconto": total_com_desconto,
            "plano_atual": _serializar_assinatura(request.user) if isinstance(request.user, Clientes) else None,
        })


class CheckoutPreviewAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ClienteTokenAuthentication]

    def post(self, request):
        if not isinstance(request.user, Clientes):
            return Response(
                {"erro": "Usuário não autenticado."},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        payload = _normalize_checkout_payload(request.data)
        serializer = CheckoutSerializer(data=payload)
        serializer.is_valid(raise_exception=True)

        itens_input = serializer.validated_data["itens"]
        itens_agregados = {}
        for item in itens_input:
            produto_id = int(item["produto_id"])
            tamanho = item.get("tamanho")
            chave = (produto_id, tamanho or "")
            agregado = itens_agregados.setdefault(
                chave,
                {
                    "produto_id": produto_id,
                    "quantidade": 0,
                    "tamanho": tamanho,
                },
            )
            agregado["quantidade"] += int(item["quantidade"])

        itens_checkout = list(itens_agregados.values())
        produto_ids = sorted({item["produto_id"] for item in itens_checkout})

        produtos_qs = (
            Produtos.objects.select_related("categoria_produtos_id_categoria_produtos")
            .filter(id_produtos__in=produto_ids)
        )
        produtos_lock = {produto.id_produtos: produto for produto in produtos_qs}

        if len(produtos_lock) != len(produto_ids):
            faltantes = [pid for pid in produto_ids if pid not in produtos_lock]
            return Response(
                {"erro": f"Produto(s) não encontrado(s): {faltantes}"},
                status=status.HTTP_404_NOT_FOUND,
            )

        resumo = _build_purchase_preview(request.user, itens_checkout, produtos_lock)
        return _response(
            "Resumo da compra carregado com sucesso.",
            **resumo,
        )


class CheckoutAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ClienteTokenAuthentication]

    def post(self, request):
        if not isinstance(request.user, Clientes):
            return Response(
                {"erro": "Usuário não autenticado."},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        payload = _normalize_checkout_payload(request.data)
        serializer = CheckoutSerializer(data=payload)
        serializer.is_valid(raise_exception=True)

        itens_input = serializer.validated_data["itens"]
        itens_agregados = {}
        for item in itens_input:
            produto_id = int(item["produto_id"])
            tamanho = item.get("tamanho")
            chave = (produto_id, tamanho or "")
            agregado = itens_agregados.setdefault(
                chave,
                {
                    "produto_id": produto_id,
                    "quantidade": 0,
                    "tamanho": tamanho,
                },
            )
            agregado["quantidade"] += int(item["quantidade"])

        itens_checkout = list(itens_agregados.values())
        produto_ids = sorted({item["produto_id"] for item in itens_checkout})
        cliente = request.user

        with transaction.atomic():
            produtos_qs = (
                Produtos.objects.select_for_update()
                .select_related("categoria_produtos_id_categoria_produtos")
                .filter(id_produtos__in=produto_ids)
            )
            produtos_lock = {produto.id_produtos: produto for produto in produtos_qs}

            if len(produtos_lock) != len(produto_ids):
                faltantes = [pid for pid in produto_ids if pid not in produtos_lock]
                return Response(
                    {"erro": f"Produto(s) não encontrado(s): {faltantes}"},
                    status=status.HTTP_404_NOT_FOUND,
                )

            compras = []
            all_ingressos = True

            for item in itens_checkout:
                produto = produtos_lock[item["produto_id"]]
                quantidade = int(item["quantidade"])
                if quantidade <= 0:
                    return Response(
                        {"erro": "Quantidade inválida."},
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                categoria_nome = _categoria_nome_normalizada(produto)
                if categoria_nome != "ingressos":
                    all_ingressos = False

                tamanho = item.get("tamanho")
                if categoria_nome == "camisas fc":
                    if not tamanho:
                        return Response(
                            {"erro": f'Tamanho é obrigatório para "{produto.nome_produtos}".'},
                            status=status.HTTP_400_BAD_REQUEST,
                        )
                    if tamanho not in {"P", "M", "G", "GG"}:
                        return Response(
                            {"erro": "Tamanho inválido. Use P, M, G ou GG."},
                            status=status.HTTP_400_BAD_REQUEST,
                        )
                else:
                    tamanho = None

                estoque_disponivel = int(produto.quantidade_estoque_produtos or 0)
                if quantidade > estoque_disponivel:
                    return Response(
                        {
                            "erro": (
                                f"Estoque insuficiente para {produto.nome_produtos}. "
                                f"Disponível: {estoque_disponivel}"
                            )
                        },
                        status=status.HTTP_400_BAD_REQUEST,
                    )

                produto.quantidade_estoque_produtos = estoque_disponivel - quantidade
                compras.append(
                    Compra(
                        produtos_id_produtos=produto,
                        pedido_id_pedido=None,
                        quantidade_pedido=quantidade,
                        tamanho=tamanho,
                        valor_compra=Decimal(str(produto.valor_produtos)) * quantidade,
                    )
                )

            status_pedido = "entregue" if all_ingressos and itens_checkout else "a caminho"

            pedido = Pedido.objects.create(
                data_pedido=timezone.now(),
                clientes_id_clientes=cliente,
                funcionarios_id_funcionarios=None,
                status=status_pedido,
            )

            for compra in compras:
                compra.pedido_id_pedido = pedido

            Compra.objects.bulk_create(compras)
            Produtos.objects.bulk_update(
                list(produtos_lock.values()),
                ["quantidade_estoque_produtos"],
            )

            resumo = _build_purchase_preview(cliente, itens_checkout, produtos_lock)

        return _response(
            "Compra finalizada com sucesso.",
            status_code=status.HTTP_201_CREATED,
            pedido_id=pedido.id_pedido,
            total=resumo["total_final"],
            total_bruto=resumo["subtotal_original"],
            desconto_percent=resumo["desconto_percent"],
            desconto=resumo["desconto_total"],
            plano_atual=_serializar_assinatura(cliente),
            beneficios_plano=resumo["beneficios_plano"],
            itens=resumo["itens"],
            status=pedido.status,
        )


class MinhaAssinaturaAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ClienteTokenAuthentication]

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
            200: openapi.Response("Assinatura atual do cliente."),
            401: openapi.Response("Não autenticado."),
        },
        operation_summary="Consultar assinatura atual",
        operation_description="Retorna o plano atual do cliente autenticado ou null caso ele não seja sócio.",
    )
    def get(self, request):
        if not isinstance(request.user, Clientes):
            return _response(
                "Não autenticado.",
                status_code=status.HTTP_401_UNAUTHORIZED,
                success=False,
            )

        return _response(
            "Assinatura carregada com sucesso.",
            assinatura=_serializar_assinatura(request.user),
            plano=_serializar_assinatura(request.user),
            plano_atual=_serializar_assinatura(request.user),
        )


class AssinarPlanoAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]
    authentication_classes = [ClienteTokenAuthentication]

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
        request_body=AssinarPlanoSerializer,
        responses={
            200: openapi.Response("Plano assinado com sucesso."),
            400: openapi.Response("Dados inválidos."),
            401: openapi.Response("Não autenticado."),
            404: openapi.Response("Plano não encontrado."),
        },
        operation_summary="Assinar plano",
        operation_description="Atualiza a categoria do cliente autenticado para o plano informado em plano_id.",
    )
    def post(self, request):
        if not isinstance(request.user, Clientes):
            return _response(
                "Não autenticado.",
                status_code=status.HTTP_401_UNAUTHORIZED,
                success=False,
            )

        serializer = AssinarPlanoSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        plano_id = serializer.validated_data["plano_id"]

        try:
            plano = CategoriaCliente.objects.get(id_categoria_cliente=plano_id)
        except CategoriaCliente.DoesNotExist:
            return _response(
                "Plano não encontrado.",
                status_code=status.HTTP_404_NOT_FOUND,
                success=False,
            )

        with transaction.atomic():
            cliente = Clientes.objects.select_for_update().get(pk=request.user.pk)
            cliente.categoria_cliente_id_categoria_cliente = plano
            cliente.save(update_fields=["categoria_cliente_id_categoria_cliente"])

        return _response(
            "Plano assinado com sucesso.",
            assinatura=CategoriaClienteAssinaturaSerializer(plano).data,
            plano=CategoriaClienteAssinaturaSerializer(plano).data,
            plano_atual=CategoriaClienteAssinaturaSerializer(plano).data,
        )
