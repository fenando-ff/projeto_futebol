import os
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.hashers import check_password, make_password
from django.contrib import messages
from django.shortcuts import render, redirect, get_object_or_404
from django.core.mail import send_mail
import random
from . import models

# -------------------------------
# Helpers
# -------------------------------

def login_cliente(request, cliente):
    # Salva os dados do cliente na sessão.
    request.session["cliente_id"] = cliente.id_clientes
    request.session["cliente_nome"] = cliente.nome_clientes
    request.session["cliente_sobrenome"] = cliente.sobrenome_clientes
    request.session["cliente_email"] = cliente.email_clientes
    request.session["cliente_telefone"] = cliente.telefone_clientes
    request.session["cliente_cpf"] = cliente.cpf_clientes
    # Armazena o id do plano e o nome para exibição
    try:
        plano_obj = cliente.categoria_cliente_id_categoria_cliente
        request.session["plano_socio_id"] = plano_obj.id_categoria_cliente
        request.session["plano_socio_nome"] = plano_obj.nome_categoria_clientes
    except Exception:
        request.session.pop("plano_socio_id", None)
        request.session.pop("plano_socio_nome", None)
        
    try:
        endereco = models.EnderecoCliente.objects.get(cliente_id_cliente=cliente)
        endereco_cliente = {
            "id": endereco.id_endereco_cliente,
            "cep": endereco.cep_endereco_cliente,
            "rua": endereco.rua_endereco_cliente,
            "casa": endereco.casa_endereco_cliente,
            "bairro": endereco.bairro_endereco_cliente,
            "complemento": endereco.complemento_endereco_cliente
        }
        request.session["cliente_endereco"] = endereco_cliente
        
    except models.EnderecoCliente.DoesNotExist:
        request.session["cliente_endereco"] = None

def get_cliente_logado(request):
    # Retorna os dados do cliente logado ou None se não estiver logado.
    if not request.session.get("cliente_id"):
        return None
    # Resolve nome do plano a partir do id em sessão, se necessário
    plano_nome = request.session.get('plano_socio_nome')
    if not plano_nome and request.session.get('plano_socio_id'):
        try:
            plano = models.CategoriaCliente.objects.get(id_categoria_cliente=request.session.get('plano_socio_id'))
            plano_nome = plano.nome_categoria_clientes
            request.session['plano_socio_nome'] = plano_nome
        except models.CategoriaCliente.DoesNotExist:
            plano_nome = None

    return {
        "id": request.session.get("cliente_id"),
        "nome": request.session.get("cliente_nome"),
        "sobrenome": request.session.get("cliente_sobrenome"),
        "email": request.session.get("cliente_email"),
        "telefone": request.session.get("cliente_telefone"),
        "endereco": request.session.get("cliente_endereco"),
        "cpf": request.session.get("cliente_cpf"),
        "plano_cliente": plano_nome,
    }

# -------------------------------
# Views
# -------------------------------

def tela_perfil(request):
    dados_cliente = get_cliente_logado(request)
    if not dados_cliente:
        return redirect('login') 
    
    return render(request, "app_futebol/perfil.html", dados_cliente)


def home(request):
    cliente = get_cliente_logado(request)
    return render(request, "app_futebol/index.html", cliente or {})


