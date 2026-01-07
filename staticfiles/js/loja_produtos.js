// ======= CARROSSEL AUTOMÁTICO DO BANNER =======
let currentBanner = 0;
const bannerSlides = document.querySelectorAll(".banner-slide");
const totalBannerSlides = bannerSlides.length;

setInterval(() => {
  // Remove ativo do slide atual
  bannerSlides[currentBanner].classList.remove("active");
  
  // Avança para o próximo slide (ou volta ao primeiro)
  currentBanner = (currentBanner + 1) % totalBannerSlides;
  
  // Adiciona ativo no novo slide
  bannerSlides[currentBanner].classList.add("active");
}, 5000); // troca a cada 5 segundos








// ======= CARROSSEL MANUAL DA TEMPORADA =======
// ======= CARROSSEL MANUAL DA TEMPORADA (com deslizamento) =======
let currentSeasonSlide = 0;
const seasonSlides = document.querySelectorAll('.season-slide');
const nextButton = document.querySelector('.next-slide');
let isSliding = false; // evita clique duplo rápido

nextButton.addEventListener('click', () => {
  if (isSliding) return;
  isSliding = true;

  const current = seasonSlides[currentSeasonSlide];
  const nextIndex = (currentSeasonSlide + 1) % seasonSlides.length;
  const next = seasonSlides[nextIndex];

  // Reseta classes
  seasonSlides.forEach(s => s.classList.remove('exit-left'));

  // Slide atual sai para a esquerda
  current.classList.remove('active');
  current.classList.add('exit-left');

  // Slide seguinte entra da direita
  next.style.left = '100%';
  next.classList.add('active');

  // Pequeno delay para a transição ocorrer
  requestAnimationFrame(() => {
    next.style.left = '0';
  });

  // Após a animação, limpa estados antigos
  setTimeout(() => {
    current.classList.remove('exit-left');
    isSliding = false;
  }, 600);

  currentSeasonSlide = nextIndex;
});






const carrossel = document.querySelectorAll('.carrossel-produtos');
carrossel.forEach(carro => {
  const btnPrev = carro.querySelector('.btn-prev');
  const btnNext = carro.querySelector('.btn-next');
  const flex = carro.querySelector('.flex');

  btnPrev.addEventListener('click', () => {
    flex.scrollBy({ left: -300, behavior: 'smooth' });
  });

  btnNext.addEventListener('click', () => {
    flex.scrollBy({ left: 300, behavior: 'smooth' });
  });
});

// ======= ADICIONAR AO CARRINHO SEM RELOAD =======
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

document.addEventListener('DOMContentLoaded', () => {
  const botoesAdicionar = document.querySelectorAll('.btn-adicionar');
  console.log('Botões encontrados:', botoesAdicionar.length);
  
  botoesAdicionar.forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      
      const produtoId = btn.getAttribute('data-id');
      const produtoNome = btn.getAttribute('data-nome');
      
      console.log('Clicou em:', produtoNome, 'ID:', produtoId);
      
      try {
        const url = `/adicionar/${produtoId}/`;
        console.log('URL:', url);
        
        const response = await fetch(url, {
          method: 'POST',
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRFToken': getCookie('csrftoken')
          }
        });
        
        console.log('Response status:', response.status);
        const data = await response.json();
        console.log('Resposta do servidor:', data);
        
        if (data.success) {
          console.log('Sucesso! Atualizando botão:', btn);
          // Mostra feedback visual
          const originalText = btn.textContent.trim();
          const originalBg = btn.style.backgroundColor;
          btn.textContent = '✓ Adicionado!';
          btn.style.backgroundColor = '#28a745';
          console.log('Botão atualizado para:', btn.textContent);
          
          setTimeout(() => {
            btn.textContent = originalText;
            btn.style.backgroundColor = originalBg;
            console.log('Botão revertido para:', originalText);
          }, 2000);
        } else {
          console.log('Erro na resposta:', data.message);
          alert('Erro ao adicionar produto: ' + data.message);
        }
      } catch (error) {
        console.error('Erro:', error);
        alert('Erro ao adicionar produto ao carrinho');
      }
    });
  });
});
