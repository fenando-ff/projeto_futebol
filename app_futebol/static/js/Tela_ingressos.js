function getCookie(name) {
  let cookieValue = null;
  if (document.cookie && document.cookie !== '') {
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
      const cookie = cookies[i].trim();
      if (cookie.substring(0, name.length + 1) === (name + '=')) {
        cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
        break;
      }
    }
  }
  return cookieValue;
}
const csrftoken = getCookie('csrftoken');

document.addEventListener("DOMContentLoaded", () => {
  const setorSelect = document.getElementById("setor");
  const quantidadeInput = document.getElementById("quantidade");
  const formSetor = document.querySelector(".form-setor");
  const listaIngressos = document.querySelector(".lista-ingressos ul");

  const botaoFinalizar = document.getElementById("btn-finalizar");
  const valorFinalEl = document.getElementById("valor-final");

  // 🛒 Adiciona ingresso à lista e ao carrinho da sessão
  formSetor.addEventListener("submit", (e) => {
    e.preventDefault();

    const optionSelecionada = setorSelect && setorSelect.selectedOptions && setorSelect.selectedOptions[0];
    if (!optionSelecionada) {
      alert('Selecione um setor válido!');
      return;
    }

    const valorValue = (optionSelecionada.getAttribute('value') || '').toString().trim();
    if (!valorValue) {
      alert('Selecione um setor válido!');
      return;
    }

    const produtoId = valorValue;
    const setorNome = optionSelecionada.textContent.trim();
    const precoUnitario = parseFloat(optionSelecionada.dataset.preco);
    const quantidade = parseInt(quantidadeInput.value, 10) || 1;

    if (isNaN(precoUnitario)) {
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
    li.dataset.produtoId = produtoId;

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

    fetch(`/adicionar/${produtoId}/`, {
      method: 'POST',
      headers: {
        'X-CSRFToken': csrftoken,
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: new URLSearchParams({ quantidade: String(quantidade) })
    }).catch(() => {
      alert('Erro ao adicionar ao carrinho. Tente novamente.');
      li.remove();
      atualizarTotal();
    });
  });

  // ❌ Excluir ingresso (apenas visual, pois o carrinho real é na sessão)
  listaIngressos.addEventListener("click", (e) => {
    if (e.target.classList.contains("botao-excluir")) {
      const item = e.target.closest(".item-ingresso");
      const produtoId = item.dataset.produtoId;
      const quantidade = parseInt(item.querySelector('.info-ingresso p:nth-child(2)').textContent.replace('Quantidade:', '').trim(), 10);

      fetch(`/remover/${produtoId}/`, {
        method: 'POST',
        headers: {
          'X-CSRFToken': csrftoken,
          'X-Requested-With': 'XMLHttpRequest'
        }
      }).then(() => {
        item.remove();
        atualizarTotal();
      }).catch(() => {
        alert('Erro ao remover item.');
      });
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

  // ✅ Finalizar compra e exibir PDF
    if (!botaoFinalizar) {
    console.error('Botão finalizar não encontrado (id=btn-finalizar)');
  } else {
    botaoFinalizar.addEventListener("click", () => {
      const total = parseFloat(valorFinalEl.textContent);

      if (total === 0) {
        alert("Adicione pelo menos um ingresso antes de finalizar!");
        return;
      }

      botaoFinalizar.disabled = true;
      botaoFinalizar.textContent = 'Processando...';

      fetch('/finalizar_compra/', {
        method: 'POST',
        headers: {
          'X-CSRFToken': csrftoken,
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(res => res.json())
      .then(data => {
        if (data.sucesso && data.pedido_id) {
          const msg = document.getElementById("mensagem-sucesso");
          if (msg) {
            msg.classList.add('show');
            msg.style.display = 'block';
            listaIngressos.innerHTML = '';
            atualizarTotal();
            setTimeout(() => {
              msg.classList.remove('show');
              msg.style.display = 'none';
            }, 1800);
          }
          window.open(`/baixar_ingresso/${data.pedido_id}/`, '_blank');
        } else {
          alert(data.mensagem || 'Erro ao finalizar compra.');
          botaoFinalizar.disabled = false;
          botaoFinalizar.textContent = `Finalizar Compra • R$ ${total.toFixed(2)}`;
        }
      })
      .catch(() => {
        alert('Erro ao processar compra. Tente novamente.');
        botaoFinalizar.disabled = false;
        botaoFinalizar.textContent = `Finalizar Compra • R$ ${total.toFixed(2)}`;
      });
    });
  }

  atualizarTotal();
});
