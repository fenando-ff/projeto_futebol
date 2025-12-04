// Script para animar a entrada dos elementos ao rolar a página (Scroll Reveal)

document.addEventListener("DOMContentLoaded", function() {
    
    // Seleciona todas as linhas da timeline
    const rows = document.querySelectorAll('.timeline-row');

    // Opções do observador (quando 15% do elemento aparecer, dispara)
    const options = {
        root: null,
        rootMargin: '0px',
        threshold: 0.15
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Adiciona a classe que faz o elemento subir e aparecer
                entry.target.classList.add('visivel');
                // Para de observar depois que já apareceu (opcional)
                observer.unobserve(entry.target);
            }
        });
    }, options);

    // Manda o observador vigiar cada linha
    rows.forEach(row => {
        observer.observe(row);
    });
});