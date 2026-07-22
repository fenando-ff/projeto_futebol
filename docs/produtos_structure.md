# Estrutura de Arquivos - `app_futebol/static/img/produtos`

As imagens dos produtos são hospedadas no **Cloudflare R2** (bucket: `drakos/produtos`).

```
app_futebol/static/img/produtos/
├── acessorios/
│   ├── objeto 1/
│   │   ├── cachecol_drakos (1).jpg
│   │   ├── cachecol_drakos (1).webp
│   │   ├── cachecol_drakos (2).webp
│   │   ├── cachecol_drakos (3).webp
│   │   └── cachecol_transparent (3).png
│   ├── objeto 2/
│   │   ├── boneco_drakos (1).jpg
│   │   ├── boneco_drakos (2).jpg
│   │   ├── boneco_drakos (3).jpg
│   │   └── boneco_transparent (3).png
│   ├── objeto 3/
│   │   ├── touca_Drakos (1).jpg
│   │   ├── touca_Drakos (1).webp
│   │   ├── touca_Drakos (2).jpg
│   │   └── touca_transparent.png
│   ├── objeto 4/
│   │   ├── olhadeira_Drakos (1).jpg
│   │   ├── olhadeira_Drakos (2).jpg
│   │   └── olhadeira_transparent.png
│   ├── objeto 5/
│   │   ├── caneca(1).png
│   │   ├── caneca(2).png
│   │   ├── caneca(3).jpg
│   │   └── caneca(3)transparente.png
│   ├── objeto 6/
│   │   ├── chaveiro_transparent.png
│   │   ├── chaveiro(1).png
│   │   └── chaveiro(2).png
│   └── objeto 7/
│       ├── capa_cel(1).png
│       ├── capa_cel(2).png
│       ├── capa_cel(3).png
│       └── capa_transparent.png
├── calcados/
│   └── sandalia.png
└── camisas/
    ├── camisa 1/
    │   ├── casaco_preto (1).jpg
    │   ├── casaco_preto (1).webp
    │   ├── casaco_preto (2).jpg
    │   ├── casaco_preto (2).webp
    │   └── casaco_transparent.png
    ├── camisa 2/
    │   ├── branco_listrado (1).jpg
    │   ├── branco_listrado (1).webp
    │   ├── branco_listrado (2).jpg
    │   ├── branco_listrado (2).webp
    │   └── Opel_transparent.png
    ├── camisa 3/
    │   ├── branco_vermelho (1).jpg
    │   ├── branco_vermelho (1).webp
    │   ├── branco_vermelho (2).webp
    │   ├── branco_vermelho (3).webp
    │   └── Camisa_branco_red.png
    ├── camisa 4/
    │   ├── full_black (1).jpg
    │   ├── full_black (1).webp
    │   ├── full_black (2).jpg
    │   ├── full_black (2).webp
    │   └── full_manga_black_transparent.png
    ├── camisa 5/
    │   ├── white_version (1).jpg
    │   ├── white_version (1).webp
    │   ├── white_version (2).jpg
    │   └── white_version (2).webp
    ├── camisa 6/
    │   ├── white_red (1).jpg
    │   ├── white_red (1).webp
    │   └── white_red (2).jpg
    ├── camisa 7/
    │   ├── full_pt (1).jpg
    │   ├── full_pt (1).webp
    │   ├── full_pt (2).jpg
    │   ├── Gemini_Generated_Image_5gwztc5gwztc5gwz.png
    │   └── preto_vermelho.png
    ├── camisa 8/
    │   ├── milan_r2006 (1).avif
    │   ├── milan_r2006 (1).webp
    │   └── milan_r2006(2).png
    ├── camisa 9/
    │   ├── white_25.26 (2).webp
    │   ├── white_25.26 (4).webp
    │   ├── white_25.26(1).png
    │   └── white_25.26(3).png
    └── camisa 10/
        ├── Black_transpa.png
        ├── blacK_Uniforme (1).jpg
        ├── blacK_Uniforme (2).jpg
        ├── blacK_Uniforme (2).webp
        └── black_Uniforme(3).jpg
```

## Hospedagem no Cloudflare R2

- **Bucket:** `drakos`
- **Pasta:** `produtos`
- **Base URL (referência):** `https://pub-<hash>.r2.dev/produtos/...` ou domínio customizado apontado para o bucket.
