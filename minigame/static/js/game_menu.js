const fase2 = document.getElementById("fase2");
const warning = document.getElementById("lockWarning");

if (fase2 && warning) {
    fase2.addEventListener("click", function(e) {

        const isLocked = this.dataset.locked === "true";

        if (isLocked) {
            e.preventDefault();

            // 1. efeito base
            this.classList.add("shake", "block-fill");

            setTimeout(() => {
                this.classList.remove("shake", "block-fill");
            }, 400);

            // 2. esconder texto
            this.classList.add("hide-text");

            // 3. mostrar cadeado
            setTimeout(() => {
                this.classList.add("show-lock");
            }, 150);

            // 4. mostrar aviso
            setTimeout(() => {
                warning.classList.add("show");
            }, 200);

            // 5. remover cadeado
            setTimeout(() => {
                this.classList.remove("show-lock");
            }, 1600);

            // 6. esconder aviso
            setTimeout(() => {
                warning.classList.remove("show");
            }, 1600);

            // 7. voltar texto
            setTimeout(() => {
                this.classList.remove("hide-text");
            }, 1600);
        }
    });
}