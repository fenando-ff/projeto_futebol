from django.shortcuts import render, redirect
from django.urls import reverse
from minigame import models as model_minigame
from app_futebol.models import models
import random
from .decorators import login_obrigatorio
from django.http import JsonResponse
import json
from django.contrib.auth.hashers import make_password, check_password
from datetime import time
from django.utils import timezone

# Create your views here.
# @login_obrigatorio                                NOME NÂO PODE SER REPETIDO
# def game(request):
#     if request.method == 'POST':
#         nome = request.POST.get('nome')
        
#         # Verifica se é requisição AJAX
#         is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
        
#         if model_minigame.Participantes.objects.using('minigame').filter(nome_participante=nome).exists():
#             if is_ajax:
#                 return JsonResponse({'error': 'Nome já cadastrado. Por favor, escolha outro nome.'}, status=400)
#             mensagem = "Nome já cadastrado. Por favor, escolha outro nome."
#             return render(request, 'minigame/game_inicio.html', {'mensagem': mensagem})
        
#         participante = model_minigame.Participantes.objects.using('minigame').create(nome_participante=nome)
#         request.session['participante_id'] = participante.id_participante
        
#         if is_ajax:
#             return JsonResponse({'success': True, 'redirect': reverse('menu_fases')})
#         return redirect('menu_fases')
        
#     return render(request, 'minigame/game_inicio.html')



@login_obrigatorio
def game(request):
    if request.method == 'POST':
        nome = request.POST.get('nome')
        senha = request.POST.get('senha')
        modo = request.POST.get('modo')

        if not nome or not senha:
            return JsonResponse({'error': 'Dados inválidos'}, status=400)

        # 🔹 CADASTRO
        if modo == "cadastro":

            if model_minigame.Participantes.objects.using('minigame').filter(nome_participante=nome).exists():
                return JsonResponse({'error': 'Nome já existe'}, status=400)

            nome_final = gerar_nome_unico(nome)

            participante = model_minigame.Participantes.objects.using('minigame').create(
                nome_participante=nome_final,
                senha=make_password(senha)
            )

            request.session['participante_id'] = participante.id_participante

            return JsonResponse({
                'redirect': reverse('menu_fases'),
                'nome_gerado': nome_final
            })

        # 🔹 LOGIN
        else:
            try:
                participante = model_minigame.Participantes.objects.using('minigame').filter(nome_participante__startswith=nome).first()
            except:
                return JsonResponse({'error': 'Usuário não encontrado'}, status=404)

            if not check_password(senha, participante.senha):
                return JsonResponse({'error': 'Senha incorreta'}, status=400)

            request.session['participante_id'] = participante.id_participante

            return JsonResponse({
                'redirect': reverse('menu_fases'),
                'nome_gerado': participante.nome_participante
            })

    return render(request, 'minigame/game_inicio.html')





#gera o nome do jogador com um sufixo aleatório para evitar repetições
def gerar_nome_unico(nome):
    sufixos = [
        "Capivara", "Dragao", "Fenix", "Lobo", "Tigre",
        "Pantera", "Corvo", "Leao", "Falcon", "Serpente","Leão","Cobra","Gato","Cadela","Mocurento","Flamenguista"
        "Cachorro","Galo","Bode","Vaca","Porco","Macaco","Tatu","Jacare","Canguru","Urso","Raposa"
    ]

    nome_base = nome.capitalize()
    sufixo = random.choice(sufixos)

    return f"{nome_base}_{sufixo}"














@login_obrigatorio
def menu_fases(request):

    participante_id = request.session.get('participante_id')

    usuario = model_minigame.Participantes.objects.using('minigame').get(
        id_participante=participante_id
    )

    # 🔥 ranking global
    jogadores = model_minigame.Participantes.objects.using('minigame')\
        .all()\
        .order_by('-pontuacao', 'tempo')[:5]

    # 🔥 formata tempo para exibição
    ranking_formatado = []

    for jogador in jogadores:

        tempo_formatado = "00:00"

        if jogador.tempo:

            total_segundos = (
                jogador.tempo.hour * 3600 +
                jogador.tempo.minute * 60 +
                jogador.tempo.second
            )

            minutos = total_segundos // 60
            segundos = total_segundos % 60

            tempo_formatado = f"{minutos:02}:{segundos:02}"

        ranking_formatado.append({
            'nome': jogador.nome_participante,
            'pontuacao': jogador.pontuacao,
            'tempo': tempo_formatado
        })

    return render(request, 'minigame/menu_game.html', {
        'jogadores': ranking_formatado,
        'usuario': usuario
    })





