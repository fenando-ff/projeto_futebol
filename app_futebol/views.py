from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def home(request):
    return render(request, "app_futebol/index.html")

def tela_carrinho(request):
    return render(request, "app_futebol/carrinho.html")

def tela_loja_detalhe(request):
    return render(request, "app_futebol/loja_detalhe.html")

def tela_socio(request):
    return render(request, "app_futebol/socio.html")

def tela_login(request):
    return render(request, "app_futebol/login.html")

def tela_cadastro(request):
    return render(request, "app_futebol/cadastro.html")

def tela_historia(request):
    return render(request, "app_futebol/historia.html")

def tela_rec_senha(request):
    return render(request, "app_futebol/rec_senha.html")

def tela_rec_senha_2(request):
    return render(request, "app_futebol/rec_senha_2.html")