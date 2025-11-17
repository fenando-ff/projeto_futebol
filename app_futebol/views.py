from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def home(request):
    return render(request, "app_futebol/index.html")


def tela_cadastro2(request):
    return render(request, "app_futebol/cadastro_2.html")


def tela_cadastro3(request):
    return render(request, "app_futebol/cadastro_3.html")


def tela_cadastro(request):
    return render(request, "app_futebol/cadastro.html")


def tela_carrinho(request):
    return render(request, "app_futebol/carrinho.html")


def tela_conta_finalizada(request):
    return render(request, "app_futebol/conta_criada.html")


def tela_login(request):
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
