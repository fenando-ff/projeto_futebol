cards = document.querySelectorAll('.plano-card');

const btnSocio = document.getElementById('btnSocio');

cards.forEach((card, index) => {

  card.addEventListener('click', (e) => {

    if (e.target.closest('.btn-plano')) return;

    cards.forEach((c) => c.classList.remove('active'));
    card.classList.add('active');

  });

});

btnSocio.addEventListener('click', () => {

  const first = cards[0];
  if (first) {
    cards.forEach((c) => c.classList.remove('active'));
    first.classList.add('active');
  }

});