from django.shortcuts import render
from app_futebol.models.models import Produtos
from app_futebol.models import models
import random

# Create your views here.
def game(request):
    return render(request, 'minigame_inicio.html')


def game_toturial(request):
    return render(request, 'minigame_toturial.html')


def game_sorteio(request):

    produtos_db = list(Produtos.objects.all())

    # 🎯 sorteia 3 produtos reais
    sorteados = random.sample(produtos_db, 3)

    produtos = [
        {
            "id": p.id_produtos,
            "nome": p.nome_produtos,
            "img": p.imagem_produtos
        }
        for p in produtos_db
    ]

    sorteados_formatados = [
        {
            "id": p.id_produtos,
            "nome": p.nome_produtos,
            "img": p.imagem_produtos
        }
        for p in sorteados
    ]

    return render(request, "minigame_roleta.html", {
        "produtos": produtos,
        "sorteados": sorteados_formatados
    })