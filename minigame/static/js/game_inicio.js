const startText = document.getElementById("startText");
const coinImg = document.getElementById("coinImg");
const video = document.getElementById("coinVideo");
const clickSound = document.getElementById("clickSound");
const cadastroScreen = document.getElementById("cadastroScreen");
const nomeInput = document.getElementById("nome");
const sobrenomeInput = document.getElementById("sobrenome");
const formSound = document.getElementById("formSound");
const btn = document.getElementById("btnCadastrar");
const transitionScreen = document.getElementById("transitionScreen");
const transitionText = document.getElementById("transitionText");

let started = false;

// 🎯 CLIQUE INICIAL
startText.addEventListener("click", () => {
    if (started) return;
    started = true;

        // 📳 vibração
    if (navigator.vibrate) {
        navigator.vibrate(80);
    }


    clickSound.play();

    startText.style.opacity = "0";

    coinImg.style.transition = "opacity 0.4s ease";
    video.style.transition = "opacity 0.4s ease";

    video.style.display = "block";
    video.offsetHeight;

    coinImg.style.opacity = "0";
    video.style.opacity = "1";

    video.play();
});

// 🎬 FINAL DO VÍDEO (ÚNICO)
video.addEventListener("ended", () => {
    video.style.transform = "scale(1.5)";
    video.style.opacity = "0";

    setTimeout(() => {
        cadastroScreen.style.opacity = "1";
        cadastroScreen.style.pointerEvents = "all";
        cadastroScreen.classList.add("active");

        formSound.play();

        setTimeout(() => {
            nomeInput.focus();

            typeEffect(nomeInput, "Digite seu nome...");
            typeEffect(sobrenomeInput, "Digite seu sobrenome...");
        }, 400);

    }, 600);
});

// ✨ DIGITAÇÃO
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

// 🚫 BLOQUEIA CLIQUE NA IMG
coinImg.addEventListener("click", (e) => {
    e.stopPropagation();
});


btn.addEventListener("click", () => {
    const nome = nomeInput.value.trim();
    const sobrenome = sobrenomeInput.value.trim();

    // validação simples
    if (!nome || !sobrenome) {
        btn.classList.add("error");

        setTimeout(() => {
            btn.classList.remove("error");
        }, 400);

        return;
    }

    // ativa loading
    btn.classList.add("loading");

    // simula processamento
    setTimeout(() => {
        transitionScreen.classList.add("active");

        typeEffectText(
            transitionText,
            `BEM-VINDO, ${nome.toUpperCase()}...`,
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
            window.location.href = "/game/menu_game/";
        }, 3000);

    }, 1200);
});


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