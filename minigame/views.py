from django.shortcuts import render, redirect
from django.urls import reverse
from django.templatetags.static import static
from django.contrib.staticfiles import finders
from urllib3 import request
from minigame import models as model_minigame
from app_futebol.models import models
import random
from .decorators import login_obrigatorio
from django.http import JsonResponse
import json
from django.contrib.auth.hashers import make_password, check_password
from datetime import time
from django.utils import timezone
from django.contrib import messages
from django.db.models import Max



def game(request):
    
    if request.method == 'POST':

        nome = request.POST.get('nome')
        senha = request.POST.get('senha')
        modo = request.POST.get('modo')

        if not nome or not senha:
            return JsonResponse({'error': 'Dados inválidos'}, status=400)

        # CADASTRO
        if modo == "cadastro":

            if model_minigame.Participantes.objects.using('minigame').filter(
                nome_participante=nome
            ).exists():

                return JsonResponse({
                    'error': 'Nome já existe'
                }, status=400)

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

        # LOGIN
        else:

            participante = model_minigame.Participantes.objects.using('minigame').filter(
                nome_participante__startswith=nome
            ).first()

            if not participante:
                return JsonResponse({
                    'error': 'Usuário não encontrado'
                }, status=404)

            if not check_password(senha, participante.senha):

                return JsonResponse({
                    'error': 'Senha incorreta'
                }, status=400)

            request.session['participante_id'] = participante.id_participante

            return JsonResponse({
                'redirect': reverse('menu_fases'),
                'nome_gerado': participante.nome_participante
            })


          

    
    return render(request, 'minigame/game_inicio.html')








#gera o nome do jogador com um sufixo aleatório para evitar repetições
def gerar_nome_unico(nome):
    sufixos = [
        'Flamengo', 'Palmeiras', 'São Paulo', 'Corinthians', 'Santos', 'Grêmio',
        'Internacional', 'Atlético-MG', 'Cruzeiro', 'Vasco', 'Fluminense', 'Botafogo',
        'Bahia', 'Fortaleza', 'Real Madrid', 'Barcelona', 'Manchester City', 'Liverpool',
        'Bayern de Munique', 'Juventus', 'Milan', 'Inter de Milão', 'Paris Saint-Germain',
        'Benfica', 'Porto', 'Ajax'
    ]

    nome_base = nome.capitalize()
    sufixo = random.choice(sufixos)

    return f"{nome_base}_{sufixo}"














# logout não exige login
def logout_minigame(request):
    """Logout apenas do minigame, mantendo sessão do app_futebol intacta"""
    request.session.pop("participante_id", None)
    request.session.pop("quiz_inicio", None)
    return redirect("game_comeco")

def formatar_tempo_user(tempo):
    if not tempo:
        return "00:00"

    total_segundos = (
        tempo.hour * 3600 +
        tempo.minute * 60 +
        tempo.second
    )

    minutos = total_segundos // 60
    segundos = total_segundos % 60

    return f"{minutos:02}:{segundos:02}"

@login_obrigatorio
def menu_fases(request):

    participante_id = request.session.get('participante_id')

    usuario = model_minigame.Participantes.objects.using('minigame').get(
        id_participante=participante_id
    )
    
    # =================================
    # TÍTULO ATIVO
    # =================================

    titulo_ativo = model_minigame.HistoricoTitulos.objects.using('minigame').filter(
        participante=usuario,
        ativo=1
    ).select_related('titulo').first()

    usuario.titulo = "Sem título"

    if titulo_ativo:
        usuario.titulo = titulo_ativo.titulo.nome_titulo
        
    # =================================
    # MELHOR COMBO
    # =================================

    melhor_combo = model_minigame.Respostas.objects.using('minigame').filter(
        participante=usuario
    ).aggregate(Max('combo_max'))

    usuario.combo_maximo = melhor_combo['combo_max__max'] or 0
    
    
    # Verifica se fase2 está liberada
    try:
        progresso = model_minigame.ProgressoFases.objects.using('minigame').get(participante=usuario)
        fase2_liberada = progresso.fase2_liberada
    except model_minigame.ProgressoFases.DoesNotExist:
        fase2_liberada = False

    # 🔥 ranking global
    jogadores = model_minigame.Participantes.objects.using('minigame')\
    .filter(respostas__isnull=False)\
    .exclude(tempo__isnull=True)\
    .exclude(pontuacao__isnull=True)\
    .exclude(pontuacao=0)\
    .order_by('-score_rank')\
    .distinct()[:5]

    jogador_mais_rapido = model_minigame.Participantes.objects.using('minigame')\
    .filter(respostas__isnull=False)\
    .exclude(tempo__isnull=True)\
    .exclude(pontuacao__isnull=True)\
    .exclude(pontuacao=0)\
    .order_by('-pontuacao', 'tempo')\
    .distinct()\
    .first()

    flash_tempo = "00:00"

    if jogador_mais_rapido:
        flash_tempo = formatar_tempo_user(jogador_mais_rapido.tempo)

    # 🔥 formata tempo para exibição
    ranking_formatado = []
    

    for jogador in jogadores:

        tempo_formatado = formatar_tempo_user(jogador.tempo)
    
        ranking_formatado.append({
            'nome': jogador.nome_participante,
            'pontuacao': jogador.pontuacao,
            'tempo': tempo_formatado,
            'flash': jogador_mais_rapido,  # Destaca o usuário logado
        })
        
        
    # =========================
    # TEMPO FORMATADO DO USUÁRIO
    # =========================

    tempo_usuario = "00:00"

    if usuario.tempo:

        total_segundos = (
            usuario.tempo.hour * 3600 +
            usuario.tempo.minute * 60 +
            usuario.tempo.second
        )

        minutos = total_segundos // 60
        segundos = total_segundos % 60

        tempo_usuario = f"{minutos:02}:{segundos:02}" 
        titulo_ganho = request.session.pop('titulo_ganho', None)

    return render(request, 'minigame/menu_game.html', {
        'jogadores': ranking_formatado,
        'usuario': usuario,
        'fase2_liberada': fase2_liberada,

        'titulo_ativo': usuario.titulo,
        'melhor_combo': usuario.combo_maximo,
        'tempo_usuario': tempo_usuario,
        'flash': jogador_mais_rapido,
        'flash_tempo': flash_tempo,
        'titulo_ganho': titulo_ganho,
    })





