let dots = document.querySelectorAll(".dot-carrossel");
const slide = document.querySelector(".slide");
const noticiasTexto = [
    {
        subtitulo: "vitória em clássico",
        paragrafo: `Vitória apertada contra seu maior rival, a torcida
                    esteve presente durante todo o jogo apoiando o clube,
                    fez com que o time se motivasse abrindo o placar aos 83.0 do 2º tempo.`,
    },
    {
        subtitulo: "novo uniforme",
        paragrafo: `Lançamento do novo uniforme de treino, que já está disponível
                    para compra na loja oficial. O tecido é mais leve e respirável,
                    perfeito para a rotina de treinos intensos.`,
    },
    {
        subtitulo: "próximo desafio",
        paragrafo: `A equipe se prepara para o próximo grande desafio da temporada.
                    O técnico ressaltou a importância do foco e da disciplina
                    para conquistar os 3 pontos fora de casa.`,
    }
];

const subtituloNoticia = document.querySelector(".subtitulo-noticia");
const paragrafoNoticia = document.querySelector(".texto-noticia p");
let slideIndex = 0; // Índice do slide atual (0, 1, ou 2)
const totalSlides = dots.length; // Quantidade de slides/pontos

// Função para atualizar o carrossel (imagem, texto e ponto)
function atualizarCarrossel() {
    // 1. Mover o slide
    const slideWidth = 100 / totalSlides; // Cada slide ocupa uma porcentagem da largura

    // 2. Atualizar o texto da notícia
    subtituloNoticia.textContent = noticiasTexto[slideIndex].subtitulo;
    paragrafoNoticia.textContent = noticiasTexto[slideIndex].paragrafo;

    // 3. Atualizar a classe 'ligado' dos pontos (dots)
    dots.forEach((ponto, index) => {
        ponto.classList.remove("ligado");
    });

    dots[slideIndex].classList.add("ligado");

    slideIndex = (slideIndex + 1) % totalSlides; // Vai para o próximo, e volta para 0 se for o último
}

// Inicializa o carrossel na posição 0 e atualiza o estado
slideIndex = 0;
atualizarCarrossel();
slideIndex = 1; // Prepara o índice para o primeiro intervalo (que chamará o índice 1)

// Configura o intervalo para a mudança automática
const intervaloCarrossel = setInterval(atualizarCarrossel, 4000); // 5000 milissegundos = 5 segundos

// Lógica de click nos pontos (dots) - Interrompe o automático e ajusta o slide
dots.forEach((dot, index) => {
    dot.addEventListener("click", () => {
        // Define o índice baseado no ponto clicado
        slideIndex = index;
        
        // Atualiza o carrossel para o slide clicado
        atualizarCarrossel(); 
    });
});

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