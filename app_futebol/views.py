from django.contrib.auth.hashers import check_password
from django.contrib import messages
from django.shortcuts import render, redirect
from django.http import JsonResponse-
from . import models

# Create your views here.

def home(request):
    nome = request.session.get("cliente_nome")
    sobrenome = request.session.get("cliente_sobrenome")
    return render(request, "app_futebol/index.html", {
        "nome": nome,
        "sobrenome":sobrenome,
    })

def tela_cadastro(request):
    return render(request, "app_futebol/cadastro.html")


def tela_carrinho(request):
    if not request.session.get("cliente_id"):
        return redirect("login")
    
    nome = request.session.get("cliente_nome")
    sobrenome = request.session.get("cliente_sobrenome")
    return render(request, "app_futebol/carrinho.html",{
        "nome":nome,
        "sobrenome":sobrenome,
    })


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
            request.session["cliente_id"] = cliente.id_clientes
            request.session["cliente_nome"] = cliente.nome_clientes
            request.session["cliente_sobrenome"] = cliente.sobrenome_clientes
            return redirect(home)
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
    return render(request, "app_futebol/rec_senha.html")


def tela_rec_senha_2(request):
    return render(request, "app_futebol/rec_senha_2.html")


def tela_socio(request):
    return render(request, "app_futebol/socio.html")


def tela_ingressos(request):
    return render(request, "app_futebol/Tela_ingresso.html")


def tela_historia(request):
    return render(request, "app_futebol/historia.html")


def pagamento_socio(request):
    return render(request, "app_futebol/pagamento_socio.html")

def tela_proximo_jogo(request):
    return render(request,"app_futebol/proximos_jogos.html")
