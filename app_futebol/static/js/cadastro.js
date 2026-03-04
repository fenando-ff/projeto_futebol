
function proximaEtapa(numero) {
    // Validação antes de avançar
    if (numero === 2) {
        const nome = document.getElementById('nome').value.trim();
        const sobrenome = document.querySelector('input[name="sobrenome"]').value.trim();
        const sexoSelecionado = document.querySelector('input[name="sexo"]:checked');
        const prefiroNaoInformar = document.getElementById('check').checked;

        if (!nome) {
            alert('Por favor, informe seu nome.');
            return false;
        }
        if (!sobrenome) {
            alert('Por favor, informe seu sobrenome.');
            return false;
        }
        if (!sexoSelecionado && !prefiroNaoInformar) {
            alert('Por favor, selecione seu sexo ou marque "Prefiro não informar".');
            return false;
        }
    }

    if (numero === 3) {
        const email = document.getElementById('email').value.trim();
        const telefone = document.getElementById('telefone').value.trim();
        const cpf = document.getElementById('cpf').value.trim();

        if (!email) {
            alert('Por favor, informe seu email.');
            return false;
        }
        if (!email.includes('@')) {
            alert('Por favor, informe um email válido.');
            return false;
        }
        if (!cpf) {
            alert('Por favor, informe seu CPF.');
            return false;
        }
        if (cpf.replace(/\D/g, '').length < 11) {
            alert('CPF deve ter pelo menos 11 dígitos.');
            return false;
        }
    }

    if (numero === 4) {
        const senha = document.getElementById('senha').value;
        const confirmSenha = document.getElementById('confirmSenha').value;

        if (!senha) {
            alert('Por favor, crie uma senha.');
            return false;
        }
        if (senha.length < 6) {
            alert('Senha deve ter pelo menos 6 caracteres.');
            return false;
        }
        if (!confirmSenha) {
            alert('Por favor, confirme sua senha.');
            return false;
        }
        if (senha !== confirmSenha) {
            alert('As senhas não coincidem.');
            return false;
        }
    }

    document.querySelectorAll('.etapa_cadastro').forEach((el, idx) => {
        el.style.display = (idx + 1 === numero) ? 'block' : 'none';
    });
    return false;
}

// Validação e envio do formulário
function validarCadastro() {
    const nome = document.getElementById('nome').value.trim();
    const sobrenome = document.querySelector('input[name="sobrenome"]').value.trim();
    const email = document.getElementById('email').value.trim();
    const cpf = document.getElementById('cpf').value.trim();
    const senha = document.getElementById('senha').value;
    const confirmSenha = document.getElementById('confirmSenha').value;

    console.log("DEBUG: Validando cadastro");
    console.log("Nome:", nome);
    console.log("Email:", email);
    console.log("CPF:", cpf);
    console.log("Senha:", senha.length > 0 ? "***" : "vazio");

    // Validações finais
    if (!nome || !sobrenome || !email || !cpf || !senha || !confirmSenha) {
        alert('Por favor, preencha todos os campos obrigatórios.');
        console.error("Erro: Campos obrigatórios faltando");
        return false;
    }

    if (senha !== confirmSenha) {
        alert('As senhas não coincidem.');
        return false;
    }

    if (!email.includes('@')) {
        alert('Email inválido.');
        return false;
    }

    if (cpf.replace(/\D/g, '').length < 11) {
        alert('CPF inválido.');
        return false;
    }

    // Se passou em todas as validações, envia o formulário
    console.log("DEBUG: Enviando formulário...");
    const form = document.querySelector('form');
    if (form) {
        console.log("Form encontrado, submitting...");
        form.submit();
    } else {
        console.error("ERROR: Form não encontrado!");
    }
    return false;
}


// Elementos do sexo
const caixaMasculina = document.getElementById("caixa_m");
const caixaFeminina = document.getElementById("caixa_f");
const checkbox = document.getElementById("check");
const caixinhas = document.querySelectorAll(".caixinha");

// Função para selecionar sexo
function marcarSexo() {
    caixinhas.forEach(icone => {
        icone.addEventListener("click", () => {
            // desmarca o checkbox se estiver marcado
            if (checkbox.checked) {
                checkbox.checked = false;
            }

            // ativa somente quem foi clicado
            caixinhas.forEach(i => i.classList.remove("active"));
            icone.classList.add("active");
        });
    });
}

// Quando marca "prefiro não informar"
checkbox.addEventListener("change", () => {
    if (checkbox.checked) {
        caixinhas.forEach(i => i.classList.remove("active"));
    }
});

// Iniciar função
marcarSexo();

