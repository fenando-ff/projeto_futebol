document.addEventListener("DOMContentLoaded", () => {

    /* =========================================================
       CARROSSEL HERO
    ========================================================= */

    const images = document.querySelectorAll(".carousel-img");
    const progressBar = document.querySelector(".progress-bar");
    const btnLeft = document.querySelector(".carousel-btn.left");
    const btnRight = document.querySelector(".carousel-btn.right");

    if (images.length && progressBar) {

        let index = 0;
        const duration = 5000;

        function showSlide(i) {

            images.forEach(img => {
                img.classList.remove("active");
            });

            images[i].classList.add("active");


            // Reinicia a barra
            progressBar.style.transition = "none";
            progressBar.style.width = "0%";


            setTimeout(() => {

                progressBar.style.transition =
                    `width ${duration}ms linear`;

                progressBar.style.width = "100%";

            }, 50);
        }


        function nextSlide() {

            index = (index + 1) % images.length;

            showSlide(index);
        }


        let interval = setInterval(nextSlide, duration);


        /* BOTÃO ESQUERDO */

        if (btnLeft) {

            btnLeft.addEventListener("click", () => {

                clearInterval(interval);

                index =
                    (index - 1 + images.length) % images.length;

                showSlide(index);

                interval =
                    setInterval(nextSlide, duration);

            });

        }


        /* BOTÃO DIREITO */

        if (btnRight) {

            btnRight.addEventListener("click", () => {

                clearInterval(interval);

                index =
                    (index + 1) % images.length;

                showSlide(index);

                interval =
                    setInterval(nextSlide, duration);

            });

        }


        // Inicia primeiro slide
        showSlide(index);
    }



    /* =========================================================
       CARROSSEL DE PRODUTOS
    ========================================================= */

    const carousel =
        document.getElementById("produtosCarousel");

    const dotsWrap =
        document.getElementById("produtosDots");

    const cards =
        document.querySelectorAll(
            ".produtos-track .product-card"
        );


    if (carousel && dotsWrap && cards.length) {

        dotsWrap.innerHTML = "";


        /* Criar dots */

        const dots =
            Array.from(cards).map((_, i) => {

                const button =
                    document.createElement("button");

                button.type = "button";

                button.setAttribute(
                    "aria-label",
                    `Ir para produto ${i + 1}`
                );


                button.addEventListener("click", () => {

                    cards[i].scrollIntoView({

                        behavior: "smooth",

                        inline: "start",

                        block: "nearest"

                    });

                });


                dotsWrap.appendChild(button);

                return button;

            });


        /* Ativar dot */

        function setActiveDot(index) {

            dots.forEach(dot => {

                dot.classList.remove("is-active");

            });


            if (dots[index]) {

                dots[index].classList.add(
                    "is-active"
                );

            }

        }


        setActiveDot(0);


        /* Detectar posição */

        function onScroll() {

            const left = carousel.scrollLeft;

            let best = 0;
            let bestDist = Infinity;


            cards.forEach((card, i) => {

                const dist =
                    Math.abs(
                        card.offsetLeft - left
                    );


                if (dist < bestDist) {

                    bestDist = dist;

                    best = i;

                }

            });


            setActiveDot(best);
        }


        carousel.addEventListener("scroll", () => {

            window.requestAnimationFrame(
                onScroll
            );

        });

    }



    /* =========================================================
       DRAKOS APP
    ========================================================= */

    const iphoneCard =
        document.querySelector(".iphone-card");

    const iphoneFrame =
        document.querySelector(".iphone-frame");

    const splash =
        document.querySelector(".app-splash");

    const appHome =
        document.querySelector(".app-home");

    const notification =
        document.querySelector(".app-notification");


    /* =========================================================
       CONTROLE DA NOTIFICAÇÃO
    ========================================================= */

    let notificationTimer;
    let notificationDelay;


    /* =========================================================
       ENTRAR NO IPHONE
    ========================================================= */

    if (iphoneCard) {

        iphoneCard.addEventListener("mouseenter", () => {

            /*
                A troca Splash → Vitrine
                é feita pelo CSS :hover.

                Aqui controlamos apenas
                a notificação.
            */


            clearTimeout(notificationTimer);

            clearTimeout(notificationDelay);


            if (notification) {

                /*
                    Espera a animação da
                    vitrine começar
                */

                notificationDelay =
                    setTimeout(() => {

                        notification.classList.add(
                            "show"
                        );


                        /*
                            Depois de 2.5 segundos
                            a notificação desaparece
                        */

                        notificationTimer =
                            setTimeout(() => {

                                notification.classList.remove(
                                    "show"
                                );

                            }, 2500);


                    }, 700);

            }

        });



        /* =====================================================
           SAIR DO IPHONE
        ===================================================== */

        iphoneCard.addEventListener("mouseleave", () => {

            clearTimeout(notificationTimer);

            clearTimeout(notificationDelay);


            /*
                Remove imediatamente
                a notificação
            */

            if (notification) {

                notification.classList.remove(
                    "show"
                );

            }


            /*
                Volta posição do iPhone
            */

            if (iphoneFrame) {

                iphoneFrame.style.transform = `
                    rotateX(0deg)
                    rotateY(0deg)
                    translateY(0px)
                `;

            }

        });

    }



    /* =========================================================
       EFEITO 3D DO IPHONE
    ========================================================= */

    if (iphoneCard && iphoneFrame) {

        iphoneCard.addEventListener(
            "mousemove",
            (event) => {

                const rect =
                    iphoneCard.getBoundingClientRect();


                /*
                    Posição do mouse
                    dentro do elemento
                */

                const mouseX =
                    event.clientX - rect.left;

                const mouseY =
                    event.clientY - rect.top;


                /*
                    Centro do iPhone
                */

                const centerX =
                    rect.width / 2;

                const centerY =
                    rect.height / 2;


                /*
                    Calcula rotação
                */

                const rotateY =
                    (
                        (mouseX - centerX)
                        / centerX
                    ) * 9;


                const rotateX =
                    (
                        (centerY - mouseY)
                        / centerY
                    ) * 7;


                /*
                    Aplica movimento
                */

                iphoneFrame.style.transform = `
                    rotateX(${rotateX}deg)
                    rotateY(${rotateY}deg)
                    translateY(-6px)
                `;

            }
        );

    }

});