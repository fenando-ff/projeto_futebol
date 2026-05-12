let atual = 0;
let pontuacao = 0;
let respostas = [];
let acertos = 0;
let comboAtual = 0;
let comboMaximo = 0;

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

        acertos++;

        comboAtual++;

        mostrarCombo(comboAtual);

        if (comboAtual > comboMaximo) {
            comboMaximo = comboAtual;
        }

    } else {

        comboAtual = 0;

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




function mostrarCombo(combo) {

    const popup = document.getElementById("comboPopup");

    let texto = "";

    if (combo >= 5) {

        texto = "🔥 LENDÁRIO";

    } else if (combo >= 4) {

        texto = "⚡ MONSTRO";

    } else if (combo >= 3) {

        texto = "💀 MITANDO";

    } else if (combo >= 2) {

        texto = "🏆 BOA!";
    }

    if (!texto) return;

    popup.innerText = `${texto} x${combo}`;

    popup.classList.add("show");


    if (combo >= 5) {

    document.body.classList.add("combo-glow");

    document.body.classList.add("shake-screen");

    criarParticulasDouradas();

    setTimeout(() => {

        document.body.classList.remove("combo-glow");

        document.body.classList.remove("shake-screen");

    }, 500);
}


    setTimeout(() => {
        popup.classList.remove("show");
    }, 700);
}



function criarParticulasDouradas() {

    for (let i = 0; i < 25; i++) {

        const p = document.createElement("div");

        p.classList.add("gold-particle");

        p.style.left = window.innerWidth / 2 + "px";

        p.style.top = window.innerHeight / 2 + "px";

        p.style.setProperty(
            "--x",
            `${(Math.random() - .5) * 500}px`
        );

        p.style.setProperty(
            "--y",
            `${(Math.random() - .5) * 500}px`
        );

        document.body.appendChild(p);

        setTimeout(() => {
            p.remove();
        }, 1000);
    }
}



// 🏁 final
function finalizarQuiz() {

    clearInterval(intervaloTimer);

    progress.style.width = "100%";

    const tempoFinal = Date.now() - tempoInicial;

    const totalSegundos = Math.floor(tempoFinal / 1000);

    const minutos = Math.floor(totalSegundos / 60);

    const segundos = totalSegundos % 60;

    const tempoFormatado =
        `${String(minutos).padStart(2, "0")}:${String(segundos).padStart(2, "0")}`;

    const precisao =
        Math.round((acertos / perguntas.length) * 100);

    // 🏆 títulos
    let titulo = "Bagre da Série B";

    if (pontuacao >= 20) {

        titulo = "Pelé do Quiz";

    } else if (pontuacao >= 15) {

        titulo = "Rei da Libertadores";

    } else if (pontuacao >= 10) {

        titulo = "Artilheiro do Brasileirão";

    } else if (pontuacao >= 5) {

        titulo = "Craque da Série A";
    }










    perguntaEl.innerText = "Quiz Finalizado";
    opcoesEl.innerHTML = `

    <div class="resultado-box fade">

        <div class="resultado-titulo">
            🏆 ${titulo}
        </div>

        <div class="resultado-stats">

            <div class="resultado-item">
                🎯 Precisão:
                <span>${precisao}%</span>
            </div>

            <div class="resultado-item">
                ⚡ Tempo:
                <span>${tempoFormatado}</span>
            </div>

            <div class="resultado-item">
                🔥 Combo Máximo:
                <span>x${comboMaximo}</span>
            </div>

            <div class="resultado-item">
                ⭐ Pontuação:
                <span>${pontuacao}</span>
            </div>

        </div>

       <div id="titulosBox" class="titulos-box">

            <h4>🏆 TÍTULOS DESBLOQUEÁVEIS</h4>

            <div class="titulos-grid">

                <div id="titulo0" class="titulo-badge">
                    ⚪ Bagre da Série B
                </div>

                <div id="titulo5" class="titulo-badge">
                    🟢 Craque Série A
                </div>

                <div id="titulo10" class="titulo-badge">
                    🔵 Artilheiro BR
                </div>

                <div id="titulo15" class="titulo-badge">
                    🟣 Rei da Libertadores
                </div>

                <div id="titulo20" class="titulo-badge">
                    🟡 Pelé do Quiz
                </div>

            </div>

        </div>

        <a href="/game/menu_game/" class="btn-menu">
            VOLTAR AO MENU
        </a>

    </div>

`;

// 🏆 desbloquear títulos

document.getElementById("titulo0")
    .classList.add("ativo");

if (pontuacao >= 5) {

    document.getElementById("titulo5")
        .classList.add("ativo");
}

if (pontuacao >= 10) {

    document.getElementById("titulo10")
        .classList.add("ativo");
}

if (pontuacao >= 15) {

    document.getElementById("titulo15")
        .classList.add("ativo");
}

if (pontuacao >= 20) {

    document.getElementById("titulo20")
        .classList.add("ativo", "especial");
}









    fetch("/game/salvar_pontuacao/", {

        method: "POST",

        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": getCSRFToken()
        },

        body: JSON.stringify({
            pontuacao: pontuacao,
            respostas: respostas,
            tempo_ms: tempoFinal,
            combo_maximo: comboMaximo
        })

    })
    .then(res => res.json())
    .then(data => {
        console.log("Dados salvos!", data);
    })
    .catch(err => console.error("Erro:", err));

    
    // tabela de títulos

}

// 🚀 START
iniciarIntro();