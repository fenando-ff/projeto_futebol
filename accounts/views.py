from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.auth import authenticate, login
from .models import Perfil
from django.contrib.auth.hashers import make_password, check_password # Isso aqui importa a ferramenta pra criar criptografia e ler criptografia
from app_futebol import models

# -------------------- codigo pra estudar e aplicar ----------------------
def cadastro(request):
    if request.method == "POST":
        print("=" * 50)
        print("DEBUG: Formulário POST recebido")
        print(f"Dados POST: {request.POST}")
        print("=" * 50)
        
        # Dados do cliente
        nome = request.POST.get("nome", "").strip()
        sobrenome = request.POST.get("sobrenome", "").strip()
        email = request.POST.get("email", "").strip().lower()
        telefone = request.POST.get("telefone", "").strip()
        cpf = request.POST.get("cpf", "").strip()
        senha = request.POST.get("senha", "")
        sexo = request.POST.get("sexo", "Não informado")
        
        # Dados do endereço
        rua = request.POST.get("rua", "").strip()
        casa_numero = request.POST.get("casa_numero", "").strip()
        bairro = request.POST.get("bairro", "").strip()
        cep = request.POST.get("cep", "").strip()
        complemento = request.POST.get("complemento", "").strip()
        
        print(f"Nome: {nome}, Email: {email}, CPF: {cpf}, Sexo: {sexo}")
        print(f"Endereço: {rua}, {casa_numero}, {bairro}, {cep}")
        
        # Categoria padrão para novo cliente (visitante/comum)
        categoria_cliente_id = 5  # Ajuste conforme sua tabela

        # ===== VALIDAÇÕES =====
        if not nome or not sobrenome:
            messages.error(request, "Nome e sobrenome são obrigatórios!")
            return render(request, "acconts/cadastro.html")

        if not email or "@" not in email:
            messages.error(request, "Email inválido!")
            return render(request, "acconts/cadastro.html")

        if not cpf or len(cpf) < 11:
            messages.error(request, "CPF deve ter pelo menos 11 dígitos!")
            return render(request, "acconts/cadastro.html")

        if not senha or len(senha) < 6:
            messages.error(request, "Senha deve ter pelo menos 6 caracteres!")
            return render(request, "acconts/cadastro.html")

        # verificação de duplicidade
        if models.Clientes.objects.filter(email_clientes=email).exists():
            messages.error(request, "Esse email já está cadastrado.")
            return render(request, "acconts/cadastro.html")

        if models.Clientes.objects.filter(cpf_clientes=cpf).exists():
            messages.error(request, "Esse CPF já está cadastrado.")
            return render(request, "acconts/cadastro.html")

        try:
            # Obtém a categoria padrão
            try:
                categoria = models.CategoriaCliente.objects.get(id_categoria_cliente=categoria_cliente_id)
            except models.CategoriaCliente.DoesNotExist:
                # Se não encontrar, pega a primeira categoria disponível
                categoria = models.CategoriaCliente.objects.first()
                if not categoria:
                    messages.error(request, "Erro ao registrar categoria do cliente.")
                    return render(request, "acconts/cadastro.html")

            print(f"Criando cliente com categoria: {categoria.nome_categoria_clientes}")
            
            # Cria o cliente
            cliente = models.Clientes(
                nome_clientes=nome,
                sobrenome_clientes=sobrenome,
                email_clientes=email,
                cpf_clientes=cpf,
                telefone_clientes=telefone,
                sexo_clientes=sexo,
                status_clientes=1,
                categoria_cliente_id_categoria_cliente=categoria,
                senha_clientes=make_password(senha),
            )
            cliente.save()
            print(f"Cliente criado com ID: {cliente.id_clientes}")

            # Cria o endereço (se fornecido)
            if rua and casa_numero and bairro and cep:
                endereco = models.EnderecoCliente(
                    cliente_id_cliente=cliente,
                    rua_endereco_cliente=rua,
                    casa_endereco_cliente=casa_numero,
                    bairro_endereco_cliente=bairro,
                    cep_endereco_cliente=cep,
                    complemento_endereco_cliente=complemento or "",
                )
                endereco.save()
                print(f"Endereço criado com ID: {endereco.id_endereco_cliente}")
                messages.success(request, "Cadastro realizado com sucesso! Endereço registrado.")
            else:
                messages.success(request, "Cadastro realizado! Complete seu endereço depois.")

            print("Redirecionando para login...")
            return redirect("login")

        except Exception as e:
            print(f"ERRO: {str(e)}")
            import traceback
            traceback.print_exc()
            messages.error(request, f"Erro ao cadastrar: {str(e)}")
            return render(request, "acconts/cadastro.html")

    return render(request, "acconts/cadastro.html")
