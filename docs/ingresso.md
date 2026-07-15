# Documentação: Compra e Visualização de Ingressos

## Visão Geral

O módulo de ingressos permite que clientes autenticados comprem entradas para jogos do Drakos FC e baixem o ingresso em PDF com QR Code de validação. A funcionalidade está dividida em duas telas principais:

- `Tela_Ingresso.html` — Compra de ingressos.
- `perfil.html` — Visualização e download dos ingressos comprados.

---

## Categoria de Produto

Os ingressos são identificados pela categoria de produto com `id = 10` (`categoria_produtos_id_categoria_produtos = 10`).

---

## 1. Tela de Compra de Ingressos

**URL:** `/ingresso/`  
**View:** `tela_ingressos`  
**Template:** `app_futebol/Tela_Ingresso.html`  
**JS:** `app_futebol/static/js/Tela_ingressos.js`  
**CSS:** `app_futebol/static/css/Tela_Ingressos.css`

### Dados enviados ao template

| Variável | Descrição |
|----------|-----------|
| `ingressos` | QuerySet de `Produtos` filtrados pela categoria 10. |
| `jogo_destaque` | Próximo jogo a partir de hoje (`Jogos.objects.filter(dia_jogo__gte=hoje).first()`). |
| `proximos_jogos` | Até 3 próximos jogos, excluindo o destaque. |

### Regras de Exibição

#### Detalhes da Partida em Destaque
- Exibe os escudos do Drakos FC e do time adversário.
- Se o adversário não tiver `url_brasao`, usa a imagem padrão `img/icones/palmeiras.png`.
- Mostra local, dia (formato `d de F`) e hora (`H:i`).
- Caso não haja jogo futuro, exibe "Nenhum jogo disponível no momento".

#### Mapa do Estádio
- Exibe imagem estática do estádio: `img/icones/estadio_atualizado.png`.

#### Formulário de Seleção de Setor
- Campo `select` populado com os ingressos (`ingressos`).
- Valor da option: `id_produtos` do ingresso.
- Atributo `data-preco`: `valor_produtos` para cálculo no JS.
- Campos: `setor` (select), `quantidade` (number, min=1, max=10).

#### Lista de Pedido (Local / Carrinho Visual)
- Gerenciada via JavaScript no template.
- Cada item adicionado vira um `<li class="item-ingresso">`.
- O botão **Excluir** remove o item visualmente e chama a view `remover_carrinho`.
- O total é recalculado dinamicamente e exibido no botão de finalizar.

### Ações do Usuário

#### Adicionar Ingresso
1. Usuário seleciona setor e quantidade.
2. Submissão do formulário é interceptada pelo JS (`e.preventDefault()`).
3. O item é criado na lista visual.
4. Requisição AJAX POST para `/adicionar/<produto_id>/` com CSRF token.
5. Se falhar, o item é removido da lista visual e alerta exibido.

#### Remover Ingresso
1. Clique no botão "Excluir" de um item.
2. Requisição AJAX POST para `/remover/<produto_id>/`.
3. Item removido da lista visual e total atualizado.

#### Finalizar Compra
1. Clique em "Finalizar Compra".
2. Requisição AJAX POST para `/finalizar_compra/`.
3. Em caso de sucesso:
   - Exibe mensagem "Compra realizada com sucesso!".
   - Limpa a lista visual (`listaIngressos.innerHTML = ''`).
   - Abre em nova aba: `/baixar_ingresso/<pedido_id>/` para download do PDF.
4. Em caso de erro:
   - Alerta com a mensagem retornada.
   - Restaura estado do botão.

#### PDF do Ingresso
- **URL:** `/baixar_ingresso/<pedido_id>/`
- **View:** `gerar_pdf_ingressos`
- Exige login (`cliente_id` na sessão).
- Verifica se o pedido pertence ao cliente logado.
- Filtra apenas itens da categoria 10 (ingressos).
- Gera um PDF com:
  - Título: "Drakos FC - Ingresso Digital".
  - Confronto: `Drakos FC vs Adversário` (casa) ou `Adversário vs Drakos FC` (fora).
  - Data e hora do jogo.
  - Local do jogo.
  - Setor/Tipo: nome do produto.
  - Titular: nome completo do cliente.
  - Número do Pedido.
  - QR Code com hash `INGRESSO-<pedido_id>-<id_compra>`.
- Upload opcional para R2 (S3) e retorno como `FileResponse`.

### Próximos Confrontos
- Exibidos em grid abaixo do formulário.
- Até 3 jogos futuros.
- Mostra escudos, nome do adversário, data (`d/m/Y`), hora (`H\hi`) e local.

---

## 2. Visualização na Página de Perfil

**URL:** `/perfil/`  
**View:** `tela_perfil`  
**Template:** `app_futebol/perfil.html`

