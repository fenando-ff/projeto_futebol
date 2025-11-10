// --- INÍCIO - LÓGICA DO MODAL DA PÁGINA HISTÓRIA ---

// Espera o documento carregar para garantir que todos os elementos existam
document.addEventListener('DOMContentLoaded', () => {

  // Seleciona todos os elementos necessários
  const cardsHistoria = document.querySelectorAll('.card-historia');
  const modalOverlay = document.getElementById('historia-modal-overlay');
  
  // É importante verificar se os elementos existem na página atual
  // Isso evita erros em outras páginas que usam o mesmo 'main.js'
  if (cardsHistoria.length > 0 && modalOverlay) {
    
    const modalCloseBtn = document.getElementById('historia-modal-close');
    const modalImg = document.getElementById('historia-modal-img');
    const modalTitle = document.getElementById('historia-modal-title');
    const modalDesc = document.getElementById('historia-modal-desc');

    // Função para abrir o modal
    function abrirModal(card) {
      // 1. Pega os dados do card que foi clicado
      const imgSrc = card.dataset.imageSrc; // Pega do 'data-image-src'
      const title = card.querySelector('.card-historia-titulo').textContent;
      const desc = card.querySelector('.card-historia-descricao').textContent;

      // 2. Alimenta o modal com esses dados
      modalImg.src = imgSrc;
      modalImg.alt = title; // Boa prática de acessibilidade
      modalTitle.textContent = title;
      modalDesc.textContent = desc;

      // 3. Mostra o modal
      modalOverlay.classList.add('active');
    }

    // Função para fechar o modal
    function fecharModal() {
      modalOverlay.classList.remove('active');
    }

    // Adiciona o 'escutador' de clique para cada card
    cardsHistoria.forEach(card => {
      card.addEventListener('click', (event) => {
        event.preventDefault(); // Impede que o link '#' mude a URL
        abrirModal(card);
      });
    });

    // Adiciona o 'escutador' de clique para o botão 'X'
    modalCloseBtn.addEventListener('click', fecharModal);

    // Adiciona o 'escutador' de clique para o fundo (overlay)
    // Isso permite fechar o modal clicando fora da caixa branca
    modalOverlay.addEventListener('click', (event) => {
      // Verifica se o clique foi no fundo (overlay) e não no conteúdo
      if (event.target === modalOverlay) {
        fecharModal();
      }
    });

  } // Fim do 'if' que verifica se os elementos existem

});

// --- FIM - LÓGICA DO MODAL DA PÁGINA HISTÓRIA ---