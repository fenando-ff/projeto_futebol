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
