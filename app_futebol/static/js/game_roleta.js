const produtos = JSON.parse(
    document.getElementById("produtos-data").textContent
);

const sorteados = JSON.parse(
    document.getElementById("sorteados-data").textContent
);



const reels = document.querySelectorAll(".reel-track");
const btn = document.getElementById("spinBtn");





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

let spinning = false;

lever.addEventListener("click", () => {

    if (spinning) return;
    spinning = true;

    lever.classList.add("pull");

    startSpin();

    setTimeout(() => {
        lever.classList.remove("pull");
    }, 300);

    setTimeout(() => {
        spinning = false;
    }, 800); // espera o giro começar melhor

});