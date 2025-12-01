from django.contrib.auth.hashers import check_password
from django.contrib import messages
from django.shortcuts import render, redirect
from . import models

# -------------------------------
# Helpers
# -------------------------------

def login_cliente(request, cliente):
    # Salva os dados do cliente na sessão.
    request.session["cliente_id"] = cliente.id_clientes
    request.session["cliente_nome"] = cliente.nome_clientes
    request.session["cliente_sobrenome"] = cliente.sobrenome_clientes
    request.session["cliente_email"] = cliente.email_clientes
    request.session["cliente_telefone"] = cliente.telefone_clientes
    request.session["cliente_cpf"] = cliente.cpf_clientes
    request.session["plano_socio"] = cliente.categoria_cliente_id_categoria_cliente.nome_categoria_clientes


def get_cliente_logado(request):
    # Retorna os dados do cliente logado ou None se não estiver logado.
    if not request.session.get("cliente_id"):
        return None
    return {
        "id": request.session.get("cliente_id"),
        "nome": request.session.get("cliente_nome"),
        "sobrenome": request.session.get("cliente_sobrenome"),
        "email": request.session.get("cliente_email"),
        "telefone": request.session.get("cliente_telefone"),
        "cpf": request.session.get("cliente_cpf"),
        "plano_cliente": request.session.get("plano_socio"),
    }

# -------------------------------
# Views
# -------------------------------

def home(request):
    cliente = get_cliente_logado(request)
    return render(request, "app_futebol/index.html", cliente or {})


def tela_carrinho(request):
    cliente = get_cliente_logado(request)
    if not cliente:
        return redirect("login")
    return render(request, "app_futebol/carrinho.html", cliente)


def tela_conta_finalizada(request):
    return render(request, "app_futebol/conta_criada.html")


def tela_login(request):
    if request.method == "POST":
        email = request.POST.get("email")
        senha = request.POST.get("senha")

        try:
            cliente = models.Clientes.objects.get(email_clientes=email)
        except models.Clientes.DoesNotExist:
            messages.error(request, "Cliente não encontrado!")
            return render(request, "app_futebol/login.html")

        if check_password(senha, cliente.senha_clientes):
            login_cliente(request, cliente)
            return redirect("home")
        else:
            messages.error(request, "Senha incorreta!")
            return render(request, "app_futebol/login.html")

    return render(request, "app_futebol/login.html")


def logout_view(request):
    request.session.flush()
    return redirect("home")


def tela_loja_detalhe(request):
    return render(request, "app_futebol/loja_detalhe.html")


def tela_loja_produtos(request):
    return render(request, "app_futebol/loja_produtos.html")


def tela_noticias(request):
    return render(request, "app_futebol/noticias.html")


def tela_rec_senha(request):
    email = get_cliente_logado(request)
    return render(request, "app_futebol/rec_senha.html")


def tela_rec_senha_2(request):
    return render(request, "app_futebol/rec_senha_2.html")


def tela_socio(request):
    planos = models.CategoriaCliente.objects.all()
    return render(request, "app_futebol/socio.html",{"planos":planos})


def tela_ingressos(request):
    return render(request, "app_futebol/Tela_ingresso.html")


def tela_historia(request):
    return render(request, "app_futebol/historia.html")


def pagamento_socio(request, plano_id):
    try:
        plano = models.CategoriaCliente.objects.get(id_categoria_cliente=plano_id)
    except models.CategoriaCliente.DoesNotExist:
        messages.error(request, "Plano não encontrado!")
        return redirect("tela_socio")
    
    cliente_id = request.session.get("cliente_id")
    if not cliente_id:
        return redirect("login")

    cliente = models.Clientes.objects.get(id_clientes=cliente_id)

    return render(request, "app_futebol/pagamento_socio.html", {
        "cliente": cliente,
        "plano": plano,
    })


def tela_proximo_jogo(request):
    return render(request, "app_futebol/proximos_jogos.html")
