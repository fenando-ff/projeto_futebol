    const botao = document.getElementById("botao_hamburguer");
    const nav = document.querySelector(".nav");

    botao.addEventListener("click", function() {
    if (nav.style.display === "flex") {
            nav.style.display = "none";
        } else {
            nav.style.display = "flex";
        }
    });