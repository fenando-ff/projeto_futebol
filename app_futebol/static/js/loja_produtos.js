console.log("JS LOJA CARREGOU 🔥");
const params = new URLSearchParams(window.location.search);
const modoJogo = params.get("modo") === "jogo";
const itensMissao = JSON.parse(localStorage.getItem("itens_sorteados")) || [];

document.addEventListener("DOMContentLoaded", () => {

  const missaoBox = document.getElementById("missao-box");
  const lista = document.getElementById("missao-list");

  function verificarMissaoCompleta() {
    const total = document.querySelectorAll("#missao-list li").length;
    const concluidos = document.querySelectorAll("#missao-list li.concluido").length;

    if (total > 0 && total === concluidos) {
        mostrarBotaoFinalizar();
    }
  }

  function mostrarBotaoFinalizar() {
    let btn = document.getElementById("btn-finalizar-missao");

    if (!btn) {
        btn = document.createElement("button");
        btn.id = "btn-finalizar-missao";
        btn.innerText = "FINALIZAR MISSÃO 🛒";

        btn.style.marginTop = "15px";
        btn.style.padding = "15px";
        btn.style.width = "100%";
        btn.style.background = "#2ee6a6";
        btn.style.border = "none";
        btn.style.borderRadius = "12px";
        btn.style.fontWeight = "bold";
        btn.style.letterSpacing = "0.4px";
        btn.style.cursor = "pointer";
        btn.style.animation = "pulse 1s infinite";

        document.getElementById("missao-box").appendChild(btn);

        btn.addEventListener("click", () => {
            window.location.href = "/carrinho/?modo=jogo";
        });
    }
  }

  // ======= BOX DE MISSÃO =======
  if (modoJogo && missaoBox && lista) {
    console.log("MISSÃO ATIVADA ✅");

    missaoBox.style.display = "block";

    itensMissao.forEach(item => {
      item.id = Number(item.id);
      const li = document.createElement("li");

      li.dataset.nome = item.nome;
      li.dataset.id = Number(item.id);
      li.innerHTML = `
        <div class="missao-item">
            <img src="${item.img}" alt="${item.nome}">
            <span>${item.nome}</span>
        </div>
      `;

      lista.appendChild(li);
    });
  }

  // ======= EFEITO 3D NOS CARDS =======
  const cards = document.querySelectorAll(".produto");

  cards.forEach(card => {
    card.addEventListener("mousemove", (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      const centerX = rect.width / 2;
      const centerY = rect.height / 2;
      const rotateX = (y - centerY) / 18;
      const rotateY = (centerX - x) / 18;
      card.style.transform =
          `translateY(-8px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.02)`;
    });

    card.addEventListener("mouseleave", () => {
      card.style.transform = "";
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
        flex.scrollBy({ left: -flex.clientWidth * 0.8, behavior: "smooth" });
      });
    }

    if (btnNext) {
      btnNext.addEventListener("click", () => {
        flex.scrollBy({ left: flex.clientWidth * 0.8, behavior: "smooth" });
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

  // ======= ADICIONAR AO CARRINHO (compartilhada entre grade e vitrine fullscreen) =======
  async function adicionarAoCarrinho(produtoId, categoriaId, btnElement) {

    if (categoriaId === "2") {
      window.location.href = `/loja_detalhe/${produtoId}/`;
      return;
    }

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

          if (!itensMissao.some(i => i.id === produtoIdNumber)) {
            const card = btnElement ? btnElement.closest(".produto") : null;
            if (card) {
              card.classList.add("erro");
              setTimeout(() => card.classList.remove("erro"), 600);
            }
            return;
          }

          const li = document.querySelector(
            `#missao-list li[data-id="${produtoIdNumber}"]`
          );
          if (li && !li.classList.contains("concluido")) {
            li.classList.add("concluido");
            verificarMissaoCompleta();
          }
        }

        // 🎨 FEEDBACK VISUAL DO BOTÃO
        if (btnElement) {
          const originalText = btnElement.textContent;
          btnElement.textContent = '✓ Adicionado!';
          btnElement.classList.add("added");
          setTimeout(() => {
            btnElement.textContent = originalText;
            btnElement.classList.remove("added");
          }, 2000);
        }

      } else {
        alert("Erro ao adicionar produto: " + data.message);
      }
    } catch (error) {
      console.error("Erro:", error);
      alert("Erro ao adicionar produto ao carrinho");
    }
  }

  const botoesAdicionar = document.querySelectorAll(".btn-adicionar");

  botoesAdicionar.forEach(btn => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      adicionarAoCarrinho(btn.dataset.id, btn.dataset.categoria, btn);
    });
  });

  // =====================================================================
  // VITRINE EXCLUSIVA (fullscreen showcase) — montada a partir dos
  // cards de produto já renderizados pelo Django, sem novas variáveis
  // de contexto e sem tocar no backend.
  // =====================================================================
  const showcaseOverlay = document.getElementById("showcase-overlay");
  const abrirVitrineBtn = document.getElementById("abrir-vitrine");

  if (showcaseOverlay && abrirVitrineBtn) {

    const produtoCards = Array.from(document.querySelectorAll(".produto-link"));

    const itensVitrine = produtoCards.map(card => {
      const img = card.querySelector(".produto-img img");
      const nome = card.querySelector(".produto-info h3");
      const preco = card.querySelector(".preco");
      const btn = card.querySelector(".btn-adicionar");
      const categoriaSection = card.closest(".categoria-section");
      const categoriaTitulo = categoriaSection ? categoriaSection.querySelector(".categoria-titulo") : null;

      return {
        img: img ? img.src : "",
        nome: nome ? nome.textContent.trim() : "",
        preco: preco ? preco.textContent.trim() : "",
        href: card.href,
        produtoId: btn ? btn.dataset.id : null,
        categoriaId: btn ? btn.dataset.categoria : "",
        categoriaNome: categoriaTitulo ? categoriaTitulo.textContent.trim() : ""
      };
    });

    if (itensVitrine.length > 0) {

      let indiceAtual = 0;

      const showcaseImg = document.getElementById("showcase-img");
      const showcaseNome = document.getElementById("showcase-nome");
      const showcasePreco = document.getElementById("showcase-preco");
      const showcaseCategoria = document.getElementById("showcase-categoria");
      const showcaseLink = document.getElementById("showcase-link");
      const showcaseAdd = document.getElementById("showcase-add");
      const showcaseThumbs = document.getElementById("showcase-thumbs");
      const showcasePrev = document.getElementById("showcase-prev");
      const showcaseNext = document.getElementById("showcase-next");

      // monta as miniaturas uma única vez
      itensVitrine.forEach((item, i) => {
        const thumb = document.createElement("button");
        thumb.type = "button";
        thumb.className = "showcase-thumb";
        thumb.setAttribute("aria-label", item.nome);
        thumb.innerHTML = `<img src="${item.img}" alt="">`;
        thumb.addEventListener("click", () => renderShowcase(i));
        showcaseThumbs.appendChild(thumb);
      });

      function renderShowcase(indice) {
        indiceAtual = (indice + itensVitrine.length) % itensVitrine.length;
        const item = itensVitrine[indiceAtual];

        showcaseImg.style.opacity = 0;
        setTimeout(() => {
          showcaseImg.src = item.img;
          showcaseImg.alt = item.nome;
          showcaseImg.style.opacity = 1;
        }, 120);

        showcaseNome.textContent = item.nome;
        showcasePreco.textContent = item.preco;
        showcaseCategoria.textContent = item.categoriaNome;
        showcaseLink.href = item.href;
        showcaseAdd.dataset.id = item.produtoId;
        showcaseAdd.dataset.categoria = item.categoriaId;

        showcaseThumbs.querySelectorAll(".showcase-thumb").forEach((t, i) => {
          t.classList.toggle("is-active", i === indiceAtual);
        });
      }

      function abrirVitrine(indiceInicial = 0) {
        renderShowcase(indiceInicial);
        showcaseOverlay.classList.add("is-open");
        showcaseOverlay.setAttribute("aria-hidden", "false");
        document.body.style.overflow = "hidden";
      }

      function fecharVitrine() {
        showcaseOverlay.classList.remove("is-open");
        showcaseOverlay.setAttribute("aria-hidden", "true");
        document.body.style.overflow = "";
      }

      abrirVitrineBtn.addEventListener("click", () => abrirVitrine(0));

      showcaseOverlay.querySelectorAll("[data-showcase-close]").forEach(el => {
        el.addEventListener("click", fecharVitrine);
      });

      showcasePrev.addEventListener("click", () => renderShowcase(indiceAtual - 1));
      showcaseNext.addEventListener("click", () => renderShowcase(indiceAtual + 1));

      showcaseAdd.addEventListener("click", () => {
        adicionarAoCarrinho(showcaseAdd.dataset.id, showcaseAdd.dataset.categoria, showcaseAdd);
      });

      document.addEventListener("keydown", (e) => {
        if (!showcaseOverlay.classList.contains("is-open")) return;
        if (e.key === "Escape") fecharVitrine();
        if (e.key === "ArrowLeft") renderShowcase(indiceAtual - 1);
        if (e.key === "ArrowRight") renderShowcase(indiceAtual + 1);
      });

    } else {
      // sem produtos carregados: esconde o CTA da vitrine para não abrir vazio
      abrirVitrineBtn.style.display = "none";
    }
  }

  // ======= REVEAL AO ROLAR A PÁGINA =======
  const revealEls = document.querySelectorAll(".reveal");
  if (revealEls.length > 0 && "IntersectionObserver" in window) {
    const revealObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          revealObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.15 });

    revealEls.forEach(el => revealObserver.observe(el));
  } else {
    revealEls.forEach(el => el.classList.add("is-visible"));
  }

  // ======= FILTRO RÁPIDO DE CATEGORIA — estado ativo ao rolar =======
  const chips = document.querySelectorAll(".quick-filter__chip");
  const categoriaSections = document.querySelectorAll(".categoria-section");

  if (chips.length > 0 && categoriaSections.length > 0 && "IntersectionObserver" in window) {
    const chipObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const id = entry.target.id;
          chips.forEach(chip => {
            chip.classList.toggle("is-active", chip.getAttribute("href") === `#${id}`);
          });
        }
      });
    }, { rootMargin: "-40% 0px -50% 0px" });

    categoriaSections.forEach(section => chipObserver.observe(section));
  }

  // ======= ENTRADA DO HERO =======
  requestAnimationFrame(() => {
    document.body.classList.add("page-ready");
  });

});