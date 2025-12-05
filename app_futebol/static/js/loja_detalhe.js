// ======================================================
// FUNÇÃO AUXILIAR: PEGAR CSRF TOKEN
// (Necessário para requisições POST com Django)
// ======================================================
function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}


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
// AÇÕES DOS BOTÕES
// ======================================================
const btnComprar = document.querySelector(".comprar");
// CORRIGIDO: Seleciona o botão de carrinho pela classe correta
const btnCarrinho = document.querySelector(".btn-adicionar"); 

btnComprar.addEventListener("click", () => {
    // Para 'Comprar agora', você deve idealmente fazer uma requisição AJAX também
    const produtoNome = document.querySelector(".titulo").textContent;
    alert(`✅ Compra do produto "${produtoNome}" confirmada! (Ainda não implementada)`);
});

// ======================================================
// ADICIONAR AO CARRINHO (AGORA COM AJAX)
// ======================================================
btnCarrinho.addEventListener("click", async (event) => {
    event.preventDefault(); // Impede qualquer ação padrão do botão
    
    // Pega o ID e o Nome do produto do HTML
    const produtoId = btnCarrinho.getAttribute("data-id");
    const produtoNome = document.querySelector(".titulo").textContent;
    
    try {
        const url = `/adicionar/${produtoId}/`;
        
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                // Envia o token CSRF para a segurança do Django
                'X-CSRFToken': getCookie('csrftoken') 
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            // Sucesso! O produto foi salvo no servidor (sessão/BD)
            mostrarMensagemCarrinho(`✓ Produto "${produtoNome}" adicionado ao carrinho!`, "sucesso");
        } else {
            // Mensagem de erro retornada pela view do Django
            mostrarMensagemCarrinho('Erro ao adicionar produto: ' + (data.message || 'Erro desconhecido.'), "erro");
        }
    } catch (error) {
        console.error('Erro na requisição AJAX:', error);
        mostrarMensagemCarrinho('Erro de conexão ao adicionar ao carrinho.', "erro");
    }
});

// ======================================================
// FUNÇÃO PARA MOSTRAR MENSAGEM ABAIXO DO BOTÃO
// ======================================================
function mostrarMensagemCarrinho(texto, tipo = "sucesso") {
    let msg = document.querySelector(".mensagem-carrinho");

    if (!msg) {
        msg = document.createElement("div");
        msg.classList.add("mensagem-carrinho");
        btnCarrinho.parentNode.appendChild(msg);
    }

    msg.textContent = texto;
    msg.className = `mensagem-carrinho ${tipo}`;
    msg.classList.add("mostrar");

    clearTimeout(msg.timeoutId);
    msg.timeoutId = setTimeout(() => {
        msg.classList.remove("mostrar");
    }, 3000);
}

// ======================================================
// ESTILOS E ANIMAÇÕES (adicionados via JS)
// ======================================================
// ... (Seus estilos permanecem os mesmos) ...
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