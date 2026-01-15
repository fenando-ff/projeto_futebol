document.addEventListener("DOMContentLoaded", function() {
    
    const linhasTimeline = document.querySelectorAll('.timeline-row');

    // 1. OBSERVADOR DE APARIÇÃO (Fade In inicial)
    // Apenas faz o item aparecer quando entra na tela.
    const observerAparicao = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visivel');
                observer.unobserve(entry.target); // Só precisa rodar uma vez
            }
        });
    }, { threshold: 0.1 });


    // 2. OBSERVADOR DE DESTAQUE (Foco/POV)
    // Liga e desliga os efeitos (brilho, cor) conforme o item passa pelo CENTRO da tela.
    const observerDestaque = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Se o elemento entrou na zona de destaque (centro da tela)
                entry.target.classList.add('ativo');
            } else {
                // Se o elemento saiu da zona de destaque
                entry.target.classList.remove('ativo');
            }
        });
    }, {
        root: null,
        // rootMargin define a "zona ativa". 
        // '-40% 0px -40% 0px' significa: O efeito só ativa quando o item estiver 
        // na faixa central da tela (os 20% do meio).
        // Isso impede que dois itens fiquem ativos ao mesmo tempo.
        rootMargin: '-40% 0px -40% 0px', 
        threshold: 0
    });

    // Aplica os observadores em cada linha
    linhasTimeline.forEach(linha => {
        observerAparicao.observe(linha);
        observerDestaque.observe(linha);
    });
});