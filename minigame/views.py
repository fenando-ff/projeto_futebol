from django.shortcuts import render, redirect
from app_futebol.models.models import Produtos
from app_futebol.models import models
import random
from .decorators import login_obrigatorio


# Create your views here.
@login_obrigatorio
def game(request):
    return render(request, 'minigame/game_inicio.html')


@login_obrigatorio
def menu_fases(request):
    return render(request, 'minigame/menu_game.html')


@login_obrigatorio
def game_toturial(request):
    return render(request, 'minigame/game_toturial.html')


@login_obrigatorio
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

    return render(request, "minigame/game_roleta.html", {
        "produtos": produtos,
        "sorteados": sorteados_formatados
    })