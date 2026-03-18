document.addEventListener("DOMContentLoaded", () => {
    const letters = document.querySelectorAll(".game-title span");
    const media = document.querySelector(".game-media");
    const button = document.querySelector(".start-button");
    const intro = document.querySelector(".game-intro");
    const video = document.getElementById("intro-video");

        window.addEventListener("load", () => {
            video.pause();

    const syncVideoToScroll = () => {
        const scrollTop = window.scrollY;
        const maxScroll = document.body.scrollHeight - window.innerHeight;

        if (video.duration && maxScroll > 0) {
            const progress = scrollTop / maxScroll;
            video.currentTime = progress * video.duration;
        }

        requestAnimationFrame(syncVideoToScroll);
    };

    syncVideoToScroll();
});

    if (!letters.length || !media || !button || !intro) return;

    gsap.set(letters, {
        opacity: 0,
        y: 120
    });

    gsap.set(media, {
        opacity: 0,
        scale: 0.85,
        y: 30
    });

    gsap.set(button, {
        opacity: 0,
        y: 25
    });

    gsap.set(intro, {
        opacity: 1
    });

    const tl = gsap.timeline();

    tl.to(letters, {
        opacity: 1,
        y: 0,
        stagger: 0.06,
        duration: 1.1,
        ease: "expo.out"
    })
    .to(media, {
        opacity: 1,
        scale: 1,
        y: 0,
        duration: 1.2,
        ease: "expo.out"
    }, "-=0.5")
    .to(button, {
        opacity: 1,
        y: 0,
        duration: 0.9,
        ease: "power4.out"
    }, "-=0.3");
});