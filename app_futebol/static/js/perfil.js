// Função dropdown para o menu do perfil
infop = document.getElementById("info-pessoais");
campop = document.getElementsByClassName("campo-pessoal");

function dropdownPessoal() {
    // escutador de evento para o clique no título
    infop.addEventListener("click", function() {
        for (let i = 0; i < campop.length; i++) {
            campop[i].style.display = "none";
        }
    });
};