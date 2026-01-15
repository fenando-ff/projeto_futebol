// Toggle simples para a seção Informações Pessoais
document.addEventListener('DOMContentLoaded', function () {
    const titulo = document.getElementById('info-pessoais');
    if (!titulo) return;

    titulo.addEventListener('click', function () {
        const container = titulo.closest('.info-pessoais');
        if (!container) return;
        // alterna a classe 'collapsed' no container; o CSS cuida da ocultação
        container.classList.toggle('collapsed');
    });

    // dropdown para endereço (mesma lógica)
    const tituloEndereco = document.getElementById('info-endereco');
    if (tituloEndereco) {
        tituloEndereco.addEventListener('click', function () {
            const container = tituloEndereco.closest('.info-endereco');
            if (!container) return;
            container.classList.toggle('collapsed');
        });
    }
});
