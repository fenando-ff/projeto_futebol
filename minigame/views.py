from django.shortcuts import render, redirect
from django.templatetags.static import static
from django.contrib.staticfiles import finders
from app_futebol import models
import random
from .decorators import login_obrigatorio
from django.http import JsonResponse
import json
from datetime import time
from django.utils import timezone
from django.contrib import messages
from django.db.models import Max


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

    cliente_id = request.session.get('cliente_id')

    try:
        usuario = models.Clientes.objects.get(
            id_clientes=cliente_id
        )
    except models.Clientes.DoesNotExist:
        # Se o participante não existe, limpa a sessão e redireciona
        request.session.pop('cliente_id', None)
        messages.error(request, "Sua conta não foi encontrada. Faça login novamente.")
        return redirect("menu_fases")
    
    # =================================
    # TÍTULO ATIVO
    # =================================

    titulo_ativo = models.HistoricoTitulos.objects.filter(
        cliente=usuario,
        ativo=1
    ).select_related('titulo').first()

    usuario.titulo = "Sem título"

    if titulo_ativo:
        usuario.titulo = titulo_ativo.titulo.nome_titulo
        
    # =================================
    # MELHOR COMBO
    # =================================

    melhor_combo = models.Respostas.objects.filter(
        cliente=usuario
    ).aggregate(Max('combo_max'))

    usuario.combo_maximo = melhor_combo['combo_max__max'] or 0
    
    
    # Verifica se fase2 está liberada
    try:
        progresso = models.ProgressoFases.objects.get(cliente=usuario)
        fase2_liberada = progresso.fase2_liberada
    except models.ProgressoFases.DoesNotExist:
        fase2_liberada = False

    # 🔥 ranking global
    jogadores = models.Clientes.objects.all()\
    .filter(respostas__isnull=False)\
    .exclude(tempo__isnull=True)\
    .exclude(score_rank__isnull=True)\
    .exclude(score_rank=0)\
    .order_by('-score_rank')\
    .distinct()[:5]

    jogador_mais_rapido = models.Clientes.objects.all()\
    .filter(respostas__isnull=False)\
    .exclude(tempo__isnull=True)\
    .exclude(score_rank__isnull=True)\
    .exclude(score_rank=0)\
    .order_by('tempo')\
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
            'nome': jogador.nome_clientes,
            'pontuacao': jogador.score_rank,
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

    cliente_id = request.session.get('cliente_id')
    try:
        cliente = models.Clientes.objects.get(id_clientes=cliente_id)
    except models.Clientes.DoesNotExist:
        return redirect('menu_fases')
    
    # Check if fase2 is unlocked
    try:
        progresso = models.ProgressoFases.objects.get(cliente=cliente)
        if not progresso.fase2_liberada:
            messages.warning(request, "Complete a Fase 01 para desbloquear a Fase 02!")
            return redirect('menu_fases')
    except models.ProgressoFases.DoesNotExist:
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
    questoes_db = models.Questoes.objects.all()

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
        
        cliente_id = request.session.get('cliente_id')
        if not cliente_id:
            return JsonResponse({'error': 'Sessão inválida'}, status=401)
        
        try:
            cliente = models.Clientes.objects.get(id_clientes=cliente_id)
        except models.Clientes.DoesNotExist:
            return JsonResponse({'error': 'Cliente não encontrado'}, status=404)
        
        if tempo_ms is not None:
            segundos = tempo_ms / 1000

            hours = int(segundos // 3600)
            minutes = int((segundos % 3600) // 60)
            seconds = int(segundos % 60)

            cliente.tempo = time(
                hour=hours,
                minute=minutes,
                second=seconds
            )
        
        # Salva pontuação total
        cliente.score_rank = pontuacao_total
        cliente.save()

        
        # Salva respostas individuais
        for resp in respostas_data:
            questao_id = resp.get('questao_id')
            alternativa_id = resp.get('alternativa_id')

            if not questao_id or not alternativa_id:
                continue
            
            cliente.save()

            try:
                alternativa = models.Alternativas.objects.get(
                    id_alternativa=alternativa_id
                )
                if alternativa.resposta_correta:
                    acertos += 1
            except models.Alternativas.DoesNotExist:
                continue
            
            models.Respostas.objects.update_or_create(
                cliente=cliente,
                questao_id=questao_id,
                defaults={
                'alternativa_id': alternativa_id,
                'combo_max': combo_maximo
            }
            )



        
        # Liberar fase 2 após completar fase 1 (quiz)
        progresso, created = models.ProgressoFases.objects.get_or_create(
            cliente=cliente,
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
        cliente.score_rank = score_final
        cliente.save()
        
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
        try:
            titulo_obj = models.Titulos.objects.get(
                nome_titulo=titulo_nome
            )
        except models.Titulos.DoesNotExist:
            titulo_obj = None

        if not titulo_obj:
            return JsonResponse({'status': 'ok', 'titulo': titulo_nome})

        # desativa títulos antigos
        models.HistoricoTitulos.objects.filter(
            cliente=cliente
        ).update(ativo=0)

        # cria ou atualiza histórico
        historico, created = models.HistoricoTitulos.objects.get_or_create(
            cliente=cliente,
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
        
        cliente_id = request.session.get('cliente_id')
        if not cliente_id:
            return JsonResponse({'error': 'Sessão inválida'}, status=401)
        
        try:
            cliente = models.Clientes.objects.get(id_clientes=cliente_id)
        except models.Clientes.DoesNotExist:
            return JsonResponse({'error': 'Cliente não encontrado'}, status=404)
        
        # Converte milissegundos para formato TimeField (HH:MM:SS)
        segundos = tempo_ms / 1000
        hours = int(segundos // 3600)
        minutes = int((segundos % 3600) // 60)
        seconds = int(segundos % 60)
        cliente.tempo = time(
            hour=hours,
            minute=minutes,
            second=seconds
        )

        
        return JsonResponse({'status': 'ok'})


@login_obrigatorio
def finalizar_missao(request):
    """
    Chamada pela tela de carrinho (modo jogo) apos o usuario clicar em
    'FINALIZAR MISSAO' e completar o pagamento rapido.
    Limpa a sessao do minigame e redireciona para o menu de fases.
    """
    request.session.pop("quiz_inicio", None)
    request.session.pop("titulo_ganho", None)
    return redirect("menu_fases")
