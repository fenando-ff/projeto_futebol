document.addEventListener("DOMContentLoaded", () => {
  const cards = document.querySelectorAll(".produto-card");
  cards.forEach(card => {

  card.addEventListener("mousemove", (e) => {

    const rect = card.getBoundingClientRect();

    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const centerX = rect.width / 2;
    const centerY = rect.height / 2;

    const rotateX = (y - centerY) / 15;
    const rotateY = (centerX - x) / 15;

    card.style.transform =
      `rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.05)`;

  });

  card.addEventListener("mouseleave", () => {

    card.style.transform =
      "rotateX(0) rotateY(0) scale(1)";

  });

});


  







  // ======= CARROSSEL AUTOMÁTICO DO BANNER =======
  let currentBanner = 0;
  const bannerSlides = document.querySelectorAll(".banner-slide");

  if (bannerSlides.length > 0) {
    const totalBannerSlides = bannerSlides.length;

    setInterval(() => {
      bannerSlides[currentBanner].classList.remove("active");

      currentBanner = (currentBanner + 1) % totalBannerSlides;

      bannerSlides[currentBanner].classList.add("active");
    }, 5000);
  }


  // ======= CARROSSEL MANUAL DA TEMPORADA =======
  let currentSeasonSlide = 0;
  const seasonSlides = document.querySelectorAll(".season-slide");
  const nextButton = document.querySelector(".next-slide");

  let isSliding = false;

  if (nextButton && seasonSlides.length > 0) {

    nextButton.addEventListener("click", () => {

      if (isSliding) return;
      isSliding = true;

      const current = seasonSlides[currentSeasonSlide];
      const nextIndex = (currentSeasonSlide + 1) % seasonSlides.length;
      const next = seasonSlides[nextIndex];

      seasonSlides.forEach(s => s.classList.remove("exit-left"));

      current.classList.remove("active");
      current.classList.add("exit-left");

      next.style.left = "100%";
      next.classList.add("active");

      requestAnimationFrame(() => {
        next.style.left = "0";
      });

      setTimeout(() => {
        current.classList.remove("exit-left");
        isSliding = false;
      }, 600);

      currentSeasonSlide = nextIndex;

    });

  }


  // ======= CARROSSEL DE PRODUTOS =======
  const carrosseis = document.querySelectorAll(".carrossel-produtos");

  carrosseis.forEach(carro => {

    const btnPrev = carro.querySelector(".btn-prev");
    const btnNext = carro.querySelector(".btn-next");
    const flex = carro.querySelector(".flex");

    if (!flex) return;

    if (btnPrev) {
      btnPrev.addEventListener("click", () => {
        flex.scrollBy({
          left: -flex.clientWidth * 0.8,
          behavior: "smooth"
        });
      });
    }

    if (btnNext) {
      btnNext.addEventListener("click", () => {
        flex.scrollBy({
          left: flex.clientWidth * 0.8,
          behavior: "smooth"
        });
      });
    }

  });


  // ======= FUNÇÃO PEGAR CSRF =======
  function getCookie(name) {
    let cookieValue = null;

    if (document.cookie && document.cookie !== "") {

      const cookies = document.cookie.split(";");

      for (let i = 0; i < cookies.length; i++) {

        const cookie = cookies[i].trim();

        if (cookie.substring(0, name.length + 1) === (name + "=")) {

          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;

        }

      }

    }

    return cookieValue;
  }


  // ======= ADICIONAR AO CARRINHO =======
  const botoesAdicionar = document.querySelectorAll(".btn-adicionar");

  botoesAdicionar.forEach(btn => {

    btn.addEventListener("click", async (e) => {

      e.preventDefault();

      const produtoId = btn.dataset.id;
      const produtoNome = btn.dataset.nome;

      try {

        const response = await fetch(`/adicionar/${produtoId}/`, {
          method: "POST",
          headers: {
            "X-Requested-With": "XMLHttpRequest",
            "X-CSRFToken": getCookie("csrftoken")
          }
        });

        const data = await response.json();

        if (data.success) {

          const originalText = btn.textContent;

          btn.textContent = '✓ Adicionado!';
          btn.classList.add("added");

          setTimeout(() => {

          btn.textContent = originalText;
          btn.classList.remove("added");

          }, 2000);

        } else {

          alert("Erro ao adicionar produto: " + data.message);

        }

      } catch (error) {

        console.error("Erro:", error);
        alert("Erro ao adicionar produto ao carrinho");

      }

      

    });

  });

});


