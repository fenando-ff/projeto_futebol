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

    let offset = index - current;

    if (offset < -1) offset += cards.length;
    if (offset > 1) offset -= cards.length;

    if (offset === 0) {
      card.style.transform =
        "translate(-50%, -50%) scale(1.2) rotateY(0deg)";
      card.style.zIndex = 3;
      card.style.opacity = 1;
      card.style.filter = "brightness(1)";
    }

    else if (offset === -1) {
      card.style.transform =
        "translate(-160%, -50%) scale(0.9) rotateY(25deg)";
      card.style.zIndex = 2;
      card.style.opacity = 0.6;
      card.style.filter = "brightness(0.7)";
    }

    else if (offset === 1) {
      card.style.transform =
        "translate(60%, -50%) scale(0.9) rotateY(-25deg)";
      card.style.zIndex = 2;
      card.style.opacity = 0.6;
      card.style.filter = "brightness(0.7)";
    }

    else {
      card.style.opacity = 0;
      card.style.zIndex = 1;
    }

  });

  beneficioText.innerHTML = beneficios[current].replace(/\n/g, "<br>");
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

cards.forEach((card, index) => {
  card.addEventListener("click", () => {
    current = index;
    updateCarousel();
  });
});

updateCarousel();


let startX = 0;
let isDragging = false;

const carousel = document.querySelector(".carousel");

carousel.addEventListener("mousedown", (e) => {
  isDragging = true;
  startX = e.clientX;
});

carousel.addEventListener("mouseup", (e) => {
  if (!isDragging) return;
  isDragging = false;

  const diff = e.clientX - startX;

  if (diff > 50) {
    current = (current - 1 + cards.length) % cards.length;
  } 
  else if (diff < -50) {
    current = (current + 1) % cards.length;
  }

  updateCarousel();
});

carousel.addEventListener("mouseleave", () => {
  isDragging = false;
});