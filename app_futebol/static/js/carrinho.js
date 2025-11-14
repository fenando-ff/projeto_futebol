// ==========================
// CARRINHO.JS — DRAKO STORE
// ==========================

// ==========================================
// CARRINHO — Carregar itens do localStorage
// ==========================================
const listaCarrinho = document.querySelector(".carrinho");
const produtosSalvos = JSON.parse(localStorage.getItem("carrinhoDrako")) || [];

function montarCarrinho() {
  if (produtosSalvos.length > 0) {
    const itensHTML = document.querySelectorAll(".item-carrinho");
    itensHTML.forEach(el => el.remove());

    produtosSalvos.forEach((item) => {
      const itemHTML = document.createElement("div");
      itemHTML.classList.add("item-carrinho");
      itemHTML.innerHTML = `
        <img src="${item.imagem}" alt="${item.nome}">
        <div class="info-produto">
          <h3>${item.nome}</h3>
          <p>Tamanho: ${item.tamanho}</p>
        </div>
        <div class="quantidade">
          <button class="menos"><</button>
          <span>${item.quantidade}</span>
          <button class="mais">></button>
        </div>
        <div class="preco">R$${item.preco}</div>
        <button class="lixeira"><i class="fa-solid fa-trash"></i></button>
      `;

      listaCarrinho.appendChild(itemHTML);
    });
  } else {
    const vazio = document.createElement("p");
    vazio.textContent = "🛍️ Seu carrinho está vazio!";
    vazio.style.textAlign = "center";
    vazio.style.marginTop = "30px";
    listaCarrinho.appendChild(vazio);
  }
}

montarCarrinho();

// Atualiza a lista após montar HTML
let itensCarrinho = document.querySelectorAll('.item-carrinho');

const subtotalEl = document.querySelector('.bloco-resumo p:nth-child(3) span + span');
const descontoEl = document.querySelector('.bloco-resumo p:nth-child(4) span + span');
const totalEl = document.querySelector('.total span + span');

let descontoFixo = 20.00;

// ==========================
// Atualiza totais automaticamente
// ==========================
function atualizarTotais() {
  let subtotal = 0;

  itensCarrinho.forEach(item => {
    const precoTexto = item.querySelector('.preco').textContent.replace('R$', '').replace(',', '.');
    const precoUnitario = parseFloat(precoTexto) || 0;
    const quantidade = parseInt(item.querySelector('.quantidade span').textContent);
    subtotal += precoUnitario * quantidade;
  });

  const desconto = descontoFixo;
  const total = subtotal - desconto;

  document.querySelector('.bloco-resumo p:nth-child(3)').innerHTML =
    `<span>Subtotal:</span> R$${subtotal.toFixed(2)}`;

  document.querySelector('.bloco-resumo p:nth-child(4)').innerHTML =
    `<span>Desconto:</span> R$${desconto.toFixed(2)}`;

  document.querySelector('.total').innerHTML =
    `<span>Total:</span> R$${total.toFixed(2)}`;
}

// ==========================
// Controle de quantidade
// ==========================
function ativarControleQuantidade() {
  itensCarrinho.forEach(item => {
    const btnMenos = item.querySelector('.quantidade button:first-child');
    const btnMais = item.querySelector('.quantidade button:last-child');
    const qtdEl = item.querySelector('.quantidade span');

    btnMais.addEventListener('click', () => {
      let valor = parseInt(qtdEl.textContent);
      valor++;
      qtdEl.textContent = valor;
      atualizarTotais();
    });

    btnMenos.addEventListener('click', () => {
      let valor = parseInt(qtdEl.textContent);
      if (valor > 1) {
        valor--;
        qtdEl.textContent = valor;
        atualizarTotais();
      }
    });
  });
}

ativarControleQuantidade();

// ==========================
// Remover item do carrinho
// ==========================
function ativarRemocao() {
  itensCarrinho.forEach(item => {
    const btnLixeira = item.querySelector('.lixeira');

    btnLixeira.addEventListener('click', () => {
      item.classList.add('removendo');
      item.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
      item.style.opacity = '0';
      item.style.transform = 'translateX(-20px)';

      setTimeout(() => {
        item.remove();
        itensCarrinho = document.querySelectorAll('.item-carrinho');
        atualizarTotais();
      }, 400);
    });
  });
}

ativarRemocao();

// ==========================
// Efeito de entrada (fade-in)
// ==========================
window.addEventListener('load', () => {
  itensCarrinho.forEach((item, i) => {
    item.style.opacity = '0';
    item.style.transform = 'translateY(15px)';
    item.style.transition = 'all 0.4s ease';

    setTimeout(() => {
      item.style.opacity = '1';
      item.style.transform = 'translateY(0)';
    }, i * 100);
  });

  atualizarTotais();
});

// =========================
// POP-UP DE PAGAMENTO
// =========================
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

// =========================
// CORREÇÃO DO PROBLEMA
// =========================
// Impede que o botão envie o formulário
openPayment.addEventListener("click", (e) => {
  e.preventDefault();
  paymentOverlay.classList.add("show");
});

// fechar popup
function closePayment() {
  paymentOverlay.classList.remove("show");
  payForm.innerHTML = "";
  paySubmit.style.display = "none";
  paySuccess.style.display = "none";
  payMethods.forEach(m => m.classList.remove("selected"));
  payTitle.textContent = "Nenhuma forma selecionada";
  paySubtitle.textContent = "Escolha um método de pagamento.";
}

closePaymentRight.addEventListener("click", closePayment);
closePaymentLeft.addEventListener("click", closePayment);

// selecionar método
payMethods.forEach(btn => {
  btn.addEventListener("click", () => {
    payMethods.forEach(m => m.classList.remove("selected"));
    btn.classList.add("selected");

    const tipo = btn.dataset.method;
    loadPaymentForm(tipo);
  });
});

// carregar formulário
function loadPaymentForm(tipo) {
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

// confirmar pagamento
paySubmit.addEventListener("click", () => {
  paySuccess.style.display = "block";
  setTimeout(closePayment, 1500);
});
