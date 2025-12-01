// 📌 Tela_ingressos.js

document.addEventListener("DOMContentLoaded", () => {
  const setorSelect = document.getElementById("setor");
  const quantidadeInput = document.getElementById("quantidade");
  const precoTotalEl = document.getElementById("preco-total");
  const formSetor = document.querySelector(".form-setor");
  const listaIngressos = document.querySelector(".lista-ingressos ul");

  // 💰 Preços por setor
  const precosSetores = {
    ladoA_arquibancada_anda: 60,
    ladoA_cadeira_cativa: 100,
    ladoA_arquibancada_cima: 50,
    ladoB_arquibancada_anda: 60,
    ladoB_cadeira_cativa: 100,
    ladoB_arquibancada_cima: 50,
    ladoA_cadeira_ladoB_cima: 80
  };

  // 🔄 Atualiza preço total
  function atualizarPreco() {
    const setor = setorSelect.value;
    const quantidade = parseInt(quantidadeInput.value) || 1;
    const precoUnitario = precosSetores[setor] || 60;
    const total = precoUnitario * quantidade;
    precoTotalEl.textContent = `R$${total.toFixed(2)}`;
  }

  setorSelect.addEventListener("change", atualizarPreco);
  quantidadeInput.addEventListener("input", atualizarPreco);

  // 🛒 Adiciona ingresso à lista
  formSetor.addEventListener("submit", (e) => {
    e.preventDefault();

    const setorNome = setorSelect.options[setorSelect.selectedIndex].text;
    const setorValor = setorSelect.value;
    const quantidade = parseInt(quantidadeInput.value) || 1;
    const precoUnitario = precosSetores[setorValor] || 60;
    const total = precoUnitario * quantidade;

    // Cria item
    const li = document.createElement("li");
    li.classList.add("item-ingresso");

    li.innerHTML = `
      <div class="info-ingresso">
        <p><strong>Setor:</strong> ${setorNome}</p>
        <p><strong>Quantidade:</strong> ${quantidade}</p>
        <p><strong>Preço:</strong> R$${total.toFixed(2)}</p>
      </div>
      <button class="botao-excluir">Excluir</button>
    `;

    listaIngressos.appendChild(li);
  });

  // 🔧 Delegação de evento para excluir (funciona em todos os botões)
  listaIngressos.addEventListener("click", (e) => {
    if (e.target.classList.contains("botao-excluir")) {
      e.target.closest("li").remove();
    }
  });

  // Inicializa preço
  atualizarPreco();
});