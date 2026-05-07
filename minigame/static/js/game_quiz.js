let atual = 0;
let pontuacao = 0;
let respostas = []; // Array para armazenar respostas do usuário

const perguntaEl = document.getElementById("pergunta");
const opcoesEl = document.getElementById("opcoes");
const progress = document.getElementById("progress");

function getCSRFToken() {
    return document.cookie
        .split('; ')
        .find(row => row.startsWith('csrftoken'))
        ?.split('=')[1];
}

// 🔥 carregar pergunta
function carregarPergunta() {
    const q = perguntas[atual];

    perguntaEl.classList.remove("fade");
    opcoesEl.classList.remove("fade");

    void perguntaEl.offsetWidth; // reset animação

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

    // trava cliques
    botoes.forEach(b => b.style.pointerEvents = "none");

    // Salva resposta do usuário
    respostas.push({
        questao_id: q.id,
        alternativa_id: op.id
    });

    if (op.correta) {
        btn.classList.add("correta");
        pontuacao += op.ponto || 0;
    } else {
        btn.classList.add("errada");

        // efeito de erro (igual seu sistema 🔥)
        document.body.classList.add("error-flash");
        setTimeout(() => {
            document.body.classList.remove("error-flash");
        }, 200);

        // mostra correta
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

// 🏁 final
function finalizarQuiz() {
    perguntaEl.innerText = "QUIZ FINALIZADO 🔥";

    opcoesEl.innerHTML = `
        <div class="resultado-box">
            <h3>SUA PONTUAÇÃO</h3>
            <p>${pontuacao} pontos</p>
        </div>
    `;

    progress.style.width = "100%";
}









// 🚀 start
carregarPergunta();

function criarParticulas(x, y) {
    for (let i = 0; i < 12; i++) {
        const p = document.createElement("div");
        p.classList.add("particle");

        // posição inicial (onde clicou)
        p.style.left = x + "px";
        p.style.top = y + "px";

        // variação aleatória lateral
        const randomX = (Math.random() - 0.5) * 60;
        const randomY = Math.random() * -80;

        p.style.transform = `translate(${randomX}px, ${randomY}px)`;

        document.body.appendChild(p);

        setTimeout(() => {
            p.remove();
        }, 1000);
    }
}





function finalizarQuiz() {
    perguntaEl.innerText = "QUIZ FINALIZADO 🔥";

    opcoesEl.innerHTML = `
        <div class="resultado-box">
            <h3>SUA PONTUAÇÃO</h3>
            <p>${pontuacao} pontos</p>
        </div>
    `;

    progress.style.width = "100%";

    // 🚀 ENVIA DADOS PARA O DJANGO
    fetch("/game/salvar_pontuacao/", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": getCSRFToken()
        },
        body: JSON.stringify({
            pontuacao: pontuacao,
            respostas: respostas
        })
    })
    .then(res => res.json())
    .then(data => {
        console.log("Dados salvos!", data);
    })
    .catch(err => console.error("Erro ao salvar:", err));
}