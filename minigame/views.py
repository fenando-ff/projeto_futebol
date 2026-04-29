from django.shortcuts import render
from app_futebol.models.models import Produtos
from app_futebol.models import models

# Create your views here.
def game(request):
    """
    View que renderiza a página do mini-jogo.
    """
    return render(request, 'game_inicio.html')



def game_toturial(request):
    """
    View que renderiza a página do mini-jogo para cadastro.
    """
    return render(request, 'game_toturial.html')





import random
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

    return render(request, "game_roleta.html", {
        "produtos": produtos,
        "sorteados": sorteados_formatados
    })