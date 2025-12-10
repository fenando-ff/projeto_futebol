// 📌 Tela_ingressos.js

document.addEventListener("DOMContentLoaded", () => {
  const setorSelect = document.getElementById("setor");
  const quantidadeInput = document.getElementById("quantidade");
  const formSetor = document.querySelector(".form-setor");
  const listaIngressos = document.querySelector(".lista-ingressos ul");
  const totalGeralEl = document.getElementById("total-geral");
  const btnFinalizar = document.getElementById("finalizar-compra");

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

  listaIngressos.addEventListener("click", (e) => {
    if (e.target.classList.contains("botao-excluir")) {
      e.target.closest("li").remove();
      atualizarTotalGeral();
    }
  });

  function atualizarTotalGeral() {
    let soma = 0;
    listaIngressos.querySelectorAll(".item-ingresso").forEach(item => {
      const valor = parseFloat(item.dataset.total || "0");
      if (!isNaN(valor)) soma += valor;
    });

    totalGeralEl.textContent = `Total da compra: R$${soma.toFixed(2)}`;

    if (listaIngressos.querySelectorAll(".item-ingresso").length > 0) {
      btnFinalizar.style.display = "block";
    } else {
      btnFinalizar.style.display = "none";
    }
  }

  // ✅ Mensagem de sucesso só quando clicar em "Finalizar Compra"
  btnFinalizar.addEventListener("click", () => {
    const msg = document.getElementById("mensagem-sucesso");
    msg.classList.add("visivel");
    setTimeout(() => msg.classList.remove("visivel"), 2000);
  });

  // ✅ Mensagem de sucesso também quando clicar no total da compra
  totalGeralEl.addEventListener("click", () => {
    const msg = document.getElementById("mensagem-sucesso");
    msg.classList.add("visivel");
    setTimeout(() => msg.classList.remove("visivel"), 2000);
  });
});