def tela_carrinho(request):
    cliente = get_cliente_logado(request)
    if not cliente:
        return redirect("login")
    
    carrinho = request.session.get("carrinho", {})
    total = 0
    itens = []
    
    for produto_id, quantidade in carrinho.items():
        try:
            produto = models.Produtos.objects.get(id_produtos=produto_id)
            subtotal = produto.valor_produtos * quantidade
            total += subtotal
            itens.append({
                "produto": produto,
                "quantidade": quantidade,
                "subtotal": subtotal,
                "preco_linha": subtotal
            })
        except models.Produtos.DoesNotExist:
            pass

    # Determina o plano do cliente: prefere o id em sessão, caso contrário busca no DB
    desconto_percent = 0.0
    plano_id = request.session.get('plano_socio_id')
    plano_nome = request.session.get('plano_socio_nome')
    if not plano_id and request.session.get('cliente_id'):
        try:
            cliente_obj = models.Clientes.objects.get(id_clientes=request.session.get('cliente_id'))
            plano_obj = cliente_obj.categoria_cliente_id_categoria_cliente
            if plano_obj:
                plano_id = plano_obj.id_categoria_cliente
                plano_nome = plano_obj.nome_categoria_clientes
                request.session['plano_socio_id'] = plano_id
                request.session['plano_socio_nome'] = plano_nome
        except models.Clientes.DoesNotExist:
            plano_id = None

    # Se temos o objeto do plano, podemos decidir desconto por nome (ou mapear por id se preferir)
    if plano_id:
        # Busca o objeto para ler o nome e decidir a taxa
        try:
            plano_obj = models.CategoriaCliente.objects.get(id_categoria_cliente=plano_id)
            nome_lower = plano_obj.nome_categoria_clientes.strip().lower()
            # Comparação por nomes exatos (insensível a maiúsculas e acentos)
            if nome_lower == 'socio drakos - diamante':
                desconto_percent = 0.20
            elif nome_lower == 'socio drakos - ouro':
                desconto_percent = 0.10
            elif nome_lower == 'socio drakos - prata':
                desconto_percent = 0.05
            elif nome_lower == 'nao socio':
                desconto_percent = 0.0
            plano_nome = plano_obj.nome_categoria_clientes
        except models.CategoriaCliente.DoesNotExist:
            desconto_percent = 0.0

    desconto_valor = total * desconto_percent
    total_com_desconto = total - desconto_valor
    return render(request, "app_futebol/carrinho.html", {
        "itens": itens,
        "total": total,
        "desconto": desconto_valor,
        "desconto_percent": int(desconto_percent * 100),
        "total_com_desconto": total_com_desconto,
        "plano_cliente": plano_nome or cliente.get('plano_cliente'),
        **cliente
    })


def adicionar_carrinho(request, produto_id):
    # Não permite adicionar sem cliente logado
    if not request.session.get("cliente_id"):
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "success": False,
                "needs_login": True,
                "message": "Faça login para adicionar ao carrinho."
            }, status=401)
        messages.error(request, "Faça login para adicionar ao carrinho!")
        return redirect("login")

    try:
        produto = models.Produtos.objects.get(id_produtos=produto_id)
    except models.Produtos.DoesNotExist:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({"success": False, "message": "Produto não encontrado!"})
        messages.error(request, "Produto não encontrado!")
        return redirect("produtos")

    carrinho = request.session.get("carrinho", {})
    pid = str(produto_id)
    carrinho[pid] = carrinho.get(pid, 0) + 1
    request.session["carrinho"] = carrinho

    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return JsonResponse({
            "success": True,
            "message": f"{produto.nome_produtos} adicionado ao carrinho!",
            "produto_nome": produto.nome_produtos,
            "quantidade": carrinho[pid]
        })

    messages.success(request, f"{produto.nome_produtos} adicionado ao carrinho!")
    return redirect("produtos")


def remover_carrinho(request, produto_id):
    carrinho = request.session.get("carrinho", {})
    produto_id_str = str(produto_id)
    
    if produto_id_str in carrinho:
        del carrinho[produto_id_str]
        request.session["carrinho"] = carrinho
        messages.success(request, "Produto removido do carrinho!")
    
    return redirect("carrinho")


