let atual = 0;
let pontuacao = 0;
let respostas = [];

const perguntaEl = document.getElementById("pergunta");
const opcoesEl = document.getElementById("opcoes");
const progress = document.getElementById("progress");
const timerEl = document.getElementById("quizTimer");

let tempoInicial = null;
let intervaloTimer = null;

// 🔥 ESCONDE QUIZ NO INÍCIO
document.querySelector(".quiz-container").style.visibility = "hidden";

function getCSRFToken() {
    return document.cookie
        .split('; ')
        .find(row => row.startsWith('csrftoken'))
        ?.split('=')[1];
}

// 🚀 INTRO
function iniciarIntro() {

    const overlay = document.getElementById("introOverlay");
    const number = document.getElementById("introNumber");

    const sequencia = ["3", "2", "1", "GO"];

    let index = 0;

    const troca = setInterval(() => {

        index++;

        if (index < sequencia.length) {

            number.innerText = sequencia[index];

        } else {

            clearInterval(troca);

            overlay.style.display = "none";

            document.querySelector(".quiz-container").style.visibility = "visible";

            iniciarQuiz();
        }

    }, 1000);
}

// 🚀 INICIA QUIZ
function iniciarQuiz() {

    tempoInicial = Date.now();

    intervaloTimer = setInterval(atualizarTimer, 1000);

    carregarPergunta();
}

// 🔥 carregar pergunta
function carregarPergunta() {

    const q = perguntas[atual];

    perguntaEl.classList.remove("fade");
    opcoesEl.classList.remove("fade");

    void perguntaEl.offsetWidth;

    perguntaEl.innerText = q.pergunta;

    perguntaEl.classList.add("fade");

    opcoesEl.innerHTML = "";

    opcoesEl.classList.add("fade");

    q.opcoes.forEach(op => {

        const btn = document.createElement("div");

        btn.classList.add("opcao");

        btn.innerText = op.texto;

        btn.onclick = () => responder(btn, op, q);

        opcoesEl.appendChild(btn);
    });

    atualizarBarra();
}

// 🎯 responder
function responder(btn, op, q) {

    const botoes = document.querySelectorAll(".opcao");

    botoes.forEach(b => b.style.pointerEvents = "none");

    respostas.push({
        questao_id: q.id,
        alternativa_id: op.id
    });

    if (op.correta) {

        btn.classList.add("correta");

        pontuacao += op.ponto || 0;

    } else {

        btn.classList.add("errada");

        document.body.classList.add("error-flash");

        setTimeout(() => {
            document.body.classList.remove("error-flash");
        }, 200);

        const correta = q.opcoes.find(o => o.correta);

        botoes.forEach(b => {

            if (b.innerText === correta.texto) {
                b.classList.add("correta");
            }

        });
    }

    setTimeout(() => {

        atual++;

        if (atual < perguntas.length) {

            carregarPergunta();

        } else {

            finalizarQuiz();
        }

    }, 1200);
}

// 📊 progresso
function atualizarBarra() {

    const pct = (atual / perguntas.length) * 100;

    progress.style.width = pct + "%";
}

// ⏱ timer
function atualizarTimer() {

    if (!tempoInicial) return;

    const agora = Date.now();

    const diff = agora - tempoInicial;

    const segundos = Math.floor(diff / 1000);

    const minutos = Math.floor(segundos / 60);

    const segRestantes = segundos % 60;

    timerEl.innerText =
        `${String(minutos).padStart(2, "0")}:${String(segRestantes).padStart(2, "0")}`;
}

// 🏁 final
function finalizarQuiz() {

    clearInterval(intervaloTimer);

    perguntaEl.innerText = "QUIZ FINALIZADO";

    opcoesEl.innerHTML = `
        <div class="resultado-box fade">

            <h3>SUA PONTUAÇÃO</h3>

            <p class="resultado-pontos">
                ${pontuacao} pontos
            </p>

            <a href="/game/menu_game/" class="btn-menu">
                VOLTAR AO MENU
            </a>

        </div>
    `;

    progress.style.width = "100%";

    const tempoFinal = Date.now() - tempoInicial;

    fetch("/game/salvar_pontuacao/", {

        method: "POST",

        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": getCSRFToken()
        },

        body: JSON.stringify({
            pontuacao: pontuacao,
            respostas: respostas,
            tempo_ms: tempoFinal
        })

    })
    .then(res => res.json())
    .then(data => {
        console.log("Dados salvos!", data);
    })
    .catch(err => console.error("Erro:", err));
}

// 🚀 START
iniciarIntro();