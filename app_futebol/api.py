from django.http import JsonResponse
from django.views.decorators.http import require_POST, require_GET
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import check_password, make_password
from django.db import transaction
import json

from .models import models
from .views.views import login_cliente, get_cliente_logado


def _json_body(request):
    try:
        return json.loads(request.body.decode("utf-8") or "{}")
    except Exception:
        return {}


@csrf_exempt
@require_POST
def api_login(request):
    data = _json_body(request)
    email = (data.get("email") or "").strip().lower()
    senha = data.get("senha") or ""

    if not email or not senha:
        return JsonResponse({"ok": False, "error": "Email e senha são obrigatórios."}, status=400)

    try:
        cliente = models.Clientes.objects.get(email_clientes=email)
    except models.Clientes.DoesNotExist:
        return JsonResponse({"ok": False, "error": "Cliente não encontrado."}, status=404)

    if not check_password(senha, cliente.senha_clientes):
        return JsonResponse({"ok": False, "error": "Senha incorreta."}, status=401)

    login_cliente(request, cliente)
    return JsonResponse({"ok": True, "cliente": get_cliente_logado(request)})


@csrf_exempt
@require_POST
def api_logout(request):
    request.session.flush()
    return JsonResponse({"ok": True})


@csrf_exempt
@require_POST
def api_register(request):
    data = _json_body(request)

    nome = (data.get("nome") or "").strip()
    sobrenome = (data.get("sobrenome") or "").strip()
    email = (data.get("email") or "").strip().lower()
    telefone = (data.get("telefone") or "").strip()
    cpf = (data.get("cpf") or "").strip()
    senha = data.get("senha") or ""
    sexo = (data.get("sexo") or "Não informado").strip()

    # endereço (opcional)
    rua = (data.get("rua") or "").strip()
    casa_numero = (data.get("casa_numero") or "").strip()
    bairro = (data.get("bairro") or "").strip()
    cep = (data.get("cep") or "").strip()
    complemento = (data.get("complemento") or "").strip()

    # validações mínimas
    if not nome or not sobrenome:
        return JsonResponse({"ok": False, "error": "Nome e sobrenome são obrigatórios."}, status=400)
    if not email or "@" not in email:
        return JsonResponse({"ok": False, "error": "Email inválido."}, status=400)
    if not cpf or len(cpf) < 11:
        return JsonResponse({"ok": False, "error": "CPF inválido."}, status=400)
    if not senha or len(senha) < 6:
        return JsonResponse({"ok": False, "error": "Senha deve ter pelo menos 6 caracteres."}, status=400)

    if models.Clientes.objects.filter(email_clientes=email).exists():
        return JsonResponse({"ok": False, "error": "Esse email já está cadastrado."}, status=409)

    if models.Clientes.objects.filter(cpf_clientes=cpf).exists():
        return JsonResponse({"ok": False, "error": "Esse CPF já está cadastrado."}, status=409)

    # categoria padrão: "nao socio" = id 5 (igual você usa)
    categoria = models.CategoriaCliente.objects.filter(id_categoria_cliente=5).first()
    if not categoria:
        categoria = models.CategoriaCliente.objects.first()
        if not categoria:
            return JsonResponse({"ok": False, "error": "Sem categoria cadastrada no banco."}, status=500)

    try:
        with transaction.atomic():
            cliente = models.Clientes.objects.create(
                nome_clientes=nome,
                sobrenome_clientes=sobrenome,
                email_clientes=email,
                cpf_clientes=cpf,
                telefone_clientes=telefone,
                sexo_clientes=sexo,
                status_clientes=1,
                categoria_cliente_id_categoria_cliente=categoria,
                senha_clientes=make_password(senha),
            )

            if rua and casa_numero and bairro and cep:
                models.EnderecoCliente.objects.create(
                    cliente_id_cliente=cliente,
                    rua_endereco_cliente=rua,
                    casa_endereco_cliente=casa_numero,
                    bairro_endereco_cliente=bairro,
                    cep_endereco_cliente=cep,
                    complemento_endereco_cliente=complemento or "",
                )

        # já faz login também (opcional, mas melhora UX)
        login_cliente(request, cliente)
        return JsonResponse({"ok": True, "cliente": get_cliente_logado(request)}, status=201)

    except Exception as e:
        return JsonResponse({"ok": False, "error": f"Erro ao cadastrar: {str(e)}"}, status=500)


@require_GET
def api_produtos(request):
    # lista produtos + imagens
    qs = models.Produtos.objects.all().select_related("categoria_produtos_id_categoria_produtos").prefetch_related("imagens")

    items = []
    for p in qs:
        items.append({
            "id": p.id_produtos,
            "nome": p.nome_produtos,
            "valor": float(p.valor_produtos),
            "descricao": p.descricao_produtos,
            "estoque": p.quantidade_estoque_produtos,
            "categoria": {
                "id": p.categoria_produtos_id_categoria_produtos.id_categoria_produtos,
                "nome": p.categoria_produtos_id_categoria_produtos.nome_categoria_produtos,
            },
            "imagem_principal": p.imagem_produtos,
            "imagens": [{"imagem": img.imagem, "ordem": img.ordem} for img in getattr(p, "imagens").all()],
        })

    return JsonResponse({"ok": True, "produtos": items})
