// ==========================
// CARRINHO.JS — DRAKO STORE
/* carrinho.js — AJAX-friendly cart
   - Usa fetch() para POST /atualizar/<id>/ com header X-Requested-With
   - Atualiza quantidades e o resumo (.bloco-resumo) com os valores retornados pelo servidor
   - Mantém apenas UX (popup e animações) client-side
*/
const params = new URLSearchParams(window.location.search);



function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

document.addEventListener('DOMContentLoaded', () => {
  const itensCarrinho = document.querySelectorAll('.item-carrinho');
  console.log('Itens encontrados:', itensCarrinho.length);





  const modoJogo = params.get("modo") === "jogo";
  const pagamentoNormal = document.getElementById("pagamento-normal");
  const pagamentoJogo = document.getElementById("pagamento-jogo");

if (modoJogo) {
    if (pagamentoNormal) pagamentoNormal.style.display = "none";
    if (pagamentoJogo) pagamentoJogo.style.display = "block";
}


  if (modoJogo) {
      document.querySelectorAll(".btn-mais, .btn-menos, .lixeira").forEach(el => {
          el.style.display = "none";
      });
  }

  if (modoJogo) {
      document.querySelectorAll(".qtd").forEach(qtd => {
          qtd.textContent = "1";
      });
  }

  if (modoJogo) {
      document.body.classList.add("modo-jogo");
  }












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

  // ========== INÍCIO: BLOCO DE POP-UP DE PAGAMENTO ========== 
  // Controla todo o fluxo de pagamento:
  // - Abre o modal ao clicar em "Escolher forma de pagamento"
  // - Permite seleção entre Visa, Mastercard e PayPal
  // - Exibe formulários específicos para cada método
  // - Submete dados para /finalizar_compra/
  // =========================================================
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

  // LISTENER: Evento de clique nos métodos de pagamento
  // Ao selecionar um método, chama loadPaymentForm() para renderizar formulário específico
  payMethods.forEach(btn => {
    btn.addEventListener('click', () => {
      payMethods.forEach(m => m.classList.remove("selected"));
      btn.classList.add("selected");
      const tipo = btn.dataset.method;
      loadPaymentForm(tipo);
    });
  });

  // FUNÇÃO: loadPaymentForm(tipo)
  // Renderiza dinamicamente o formulário de pagamento de acordo com método selecionado
  // Parâmetro: tipo = 'visa' | 'mastercard' | 'paypal'
  // Ação: Modifica innerHTML de #payForm, altera textos de title/subtitle e exibe botão submit
  // FORMULÁRIO VISA/MASTERCARD: Nome titular, número cartão (19 dígitos), validade MM/AA, CVV
  // FORMULÁRIO PAYPAL: Email da conta e confirmação de email
  function loadPaymentForm(tipo) {
    if (!paySubmit || !payForm || !payTitle || !paySubtitle) return;
    paySubmit.style.display = "block";

    // Formulário para cartões de crédito (Visa/Mastercard)
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

    // Formulário para PayPal
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

  // LISTENER: Submissão do formulário de pagamento (botão #paySubmit)
  // Ação: Envia POST para /finalizar_compra/ com dados da compra
  // Comportamento:
  //   1. Desabilita botão durante processamento (evita cliques múltiplos)
  //   2. Exibe "Processando..." enquanto aguarda resposta do servidor
  //   3. Se sucesso (dados.sucesso === true): Exibe mensagem de aprovação e redireciona em 2s
  //   4. Se erro: Exibe alerta e reabilita botão para nova tentativa
  // FUNÇÃO: Submissão do formulário de pagamento
  // Envia dados para a API /finalizar_compra/
  if (paySubmit) {
    paySubmit.addEventListener("click", () => {
      // Desabilita o botão para evitar cliques múltiplos
      paySubmit.disabled = true;
      paySubmit.textContent = 'Processando...';
      
      // Chama a API para finalizar a compra
      fetch('/finalizar_compra/', {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRFToken': getCookie('csrftoken') || ''
        },
        credentials: 'same-origin'
      })
      .then(resposta => resposta.json())
      .then(dados => {
        if (dados.sucesso) {
          // Mostra mensagem de sucesso
          if (paySuccess) {
            paySuccess.textContent = 'Pagamento aprovado! Pedido #' + dados.pedido_id;
            paySuccess.style.display = "block";
          }
          
          // Redireciona após 2 segundos
          setTimeout(() => {
            window.location.href = '/';
          }, 2000);
        } else {
          // Mostra mensagem de erro
          alert('Erro: ' + dados.mensagem);
          paySubmit.disabled = false;
          paySubmit.textContent = 'Confirmar Pagamento';
        }
      })
      .catch(erro => {
        console.error('Erro ao finalizar compra:', erro);
        alert('Erro ao processar o pagamento. Tente novamente.');
        paySubmit.disabled = false;
        paySubmit.textContent = 'Confirmar Pagamento';
      });
    });
  }
  // ========== FIM: BLOCO DE POP-UP DE PAGAMENTO ==========






  const btnPagamentoGame = document.getElementById("btnPagamentoGame");
  const gamePaymentOverlay = document.getElementById('gamePaymentOverlay');
  const gamePaymentConfirm = document.getElementById('gamePaymentConfirm');
  const gamePaymentCancel = document.getElementById('gamePaymentCancel');
  const gameCardHolder = document.getElementById('gameCardHolder');
  const gameCardNumber = document.getElementById('gameCardNumber');
  const gameCardExpiry = document.getElementById('gameCardExpiry');
  const gameCardCvv = document.getElementById('gameCardCvv');
  const gamePaymentError = document.getElementById('gamePaymentError');
  const gamePreviewNumber = document.getElementById('gamePreviewNumber');

  const expectedCardPrefix = gamePreviewNumber
    ? gamePreviewNumber.textContent.replace(/\s+/g, '').slice(0, 4)
    : '5319';

  function showGamePaymentError(message) {
    if (!gamePaymentError) return;
    gamePaymentError.textContent = message;
    gamePaymentError.style.display = message ? 'block' : 'none';
  }

  function validateGamePaymentForm() {
    const cardHolder = gameCardHolder?.value.trim() || '';
    const cardNumber = (gameCardNumber?.value || '').replace(/\s+/g, '');
    const expiry = gameCardExpiry?.value.trim() || '';
    const cvv = (gameCardCvv?.value || '').trim();

    if (!cardHolder) {
      showGamePaymentError('Nome do titular é obrigatório.');
      return false;
    }

    if (!cardNumber.startsWith(expectedCardPrefix)) {
      showGamePaymentError('Use as informações do cartão exibido para continuar.');
      return false;
    }

    if (!/^[0-9]{3,4}$/.test(cvv)) {
      showGamePaymentError('CVV deve ter 3 ou 4 dígitos.');
      return false;
    }

    if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) {
      showGamePaymentError('Validade deve estar no formato MM/AA.');
      return false;
    }

    return true;
  }

  function openGamePaymentModal() {
    if (!gamePaymentOverlay) return;
    gamePaymentOverlay.style.display = 'flex';
    gamePaymentOverlay.classList.add('visible');
    showGamePaymentError('');
    if (gamePaymentConfirm) {
      gamePaymentConfirm.disabled = false;
      gamePaymentConfirm.textContent = 'Confirmar';
    }
  }

  function closeGamePaymentModal() {
    if (!gamePaymentOverlay) return;
    gamePaymentOverlay.style.display = 'none';
    gamePaymentOverlay.classList.remove('visible');
    showGamePaymentError('');
  }

  if (gamePaymentOverlay) {
    gamePaymentOverlay.addEventListener('click', (event) => {
      if (event.target === gamePaymentOverlay) {
        closeGamePaymentModal();
      }
    });
  }

  if (gamePaymentCancel) {
    gamePaymentCancel.addEventListener('click', closeGamePaymentModal);
  }

  if (gamePaymentConfirm) {
    gamePaymentConfirm.addEventListener('click', () => {
      showGamePaymentError('');
      if (!validateGamePaymentForm()) {
        return;
      }

      gamePaymentConfirm.disabled = true;
      gamePaymentConfirm.textContent = 'Processando...';

      fetch('/finalizar_compra/', {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRFToken': getCookie('csrftoken') || ''
        },
        credentials: 'same-origin'
      })
        .then(r => r.json())
        .then(data => {
          if (data.sucesso) {
            closeGamePaymentModal();
            btnPagamentoGame.textContent = 'MISSÃO CONCLUÍDA ✅';

            setTimeout(() => {
              window.location.href = '/';
            }, 2000);
          } else {
            showGamePaymentError(data.mensagem || 'Erro ao finalizar a missão.');
            gamePaymentConfirm.disabled = false;
            gamePaymentConfirm.textContent = 'Confirmar';
          }
        })
        .catch(() => {
          showGamePaymentError('Erro na missão. Tente novamente.');
          gamePaymentConfirm.disabled = false;
          gamePaymentConfirm.textContent = 'Confirmar';
        });
    });
  }

  if (modoJogo && btnPagamentoGame) {
    btnPagamentoGame.addEventListener('click', openGamePaymentModal);
  }

});