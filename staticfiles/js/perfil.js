// Toggle e dropdowns do perfil
document.addEventListener('DOMContentLoaded', function () {
	// info pessoais / endereco já configurados em outro trecho

	// Dropdown por pedido: todo o item-pedido é clicável
	const pedidosList = document.querySelectorAll('.lista-pedidos .item-pedido');
	if (pedidosList && pedidosList.length) {
		pedidosList.forEach(p => {
			const btn = p.querySelector('.btn-ver-detalhes');
			const detalhes = p.querySelector('.detalhes-pedido');
			if (!detalhes) return;

			// inicializa atributos ARIA
			if (btn) btn.setAttribute('aria-expanded', 'false');
			detalhes.setAttribute('aria-hidden', 'true');

			// toggle helper
			const toggle = () => {
				const aberto = p.classList.toggle('aberto');
				if (btn) {
					btn.setAttribute('aria-expanded', aberto ? 'true' : 'false');
					btn.textContent = aberto ? 'Ocultar Detalhes' : 'Ver Detalhes';
				}
				detalhes.setAttribute('aria-hidden', aberto ? 'false' : 'true');
			};

			// clique no botão (previne propagação)
			if (btn) {
				// texto inicial
				btn.textContent = 'Ver Detalhes';
				btn.addEventListener('click', function (e) {
					e.stopPropagation();
					e.preventDefault();
					toggle();
				});

				// Convert server-provided ISO datetimes to device-local format
				(function convertPedidoTimes(){
					try{
						var els = document.querySelectorAll('.pedido-data[data-datetime]');
						if(!els || els.length===0) return;
						els.forEach(function(el){
							var iso = el.getAttribute('data-datetime');
							if(!iso) return;
							var dt = new Date(iso);
							if(isNaN(dt)) return;
							// Use user's locale and show date + time
							var fmt = new Intl.DateTimeFormat(navigator.language || undefined, {
								year: 'numeric', month: 'short', day: 'numeric',
								hour: '2-digit', minute: '2-digit'
							});
							el.textContent = fmt.format(dt);
						});
					}catch(e){
						console.error('pedido time conversion failed', e);
					}
				})();
				btn.addEventListener('keydown', function (e) {
					if (e.key === 'Enter' || e.key === ' ') {
						e.preventDefault();
						btn.click();
					}
				});
			}

			// clique no container: ignora cliques dentro dos detalhes ou em links/botões
			p.addEventListener('click', function (e) {
				if (e.target.closest('.detalhes-pedido')) return;
				if (e.target.closest('a') || e.target.closest('button')) return;
				toggle();
			});

			// teclado no container
			p.setAttribute('tabindex', '0');
			p.setAttribute('role', 'button');
			p.addEventListener('keydown', function (e) {
				if (e.key === 'Enter' || e.key === ' ') {
					e.preventDefault();
					toggle();
				}
			});
		});
	}
});

