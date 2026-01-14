import os
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.hashers import check_password, make_password
from django.contrib import messages
from django.shortcuts import render, redirect, get_object_or_404
from django.core.mail import send_mail
import random
from django.utils import timezone # timezone para pegar a data atual
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
    # Usa o nome do plano já armazenado na sessão (sem consulta ao banco)
    return {
        "id": request.session.get("cliente_id"),
        "nome": request.session.get("cliente_nome"),
        "sobrenome": request.session.get("cliente_sobrenome"),
        "email": request.session.get("cliente_email"),
        "telefone": request.session.get("cliente_telefone"),
        "endereco": request.session.get("cliente_endereco"),
        "cpf": request.session.get("cliente_cpf"),
        "plano_cliente": request.session.get('plano_socio_nome'),
    }

# -------------------------------
# Views
# -------------------------------

def tela_perfil(request):
    cliente_id = request.session.get("cliente_id")
    if not cliente_id:
        return redirect('login') 
    
    # 2. Busca o objeto do cliente no banco (necessário para salvar)
    try:
        cliente = models.Clientes.objects.get(id_clientes=cliente_id)
    except models.Clientes.DoesNotExist:
        messages.error(request, "Erro ao carregar dados do usuário.")
        return redirect('logout')

    # 3. Processamento do Formulário (POST)
    if request.method == "POST":
        # --- Atualiza Dados Pessoais ---
        cliente.nome_clientes = request.POST.get("nome")
        cliente.sobrenome_clientes = request.POST.get("sobrenome")
        cliente.email_clientes = request.POST.get("email")
        cliente.telefone_clientes = request.POST.get("telefone")
        
        cliente.save() # Salva na tabela Clientes

        # --- Atualiza ou Cria o Endereço ---
        # Tenta buscar o endereço, se não existir, cria um novo vinculado ao cliente
        endereco, created = models.EnderecoCliente.objects.get_or_create(
            cliente_id_cliente=cliente
        )
        
        endereco.rua_endereco_cliente = request.POST.get("rua")
        endereco.casa_endereco_cliente = request.POST.get("casa")
        endereco.bairro_endereco_cliente = request.POST.get("bairro")
        endereco.cep_endereco_cliente = request.POST.get("cep")
        endereco.complemento_endereco_cliente = request.POST.get("complemento")
        
        endereco.save() # Salva na tabela EnderecoCliente

        # --- Atualiza a Sessão ---
        # Isso é crucial para que o nome no topo do site mude sem precisar relogar
        request.session["cliente_nome"] = cliente.nome_clientes
        request.session["cliente_sobrenome"] = cliente.sobrenome_clientes
        request.session["cliente_email"] = cliente.email_clientes
        request.session["cliente_telefone"] = cliente.telefone_clientes
        
        # Atualiza o endereço na sessão
        request.session["cliente_endereco"] = {
            "id": endereco.id_endereco_cliente,
            "cep": endereco.cep_endereco_cliente,
            "rua": endereco.rua_endereco_cliente,
            "casa": endereco.casa_endereco_cliente,
            "bairro": endereco.bairro_endereco_cliente,
            "complemento": endereco.complemento_endereco_cliente
        }

        messages.success(request, "Perfil atualizado com sucesso!")
        return redirect("perfil") # Recarrega a página para mostrar os dados novos

    # 4. Renderização (GET)
    # Usa a função helper existente para pegar os dados formatados da sessão atualizada
    dados_cliente = get_cliente_logado(request)
    return render(request, "app_futebol/perfil.html", dados_cliente)


def home(request):
    cliente = get_cliente_logado(request)

    # Busca o próximo jogo (a partir de hoje) e inclui o time adversário via select_related
    jogo_destaque = models.Jogos.objects.filter(
        dia_jogo__gte=timezone.now().date()
    ).select_related('times_id_times').order_by('dia_jogo').first() # Select_related serve para otimizar a consulta e trazer os dados do time adversário junto de acordo com a chave estrangeira

    jogo = {
        "jogo_destaque": jogo_destaque}
    dados_cliente = cliente or {}
 

    return render(request, "app_futebol/index.html", {**jogo, **dados_cliente}) # ** serve para desempacotar os dicionários e passar os valores como argumentos separados


