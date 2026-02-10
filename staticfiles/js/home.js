document.addEventListener("DOMContentLoaded", () => {
  const images = document.querySelectorAll(".carousel-img");
  const progressBar = document.querySelector(".progress-bar");
  const btnLeft = document.querySelector(".carousel-btn.left");
  const btnRight = document.querySelector(".carousel-btn.right");
  const carousel = document.querySelector(".hero-carousel");

  if (!images.length || !progressBar || !btnLeft || !btnRight || !carousel) return;

  let index = 0;
  const duration = 5000;
  let interval = null;

  function showSlide(i) {
    images.forEach(img => img.classList.remove("active"));
    images[i].classList.add("active");

    progressBar.style.transition = "none";
    progressBar.style.width = "0%";

    requestAnimationFrame(() => {
      progressBar.style.transition = `width ${duration}ms linear`;
      progressBar.style.width = "100%";
    });
  }

  function nextSlide() {
    index = (index + 1) % images.length;
    showSlide(index);
  }

  function start() {
    stop();
    interval = setInterval(nextSlide, duration);
  }

  function stop() {
    if (interval) clearInterval(interval);
    interval = null;
  }

  btnLeft.addEventListener("click", () => {
    index = (index - 1 + images.length) % images.length;
    showSlide(index);
    start();
  });

  btnRight.addEventListener("click", () => {
    index = (index + 1) % images.length;
    showSlide(index);
    start();
  });

  carousel.addEventListener("mouseenter", stop);
  carousel.addEventListener("mouseleave", start);

  showSlide(index);
  start();
});
