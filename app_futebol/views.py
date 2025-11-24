from django.shortcuts import render, redirect
from . import models
from django.http import HttpResponse
from django.contrib import messages
from django.contrib.auth.hashers import check_password, make_password

# Create your views here.

def home(request):
    return render(request, "app_futebol/index.html")

def tela_cadastro(request):
    return render(request, "app_futebol/cadastro.html")


def tela_carrinho(request):
    return render(request, "app_futebol/carrinho.html")


def tela_conta_finalizada(request):
    return render(request, "app_futebol/conta_criada.html")



def tela_login(request):
    if request.method == "POST":
        email = request.POST.get("email")
        senha = request.POST.get("senha")

        try:
            cliente = models.Clientes.objects.get(email_clientes=email)
            # clientes = models.Clientes.objects.get(senha_clientes=senha)
        except models.Clientes.DoesNotExist:
            messages.error(request, "Cliente não encontrado!")
            return render(request, "app_futebol/login.html")

        if check_password(senha, cliente.senha_clientes):
            request.session["id_clientes"] = cliente.id_clientes
            return redirect(home)  # nome de url
        else:
            messages.error(request, "Senha incorreta!")

    return render(request, "app_futebol/login.html")


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
