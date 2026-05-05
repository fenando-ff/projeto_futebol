from django.shortcuts import render, redirect
from minigame import models as model_minigame
from app_futebol.models import models
import random
from .decorators import login_obrigatorio
from django.http import JsonResponse
import json

# Create your views here.
@login_obrigatorio
def game(request):
    if request.method == 'POST':
        nome = request.POST.get('nome')
        if model_minigame.Participantes.objects.using('minigame').filter(nome_participante=nome).exists():
            mensagem = "Nome já cadastrado. Por favor, escolha outro nome."
            return render(request, 'minigame/game_inicio.html', {'mensagem': mensagem})
        
        model_minigame.Participantes.objects.using('minigame').create(nome_participante=nome)
        return redirect('menu_fases')
        
    return render(request, 'minigame/game_inicio.html')



@login_obrigatorio
def menu_fases(request):
    jogadores = model_minigame.Participantes.objects.using('minigame')\
        .all().order_by('-id_participante')[:5]

    return render(request, 'minigame/menu_game.html', {
        'jogadores': jogadores
    })


@login_obrigatorio
def game_toturial(request):
    return render(request, 'minigame/game_toturial.html')


@login_obrigatorio
def game_sorteio(request):

    produtos_db = list(models.Produtos.objects.all())

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
    
    

# views quiz        
@login_obrigatorio
def game_quiz(request):

    questoes_db = model_minigame.Questoes.objects.using('minigame').all() #anotado

    perguntas = []

    for q in questoes_db:
        alternativas = q.alternativas_set.all()  # ⚠️ AQUI MUDA

        opcoes = []

        for alt in alternativas:
            opcoes.append({
                "id": alt.id_alternativa,
                "texto": alt.opcao_resposta,
                "correta": bool(alt.resposta_correta),  # 👈 converte 0/1 pra true/false
                "ponto": alt.ponto
            })

        perguntas.append({
            "id": q.id_questao,
            "pergunta": q.pergunta,
            "opcoes": opcoes
        })

    return render(request, "minigame/game_quiz.html", {
        "perguntas": perguntas
    })
    
    


@login_obrigatorio
def salvar_pontuacao(request):
    if request.method == 'POST':
        data = json.loads(request.body)

        pontuacao = data.get('pontuacao')

        # pega o último participante (ou pode melhorar depois com sessão)
        participante = model_minigame.Participantes.objects.using('minigame').last()

        if participante:
            participante.tempo = None  # opcional (ou usar outro campo depois)
            participante.save()

        return JsonResponse({'status': 'ok'})