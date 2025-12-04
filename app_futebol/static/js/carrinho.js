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
  console.log('Itens encontrados:', itensCarrinho.length);

  itensCarrinho.forEach(item => {
    // Seleciona os botões CORRETAMENTE pela classe
    const btnMenos = item.querySelector('.btn-menos');
    const btnMais = item.querySelector('.btn-mais');
    const qtdEl = item.querySelector('.qtd'); // Encontra o <span class="qtd">
    const precoLinhaEl = item.querySelector('.preco-linha');
    
    // Extrai ID do produto do atributo data-id
    const id = item.getAttribute('data-id');

    console.log(`ID: ${id}, btnMenos: ${!!btnMenos}, btnMais: ${!!btnMais}, qtdEl: ${!!qtdEl}`);

    function postQuantidade(novaQtd) {
      if (!id) {
        console.error('ID não encontrado!');
        return;
      }
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
          if (!data.success) {
            console.error('Erro:', data);
            return;
          }

          if (novaQtd <= 0) {
            // Remove item do DOM se quantidade for 0
            item.remove();
          } else {
            // Atualiza quantidade no DOM
            if (qtdEl) {
              qtdEl.textContent = novaQtd;
            }
            
            // Atualiza preço da linha se existir
            if (precoLinhaEl && data.itens) {
              const itemServidor = data.itens.find(i => String(i.id) === String(id));
              if (itemServidor && itemServidor.subtotal) {
                precoLinhaEl.textContent = itemServidor.subtotal.toFixed(2);
              }
            }
          }

          // Atualiza resumo com dados do servidor
          atualizarResumo(data);
        })
        .catch(err => console.error('Erro na requisição:', err));
    }

    // Botão MAIS
    if (btnMais) {
      btnMais.addEventListener('click', (e) => {
        e.preventDefault();
        const valor = parseInt(qtdEl.textContent) + 1;
        console.log(`Clicou em MAIS: ${valor}`);
        postQuantidade(valor);
      });
    }

    // Botão MENOS
    if (btnMenos) {
      btnMenos.addEventListener('click', (e) => {
        e.preventDefault();
        const valor = parseInt(qtdEl.textContent) - 1;
        console.log(`Clicou em MENOS: ${valor}`);
        postQuantidade(valor);
      });
    }
  });

  // Função para atualizar resumo (subtotal, desconto, total)
  function atualizarResumo(data) {
    const subtotalEl = document.getElementById('subtotal');
    const descontoEl = document.getElementById('desconto');
    const descontoPercentEl = document.getElementById('desconto-percent');
    const totalEl = document.getElementById('total');

    if (subtotalEl) {
      const valorEl = subtotalEl.querySelector('.valor');
      if (valorEl) {
        valorEl.textContent = `R$${(data.total || 0).toFixed(2)}`;
      }
    }

    if (descontoEl) {
      const valorEl = descontoEl.querySelector('.valor');
      if (valorEl) {
        valorEl.textContent = `R$${(data.desconto || 0).toFixed(2)}`;
      }
      if (descontoPercentEl) {
        descontoPercentEl.textContent = `(${data.desconto_percent || 0}%)`;
      }
    }

    if (totalEl) {
      const valorEl = totalEl.querySelector('.valor');
      if (valorEl) {
        valorEl.textContent = `R$${(data.total_com_desconto || 0).toFixed(2)}`;
      }
    }
  }

  // remover via ícone lixeira
  const lixeiras = document.querySelectorAll('a.lixeira');
  lixeiras.forEach(link => {
    link.addEventListener('click', (e) => {
      e.preventDefault();
      const href = link.getAttribute('href');
      const m = href.match(/\/(\d+)\//);
      const id = m ? m[1] : null;
      if (!id) return;

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
            atualizarResumo(data);
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
