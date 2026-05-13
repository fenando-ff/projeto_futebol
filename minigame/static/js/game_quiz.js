let atual = 0;
let pontuacao = 0;
let respostas = [];
let quizAtivo = true; // Controla se o quiz ainda está ativo

const perguntaEl = document.getElementById("pergunta");
const opcoesEl = document.getElementById("opcoes");
const progress = document.getElementById("progress");
const timerEl = document.getElementById("quizTimer");
const quizContainer = document.querySelector(".quiz-container");

let tempoInicial = null;
let intervaloTimer = null;

// 🔥 ESCONDE QUIZ NO INÍCIO
if (quizContainer) {
    quizContainer.style.visibility = "hidden";
}

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
    
    if (!overlay || !number) {
        // Se não tem overlay, inicia direto
        if (quizContainer) quizContainer.style.visibility = "visible";
        iniciarQuiz();
        return;
    }

    const sequencia = ["3", "2", "1", "GO"];
    let index = 0;

    const troca = setInterval(() => {
        index++;

        if (index < sequencia.length) {
            number.innerText = sequencia[index];
        } else {
            clearInterval(troca);
            overlay.style.display = "none";
            if (quizContainer) quizContainer.style.visibility = "visible";
            iniciarQuiz();
        }
    }, 1000);
}

// 🚀 INICIA QUIZ
function iniciarQuiz() {
    if (!perguntas || perguntas.length === 0) {
        console.error("Nenhuma pergunta carregada!");
        return;
    }
    
    quizAtivo = true;
    tempoInicial = Date.now();
    intervaloTimer = setInterval(atualizarTimer, 1000);
    carregarPergunta();
}

// 🔥 CARREGAR PERGUNTA
function carregarPergunta() {
    if (!quizAtivo) return;
    
    const q = perguntas[atual];
    
    if (!q) {
        finalizarQuiz();
        return;
    }

    perguntaEl.classList.remove("fade");
    opcoesEl.classList.remove("fade");

    void perguntaEl.offsetWidth; // Force reflow

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

// 🎯 RESPONDER
function responder(btn, op, q) {
    if (!quizAtivo) return;
    
    const botoes = document.querySelectorAll(".opcao");
    botoes.forEach(b => b.style.pointerEvents = "none");

    respostas.push({
        questao_id: q.id,
        alternativa_id: op.id
    });

    if (op.correta) {
        btn.classList.add("correta");
        pontuacao += op.ponto || 0;
        
        // 🎉 Efeito de acerto (opcional)
        criarParticulas(btn);
        
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
        
        if (atual < perguntas.length && quizAtivo) {
            carregarPergunta();
        } else {
            finalizarQuiz();
        }
    }, 1200);
}

// ✨ Efeito de partículas (opcional)
function criarParticulas(elemento) {
    const rect = elemento.getBoundingClientRect();
    for (let i = 0; i < 15; i++) {
        const particle = document.createElement('div');
        particle.classList.add('particle');
        particle.style.left = rect.left + rect.width/2 + 'px';
        particle.style.top = rect.top + rect.height/2 + 'px';
        const angle = Math.random() * Math.PI * 2;
        const distance = 50 + Math.random() * 80;
        particle.style.setProperty('--x', Math.cos(angle) * distance + 'px');
        particle.style.setProperty('--y', Math.sin(angle) * distance + 'px');
        document.body.appendChild(particle);
        setTimeout(() => particle.remove(), 900);
    }
}

// 📊 PROGRESSO
function atualizarBarra() {
    if (!progress) return;
    const pct = (atual / perguntas.length) * 100;
    progress.style.width = pct + "%";
}

// ⏱ TIMER
function atualizarTimer() {
    if (!tempoInicial || !quizAtivo) return;

    const agora = Date.now();
    const diff = agora - tempoInicial;
    const segundos = Math.floor(diff / 1000);
    const minutos = Math.floor(segundos / 60);
    const segRestantes = segundos % 60;

    if (timerEl) {
        timerEl.innerText = `${String(minutos).padStart(2, "0")}:${String(segRestantes).padStart(2, "0")}`;
    }
}

// 🏁 FINALIZAR
function finalizarQuiz() {
    quizAtivo = false;
    
    if (intervaloTimer) {
        clearInterval(intervaloTimer);
        intervaloTimer = null;
    }

    if (perguntaEl) {
        perguntaEl.innerText = "QUIZ FINALIZADO";
    }

    if (opcoesEl) {
        opcoesEl.innerHTML = `
            <div class="resultado-box fade">
                <h3>SUA PONTUAÇÃO</h3>
                <p class="resultado-pontos">${pontuacao} pontos</p>
                <a href="/game/menu_game/" class="btn-menu">VOLTAR AO MENU</a>
            </div>
        `;
    }

    if (progress) {
        progress.style.width = "100%";
    }

    const tempoFinal = Date.now() - tempoInicial;

    // Salvar pontuação
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

// 🚀 INICIAR
// Aguarda o DOM carregar completamente
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', iniciarIntro);
} else {
    iniciarIntro();
}