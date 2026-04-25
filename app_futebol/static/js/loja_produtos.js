console.log("JS LOJA CARREGOU 🔥");
const params = new URLSearchParams(window.location.search);
const modoJogo = params.get("modo") === "jogo";
const itensMissao = JSON.parse(localStorage.getItem("itens_sorteados")) || [];
JSON.parse(localStorage.getItem("itens_sorteados"))
localStorage.getItem("itens_sorteados")

 
document.addEventListener("DOMContentLoaded", () => {

  const missaoBox = document.getElementById("missao-box");
  const lista = document.getElementById("missao-list");

  if (modoJogo && missaoBox && lista) {

      console.log("MISSÃO ATIVADA ✅");

      missaoBox.style.display = "block";

    itensMissao.forEach(item => {
      item.id = Number(item.id); // 🔥 força número
      const li = document.createElement("li");

    li.dataset.nome = item.nome;
    li.innerHTML = `
        <div class="missao-item">
            <img src="/static/${item.img}" alt="${item.nome}">
            // <span>${item.nome}</span
        </div>
    `;


        li.dataset.id = Number(item.id);

    lista.appendChild(li);
      });
  }


const botoesAdicionar = document.querySelectorAll(".btn-adicionar");


    // 🎯 EFEITO 3D NOS CARDS
    const cards = document.querySelectorAll(".produto");

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

  



  
  
    
    
    // jog







botoesAdicionar.forEach(btn => {

    // 🎯 destaque visual dos itens da missão
    const produtoId = Number(btn.dataset.id);

    // if (modoJogo && itensMissao.some(i => Number(i.id) === produtoId)) {
    //     const card = btn.closest(".produto");

    //     if (card) {
    //         card.style.boxShadow = "0 0 15px gold";
    //         card.style.transform = "scale(1.02)";
        // }
    // }

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

                // 🎯 MARCAR MISSÃO COMO CONCLUÍDA
                if (modoJogo) {

                 const produtoIdNumber = Number(produtoId);
                  const li = document.querySelector(
                      `#missao-list li[data-id="${produtoIdNumber}"]`
                  );
                  

                    if (modoJogo && !itensMissao.some(i => i.id === produtoIdNumber)) {

                        const card = btn.closest(".produto");

                        if (card) {
                            card.classList.add("erro");

                            // remove depois pra poder repetir o efeito
                            setTimeout(() => {
                                card.classList.remove("erro");
                            }, 600);
                        }

                        return; // bloqueia ação
                    }




                    if (li && !li.classList.contains("concluido")) {
                        li.classList.add("concluido");
                    }
                }

                // 🎨 FEEDBACK VISUAL DO BOTÃO
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



