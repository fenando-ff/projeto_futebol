const wrapper = document.querySelector('.slides-wrapper');
const slides = document.querySelectorAll('.slide');

let currentIndex = 0;
let isScrolling = false;

function updateSlide() {
    wrapper.style.transform = `translateX(-${currentIndex * 100}%)`;
}

function nextSlide() {
    if (currentIndex < slides.length - 1) {
        currentIndex++;
    } else {
        currentIndex = 0;
    }
    updateSlide();
}

function prevSlide() {
    if (currentIndex > 0) {
        currentIndex--;
    } else {
        currentIndex = slides.length - 1;
    }
    updateSlide();
}

/* SCROLL CONTROL */
window.addEventListener('wheel', (e) => {

    if (isScrolling) return;
    isScrolling = true;

    if (e.deltaY > 0) {
        nextSlide();
    } else {
        prevSlide();
    }

    setTimeout(() => {
        isScrolling = false;
    }, 900);

});

/* SWIPE MOBILE */
let startX = 0;

wrapper.addEventListener('touchstart', (e) => {
    startX = e.touches[0].clientX;
});

wrapper.addEventListener('touchend', (e) => {
    let endX = e.changedTouches[0].clientX;
    let diff = startX - endX;

    if (diff > 50) {
        nextSlide();
    } else if (diff < -50) {
        prevSlide();
    }
});