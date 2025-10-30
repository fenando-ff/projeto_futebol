// puxando para o DOM
// let caixa_masculina = document.getElementById("caixa_m");
// let caixa_feminina = document.getElementById("caixa_f");
// let caixa_check = document.getElementById("check");
// let sexo = document.querySelectorAll(".caixinha");

// function marcarSexo(){
//     sexo.forEach( icone =>{
//         icone.addEventListener("click", ()=> {
//             if (!icone.classList.contains("ativo")) {
//                 sexo.forEach(doido =>{
//                     doido.classList.remove("ativo")
//                 });
//                 icone.classList.add("ativo");
//             } else {
//                 icone.classList.remove("ativo")
//             };
//         });
//     });

//     caixa_check.addEventListener("change", () =>{
//         if (caixa_check.checked) {
//             sexo.forEach(i => i.classList.remove("ativo"));
//         } else {
//             marcarSexo();
//         }
//     });
// };


// marcarSexo()



// selecionando elementos
const caixaMasculina = document.getElementById("caixa_m");
const caixaFeminina = document.getElementById("caixa_f");
const checkbox = document.getElementById("check");
const caixinhas = document.querySelectorAll(".caixinha");

// função para marcar sexo
function marcarSexo() {
    caixinhas.forEach(icone => {
        icone.addEventListener("click", () => {
            // se o checkbox estiver marcado, desmarca
            if (checkbox.checked) {
                checkbox.checked = false;
            }

            // toggle ativo
            if (!icone.classList.contains("ativo")) {
                caixinhas.forEach(i => i.classList.remove("ativo"));
                icone.classList.add("ativo");
            } else {
                icone.classList.remove("ativo");
            }
        });
    });
}

// resetar caixinhas ao marcar o checkbox
checkbox.addEventListener("change", () => {
    if (checkbox.checked) {
        caixinhas.forEach(i => i.classList.remove("ativo"));
    };
});

// inicializa
marcarSexo();


// "" = vazio
// " " = contem espaço


