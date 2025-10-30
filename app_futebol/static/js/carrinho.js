// ==========================
// CARRINHO.JS — DRAKO STORE
// ==========================

// ==========================================
// CARRINHO — Carregar itens do localStorage
// ==========================================
const listaCarrinho = document.querySelector(".carrinho");
const produtosSalvos = JSON.parse(localStorage.getItem("carrinhoDrako")) || [];

if (produtosSalvos.length > 0) {
  // Remove os itens de exemplo HTML (se existirem)
  const itensHTML = document.querySelectorAll(".item-carrinho");
  itensHTML.forEach(el => el.remove());

  // Adiciona produtos do localStorage
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
  // Se carrinho estiver vazio
  const vazio = document.createElement("p");
  vazio.textContent = "🛍️ Seu carrinho está vazio!";
  vazio.style.textAlign = "center";
  vazio.style.marginTop = "30px";
  listaCarrinho.appendChild(vazio);
}


// Seletores principais
const itensCarrinho = document.querySelectorAll('.item-carrinho');
const subtotalEl = document.querySelector('.bloco-resumo p:nth-child(3) span + span');
const descontoEl = document.querySelector('.bloco-resumo p:nth-child(4) span + span');
const totalEl = document.querySelector('.total span + span');

// Caso queira, pode definir um desconto fixo
let descontoFixo = 20.00; // R$20 de desconto, só pra exemplo

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

  // Atualiza os textos formatados
  document.querySelector('.bloco-resumo p:nth-child(3)').innerHTML = `<span>Subtotal:</span> R$${subtotal.toFixed(2)}`;
  document.querySelector('.bloco-resumo p:nth-child(4)').innerHTML = `<span>Desconto:</span> R$${desconto.toFixed(2)}`;
  document.querySelector('.total').innerHTML = `<span>Total:</span> R$${total.toFixed(2)}`;
}

// ==========================
// Controle de quantidade
// ==========================
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

// ==========================
// Remover item do carrinho
// ==========================
itensCarrinho.forEach(item => {
  const btnLixeira = item.querySelector('.lixeira');

  btnLixeira.addEventListener('click', () => {
    item.classList.add('removendo');
    item.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
    item.style.opacity = '0';
    item.style.transform = 'translateX(-20px)';

    setTimeout(() => {
      item.remove();
      atualizarTotais();
    }, 400);
  });
});

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

// ==========================
// Botão de pagamento
// ==========================
const btnPagamento = document.querySelector('.btn-pagamento');

btnPagamento.addEventListener('click', () => {
  const totalTexto = document.querySelector('.total').textContent;
  alert(`💳 Pagamento de ${totalTexto.replace('Total:', '').trim()} realizado com sucesso!\nObrigado por comprar na Drako Store!`);
});
