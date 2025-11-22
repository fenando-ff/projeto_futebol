from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.auth import authenticate, login
from .models import Perfil


# fique um tempao batendo cabeca com essa porra aqui, peguei algumas coisa do chat

def register_user(request):
    if request.method == 'POST':

        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')
        sexo = request.POST.get('sexo')
        cpf = request.POST.get('cpf')
        telefone = request.POST.get('telefone')

        # Verificando se o burro do usuário já existe
        if User.objects.filter(username=username).exists():
            messages.error(request, 'Usuário já existe!')
            return redirect('register')

        if User.objects.filter(email=email).exists():
            messages.error(request, 'Email já está em uso!')
            return redirect('register')

        if Perfil.objects.filter(cpf=cpf).exists():
            messages.error(request, 'CPF já está cadastrado!')
            return redirect('register')

        # Criando o burro do usuário
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password
        )

        # adicionando os bagulho do perfil com os dados extras
        Perfil.objects.create(
            user=user,
            sexo=sexo,
            cpf=cpf,
            telefone=telefone
        )

        messages.success(request, 'Conta criada com sucesso!')
        return redirect('login')

    return render(request, 'accounts/register.html')
