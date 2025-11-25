from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.auth import authenticate, login
from .models import Perfil
from django.contrib.auth.hashers import make_password, check_password # Isso aqui importa a ferramenta pra criar criptografia e ler criptografia
from app_futebol import models

# fique um tempao batendo cabeca com essa porra aqui, peguei algumas coisa do chat

# def register_user(request):
#     if request.method == 'POST':

#         username = request.POST.get('username')
#         email = request.POST.get('email')
#         password = request.POST.get('password')
#         sexo = request.POST.get('sexo')
#         cpf = request.POST.get('cpf')
#         telefone = request.POST.get('telefone')

#         # Verificando se o burro do usuário já existe
#         if User.objects.filter(username=username).exists():
#             messages.error(request, 'Usuário já existe!')
#             return redirect('register')

#         if User.objects.filter(email=email).exists():
#             messages.error(request, 'Email já está em uso!')
#             return redirect('register')

#         if Perfil.objects.filter(cpf=cpf).exists():
#             messages.error(request, 'CPF já está cadastrado!')
#             return redirect('register')

#         # Criando o burro do usuário
#         user = User.objects.create_user(
#             username=username,
#             email=email,
#             password=password
#         )

#         # adicionando os bagulho do perfil com os dados extras
#         Perfil.objects.create(
#             user=user,
#             sexo=sexo,
#             cpf=cpf,
#             telefone=telefone
#         )

#         messages.success(request, 'Conta criada com sucesso!')
#         return redirect('login')

#     return render(request, 'acconts/cadastro.html')
# -------------------- codigo pra estudar e aplicar ----------------------
def cadastro(request):
    if request.method == "POST":

        nome = request.POST.get("nome")
        sobrenome = request.POST.get("sobrenome")
        email = request.POST.get("email")
        telefone = request.POST.get("telefone")
        cpf = request.POST.get("cpf")
        senha = request.POST.get("senha")
        sexo = request.POST.get("sexo")
        categoria_cliente = 5

        # verificação de duplicidade
        if models.Clientes.objects.filter(email_clientes=email).exists():
            messages.error(request, "Esse email já está cadastrado.")
            return render(request, "acconts/cadastro.html")

        if models.Clientes.objects.filter(cpf_clientes=cpf).exists():
            messages.error(request, "Esse CPF já está cadastrado.")
            return render(request, "acconts/cadastro.html")

        cliente = models.Clientes(
            nome_clientes=nome,
            sobrenome_clientes=sobrenome,
            email_clientes=email,
            cpf_clientes=cpf,
            telefone_clientes=telefone,
            sexo_clientes=sexo,
            status_clientes=1,
            categoria_cliente_id_categoria_cliente_id=categoria_cliente,  # exemplo
            senha_clientes=make_password(senha),  # Isso aqui criptografa a senha
        )
        cliente.save()

        messages.success(request, "Cadastro realizado com sucesso!")
        return redirect("login")

    return render(request, "acconts/cadastro.html")
