# Plano: Sessão de Divulgação do App Mobile

## Objetivo

Adicionar uma seção na página inicial (`index.html`) para divulgar o aplicativo mobile da plataforma, com:
- **Desktop**: exibição de QR Code para download
- **Mobile**: botão direto de download do `.apk`

## Estrutura de Arquivos

```
app_futebol/
├── static/
│   ├── img/
│   │   └── app/
│   │       ├── qrcode-app.png          # QR code para download (já existe ou será fornecido)
│   │       └── icone-app.png           # Ícone do app (opcional, para estilização)
│   └── download/
│       └── drako-app.apk               # Arquivo .apk do app
└── templates/
    └── app_futebol/
        └── index.html                  # Adicionar nova seção
```

## Passo a Passo

### 1. Organizar Arquivos Estáticos

| Arquivo | Origem | Destino |
|---------|--------|---------|
| `.apk` | Fornecido pelo usuário | `app_futebol/static/download/drako-app.apk` |
| QR Code | Fornecido pelo usuário | `app_futebol/static/img/app/qrcode-app.png` |

> **Nota:** O QR Code deve apontar para a URL de download do `.apk` (ex: `/static/download/drako-app.apk` ou URL de CDN).

### 2. Alterar `views.py` (se necessário)

Verificar se a view `home()` (`views.py:380`) precisa de contexto adicional. Provavelmente **não** precisa, pois a seção será estática.

### 3. Modificar `index.html`

Adicionar nova seção **após** a seção `<!-- ======================== PRODUTOS =============================== -->` (linha 222) e **antes** de `</main>` (linha 223).

**Estrutura HTML proposta:**

```html
<!-- ======================== APP MOBILE =============================== -->
<section class="app-mobile">
    <div class="app-mobile-content">
        <div class="app-info">
            <h2>Baixe nosso App</h2>
            <p>Acompanhe o Drako FC. Acompanhe seu time, próximos jogos e muito mais.</p>
            
            <!-- Desktop: QR Code -->
            <div class="qr-desktop">
                <img src="{% static 'img/app/qrcode-app.png' %}" alt="QR Code para download do app">
                <span class="qr-label">Escaneie para baixar</span>
            </div>
            
            <!-- Mobile: Botão de download -->
            <a href="{% static 'download/drako-app.apk' %}" class="btn-download-app" download>
                <i class="fa-brands fa-android"></i>
                Baixar App
            </a>
        </div>
        
        <!-- Mockup ilustrativo do app (opcional) -->
        <div class="app-mockup">
            <img src="{% static 'img/app/mockup-app.png' %}" alt="App Drako FC">
        </div>
    </div>
</section>
```

### 4. Adicionar CSS em `home.css`

**Novas regras CSS (adicionar antes de `@media` queries):**

```css
/* ======================= APP MOBILE ======================= */
.app-mobile {
    padding: 64px 11%;
    background: linear-gradient(180deg, #111, #1a0505);
}

.app-mobile-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 48px;
    max-width: 1200px;
    margin: 0 auto;
}

.app-info {
    flex: 1;
}

.app-info h2 {
    font-size: 2.2rem;
    margin-bottom: 16px;
    color: #f0f0f0;
}

.app-info p {
    font-size: 1.1rem;
    opacity: 0.85;
    margin-bottom: 24px;
    line-height: 1.6;
}

/* QR Code (desktop) */
.qr-desktop {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    margin-bottom: 24px;
}

.qr-desktop img {
    width: 180px;
    height: 180px;
    border-radius: 12px;
    background: #fff;
    padding: 12px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.4);
}

.qr-label {
    font-size: 0.9rem;
    opacity: 0.7;
}

/* Botão de download (mobile - escondido no desktop) */
.btn-download-app {
    display: none;
    background: #F72B2B;
    color: white;
    padding: 14px 28px;
    border-radius: 12px;
    font-weight: bold;
    font-size: 1.1rem;
    text-align: center;
    align-items: center;
    gap: 10px;
    transition: 0.3s;
}

.btn-download-app:hover {
    background: #eaeaea;
    color: #870000;
}

/* Mockup (opcional) */
.app-mockup {
    flex: 0 0 300px;
}

.app-mockup img {
    width: 100%;
    max-width: 280px;
    border-radius: 24px;
    box-shadow: 0 8px 40px rgba(0,0,0,0.5);
}
```

### 5. Responsividade

**Adicionar em `home.css` dentro de `@media (max-width: 900px)`:**

```css
/* APP MOBILE - Responsivo */
.app-mobile {
    padding: 40px 16px;
}

.app-mobile-content {
    flex-direction: column-reverse;
    text-align: center;
    gap: 24px;
}

.app-info h2 {
    font-size: 1.6rem;
}

.app-info p {
    font-size: 1rem;
}

/* Esconde QR no mobile, mostra botão */
.qr-desktop {
    display: none;
}

.btn-download-app {
    display: inline-flex;
    margin-top: 16px;
}

.app-mockup {
    flex: none;
    width: 200px;
}

.app-mockup img {
    max-width: 180px;
}
```

### 6. Considerações Técnicas

| Item | Detalhe |
|------|---------|
| **Formato do APK** | `.apk` puro (não precisa de compressão extra para download direto) |
| **MIME type** | Django serve `.apk` como `application/vnd.android.package-archive` por padrão |
| **Tamanho do APK** | Se > 50MB, considerar CDN ou link externo (Google Drive, Firebase App Distribution) |
| **QR Code** | Deve conter a URL absoluta do download: `https://seudominio.com/static/download/drako-app.apk` |
| **HTTPS obrigatório** | Android exige HTTPS para instalação de APKs via browser (exceto em debug/localhost) |

### 7. Checklist de Execução

- [ ] Colocar `.apk` em `app_futebol/static/download/drako-app.apk`
- [ ] Colocar QR Code em `app_futebol/static/img/app/qrcode-app.png`
- [ ] Adicionar HTML da seção em `index.html` (após produtos, antes de `</main>`)
- [ ] Adicionar CSS em `home.css`
- [ ] Testar em desktop (QR visível, botão oculto)
- [ ] Testar em mobile (botão visível, QR oculto)
- [ ] Verificar se o download do APK funciona corretamente
- [ ] Validar em diferentes tamanhos de tela (375px, 768px, 1024px, 1440px)

## Ordem de Implementação

1. Criar pastas `static/download/` e `static/img/app/`
2. Mover arquivos `.apk` e QR Code para as pastas corretas
3. Editar `index.html` para adicionar a seção
4. Editar `home.css` para adicionar estilos
5. Testar responsividade