### Contexto Enviado pelo Template

Além dos dados do cliente (`get_cliente_logado`), a view envia:

| Variável | Descrição |
|----------|-----------|
| `historico` | Histórico geral de compras (qualquer categoria). |
| `ingressos` | Apenas ingressos (categoria 10), retornados por `get_ingressos_cliente`. |

### Estrutura dos Dados de Ingresso (`ingressos`)

Cada pedido agrupado contém:

```python
{
    'pedido': {
        'id_pedido': int,
        'data_pedido': str,      # "DD/MM/YYYY HH:MM"
        'data_pedido_iso': str,  # ISO para JS se necessário
        'status': str            # status do pedido
    },
    'itens': [
        {
            'quantidade': int,
            'valor_unitario': float,
            'subtotal': float,
            'produto': {
                'nome_produtos': str
            },
            'adversario': str,    # nome do time adversário
            'data_hora': str,     # "DD/MM/YYYY HH:MM"
            'local': str,         # local do jogo
            'casa_fora': str      # 'casa' ou 'fora'
        }
    ],
    'valor_total': float
}
```

### Regras de Exibição

#### Histórico de Compras (Geral)
- Itera sobre `historico`.
- Exibe:
  - ID do pedido (via `data-pedido`).
  - Status com classes condicionais: `status-entregue` ou `status-processando`.
  - Valor total formatado (`R$ X,XX`).
  - Botão "Ver Detalhes" para expandir/recolher itens.
- Detalhes expandidos mostram:
  - Imagem do produto (se for URL externa, usa diretamente; senão, usa `{% static %}`).
  - Nome, preço unitário, quantidade e subtotal por item.

#### Seção de Ingressos
- A view carrega `ingressos = get_ingressos_cliente(request, cliente)`.
- **Observação:** No template atual (`perfil.html`), não há seção dedicada visível para listar os ingressos separadamente do histórico geral.
- A função `get_ingressos_cliente` retorna a mesma estrutura de agrupamento por pedido, mas apenas com itens da categoria 10.

### Função Helper: `get_ingressos_cliente`

```python
def get_ingressos_cliente(request, cliente_obj=None):
    compras = models.Compra.objects.filter(
        pedido_id_pedido__clientes_id_clientes=cliente_obj,
        produtos_id_produtos__categoria_produtos_id_categoria_produtos=10
    ).select_related(...)
    # Agrupa por pedido, adicionando campos extras de jogo (adversário, data_hora, local, casa_fora)
    return [agrupados[pid] for pid in ordem]
```

---

## 3. Views e URLs Relacionadas

| URL | View | Método | Descrição |
|-----|------|--------|-----------|
| `/ingresso/` | `tela_ingressos` | GET | Renderiza página de compra de ingressos. |
| `/adicionar/<produto_id>/` | `adicionar_carrinho` | POST | Adiciona ingresso ao carrinho da sessão. |
| `/remover/<produto_id>/` | `remover_carrinho` | POST | Remove ingresso do carrinho. |
| `/atualizar/<produto_id>/` | `atualizar_quantidade_carrinho` | POST | Atualiza quantidade (usado principalmente no carrinho). |
| `/finalizar_compra/` | `finalizar_compra` | POST | Cria `Pedido` e `Compra`, abate estoque, limpa sessão. |
| `/baixar_ingresso/<pedido_id>/` | `gerar_pdf_ingressos` | GET | Gera e retorna PDF dos ingressos do pedido. |

---

## 4. Fluxo de Dados

```
[Tela_Ingresso.html]
    |
    |--> Seleciona setor + quantidade
    |--> JS adiciona item visual
    |--> AJAX POST /adicionar/<id>/
            |
            v
    [Carrinho na Sessão]
            |
            |--> Finalizar Compra
            |--> AJAX POST /finalizar_compra/
                    |
                    v
            [Pedido + Compras no Banco]
                    |
                    |--> Retorna {pedido_id, sucesso: true}
                    |
                    v
            [JS abre /baixar_ingresso/<pedido_id>/]
                    |
                    v
            [PDF gerado em memória + upload opcional R2]
```

---

## 5. Considerações Técnicas

- Autenticação: todas as ações exigem `cliente_id` na sessão.
- CSRF Token: obrigatório em todas as requisições POST (AJAX e formulários).
- Cálculo de total no JS é apenas visual; o valor final é processado no back-end em `/finalizar_compra/`.
- O desconto por plano sócio é aplicado na tela de carrinho, não diretamente na tela de ingressos (a menos que o item seja adicionado ao carrinho e o usuário acesse `/carrinho/`).
- Upload de PDF para R2 é opcional e silencioso: em caso de erro, o PDF é retornado diretamente pelo `FileResponse`.
- QR Code gerado em memória (BytesIO) sem salvar em disco.
