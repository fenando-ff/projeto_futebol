const subtituloTabela = document.getElementById("subtituloTabela");

// 1. Função para montar o HTML com cores intercaladas (Rodar uma vez)
function inicializarCoresIntercaladas() {
    const cores = ['cor-1', 'cor-2', 'cor-3', 'cor-4'];
    
    if (subtituloTabela) {
        // Pega o texto original antes de ser modificado
        const textoOriginal = subtituloTabela.textContent.trim();
        const letras = textoOriginal.split('');
        
        let novoHTML = '';
    
        letras.forEach((letra, index) => {
            const indiceCor = index % cores.length; 
            const classeCor = cores[indiceCor];
            if (letra === ' ') {
                novoHTML += ' ';
            } else {
                // Cria o <span> com a classe de cor fixa
                novoHTML += `<span class="${classeCor}">${letra}</span>`;
            }
        });
    
        subtituloTabela.innerHTML = novoHTML;
    }
}

// 2. Função de Hover/Mouseout (Apenas adiciona/remove classe)
function handleMouseOver() {
    subtituloTabela.classList.remove('hover-ativo');
}

function handleMouseOut() {
    subtituloTabela.classList.add('hover-ativo');
}


// --- Execução ---

// Execute a função de inicialização UMA VEZ.
inicializarCoresIntercaladas(); 

// Adiciona os Event Listeners
subtituloTabela.addEventListener("mouseover", handleMouseOver);
subtituloTabela.addEventListener("mouseout", handleMouseOut);

// E no seu CSS, defina o que 'hover-ativo' faz:
/*
#subtituloTabela.hover-ativo span {
    color: #f0f0f0 !important;
}
*/