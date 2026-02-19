document.addEventListener("DOMContentLoaded", () => {

    const images = document.querySelectorAll(".carousel-img");
    const progressBar = document.querySelector(".progress-bar");
    const btnLeft = document.querySelector(".carousel-btn.left");
    const btnRight = document.querySelector(".carousel-btn.right");

    let index = 0;
    let duration = 5000; // tempo de cada slide

    function showSlide(i) {
        images.forEach(img => img.classList.remove("active"));
        images[i].classList.add("active");

        // reiniciar barra
        progressBar.style.transition = "none";
        progressBar.style.width = "0%";

        setTimeout(() => {
            progressBar.style.transition = `width ${duration}ms linear`;
            progressBar.style.width = "100%";
        }, 50);
    }

    function nextSlide() {
        index = (index + 1) % images.length;
        showSlide(index);
    }

    let interval = setInterval(nextSlide, duration);

    // controles manuais
    btnLeft.addEventListener("click", () => {
        clearInterval(interval);
        index = (index - 1 + images.length) % images.length;
        showSlide(index);
        interval = setInterval(nextSlide, duration);
    });

    btnRight.addEventListener("click", () => {
        clearInterval(interval);
        index = (index + 1) % images.length;
        showSlide(index);
        interval = setInterval(nextSlide, duration);
    });

    // inicia o primeiro
    showSlide(index);

    document.addEventListener("DOMContentLoaded", () => {
  const carousel = document.getElementById("produtosCarousel");
  const dotsWrap = document.getElementById("produtosDots");
  const cards = document.querySelectorAll(".produtos-track .product-card");

  if (!carousel || !dotsWrap || !cards.length) return;

  // cria dots
  dotsWrap.innerHTML = "";
  const dots = Array.from(cards).map((_, i) => {
    const b = document.createElement("button");
    b.type = "button";
    b.setAttribute("aria-label", `Ir para produto ${i + 1}`);
    b.addEventListener("click", () => {
      cards[i].scrollIntoView({ behavior: "smooth", inline: "start", block: "nearest" });
    });
    dotsWrap.appendChild(b);
    return b;
  });

  function setActiveDot(index){
    dots.forEach(d => d.classList.remove("is-active"));
    if (dots[index]) dots[index].classList.add("is-active");
  }

  // ativa o primeiro
  setActiveDot(0);

  // atualiza dot conforme scroll
  const onScroll = () => {
    const left = carousel.scrollLeft;
    let best = 0;
    let bestDist = Infinity;

    cards.forEach((card, i) => {
      const dist = Math.abs(card.offsetLeft - left);
      if (dist < bestDist) {
        bestDist = dist;
        best = i;
      }
    });

    setActiveDot(best);
  };

  carousel.addEventListener("scroll", () => {
    window.requestAnimationFrame(onScroll);
  });
});


});
