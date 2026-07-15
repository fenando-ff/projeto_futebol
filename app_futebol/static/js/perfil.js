// Toggle e dropdowns do perfil
function initPerfil() {
	// Toggle 'Meus Dados' (colapsável)
	const fotoInput = document.getElementById('foto');
	const previewAvatar = document.getElementById('previewAvatar');
	const avatarFilename = document.getElementById('avatarFilename');
	const avatarError = document.getElementById('avatarError');
	const btnSalvarFoto = document.getElementById('btnSalvarFoto');

	if (btnSalvarFoto) {
		btnSalvarFoto.addEventListener('click', function () {
			document.querySelector('.form-perfil').submit();
		});
	}

	if (fotoInput && previewAvatar) {
		const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];

		fotoInput.addEventListener('change', function () {
			avatarError.textContent = '';
			const file = this.files[0];
			if (!file) {
				avatarFilename.textContent = 'Nenhuma imagem selecionada';
				return;
			}

			if (!allowedTypes.includes(file.type)) {
				avatarError.textContent = 'Formato inválido. Envie JPG, JPEG, PNG ou WEBP.';
				this.value = '';
				avatarFilename.textContent = 'Nenhuma imagem selecionada';
				return;
			}

			if (file.size > 5 * 1024 * 1024) {
				avatarError.textContent = 'A imagem deve ter no máximo 5MB.';
				this.value = '';
				avatarFilename.textContent = 'Nenhuma imagem selecionada';
				return;
			}

			avatarFilename.textContent = file.name;
			const reader = new FileReader();
			reader.onload = function (e) {
				previewAvatar.src = e.target.result;
			};
			reader.readAsDataURL(file);

			if (btnSalvarFoto) {
				btnSalvarFoto.style.display = 'inline-flex';
			}

			if (btnSalvarFoto) {
				btnSalvarFoto.addEventListener('click', function () {
					document.querySelector('.form-perfil').submit();
				});
			}
		});
	}

	(function(){
		var toggle = document.querySelector('.toggle-meus-dados');
		if(!toggle) return;
		var perfilDados = document.getElementById('perfil-dados');
		var body = document.getElementById('meus-dados-body');
		if(toggle.getAttribute('aria-expanded') === 'true'){
			perfilDados.classList.remove('collapsed');
			body.setAttribute('aria-hidden','false');
		} else {
			perfilDados.classList.add('collapsed');
			body.setAttribute('aria-hidden','true');
		}

		var doToggle = function(){
			var expanded = toggle.getAttribute('aria-expanded') === 'true';
			if(expanded){
				toggle.setAttribute('aria-expanded','false');
				perfilDados.classList.add('collapsed');
				body.setAttribute('aria-hidden','true');
			} else {
				toggle.setAttribute('aria-expanded','true');
				perfilDados.classList.remove('collapsed');
				body.setAttribute('aria-hidden','false');
			}
		};

		toggle.addEventListener('click', function(e){
			e.preventDefault();
			doToggle();
		});

		toggle.addEventListener('keydown', function(e){
			if(e.key === 'Enter' || e.key === ' ') { e.preventDefault(); doToggle(); }
		});
	})();

	// Dropdown de Ingressos (seção Meus Ingressos)
	var toggleIngressosEl = document.querySelector('#perfil-ingressos .toggle-ingressos');
	if (toggleIngressosEl) {
		var perfilIngressos = document.getElementById('perfil-ingressos');
		var body = document.getElementById('meus-ingressos-body');
		if(!perfilIngressos || !body) return;

		if(toggleIngressosEl.getAttribute('aria-expanded') === 'true'){
			perfilIngressos.classList.remove('collapsed');
			body.setAttribute('aria-hidden','false');
		} else {
			perfilIngressos.classList.add('collapsed');
			body.setAttribute('aria-hidden','true');
		}

		var doToggle = function(){
			var expanded = toggleIngressosEl.getAttribute('aria-expanded') === 'true';
			if(expanded){
				toggleIngressosEl.setAttribute('aria-expanded','false');
				perfilIngressos.classList.add('collapsed');
				body.setAttribute('aria-hidden','true');
			} else {
				toggleIngressosEl.setAttribute('aria-expanded','true');
				perfilIngressos.classList.remove('collapsed');
				body.setAttribute('aria-hidden','false');
			}
		};

		toggleIngressosEl.addEventListener('click', function(e){
			e.preventDefault();
			doToggle();
		});

		toggleIngressosEl.addEventListener('keydown', function(e){
			if(e.key === 'Enter' || e.key === ' ') { e.preventDefault(); doToggle(); }
		});
	}

	// Dropdown por pedido: todo o item-pedido é clicável
	const pedidosList = document.querySelectorAll('.lista-pedidos .item-pedido');
	if (pedidosList && pedidosList.length) {
		pedidosList.forEach(p => {
			const btn = p.querySelector('.btn-ver-detalhes');
			const detalhes = p.querySelector('.detalhes-pedido');
			if (!detalhes) return;

			if (btn) btn.setAttribute('aria-expanded', 'false');
			detalhes.setAttribute('aria-hidden', 'true');

			const toggle = () => {
				const aberto = p.classList.toggle('aberto');
				if (btn) {
					btn.setAttribute('aria-expanded', aberto ? 'true' : 'false');
					btn.textContent = aberto ? 'Ocultar Detalhes' : 'Ver Detalhes';
				}
				detalhes.setAttribute('aria-hidden', aberto ? 'false' : 'true');
			};

			if (btn) {
				btn.textContent = 'Ver Detalhes';
				btn.addEventListener('click', function (e) {
					e.stopPropagation();
					e.preventDefault();
					toggle();
				});

				(function convertPedidoTimes(){
					try{
						var els = document.querySelectorAll('.pedido-data[data-datetime]');
						if(!els || els.length===0) return;
						els.forEach(function(el){
							var iso = el.getAttribute('data-datetime');
							if(!iso) return;
							var dt = new Date(iso);
							if(isNaN(dt)) return;
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

			p.addEventListener('click', function (e) {
				if (e.target.closest('.detalhes-pedido')) return;
				if (e.target.closest('a') || e.target.closest('button')) return;
				toggle();
			});

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
}

if (document.readyState === 'loading') {
	document.addEventListener('DOMContentLoaded', initPerfil);
} else {
	initPerfil();
}
