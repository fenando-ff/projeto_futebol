from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse

def home(request):
    return render(request, "app_futebol/index.html")

def tela_carrinho(request):
    return render(request, "app_futebol/carrinho.html")

def tela_loja_detalhe(request):
    return render(request, "app_futebol/loja_detalhe.html")