def atualizar_quantidade_carrinho(request, produto_id):
    # Simplificado: aceita apenas POST para atualizar quantidade
    if request.method != "POST":
        return redirect("carrinho")

    try:
        quantidade = int(request.POST.get("quantidade", 1))
    except (TypeError, ValueError):
        quantidade = 1

    carrinho = request.session.get("carrinho", {})
    pid = str(produto_id)

    if quantidade <= 0:
        # remove do carrinho
        if pid in carrinho:
            del carrinho[pid]
    else:
        carrinho[pid] = quantidade

    request.session["carrinho"] = carrinho

    # Recalcula totais e monta lista de itens
    total = 0.0
    itens = []
    for prod_id_str, qtd in carrinho.items():
        try:
            prod = models.Produtos.objects.get(id_produtos=int(prod_id_str))
        except models.Produtos.DoesNotExist:
            continue
        subtotal = prod.valor_produtos * qtd
        total += subtotal
        itens.append({ #
            "id": prod.id_produtos,
            "nome": prod.nome_produtos,
            "preco_unit": prod.valor_produtos,
            "quantidade": qtd,
            "subtotal": subtotal
        })

    # Aplicar desconto simples baseado no plano em sessão (se houver)
    desconto_percent = 0.0
    plano_id = request.session.get('plano_socio_id')
    if plano_id:
        try:
            plano = models.CategoriaCliente.objects.get(id_categoria_cliente=plano_id)
            nome = (plano.nome_categoria_clientes or "").lower()
            if "ouro" in nome:
                desconto_percent = 0.15
            elif "sócio" in nome or "socio" in nome:
                desconto_percent = 0.10
        except models.CategoriaCliente.DoesNotExist:
            desconto_percent = 0.0

    desconto_valor = total * desconto_percent
    total_com_desconto = total - desconto_valor

    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return JsonResponse({
            "success": True,
            "itens": itens,
            "total": total,
            "desconto": desconto_valor,
            "desconto_percent": int(desconto_percent * 100),
            "total_com_desconto": total_com_desconto
        })

    return redirect("carrinho")


def tela_conta_finalizada(request):
    return render(request, "app_futebol/conta_criada.html")


def tela_login(request):
    if request.method == "POST":
        email = request.POST.get("email")
        senha = request.POST.get("senha")

        try:
            cliente = models.Clientes.objects.get(email_clientes=email)
        except models.Clientes.DoesNotExist:
            messages.error(request, "Cliente não encontrado!")
            return render(request, "app_futebol/login.html")

        if check_password(senha, cliente.senha_clientes):
            login_cliente(request, cliente)
            return redirect("home")
        else:
            messages.error(request, "Senha incorreta!")
            return render(request, "app_futebol/login.html")

    return render(request, "app_futebol/login.html")


def logout_view(request):
    request.session.flush()
    return redirect("home")


def tela_loja_detalhe(request, produto_id):    
    try:
        produto = models.Produtos.objects.get(id_produtos=produto_id)
    except models.Produtos.DoesNotExist:
        return redirect('produtos') 
    
    cliente = get_cliente_logado(request) # Pega as info do cliente logado
    
    context = {
        "produto": produto,
        **(cliente or {}) # Inclui as informações do cliente logado
    }
    
    return render(request, "app_futebol/loja_detalhe.html", context)


def tela_loja_produtos(request):
    todas_categorias = models.CategoriaProdutos.objects.all() # Armazena todas as categorias
    produtos_por_categoria = {} # Dicionário para armazenar produtos por categoria
    
    for categoria in todas_categorias: # Vai andar por cada categoria
        produtos_por_categoria[categoria] = models.Produtos.objects.filter( # Adiciona os produtos daquela categoria ao dicionário
            categoria_produtos_id_categoria_produtos=categoria # Usa a chave estrangeira da tabela Produtos que está ligada a CategoriaProdutos
        )
    
    cliente = get_cliente_logado(request) # Pega as info do cliente logado
    return render(request, "app_futebol/loja_produtos.html", { # renderiza a página da loja
        "produtos_por_categoria": produtos_por_categoria, # adiciona os produtos por categoria da linha 303
        **(cliente or {}) # inclui as informações do cliente logado e se não tiver ninguém logado, passa um dicionário vazio
    })


def tela_noticias(request):
    return render(request, "app_futebol/noticias.html")