def tela_carrinho(request):
    cliente = get_cliente_logado(request)
    if not cliente:
        return redirect("login")
    
    carrinho = request.session.get("carrinho", {})
    
    # Busca todos os produtos de uma vez (otimização)
    if carrinho:
        produto_ids = list(carrinho.keys())
        produtos = {str(p.id_produtos): p for p in models.Produtos.objects.filter(id_produtos__in=produto_ids)}
    else:
        produtos = {}
    
    total = 0
    itens = []
    
    for produto_id, quantidade in carrinho.items():
        produto = produtos.get(produto_id)
        if produto:
            subtotal = produto.valor_produtos * quantidade
            total += subtotal
            itens.append({
                "produto": produto,
                "quantidade": quantidade,
                "subtotal": subtotal,
                "preco_linha": subtotal
            })

    # Calcula desconto baseado no plano da sessão
    desconto_percent = 0.0
    plano_nome = request.session.get('plano_socio_nome', '')
    
    if plano_nome:
        nome_lower = plano_nome.strip().lower()
        if nome_lower == 'socio drakos - diamante':
            desconto_percent = 0.20
        elif nome_lower == 'socio drakos - ouro':
            desconto_percent = 0.10
        elif nome_lower == 'socio drakos - prata':
            desconto_percent = 0.05

    desconto_valor = total * desconto_percent
    total_com_desconto = total - desconto_valor
    return render(request, "app_futebol/carrinho.html", {
        "itens": itens,
        "total": total,
        "desconto": desconto_valor,
        "desconto_percent": int(desconto_percent * 100),
        "total_com_desconto": total_com_desconto,
        "plano_cliente": plano_nome,
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

    # Busca todos os produtos de uma vez (otimização)
    if carrinho:
        produto_ids = [int(pid) for pid in carrinho.keys()]
        produtos = {str(p.id_produtos): p for p in models.Produtos.objects.filter(id_produtos__in=produto_ids)}
    else:
        produtos = {}

    # Recalcula totais e monta lista de itens
    total = 0.0
    itens = []
    for prod_id_str, qtd in carrinho.items():
        prod = produtos.get(prod_id_str)
        if not prod:
            continue
        subtotal = prod.valor_produtos * qtd
        total += subtotal
        itens.append({
            "id": prod.id_produtos,
            "nome": prod.nome_produtos,
            "preco_unit": prod.valor_produtos,
            "quantidade": qtd,
            "subtotal": subtotal
        })

    # Calcula desconto baseado no plano da sessão
    desconto_percent = 0.0
    plano_nome = request.session.get('plano_socio_nome', '')
    
    if plano_nome:
        nome_lower = plano_nome.strip().lower()
        if nome_lower == 'socio drakos - diamante':
            desconto_percent = 0.20
        elif nome_lower == 'socio drakos - ouro':
            desconto_percent = 0.10
        elif nome_lower == 'socio drakos - prata':
            desconto_percent = 0.05

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


def finalizar_compra(request):
    """
    Função para registrar uma compra ao finalizar o carrinho.
    Cria um pedido e registra todos os itens da compra.
    """
    # Verifica se o cliente está logado
    cliente_id = request.session.get("cliente_id")
    if not cliente_id:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "sucesso": False,
                "mensagem": "Você precisa estar logado para finalizar a compra."
            }, status=401)
        messages.error(request, "Você precisa estar logado para finalizar a compra!")
        return redirect("login")
    
    # Busca o cliente no banco de dados
    try:
        cliente = models.Clientes.objects.get(id_clientes=cliente_id)
    except models.Clientes.DoesNotExist:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "sucesso": False,
                "mensagem": "Cliente não encontrado!"
            }, status=404)
        messages.error(request, "Cliente não encontrado!")
        return redirect("login")
    
    # Obtém o carrinho da sessão
    carrinho = request.session.get("carrinho", {})
    
    # Verifica se o carrinho está vazio
    if not carrinho:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "sucesso": False,
                "mensagem": "Seu carrinho está vazio!"
            })
        messages.warning(request, "Seu carrinho está vazio!")
        return redirect("carrinho")
    
    # Busca todos os produtos de uma vez (otimização)
    produto_ids = [int(pid) for pid in carrinho.keys()]
    produtos_db = models.Produtos.objects.filter(id_produtos__in=produto_ids)
    produtos_dict = {p.id_produtos: p for p in produtos_db}
    
    # Valida os produtos e estoque
    itens_compra = []
    valor_total = 0
    
    for produto_id_str, quantidade in carrinho.items():
        produto = produtos_dict.get(int(produto_id_str))
        if not produto:
            continue
        
        # Verifica se há estoque suficiente
        if produto.quantidade_estoque_produtos < quantidade:
            if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                return JsonResponse({
                    "sucesso": False,
                    "mensagem": f"Estoque insuficiente para {produto.nome_produtos}. Disponível: {produto.quantidade_estoque_produtos}"
                })
            messages.error(request, f"Estoque insuficiente para {produto.nome_produtos}. Disponível: {produto.quantidade_estoque_produtos}")
            return redirect("carrinho")
        
        valor_item = produto.valor_produtos * quantidade
        valor_total += valor_item
        
        itens_compra.append({
            "produto": produto,
            "quantidade": quantidade,
            "valor_unitario": produto.valor_produtos,
            "valor_total": valor_item
        })
    
    # Verifica novamente se há itens válidos
    if not itens_compra:
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "sucesso": False,
                "mensagem": "Nenhum produto válido no carrinho!"
            })
        messages.error(request, "Nenhum produto válido no carrinho!")
        return redirect("carrinho")
    
    # Cria o pedido
    try:
        novo_pedido = models.Pedido(
            data_pedido=timezone.now(),
            clientes_id_clientes=cliente,
            funcionarios_id_funcionarios=None
        )
        novo_pedido.save()
        
        # Prepara listas para bulk operations
        compras_para_criar = []
        produtos_para_atualizar = []
        
        for item in itens_compra:
            produto = item["produto"]
            quantidade_comprada = item["quantidade"]
            valor_item = item["valor_total"]
            
            # Prepara o registro de compra
            compras_para_criar.append(models.Compra(
                produtos_id_produtos=produto,
                pedido_id_pedido=novo_pedido,
                quantidade_pedido=quantidade_comprada,
                valor_compra=valor_item
            ))
            
            # Atualiza o estoque do produto
            produto.quantidade_estoque_produtos -= quantidade_comprada
            produtos_para_atualizar.append(produto)
        
        # Salva tudo de uma vez (otimização)
        models.Compra.objects.bulk_create(compras_para_criar)
        models.Produtos.objects.bulk_update(produtos_para_atualizar, ['quantidade_estoque_produtos'])
        
        # Limpa o carrinho da sessão
        request.session["carrinho"] = {}
        request.session.modified = True
        
        # Retorna sucesso
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "sucesso": True,
                "mensagem": "Compra finalizada com sucesso!",
                "pedido_id": novo_pedido.id_pedido,
                "valor_total": float(valor_total),
                "data_pedido": novo_pedido.data_pedido.strftime("%d/%m/%Y %H:%M")
            })
        
        messages.success(request, f"Compra finalizada com sucesso! Pedido #{novo_pedido.id_pedido}")
        return redirect("home")
        
    except Exception as erro:
        # Em caso de erro, retorna mensagem de erro
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                "sucesso": False,
                "mensagem": f"Erro ao processar a compra: {str(erro)}"
            }, status=500)
        messages.error(request, f"Erro ao processar a compra: {str(erro)}")
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
    # Busca todos os produtos de uma vez
    todos_produtos = models.Produtos.objects.select_related('categoria_produtos_id_categoria_produtos').all()
    todas_categorias = models.CategoriaProdutos.objects.all()
    
    # Organiza produtos por categoria (em memória, sem queries extras)
    produtos_por_categoria = {categoria: [] for categoria in todas_categorias}
    for produto in todos_produtos:
        if produto.categoria_produtos_id_categoria_produtos in produtos_por_categoria:
            produtos_por_categoria[produto.categoria_produtos_id_categoria_produtos].append(produto)
    
    cliente = get_cliente_logado(request)
    return render(request, "app_futebol/loja_produtos.html", {
        "produtos_por_categoria": produtos_por_categoria,
        **(cliente or {})
    })


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
    ingresso = models.Produtos.objects.filter(categoria_produtos_id_categoria_produtos=10) # Filtra os ingressos pela categoria de id 10

    # Busca o jogo em destaque: próximo jogo a partir de hoje (qualquer casa/fora)
    jogos_qs = models.Jogos.objects.filter(
        dia_jogo__gte=timezone.now().date()
    ).select_related('times_id_times').order_by('dia_jogo')

    jogo_destaque = jogos_qs.first()

    # Busca os próximos 3 jogos excluindo o destaque (jogo 2,3 e 4)
    if jogo_destaque:
        proximos_jogos = jogos_qs.exclude(id_jogos=jogo_destaque.id_jogos)[:3]
    else:
        proximos_jogos = jogos_qs[:3]

    return render(request, "app_futebol/Tela_ingresso.html", {
        "ingressos": ingresso,
        "jogo_destaque": jogo_destaque,
        "proximos_jogos": proximos_jogos
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
