const cards = document.querySelectorAll('.plano-card');

cards.forEach((card) => {

  card.addEventListener('click', (e) => {

    if (e.target.closest('.btn-plano')) return;

    cards.forEach((c) => c.classList.remove('active'));
    card.classList.add('active');

  });

});
