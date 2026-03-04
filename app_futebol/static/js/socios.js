const cards = document.querySelectorAll('.card');
const tipo_socioText = document.getElementById('tipo_socioText');
const beneficioText = document.getElementById('beneficio-text');
const prev = document.getElementById('prev');
const next = document.getElementById('next');
const btnSocio = document.getElementById('btnSocio');
const popup = document.getElementById('popup');
const closePopup = document.getElementById('closePopup');

let current = 0;

const tipo_socio = [
  "Prata",
  "Diamante",
  "Ouro"
];

const beneficios = [
  "5% de desconto em produtos oficiais \n10% de desconto em ingressos para jogos em casa \nAcesso antecipado a notícias e conteúdos exclusivos do clube",
  "Com o CRN CARD Preto você ganha ingressos com valores reduzidos e acesso exclusivo a eventos especiais.",
  "Com o CRN CARD Vermelho você tem todos os benefícios anteriores e brindes limitados durante a temporada."
];


function updateCarousel() {
  cards.forEach((card, index) => {
    card.classList.toggle('active', index === current);
  });
  beneficioText.textContent = beneficios[current];
    cards.forEach((card, index) => {
    card.classList.toggle('active', index === current);
  });
  tipo_socioText.textContent = tipo_socio[current];
}

next.addEventListener('click', () => {
  current = (current + 1) % cards.length;
  updateCarousel();
});

prev.addEventListener('click', () => {
  current = (current - 1 + cards.length) % cards.length;
  updateCarousel();
});

btnSocio.addEventListener('click', () => {
  popup.style.display = 'flex';
});

closePopup.addEventListener('click', () => {
  popup.style.display = 'none';
});

popup.addEventListener('click', (e) => {
  if (e.target === popup) popup.style.display = 'none';
});
