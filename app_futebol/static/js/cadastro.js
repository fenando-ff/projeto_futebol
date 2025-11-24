
function proximaEtapa(numero) {
    document.querySelectorAll('.etapa_cadastro').forEach((el, idx) => {
        el.style.display = (idx + 1 === numero) ? 'block' : 'none';
    });
}

// Validação básica antes do envio
function validarCadastro() {
    const nome = document.getElementById('nome').value.trim();
    const email = document.getElementById('email').value.trim();
    const cpf = document.getElementById('cpf').value.trim();
    const senha = document.getElementById('senha').value;
    const confirmSenha = document.getElementById('confirmSenha').value;

    if(!nome || !email || !cpf || !senha || !confirmSenha) {
        alert('Por favor, preencha todos os campos obrigatórios.');
        return;
    }

    if(senha !== confirmSenha) {
        alert('As senhas não coincidem.');
        return;
    }

    // Validação simples de CPF (formato XXX.XXX.XXX-XX)
    const cpfRegex = /^\d{3}\.\d{3}\.\d{3}-\d{2}$/;
    if(!cpfRegex.test(cpf)) {
        alert('CPF inválido.');
        return;
    }

    alert('Cadastro realizado com sucesso!');
    // Aqui você pode enviar o formulário via AJAX ou redirecionar

}


// pega os elementos
const caixaMasculina = document.getElementById("caixa_m");
const caixaFeminina = document.getElementById("caixa_f");
const checkbox = document.getElementById("check");
const caixinhas = document.querySelectorAll(".caixinha");

// função para selecionar sexo
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

// quando marca "prefiro não informar"
checkbox.addEventListener("change", () => {
    if (checkbox.checked) {
        caixinhas.forEach(i => i.classList.remove("active"));
    }
});

// iniciar função
marcarSexo();



// "" = vazio
// " " = contem espaço


