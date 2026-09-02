// ======================================================
// MENU HAMBURGUER — RESPONSIVO
// ======================================================

const NAV_BREAKPOINT = 1180;

const botao = document.getElementById("botao_hamburguer");
const nav = document.getElementById("menuNav");
const overlay = document.getElementById("menuOverlay");
const fechar = document.getElementById("fechar_menu");


function openMenu() {

    if (!nav) return;

    nav.classList.add("is-open");

    if (overlay) {
        overlay.classList.add("is-open");
    }

    if (botao) {
        botao.setAttribute("aria-expanded", "true");
    }

    document.body.classList.add("no-scroll");
}


function closeMenu() {

    if (!nav) return;

    nav.classList.remove("is-open");

    if (overlay) {
        overlay.classList.remove("is-open");
    }

    if (botao) {
        botao.setAttribute("aria-expanded", "false");
    }

    document.body.classList.remove("no-scroll");
}


// ======================================================
// HAMBURGUER
// ======================================================

if (botao) {

    botao.addEventListener("click", () => {

        nav.classList.contains("is-open")
            ? closeMenu()
            : openMenu();

    });

}


// Overlay
if (overlay) {
    overlay.addEventListener("click", closeMenu);
}


// X
if (fechar) {
    fechar.addEventListener("click", closeMenu);
}


// ======================================================
// LINKS
// ======================================================

if (nav) {

    nav.addEventListener("click", (event) => {

        const link = event.target.closest("a");

        if (!link) return;


        // Só executa comportamento de drawer
        // quando realmente estamos em tablet/mobile.
        if (window.innerWidth <= NAV_BREAKPOINT) {
            closeMenu();
        }

    });

}


// ======================================================
// ESC
// ======================================================

document.addEventListener("keydown", (event) => {

    if (event.key === "Escape") {
        closeMenu();
    }

});


// ======================================================
// RESIZE
// ======================================================

let resizeFrame;

window.addEventListener("resize", () => {

    cancelAnimationFrame(resizeFrame);

    resizeFrame = requestAnimationFrame(() => {

        /*
           Usuário abriu o drawer e depois aumentou
           a janela para desktop.
        */
        if (window.innerWidth > NAV_BREAKPOINT) {
            closeMenu();
        }

    });

});


// ======================================================
// ALERTAS
// ======================================================

setTimeout(() => {

    const alerts = document.querySelectorAll(".alert");

    alerts.forEach(alert => {

        alert.style.opacity = "0";
        alert.style.transform = "translateX(50px)";

        setTimeout(() => {
            alert.remove();
        }, 300);

    });

}, 3000);