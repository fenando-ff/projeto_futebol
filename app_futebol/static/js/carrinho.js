let qtd = document.querySelector(".qtd-produto");
let mais = document.querySelector(".fa-plus");
let menos = document.querySelector(".fa-minus");
let valor = document.querySelector(".valor-produto")

mais.addEventListener("click", function() {
    let qtdAtual = parseInt(qtd.textContent);
    qtd.textContent = qtdAtual + 1;

    let valorAtual = parseFloat(valor.textContent);
    valor.textContent = valor + valorAtual;
});

menos.addEventListener("click", function() {
    let qtdAtual = parseInt(qtd.textContent)
    if (qtdAtual > 1) {
        qtd.textContent = qtdAtual - 1;
    }
});