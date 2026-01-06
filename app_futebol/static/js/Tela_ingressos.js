document.addEventListener("DOMContentLoaded", () => {
  const setorSelect = document.getElementById("setor");
  const quantidadeInput = document.getElementById("quantidade");
  const formSetor = document.querySelector(".form-setor");
  const listaIngressos = document.querySelector(".lista-ingressos ul");
  const totalGeralEl = document.getElementById("total-geral");

  // 🛒 Adiciona ingresso à lista
  formSetor.addEventListener("submit", (e) => {
    e.preventDefault();

    const optionSelecionada = setorSelect.selectedOptions[0];
    const setorNome = optionSelecionada ? optionSelecionada.text : "";
    const setorValor = setorSelect.value;
    const quantidade = parseInt(quantidadeInput.value, 10) || 1;

    const precoUnitario = optionSelecionada
      ? parseFloat(optionSelecionada.dataset.preco)
      : NaN;

    if (!setorValor || isNaN(precoUnitario)) {
      alert("Selecione um setor válido!");
      return;
    }

    const total = precoUnitario * quantidade;

    const li = document.createElement("li");
    li.classList.add("item-ingresso");
    li.dataset.total = String(total);

    li.innerHTML = `
      <div class="info-ingresso">
        <p><strong>Setor:</strong> ${setorNome}</p>
        <p><strong>Quantidade:</strong> ${quantidade}</p>
        <p><strong>Preço:</strong> R$${total.toFixed(2)}</p>
      </div>
      <button class="botao-excluir">Excluir</button>
    `;

    listaIngressos.appendChild(li);

    atualizarTotalGeral();
  });

  // ❌ Excluir item da lista
  listaIngressos.addEventListener("click", (e) => {
    if (e.target.classList.contains("botao-excluir")) {
      e.target.closest("li").remove();
      atualizarTotalGeral();
    }
  });

  // 🔢 Atualiza o total da compra
  function atualizarTotalGeral() {
    let soma = 0;

    listaIngressos.querySelectorAll(".item-ingresso").forEach(item => {
      const valor = parseFloat(item.dataset.total || "0");
      if (!isNaN(valor)) soma += valor;
    });

    totalGeralEl.textContent = `Total da compra: R$${soma.toFixed(2)}`;
  }

  // ✅ Mensagem de sucesso ao clicar no total (apenas se houver ingressos na lista)
  totalGeralEl.addEventListener("click", () => {
    const quantidadeIngressos = listaIngressos.querySelectorAll(".item-ingresso").length;

    if (quantidadeIngressos > 0) {
      const msg = document.getElementById("mensagem-sucesso");
      if (msg) {
        msg.classList.add("visivel");
        setTimeout(() => msg.classList.remove("visivel"), 2000);
      } else {
        alert("Compra realizada com sucesso!");
      }
    } else {
      alert("Adicione pelo menos um ingresso antes de finalizar a compra!");
    }
  });
});
