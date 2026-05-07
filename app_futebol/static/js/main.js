// MENU HAMBURGUER (drawer mobile)
const botao = document.getElementById("botao_hamburguer");
const nav = document.getElementById("menuNav");
const overlay = document.getElementById("menuOverlay");
const fechar = document.getElementById("fechar_menu");

function openMenu() {
  nav.classList.add("is-open");
  overlay.classList.add("is-open");
  botao.setAttribute("aria-expanded", "true");
  document.body.classList.add("no-scroll");
}

function closeMenu() {
  nav.classList.remove("is-open");
  overlay.classList.remove("is-open");
  botao.setAttribute("aria-expanded", "false");
  document.body.classList.remove("no-scroll");
}

// toggle
botao.addEventListener("click", () => {
  nav.classList.contains("is-open") ? closeMenu() : openMenu();
});

// fecha clicando no overlay e no X
overlay.addEventListener("click", closeMenu);
if (fechar) fechar.addEventListener("click", closeMenu);

// fecha ao clicar em algum link do menu (no mobile)
nav.addEventListener("click", (e) => {
  if (e.target.closest("a")) closeMenu();
});

// fecha no ESC
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") closeMenu();
});


setTimeout(() => {
  const alerts = document.querySelectorAll(".alert");
  alerts.forEach(alert => {
    alert.style.opacity = "0";
    alert.style.transform = "translateX(50px)";
    setTimeout(() => alert.remove(), 300);
  });
}, 3000);