def tela_rec_senha(request):
    if request.method == "POST":
        email = request.POST.get("email")

        try:
            cliente = models.Clientes.objects.get(email_clientes=email) # compara o email digitado com email do banco de dados
        except models.Clientes.DoesNotExist:
            messages.error(request, "Email não encontrado!")
            return redirect("recuperar_senha")

        codigo = str(random.randint(100000, 999999)) # gera um código aleatório de 6 dígitos

        models.RecuperacaoSenha.objects.create( # Adiciona aleatório ao banco de dados
            cliente=cliente,
            codigo=codigo,
        )

        try:
            send_mail( 
                "Código de recuperação de senha", # titulo
                f"Seu código: {codigo}", # conteudo
                os.environ.get("EMAIL_HOST_USER"), # email que envia a mensagem
                [email], # email(s) que recebe(m) a mensagem
                fail_silently=False,
            )
        except Exception as e:
            print(f"Erro ao enviar email: {e}")
            messages.error(request, f"Erro ao enviar email: {str(e)}")
            return redirect("recuperar_senha")

        request.session["recuperacao_email"] = email
        messages.success(request, "Código enviado ao seu email!")
        return redirect("recuperar_senha2")
    return render(request, "app_futebol/rec_senha.html")



def tela_rec_senha_2(request):
    if request.method == "POST":
        codigo_digitado = request.POST.get("codigo")
        email = request.session.get("recuperacao_email")

        if not email:
            messages.error(request, "Sessão expirada, tente novamente.")
            return redirect("recuperar_senha")

        try:
            cliente = models.Clientes.objects.get(email_clientes=email)
            recuperacao = models.RecuperacaoSenha.objects.filter(cliente=cliente).latest("criado_em")
        except:
            messages.error(request, "Código inválido!")
            return redirect("recuperar_senha2")

        if recuperacao.expirado():
            messages.error(request, "Código expirado! Tente novamente.")
            return redirect("recuperar_senha")

        if recuperacao.codigo != codigo_digitado:
            messages.error(request, "Código incorreto!")
            return redirect("recuperar_senha2")

        request.session["codigo_validado"] = True
        return redirect("recuperar_senha3")

    return render(request, "app_futebol/rec_senha_2.html")


def tela_rec_senha_3(request):
    if not request.session.get("codigo_validado"):
        return redirect("recuperar_senha")

    if request.method == "POST":
        nova_senha = request.POST.get("senha")

        email = request.session.get("recuperacao_email")
        try:
            cliente = models.Clientes.objects.get(email_clientes=email)
            cliente.senha_clientes = make_password(nova_senha)
            cliente.save()

            # Limpa sessão
            request.session.pop("recuperacao_email", None)
            request.session.pop("codigo_validado", None)

            messages.success(request, "Senha alterada com sucesso!")
            return redirect("login")
        except models.Clientes.DoesNotExist:
            messages.error(request, "Cliente não encontrado!")
            return redirect("recuperar_senha")

    return render(request, "app_futebol/rec_senha3.html")


def tela_socio(request):
    planos = models.CategoriaCliente.objects.all()
    return render(request, "app_futebol/socio.html",{"planos":planos})


def tela_ingressos(request):
    ingresso = models.Produtos.objects.filter(categoria_produtos_id_categoria_produtos=10)
    return render(request, "app_futebol/Tela_ingresso.html", {
        "ingressos": ingresso
    })


def tela_historia(request):
    return render(request, "app_futebol/historia.html")


def pagamento_socio(request, plano_id):
    try:
        plano = models.CategoriaCliente.objects.get(id_categoria_cliente=plano_id)
    except models.CategoriaCliente.DoesNotExist:
        messages.error(request, "Plano não encontrado!")
        return redirect("tela_socio")
    
    cliente_id = request.session.get("cliente_id")
    if not cliente_id:
        return redirect("login")

    cliente = models.Clientes.objects.get(id_clientes=cliente_id)
    
    # Se o usuário confirmar o pagamento, atualiza o plano do cliente
    if request.method == "POST":
        # Aqui você poderia validar o pagamento com gateway real.
        cliente.categoria_cliente_id_categoria_cliente = plano
        cliente.save()

        # Atualiza sessão (armazenando id e nome)
        request.session["plano_socio_id"] = plano.id_categoria_cliente
        request.session["plano_socio_nome"] = plano.nome_categoria_clientes

        messages.success(request, "Parabéns! Agora você é sócio: %s" % plano.nome_categoria_clientes)
        return redirect("home")

    return render(request, "app_futebol/pagamento_socio.html", {
        "cliente": cliente,
        "plano": plano,
    })


def tela_proximo_jogo(request):
    return render(request, "app_futebol/proximos_jogos.html")

