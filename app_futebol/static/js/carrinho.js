// ==========================
// CARRINHO.JS — DRAKO STORE
/* carrinho.js — AJAX-friendly cart
   - Usa fetch() para POST /atualizar/<id>/ com header X-Requested-With
   - Atualiza quantidades e o resumo (.bloco-resumo) com os valores retornados pelo servidor
   - Mantém apenas UX (popup e animações) client-side
*/

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

document.addEventListener('DOMContentLoaded', () => {
  const itensCarrinho = document.querySelectorAll('.item-carrinho');

  // adiciona listeners que chamam a função do servidor via AJAX
  itensCarrinho.forEach(item => {
    const btnMenos = item.querySelector('.quantidade button:first-child');
    const btnMais = item.querySelector('.quantidade button:last-child');
    const qtdEl = item.querySelector('.quantidade span');
    const precoUnitarioEl = item.querySelector('.preco-unitario');
    const precoLinhaEl = item.querySelector('.preco-linha');
    const precoTotalEl = item.querySelector('.preco-total');
    const produtoId = item.querySelector('a.lixeira') ? item.querySelector('a.lixeira').getAttribute('href').match(/\/(\d+)\//) : null;
    let id = null;
    if (produtoId && produtoId[1]) id = produtoId[1];

    function postQuantidade(novaQtd) {
      if (!id) return;
      const url = `/atualizar/${id}/`;
      const formData = new FormData();
      formData.append('quantidade', novaQtd);

      fetch(url, {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRFToken': getCookie('csrftoken') || ''
        },
        body: formData,
        credentials: 'same-origin'
      }).then(r => r.json())
        .then(data => {
          console.log('Resposta do servidor:', data);
          if (!data.success) return;

          // atualiza quantidade no DOM
          if (novaQtd <= 0) {
            item.remove();
          } else {
            qtdEl.textContent = novaQtd;
            
            // Atualiza o preço da linha (quantidade x preço unitário)
            if (precoUnitarioEl && precoLinhaEl && precoTotalEl) {
              const precoUnitario = parseFloat(precoUnitarioEl.textContent);
              const precoLinha = precoUnitario * novaQtd;
              precoLinhaEl.textContent = precoLinha.toFixed(2);
              precoTotalEl.textContent = novaQtd;
            }
          }

          // atualiza resumo (subtotal, desconto e total)
          const subtotalEl = document.getElementById('subtotal');
          const descontoEl = document.getElementById('desconto');
          const descontoPercentEl = document.getElementById('desconto-percent');
          const totalEl = document.getElementById('total');
          
          console.log('descontoEl:', descontoEl);
          console.log('descontoPercentEl:', descontoPercentEl);
          
          if (subtotalEl) {
            const valorEl = subtotalEl.querySelector('.valor');
            console.log('Atualizando subtotal valor:', `R$${data.total.toFixed(2)}`);
            if (valorEl) valorEl.textContent = `R$${data.total.toFixed(2)}`;
          }
          
          if (descontoEl) {
            const valorEl = descontoEl.querySelector('.valor');
            console.log('Atualizando desconto valor:', `R$${data.desconto.toFixed(2)}`);
            console.log('Atualizando desconto percent:', `(${data.desconto_percent}%)`);
            if (valorEl) valorEl.textContent = `R$${data.desconto.toFixed(2)}`;
            if (descontoPercentEl) {
              descontoPercentEl.textContent = `(${data.desconto_percent}%)`;
            }
          }
          
          if (totalEl) {
            const valorEl = totalEl.querySelector('.valor');
            if (valorEl) valorEl.textContent = `R$${data.total_com_desconto.toFixed(2)}`;
          }
        })
        .catch(err => console.error('Erro ao atualizar carrinho:', err));
    }

    if (btnMais) {
      btnMais.addEventListener('click', () => {
        const valor = parseInt(qtdEl.textContent) + 1;
        postQuantidade(valor);
      });
    }

    if (btnMenos) {
      btnMenos.addEventListener('click', () => {
        const valor = parseInt(qtdEl.textContent) - 1;
        // permitir zero para remoção
        postQuantidade(valor);
      });
    }
  });

  // remover via ícone lixeira (link padrão já faz redirect). Interceptamos para chamada AJAX.
  const lixeiras = document.querySelectorAll('a.lixeira');
  lixeiras.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const href = link.getAttribute('href');
      const m = href.match(/\/(\d+)\/\s*$/);
      const id = m ? m[1] : null;
      if (!id) return;
      // remover chamando quantidade 0
      const itemEl = link.closest('.item-carrinho');
      const formData = new FormData();
      formData.append('quantidade', 0);

      fetch(`/atualizar/${id}/`, {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRFToken': getCookie('csrftoken') || ''
        },
        body: formData,
        credentials: 'same-origin'
      }).then(r => r.json())
        .then(data => {
          if (data.success) {
            if (itemEl) itemEl.remove();
            const subtotalEl = document.getElementById('subtotal');
            const descontoEl = document.getElementById('desconto');
            const descontoPercentEl = document.getElementById('desconto-percent');
            const totalEl = document.getElementById('total');
            
            if (subtotalEl) {
              const valorEl = subtotalEl.querySelector('.valor');
              if (valorEl) valorEl.textContent = `R$${data.total.toFixed(2)}`;
            }
            
            if (descontoEl) {
              const valorEl = descontoEl.querySelector('.valor');
              if (valorEl) valorEl.textContent = `R$${data.desconto.toFixed(2)}`;
              if (descontoPercentEl) {
                descontoPercentEl.textContent = `(${data.desconto_percent}%)`;
              }
            }
            
            if (totalEl) {
              const valorEl = totalEl.querySelector('.valor');
              if (valorEl) valorEl.textContent = `R$${data.total_com_desconto.toFixed(2)}`;
            }
          }
        }).catch(err => console.error(err));
    });
  });

  // POP-UP DE PAGAMENTO (mantido)
  const paymentOverlay = document.getElementById("paymentOverlay");
  const openPayment = document.getElementById("openPayment");
  const closePaymentRight = document.getElementById("closePaymentRight");
  const closePaymentLeft = document.getElementById("closePaymentLeft");
  const payMethods = document.querySelectorAll(".pay-method");

  const payTitle = document.getElementById("payTitle");
  const paySubtitle = document.getElementById("paySubtitle");
  const payForm = document.getElementById("payForm");
  const paySubmit = document.getElementById("paySubmit");
  const paySuccess = document.getElementById("paySuccess");

  if (openPayment) {
    openPayment.addEventListener("click", (e) => {
      e.preventDefault();
      paymentOverlay.classList.add("show");
    });
  }

  function closePayment() {
    if (!paymentOverlay) return;
    paymentOverlay.classList.remove("show");
    if (payForm) payForm.innerHTML = "";
    if (paySubmit) paySubmit.style.display = "none";
    if (paySuccess) paySuccess.style.display = "none";
    payMethods.forEach(m => m.classList.remove("selected"));
    if (payTitle) payTitle.textContent = "Nenhuma forma selecionada";
    if (paySubtitle) paySubtitle.textContent = "Escolha um método de pagamento.";
  }

  if (closePaymentRight) closePaymentRight.addEventListener("click", closePayment);
  if (closePaymentLeft) closePaymentLeft.addEventListener("click", closePayment);

  payMethods.forEach(btn => {
    btn.addEventListener('click', () => {
      payMethods.forEach(m => m.classList.remove("selected"));
      btn.classList.add("selected");
      const tipo = btn.dataset.method;
      loadPaymentForm(tipo);
    });
  });

  function loadPaymentForm(tipo) {
    if (!paySubmit || !payForm || !payTitle || !paySubtitle) return;
    paySubmit.style.display = "block";

    if (tipo === "visa" || tipo === "mastercard") {
      payTitle.textContent = `Pagamento com ${tipo.toUpperCase()}`;
      paySubtitle.textContent = "Preencha os dados do cartão:";
      payForm.innerHTML = `
        <label>Nome do titular</label>
        <input type="text" placeholder="Nome no cartão">

        <label>Número do cartão</label>
        <input type="text" maxlength="19" placeholder="0000 0000 0000 0000">

        <div class="row">
          <div>
            <label>Validade</label>
            <input type="text" maxlength="5" placeholder="MM/AA">
          </div>

          <div>
            <label>CVV</label>
            <input type="text" maxlength="4" placeholder="123">
          </div>
        </div>
      `;
    }

    if (tipo === "paypal") {
      payTitle.textContent = "Pagamento com PayPal";
      paySubtitle.textContent = "Informe o e-mail da conta:";
      payForm.innerHTML = `
        <label>E-mail</label>
        <input type="email" placeholder="email@exemplo.com">

        <label>Confirmar e-mail</label>
        <input type="email" placeholder="email@exemplo.com">
      `;
    }
  }

  if (paySubmit) {
    paySubmit.addEventListener("click", () => {
      if (paySuccess) paySuccess.style.display = "block";
      setTimeout(closePayment, 1500);
    });
  }

});
