(function () {
  const storageKey = "drakos-theme";
  const root = document.documentElement;
  const toggle = document.getElementById("theme-toggle");
  const themes = new Set(["dark", "light"]);

  function applyTheme(theme) {
    const nextTheme = themes.has(theme) ? theme : "dark";
    root.dataset.theme = nextTheme;
    document.body.dataset.theme = nextTheme;
    localStorage.setItem(storageKey, nextTheme);

    if (toggle) {
      const isLight = nextTheme === "light";
      toggle.setAttribute("aria-pressed", String(isLight));
      toggle.setAttribute(
        "aria-label",
        isLight ? "Ativar modo escuro" : "Ativar modo claro"
      );
      toggle.innerHTML = isLight
        ? '<i class="bx bx-moon" aria-hidden="true"></i>'
        : '<i class="bx bx-sun" aria-hidden="true"></i>';
    }
  }

  const savedTheme = localStorage.getItem(storageKey);
  applyTheme(savedTheme || root.dataset.theme);

  if (toggle) {
    toggle.addEventListener("click", function () {
      applyTheme(root.dataset.theme === "light" ? "dark" : "light");
    });
  }

  window.setDrakosTheme = applyTheme;
})();
