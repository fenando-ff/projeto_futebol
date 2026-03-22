const cards = document.querySelectorAll(".card");
const btn = document.querySelector(".next-btn");

let current = 0;

/* 🎬 ANIMAÇÃO DE ENTRADA */
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
        // 👇 vira só a primeira automaticamente
        activateCard(0);
    }
});

/* 🎯 FUNÇÃO PRINCIPAL */
function activateCard(index) {
    const card = cards[index];

    // adiciona classe ativa
    card.classList.add("active");

    // vira a carta
    setTimeout(() => {
        card.classList.add("flip");
    }, 200);
}

/* 👉 BOTÃO SEGUIR */
btn.addEventListener("click", () => {

    // impede ultrapassar
    if (current >= cards.length - 1) return;

    // remove active da atual
    cards[current].classList.remove("active");

    // próxima carta
    current++;

    activateCard(current);
});





