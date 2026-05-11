const startText = document.getElementById("startText");
const coinImg = document.getElementById("coinImg");
const video = document.getElementById("coinVideo");
const cadastroScreen = document.getElementById("cadastroScreen");
const nomeInput = document.getElementById("nome");
const form = document.getElementById("cadastroForm");
const btn = document.getElementById("btnCadastrar");
const transitionScreen = document.getElementById("transitionScreen");
const transitionText = document.getElementById("transitionText");
const errorMsg = document.getElementById("errorMsg");
const senhaInput = document.getElementById("senha");
const confirmarSenhaInput = document.getElementById("confirmarSenha");
const toggleMode = document.getElementById("toggleMode");
const formTitle = document.getElementById("formTitle");

let modoCadastro = false;
let started = false;

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

function showError(message) {
    errorMsg.textContent = message;
    errorMsg.style.display = 'block';
    btn.classList.add('error');
    setTimeout(() => {
        btn.classList.remove('error');
    }, 400);
}

function hideError() {
    errorMsg.textContent = '';
    errorMsg.style.display = 'none';
}

function typeEffect(input, text, speed = 60) {
    let i = 0;
    input.placeholder = "";

    function typing() {
        if (i < text.length) {
            input.placeholder += text.charAt(i);
            i++;
            setTimeout(typing, speed);
        }
    }

    typing();
}

function typeEffectText(element, text, speed = 50) {
    element.innerHTML = "";
    let i = 0;

    function typing() {
        if (i < text.length) {
            element.innerHTML += text.charAt(i);
            i++;
            setTimeout(typing, speed);
        }
    }

    typing();
}

toggleMode.addEventListener("click", () => {
    modoCadastro = !modoCadastro;

    if (modoCadastro) {
        formTitle.innerText = "Cadastro";
        toggleMode.innerText = "Já tenho conta";
        confirmarSenhaInput.classList.remove("hidden-field");
        typeEffect(nomeInput, "Insira seu nome");
        confirmarSenhaInput.focus();
    } else {
        formTitle.innerText = "Login";
        toggleMode.innerText = "Criar conta";
        confirmarSenhaInput.classList.add("hidden-field");
        confirmarSenhaInput.value = "";
        typeEffect(nomeInput, "Nome ou ID do jogador");
    }

    nomeInput.focus();
    hideError();
});

nomeInput.addEventListener('input', hideError);
senhaInput.addEventListener('input', hideError);
confirmarSenhaInput.addEventListener('input', hideError);

startText.addEventListener("click", () => {
    if (started) return;
    started = true;

    if (navigator.vibrate) {
        navigator.vibrate(80);
    }

    startText.style.opacity = "0";

    coinImg.style.transition = "opacity 0.4s ease";
    video.style.transition = "opacity 0.4s ease";

    video.style.display = "block";
    video.offsetHeight;

    coinImg.style.opacity = "0";
    video.style.opacity = "1";

    video.play();
});

video.addEventListener("ended", () => {
    video.style.transform = "scale(1.5)";
    video.style.opacity = "0";

    setTimeout(() => {
        cadastroScreen.style.opacity = "1";
        cadastroScreen.style.pointerEvents = "all";
        cadastroScreen.classList.add("active");

        setTimeout(() => {
            nomeInput.focus();
            typeEffect(nomeInput, "Nome ou ID do jogador");
        }, 400);

    }, 600);
});

coinImg.addEventListener("click", (e) => {
    e.stopPropagation();
});

btn.addEventListener("click", async (e) => {
    e.preventDefault();

    const nome = nomeInput.value.trim();
    const senha = senhaInput.value.trim();
    const confirmarSenha = confirmarSenhaInput.value.trim();

    if (!nome) {
        showError("Digite seu nome.");
        return;
    }

    if (!senha) {
        showError("Digite sua senha.");
        return;
    }

    if (modoCadastro && !confirmarSenha) {
        showError("Confirme sua senha.");
        return;
    }

    if (modoCadastro && senha !== confirmarSenha) {
        showError("As senhas não coincidem.");
        return;
    }

    hideError();
    btn.classList.add("loading");

    try {
        const response = await fetch("", {
            method: "POST",
            headers: {
                "X-CSRFToken": getCookie("csrftoken"),
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: new URLSearchParams({
                nome: nome,
                senha: senha,
                modo: modoCadastro ? "cadastro" : "login"
            })
        });

        const data = await response.json();

        if (!response.ok) {
            showError(data.error);
            btn.classList.remove("loading");
        } else {
            transitionScreen.classList.add("active");
            typeEffectText(
                transitionText,
                `BEM-VINDO, ${data.nome_gerado.toUpperCase()}...`,
                40
            );

            setTimeout(() => {
                typeEffectText(
                    transitionText,
                    "PREPARE-SE...",
                    40
                );
            }, 1500);

            setTimeout(() => {
                window.location.href = data.redirect;
            }, 2500);
        }

    } catch (error) {
        showError("Erro na requisição. Tente novamente.");
        btn.classList.remove("loading");
    }
});
