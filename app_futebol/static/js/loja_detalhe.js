// ======================================================
// GALERIA DE IMAGENS
// ======================================================
const imagemPrincipal = document.querySelector(".imagem-principal");
const miniaturas = document.querySelectorAll(".miniaturas img");

function trocarImagem(novaSrc) {
  imagemPrincipal.classList.add("fade-out");

  setTimeout(() => {
    imagemPrincipal.src = novaSrc;
    imagemPrincipal.classList.remove("fade-out");
    imagemPrincipal.classList.add("fade-in");

    setTimeout(() => imagemPrincipal.classList.remove("fade-in"), 300);
  }, 250);
}

miniaturas.forEach((thumb) => {
  thumb.addEventListener("click", () => {
    trocarImagem(thumb.src);
    miniaturas.forEach((img) => img.classList.remove("ativa"));
    thumb.classList.add("ativa");
  });
});

// ======================================================
// SELEÇÃO DE TAMANHO
// ======================================================
const botoesTamanho = document.querySelectorAll(".botoes-tamanho button");
let tamanhoSelecionado = null;

botoesTamanho.forEach((btn) => {
  btn.addEventListener("click", () => {
    botoesTamanho.forEach((b) => b.classList.remove("ativo"));
    btn.classList.add("ativo");
    tamanhoSelecionado = btn.textContent;
  });
});

// ======================================================
// AÇÕES DOS BOTÕES
// ======================================================
const btnComprar = document.querySelector(".comprar");
const btnCarrinho = document.querySelector(".carrinho");

btnComprar.addEventListener("click", () => {
  if (!tamanhoSelecionado) {
    mostrarMensagemCarrinho("⚠️ Selecione um tamanho antes de comprar!", "erro");
    return;
  }

  alert(`✅ Compra do tamanho ${tamanhoSelecionado} confirmada!`);
});

// ======================================================
// ADICIONAR AO CARRINHO (com mensagens animadas)
// ======================================================
btnCarrinho.addEventListener("click", () => {
  if (!tamanhoSelecionado) {
    mostrarMensagemCarrinho("⚠️ Selecione um tamanho antes de adicionar ao carrinho!", "erro");
    return;
  }

  const produto = {
    nome: document.querySelector(".titulo").textContent,
    preco: document.querySelector(".preco").textContent,
    tamanho: tamanhoSelecionado,
    imagem: imagemPrincipal.src,
    quantidade: 1
  };

  const carrinho = JSON.parse(localStorage.getItem("carrinho")) || [];

  const produtoExistente = carrinho.find(
    (item) => item.nome === produto.nome && item.tamanho === produto.tamanho
  );

  let mensagemTexto = "";

    // alteracao feita, caso produto existente so trocar a legenda
  if (produtoExistente) {
    carrinho.push(produto);
    mensagemTexto = " Produto adicionado ao carrinho!";
  } else {
    carrinho.push(produto);
    mensagemTexto = " Produto já adcionado ao carrinho!!!";
  }

  localStorage.setItem("carrinho", JSON.stringify(carrinho));

  mostrarMensagemCarrinho(mensagemTexto, "sucesso");
});

// ======================================================
// FUNÇÃO PARA MOSTRAR MENSAGEM ABAIXO DO BOTÃO
// ======================================================
function mostrarMensagemCarrinho(texto, tipo = "sucesso") {
  let msg = document.querySelector(".mensagem-carrinho");

  // Se ainda não existe a div, cria
  if (!msg) {
    msg = document.createElement("div");
    msg.classList.add("mensagem-carrinho");
    btnCarrinho.parentNode.appendChild(msg);
  }

  // Define a cor de acordo com o tipo
  msg.textContent = texto;
  msg.className = `mensagem-carrinho ${tipo}`;
  msg.classList.add("mostrar");

  // Remove a mensagem após 3 segundos
  clearTimeout(msg.timeoutId);
  msg.timeoutId = setTimeout(() => {
    msg.classList.remove("mostrar");
  }, 3000);
}

// ======================================================
// ESTILOS E ANIMAÇÕES (adicionados via JS)
// ======================================================
const style = document.createElement("style");
style.textContent = `
  .fade-out {
    opacity: 0;
    transform: scale(0.97);
    transition: opacity 0.25s ease, transform 0.25s ease;
  }

  .fade-in {
    opacity: 1;
    transform: scale(1);
    transition: opacity 0.3s ease, transform 0.3s ease;
  }

  .miniaturas img.ativa {
    border: 2px solid #e72a2a;
    transform: scale(1.05);
  }

  .botoes-tamanho button.ativo {
    border-color: #e72a2a;
    color: #e72a2a;
    font-weight: 600;
  }

  /* MENSAGEM ABAIXO DO BOTÃO */
  .mensagem-carrinho {
    text-align: center;
    font-weight: 600;
    margin-top: 10px;
    opacity: 0;
    transform: translateY(5px);
    transition: all 0.4s ease;
  }

  .mensagem-carrinho.mostrar {
    opacity: 1;
    transform: translateY(0);
  }

  .mensagem-carrinho.sucesso {
    color:rgb(188, 153, 0);
  }

  .mensagem-carrinho.erro {
    color: #dc2626;
  }
`;
document.head.appendChild(style);
