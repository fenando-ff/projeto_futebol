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

});