@login_obrigatorio
def game_toturial(request):
    return render(request, 'minigame/game_toturial.html')


@login_obrigatorio
def quiz_toturial(request):
    return render(request, 'minigame/quiz_toturial.html')


@login_obrigatorio
def game_sorteio(request):

    participante_id = request.session.get('participante_id')
    try:
        participante = model_minigame.Participantes.objects.using('minigame').get(id_participante=participante_id)
    except model_minigame.Participantes.DoesNotExist:
        return redirect('game_comeco')
    
    # Check if fase2 is unlocked
    try:
        progresso = model_minigame.ProgressoFases.objects.using('minigame').get(participante=participante)
        if not progresso.fase2_liberada:
            messages.warning(request, "Complete a Fase 01 para desbloquear a Fase 02!")
            return redirect('menu_fases')
    except model_minigame.ProgressoFases.DoesNotExist:
        messages.warning(request, "Complete a Fase 01 para desbloquear a Fase 02!")
        return redirect('menu_fases')
    
    produtos_db = list(models.Produtos.objects.all())

    # 🎯 sorteia 3 produtos reais
    sorteados = random.sample(produtos_db, 3)

    def get_img_for_product(p):
        # Tenta usar imagem cadastrada se existir no staticfiles
        if p.imagem_produtos:
            try:
                finders.find(p.imagem_produtos)
                return static(p.imagem_produtos)
            except ValueError:
                pass
        # Fallback baseado na categoria
        cat_id = p.categoria_produtos_id_categoria_produtos_id
        if cat_id == 1:  # Acessórios
            return static('jogo/icones/dragon_icon.png')
        elif cat_id == 2:  # Camisas FC
            return static('jogo/icones/tridente_icon.png')
        elif cat_id == 3:  # Calçados
            return static('jogo/icones/coroa_icon.png')
        else:  # Outros (ex: Ingressos)
            return static('jogo/icones/mouse_click.png')

    produtos = [
        {
            "id": p.id_produtos,
            "nome": p.nome_produtos,
            "img": get_img_for_product(p)
        }
        for p in produtos_db
    ]

    sorteados_formatados = [
        {
            "id": p.id_produtos,
            "nome": p.nome_produtos,
            "img": get_img_for_product(p)
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
        combo_maximo = data.get('combo_maximo', 0)
        total_questoes = len(respostas_data)
        acertos = 0
        acertos = 0
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


            participante.save()

            alternativa = model_minigame.Alternativas.objects.using('minigame').get(
                id_alternativa=alternativa_id
            )

            if alternativa.resposta_correta:
                acertos += 1
            
            if not questao_id or not alternativa_id:
                continue
            
            model_minigame.Respostas.objects.using('minigame').update_or_create(
                participante=participante,
                questao_id=questao_id,
                defaults={
                'alternativa_id': alternativa_id,
                'combo_max': combo_maximo
            }
            )



        
        # Liberar fase 2 após completar fase 1 (quiz)
        progresso, created = model_minigame.ProgressoFases.objects.using('minigame').get_or_create(
            participante=participante,
            defaults={'fase2_liberada': True}
        )
        if not created:
            progresso.fase2_liberada = True
            progresso.save()
        

        precisao = (acertos / total_questoes) * 100

        tempo_segundos = tempo_ms / 1000


                        # =================================
        # SCORE INTELIGENTE
        # =================================
        tempo_segundos = int(tempo_ms / 1000)
        precisao = int((acertos / total_questoes) * 100)
        score_final = (
            (acertos * 10)
            + (combo_maximo * 5)
            + precisao
            - tempo_segundos
        )
        if score_final < 0:
            score_final = 0
        participante.score_rank = score_final    

        participante.score_rank = score_final
        participante.save()
        
        # =========================================
        # SISTEMA DE TÍTULOS
        # =========================================

        if score_final >= 180:
            titulo_nome = "Pelé do Quiz"

        elif score_final >= 140:
            titulo_nome = "Rei da Libertadores"

        elif score_final >= 100:
            titulo_nome = "Artilheiro"

        elif score_final >= 60:
            titulo_nome = "Craque da Série A"

        else:
            titulo_nome = "Bagre da Série B"


        # 🔥 salva na sessão
        request.session['titulo_ganho'] = titulo_nome


        # pega título no banco
        titulo_obj = model_minigame.Titulos.objects.using('minigame').get(
            nome_titulo=titulo_nome
        )

        # desativa títulos antigos
        model_minigame.HistoricoTitulos.objects.using('minigame').filter(
            participante=participante
        ).update(ativo=0)

        # cria ou atualiza histórico
        historico, created = model_minigame.HistoricoTitulos.objects.using('minigame').get_or_create(
            participante=participante,
            titulo=titulo_obj,
            defaults={'ativo': 1}
        )

        # se já existia → ativa novamente
        if not created:
            historico.ativo = 1
            historico.save()
        
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
        participante.tempo = time(
            hour=hours,
            minute=minutes,
            second=seconds
        )

        
        return JsonResponse({'status': 'ok'})