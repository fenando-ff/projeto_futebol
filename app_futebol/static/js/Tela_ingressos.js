document.addEventListener("DOMContentLoaded", () => {
  const setorSelect = document.getElementById("setor");
  const quantidadeInput = document.getElementById("quantidade");
  const formSetor = document.querySelector(".form-setor");
  const listaIngressos = document.querySelector(".lista-ingressos ul");

  const botaoFinalizar = document.getElementById("btn-finalizar");
  const valorFinalEl = document.getElementById("valor-final");

  // 🛒 Adiciona ingresso à lista
  formSetor.addEventListener("submit", (e) => {
    e.preventDefault();

    // Seleção robusta do option
    const optionSelecionada = setorSelect && setorSelect.selectedOptions && setorSelect.selectedOptions[0];
    if (!optionSelecionada) {
      console.error('Nenhuma option selecionada ou select não encontrado', setorSelect);
      alert('Selecione um setor válido!');
      return;
    }

    const valorValue = (optionSelecionada.getAttribute('value') || '').toString().trim();
    if (!valorValue) {
      console.error('Option selecionada sem valor:', optionSelecionada);
      alert('Selecione um setor válido!');
      return;
    }

    const setorNome = optionSelecionada.textContent.trim();
    const precoUnitario = parseFloat(optionSelecionada.dataset.preco);
    const quantidade = parseInt(quantidadeInput.value, 10) || 1;

    if (isNaN(precoUnitario)) {
      console.error('Preço inválido no option selecionado:', optionSelecionada.dataset.preco);
      alert('Preço inválido para o setor selecionado.');
      return;
    }
    if (isNaN(quantidade) || quantidade < 1) {
      alert('Quantidade inválida!');
      return;
    }

    const total = precoUnitario * quantidade;

    const li = document.createElement("li");
    li.classList.add("item-ingresso");
    li.dataset.total = total;

    li.innerHTML = `
      <div class="info-ingresso">
        <p><strong>Setor:</strong> ${setorNome}</p>
        <p><strong>Quantidade:</strong> ${quantidade}</p>
        <p><strong>Preço:</strong> R$ ${total.toFixed(2)}</p>
      </div>
      <button type="button" class="botao-excluir">Excluir</button>
    `;

    listaIngressos.appendChild(li);
    atualizarTotal();
    formSetor.reset();
    quantidadeInput.value = 1;
  });

  // ❌ Excluir ingresso
  listaIngressos.addEventListener("click", (e) => {
    if (e.target.classList.contains("botao-excluir")) {
      e.target.closest(".item-ingresso").remove();
      atualizarTotal();
    }
  });

  // 🔢 Atualiza total no botão
  function atualizarTotal() {
    let soma = 0;

    listaIngressos.querySelectorAll(".item-ingresso").forEach(item => {
      soma += parseFloat(item.dataset.total);
    });

    valorFinalEl.textContent = soma.toFixed(2);

    botaoFinalizar.disabled = soma === 0;
    botaoFinalizar.style.opacity = soma === 0 ? "0.6" : "1";
  }

  // ✅ Finalizar compra
  if (!botaoFinalizar) {
    console.error('Botão finalizar não encontrado (id=btn-finalizar)');
  } else {
    botaoFinalizar.addEventListener("click", () => {
      const total = parseFloat(valorFinalEl.textContent);

      console.log('Finalizar click - total', total);

      if (total === 0) {
        alert("Adicione pelo menos um ingresso antes de finalizar!");
        return;
      }

      const msg = document.getElementById("mensagem-sucesso");
      console.log('mensagem element:', msg);
      if (msg) {
        // tenta usar a classe animada
        msg.classList.add('show');
        // fallback: garante display (caso CSS não carregado ou cache)
        msg.style.display = 'block';

        // evita múltiplos clicks
        botaoFinalizar.disabled = true;
        // limpar lista de ingressos imediatamente para refletir compra
        listaIngressos.innerHTML = '';
        atualizarTotal();

        setTimeout(() => {
          msg.classList.remove('show');
          msg.style.display = 'none';
          botaoFinalizar.disabled = false;
        }, 1800);
      } else {
        alert(`Compra realizada com sucesso! Total: R$ ${total.toFixed(2)}`);
      }
    });
  }
});
