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
const btn = document.getElementById("spinBtn");

let reelsStopped = 0;
let alreadyPlayed = false;
let spinning = false;
let completed = 0;






// 🧠 cria lista grande (efeito infinito)
function generateReelContent() {
    let content = [];

    for (let i = 0; i < 20; i++) {
        produtos.forEach(p => {
            content.push(`
                <div class="slot-item">
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

        const totalItems = reel.children.length;
        const itemSorteado = sorteados[index];

        const targetIndex = Array.from(reel.children).findIndex(el =>
            el.innerHTML.includes(itemSorteado.img)
        );

        const itemHeight = 100;
        const extraSpins = 8;

        const loopSize = produtos.length * itemHeight;        
        const finalY = -(targetIndex * itemHeight + extraSpins * loopSize);

        gsap.killTweensOf(reel);
        gsap.set(reel, { y: 0 });

        gsap.to(reel, {
            y: finalY,
            duration: 2 + index * 0.6,
            ease: "power3.out",

            onComplete: () => {
                completed++;

                // 🎯 quando TODOS pararem
                if (completed === reels.length) {

                    // 🔇 parar som
                    spinSound.pause();
                    spinSound.currentTime = 0;

                    // 💾 salvar itens
                    localStorage.setItem("itens_sorteados", JSON.stringify(sorteados));

                    // 🎉 efeitos
                    triggerWinEffect();
                    screenShake();

                    // 🎮 MOSTRAR BOTÃO
                    startBtn.style.display = "block";

                    // 🎮 botão aparecer
                    startBtn.addEventListener("click", () => {

                        window.location.href = "/loja_produtos/?modo=jogo";

                    });

                    gsap.fromTo(startBtn,
                        { scale: 0, opacity: 0 },
                        { scale: 1, opacity: 1, duration: 0.5, ease: "back.out(2)" }
                    );

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