@login_obrigatorio
def game_toturial(request):
    return render(request, 'minigame/game_toturial.html')


@login_obrigatorio
def quiz_toturial(request):
    return render(request, 'minigame/quiz_toturial.html')


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

    # 🔥 pega todas as questões
    questoes_db = model_minigame.Questoes.objects.using('minigame').all()

    perguntas = []

    for q in questoes_db:

        # 🔹 pega alternativas da questão
        alternativas = q.alternativas_set.all()

        opcoes = []

        for alt in alternativas:

            opcoes.append({
                "id": alt.id_alternativa,
                "texto": alt.opcao_resposta,
                "correta": bool(alt.resposta_correta),
                "ponto": alt.ponto
            })

        perguntas.append({
            "id": q.id_questao,
            "pergunta": q.pergunta,
            "opcoes": opcoes
        })

    # 🔀 embaralha perguntas
    perguntas = random.sample(perguntas, len(perguntas))

    # ⏱️ inicia tempo do quiz na sessão
    request.session['quiz_inicio'] = timezone.now().isoformat()

    return render(request, "minigame/game_quiz.html", {
        "perguntas": perguntas
    })
    
    


@login_obrigatorio
def salvar_pontuacao(request):
    
    if request.method == 'POST':
        data = json.loads(request.body)
        pontuacao_total = data.get('pontuacao')
        respostas_data = data.get('respostas', [])
        tempo_ms = data.get('tempo_ms')
        print(data)
        print(tempo_ms)
        print(type(tempo_ms))
        
        participante_id = request.session.get('participante_id')
        if not participante_id:
            return JsonResponse({'error': 'Sessão inválida'}, status=401)
        
        try:
            participante = model_minigame.Participantes.objects.using('minigame').get(id_participante=participante_id)
        except model_minigame.Participantes.DoesNotExist:
            return JsonResponse({'error': 'Participante não encontrado'}, status=404)
        
        if tempo_ms is not None:
            segundos = tempo_ms / 1000

            hours = int(segundos // 3600)
            minutes = int((segundos % 3600) // 60)
            seconds = int(segundos % 60)

            participante.tempo = time(
                hour=hours,
                minute=minutes,
                second=seconds
            )
        
        # Salva pontuação total
        participante.pontuacao = pontuacao_total
        participante.save()
        
        # Salva respostas individuais
        for resp in respostas_data:
            questao_id = resp.get('questao_id')
            alternativa_id = resp.get('alternativa_id')
            
            if not questao_id or not alternativa_id:
                continue
            
            model_minigame.Respostas.objects.using('minigame').update_or_create(
                participante=participante,
                questao_id=questao_id,
                defaults={'alternativa_id': alternativa_id}
            )
        
        return JsonResponse({'status': 'ok'})


@login_obrigatorio
def salvar_tempo_roleta(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        tempo_ms = data.get('tempo_ms')
        
        participante_id = request.session.get('participante_id')
        if not participante_id:
            return JsonResponse({'error': 'Sessão inválida'}, status=401)
        
        try:
            participante = model_minigame.Participantes.objects.using('minigame').get(id_participante=participante_id)
        except model_minigame.Participantes.DoesNotExist:
            return JsonResponse({'error': 'Participante não encontrado'}, status=404)
        
        # Converte milissegundos para formato TimeField (HH:MM:SS)
        segundos = tempo_ms / 1000
        hours = int(segundos // 3600)
        minutes = int((segundos % 3600) // 60)
        seconds = int(segundos % 60)
        tempo_str = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        participante.tempo = tempo_str
        participante.save()
        
        return JsonResponse({'status': 'ok'})