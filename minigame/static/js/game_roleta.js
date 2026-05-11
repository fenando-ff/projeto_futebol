const leverSound = document.getElementById("leverSound");
const spinSound = document.getElementById("spinSound");
const startBtn = document.getElementById("startGameBtn");

const produtos = JSON.parse(
    document.getElementById("produtos-data").textContent
);
const sorteados = JSON.parse(
    document.getElementById("sorteados-data").textContent
);
const reels = document.querySelectorAll(".reel-track");

let alreadyPlayed = false;
let spinning = false;
let completed = 0;
let startTime = null; // 📊 cronômetro

function getCSRFToken() {
    return document.cookie
        .split('; ')
        .find(row => row.startsWith('csrftoken'))
        ?.split('=')[1];
}






// 🧠 cria lista grande (efeito infinito)
function generateReelContent() {
    let content = [];

    for (let i = 0; i < 20; i++) {
        produtos.forEach(p => {
            content.push(`
                <div class="slot-item" data-img="${p.img}">
                    <img src="/static/${p.img}">
                </div>
            `);
        });
    }

    return content.join("");
}

// 🎯 monta os reels
reels.forEach(reel => {
    reel.innerHTML = generateReelContent();
});



// 🎰 GIRO
const lever = document.getElementById("lever");



lever.addEventListener("click", () => {

    if (alreadyPlayed || spinning) return;

    alreadyPlayed = true;
    spinning = true;

    // ⏱️ Inicia cronômetro
    startTime = Date.now();

    lever.classList.add("pull");

    // 🔊 som alavanca
    leverSound.playbackRate = 1.4;
    leverSound.currentTime = 0;
    leverSound.play().catch(() => {});

    // 🔊 som roleta
    spinSound.currentTime = 0;
    spinSound.loop = true;
    spinSound.play().catch(() => {});

    startSpin();

    setTimeout(() => {
        lever.classList.remove("pull");
    }, 300);

    
});

function startSpin() {

    completed = 0;

    reels.forEach((reel, index) => {

        const coluna = Number(reel.dataset.coluna);
        const itemSorteado = sorteados[coluna];
       
        


       const items = Array.from(reel.children);

const targetIndex = items.findIndex(el =>
    el.dataset.img === itemSorteado.img
);

// 🛡️ proteção contra erro
if (targetIndex === -1) {
    console.error("Item não encontrado:", itemSorteado.img);
    return;
}





const itemHeight = 100;
const visibleOffset = 1; // 👈 AJUSTE AQUI (posição do centro visual)

const extraSpins = 6;

const finalY = -((targetIndex - visibleOffset) * itemHeight + extraSpins * produtos.length * itemHeight);

        gsap.killTweensOf(reel);
        gsap.set(reel, { y: 0 });

        gsap.to(reel, {
            y: finalY,
            duration: 2 + index * 0.6,
            ease: "power3.out",

            onComplete: () => {
                completed++;

                if (completed === reels.length) {

                    spinSound.pause();
                    spinSound.currentTime = 0;

                    // 💾 salvar correto
                    localStorage.removeItem("itens_sorteados");
                    localStorage.setItem(
                        "itens_sorteados",
                        JSON.stringify(sorteados)
                    );

                    triggerWinEffect();
                    screenShake();

                    startBtn.style.display = "block";

                    startBtn.addEventListener("click", () => {
                        window.location.href = "/loja_produtos/?modo=jogo";
                    });

                    gsap.fromTo(startBtn,
                        { scale: 0, opacity: 0 },
                        { scale: 1, opacity: 1, duration: 0.5, ease: "back.out(2)" }
                    );

                    // ⏱️ Salvar tempo da roleta
                    if (startTime) {
                        const tempo_ms = Date.now() - startTime;
                        fetch("/game/salvar_tempo_roleta/", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                                "X-CSRFToken": getCSRFToken()
                            },
                            body: JSON.stringify({ tempo_ms: tempo_ms })
                        }).catch(err => console.error("Erro ao salvar tempo:", err));
                    }

                    spinning = false;
                }
            }
        });

    });
}


function triggerWinEffect() {
    const slots = document.querySelectorAll(".reel");

    let count = 0;

    const interval = setInterval(() => {
        slots.forEach(slot => {
            slot.classList.toggle("win");
        });

        count++;

        if (count >= 6) { // 3 piscadas (liga/desliga)
            clearInterval(interval);

            // garante que termina ligado
            slots.forEach(slot => slot.classList.add("win"));
        }
    }, 200);
}




function screenShake() {
    const container = document.querySelector(".slot-machine");

    let intensity = 10; // força da tremida
    let shakes = 8;

    const tl = gsap.timeline();

    for (let i = 0; i < shakes; i++) {
        tl.to(container, {
            x: gsap.utils.random(-intensity, intensity),
            y: gsap.utils.random(-intensity, intensity),
            duration: 0.05
        });
    }

    // volta pro lugar
    tl.to(container, {
        x: 0,
        y: 0,
        duration: 0.1
    });
}





