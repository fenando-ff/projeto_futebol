cards = document.querySelectorAll('.card');
const tipo_socioText = document.getElementById('tipo_socioText');
const beneficioText = document.getElementById('beneficio-text');
const prev = document.getElementById('prev');
const next = document.getElementById('next');
const btnSocio = document.getElementById('btnSocio');
const popup = document.getElementById('popup');
const closePopup = document.getElementById('closePopup');


let current = -1;

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

  if(current === -1){
  beneficioText.innerText = "";
  tipo_socioText.textContent = "";
  return;
}

  beneficioText.classList.remove("info-enter","titulo-glow");
  tipo_socioText.classList.remove("info-enter","titulo-glow");

  void beneficioText.offsetWidth;

  beneficioText.innerText = beneficios[current];
  tipo_socioText.textContent = tipo_socio[current];

  beneficioText.classList.add("info-enter","titulo-glow");
  tipo_socioText.classList.add("info-enter","titulo-glow");

}
next.addEventListener('click', () => {

  if(current === -1){
    current = 0;
  } else {
    current = (current + 1) % cards.length;
  }

  updateCarousel();
});

prev.addEventListener('click', () => {

  if(current === -1){
    current = cards.length - 1;
  } else {
    current = (current - 1 + cards.length) % cards.length;
  }

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
    current = index
    updateCarousel()
  })
})

const cardsContainer = document.querySelector(".cards");

let scrollTimeout;

cardsContainer.addEventListener("scroll", () => {

  clearTimeout(scrollTimeout);

  scrollTimeout = setTimeout(() => {

    const containerCenter = cardsContainer.offsetWidth / 2;
    let closestIndex = 0;
    let closestDistance = Infinity;

    cards.forEach((card, index) => {

      const cardCenter =
        card.offsetLeft +
        card.offsetWidth / 2 -
        cardsContainer.scrollLeft;

      const distance = Math.abs(containerCenter - cardCenter);

      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = index;
      }

    });

    current = closestIndex;
    updateCarousel();

    cardsContainer.scrollTo({
      left:
        cards[closestIndex].offsetLeft -
        cardsContainer.offsetWidth / 2 +
        cards[closestIndex].offsetWidth / 2,
      behavior: "smooth",
    });

  }, 100);

});


updateCarousel();


