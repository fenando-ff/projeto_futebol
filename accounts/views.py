from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.auth import authenticate, login
from .models import Perfil
from django.contrib.auth.hashers import make_password, check_password # Isso aqui importa a ferramenta pra criar criptografia e ler criptografia
from app_futebol.models import models
import re
from django.core.validators import validate_email
from django.core.exceptions import ValidationError

# -------------------- codigo pra estudar e aplicar ----------------------
def cadastro(request):
    if request.method == "POST":

        # =========================
        # DADOS DO CLIENTE
        # =========================
        nome = request.POST.get("nome", "").strip()
        sobrenome = request.POST.get("sobrenome", "").strip()
        email = request.POST.get("email", "").strip().lower()
        telefone = request.POST.get("telefone", "").strip()
        cpf = re.sub(r"\D", "", request.POST.get("cpf", ""))
        senha = request.POST.get("senha", "")
        sexo = request.POST.get("sexo")

        # =========================
        # DADOS DO ENDEREÇO
        # =========================
        rua = request.POST.get("rua", "").strip()
        casa_numero = request.POST.get("casa_numero", "").strip()
        bairro = request.POST.get("bairro", "").strip()
        cep = re.sub(r"\D", "", request.POST.get("cep", ""))
        complemento = request.POST.get("complemento", "").strip()

        # =========================
        # VALIDAÇÕES
        # =========================

        if not nome or not sobrenome:
            messages.error(request, "Nome e sobrenome são obrigatórios.")

        elif not sexo:
            messages.error(request, "Selecione seu sexo.")

        else:
            # Validação de email profissional
            try:
                validate_email(email)
            except ValidationError:
                messages.error(request, "Informe um email válido.")
                return render(request, "acconts/cadastro.html")

            # CPF
            if len(cpf) != 11:
                messages.error(request, "CPF deve conter 11 números.")
            
            # Senha
            elif len(senha) < 6:
                messages.error(request, "A senha deve ter no mínimo 6 caracteres.")
            
            # Verificação duplicidade
            elif models.Clientes.objects.filter(email_clientes=email).exists():
                messages.error(request, "Este email já está cadastrado.")
                return render(request, "acconts/cadastro.html")
            
            elif models.Clientes.objects.filter(cpf_clientes=cpf).exists():
                messages.error(request, "Este CPF já está cadastrado.")

            else:
                try:
                    categoria = models.CategoriaCliente.objects.filter(
                        id_categoria_cliente=5
                    ).first()

                    if not categoria:
                        categoria = models.CategoriaCliente.objects.first()

                    if not categoria:
                        messages.error(request, "Erro ao registrar categoria.")
                        return render(request, "acconts/cadastro.html")

                    # =========================
                    # CRIAR CLIENTE
                    # =========================
                    cliente = models.Clientes.objects.create(
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

                    # =========================
                    # CRIAR ENDEREÇO (OPCIONAL)
                    # =========================
                    if rua and casa_numero and bairro and cep:
                        models.EnderecoCliente.objects.create(
                            cliente_id_cliente=cliente,
                            rua_endereco_cliente=rua,
                            casa_endereco_cliente=casa_numero,
                            bairro_endereco_cliente=bairro,
                            cep_endereco_cliente=cep,
                            complemento_endereco_cliente=complemento or "",
                        )

                    messages.success(request, "Cadastro realizado com sucesso!")
                    return redirect("login")

                except Exception as e:
                    messages.error(request, f"Erro ao cadastrar: {str(e)}")

        return render(request, "acconts/cadastro.html")

    return render(request, "acconts/cadastro.html")
