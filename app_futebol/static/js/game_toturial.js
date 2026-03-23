const cards = document.querySelectorAll(".card");
const btn = document.querySelector(".next-btn");
const flipSound = document.getElementById("cardFlipSound");
const stackSound = document.getElementById("cardStackSound");

let current = 0;
let started = false;

// 🎯 PRIMEIRO CLIQUE NA TELA (desbloqueia áudio)
document.addEventListener("click", () => {
    if (started) return;
    started = true;

    startIntro();
}, { once: true });

function startIntro() {

    // 🔊 SOM DAS CARTAS ENTRANDO
    stackSound.currentTime = 0;
    stackSound.volume = 0.5;
    stackSound.play().catch(() => {});

    // 🎬 ANIMAÇÃO
    gsap.fromTo(".card",
    {
        x: () => gsap.utils.random(-300, 300),
        y: 200,
        rotation: () => gsap.utils.random(-30, 30),
        opacity: 0
    },
    {
        x: 0,
        y: 0,
        rotation: 0,
        opacity: 1,
        duration: 0.9,
        ease: "back.out(1.8)",
        stagger: 0.2,

        onComplete: () => {
            activateCard(0);
        }
    });
}

// 🎯 ATIVA CARTA
function activateCard(index) {
    const card = cards[index];

    card.classList.add("active");

    // 🔊 SOM DO FLIP
    setTimeout(() => {
        flipSound.currentTime = 0;
        flipSound.play().catch(() => {});
    }, 150);

    setTimeout(() => {
        card.classList.add("flip");
    }, 200);
}

// 👉 BOTÃO
btn.addEventListener("click", () => {

    if (current >= cards.length - 1) return;

    cards[current].classList.remove("active");

    current++;

    activateCard(current);
});


stackSound.volume = 2.0; // máximo
flipSound.volume = 0.8;