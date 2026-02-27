
const inputs = document.querySelectorAll(".codigo-input");
const hiddenInput = document.getElementById("codigo-completo");

inputs.forEach((input, index) => {
    input.addEventListener("input", () => {
        if (input.value.length === 1 && index < inputs.length - 1) {
            inputs[index + 1].focus();
        }

        let codigo = "";
        inputs.forEach(i => codigo += i.value);
        hiddenInput.value = codigo;
    });

    input.addEventListener("keydown", (e) => {
        if (e.key === "Backspace" && input.value === "" && index > 0) {
            inputs[index - 1].focus();
        }
    });
});
