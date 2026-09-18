# Auditoria de fluxo e codigo morto — 17/09/2026

## 1. Bugs encontrados

- Recuperacao, etapa 2: GET renderizava a tela sem verificar a conclusao da etapa 1.
- Recuperacao, etapa 3: a flag `codigo_validado` nao estava vinculada ao registro de recuperacao. Reiniciar a etapa 1 nao limpava essa flag, permitindo aproveitar uma validacao anterior inclusive ao informar outro email.
- Etapa 3 nao revalidava existencia/expiracao do registro; a troca de senha nao consumia os codigos no banco.
- Falha no envio de email podia deixar estado parcial na sessao. POST sem senha podia gerar erro ao calcular seu tamanho.
- A API imprimia codigos recebidos e armazenados. A representacao textual do model e o serializer administrativo tambem expunham o codigo.
- Pagamento aceitava GET/POST com qualquer categoria existente na URL, sem selecao anterior. Plano inexistente redirecionava para `tela_socio`, nome de rota que nao existe.
- `socios.js` registrava um listener em `btnSocio`, elemento ausente dos templates, causando erro JavaScript. Tambem criava uma variavel global implicita.

## 2. Correcoes aplicadas

### Recuperacao

- GET e POST das etapas 2 e 3 validam sessao, cliente, registro mais recente e prazo existente de duas horas.
- A etapa 3 exige `recuperacao_validada_id` igual ao registro atual; a flag antiga nao concede acesso.
- Entrar/reiniciar a etapa 1 limpa o estado anterior. A etapa 2 so e liberada apos envio de email bem-sucedido.
- A troca de senha revalida o registro dentro de transacao com `select_for_update`, atualiza a senha e exclui os registros de recuperacao do cliente. Depois limpa a sessao.
- Codigos gerados com `secrets`; comparacao constante no fluxo web; cinco erros na sessao invalidam o registro.
- Acesso indevido redireciona ao inicio com mensagem generica. Respostas dessas telas usam `never_cache`.
- Removidos logs de diagnostico da recuperacao que podiam revelar codigos. Codigo removido do `__str__` e marcado `write_only` no serializer administrativo.
- Os endpoints publicos de recuperacao mantem seus campos e respostas; a API continua validando o codigo no proprio pedido de redefinicao.

### Socio

- Nova rota web `selecionar_plano_socio/<id>/`, somente POST e protegida pelo middleware CSRF.
- A escolha valida a categoria no banco e usa a classificacao de socio existente, rejeitando categoria inexistente ou nao socio.
- A sessao guarda plano, cliente e horario da escolha, com validade de 30 minutos.
- GET e POST de pagamento exigem essa selecao, correspondencia com a URL/cliente e nova consulta ao plano no banco.
- Confirmar a assinatura consome a selecao; login limpa selecoes anteriores. Acesso invalido redireciona para a rota `socio`.
- Os cards conservam suas classes e conteudo: o container passa a ser um form e o link de escolha passa a ser um botao de envio. Nenhum CSS ativo foi editado nesta auditoria.
- Regras de categoria, descontos, cancelamento e atualizacao da assinatura foram preservadas. O pagamento existente continua sendo uma confirmacao simulada, sem verificacao por gateway; esta auditoria nao implementa cobranca real.

## 3. Arquivos mortos removidos

Antes da exclusao: pesquisa de referencias no repositorio, templates, rotas/views, JavaScript e imports CSS. Nao havia referencias aos nomes/caminhos nem carregamento dinamico desses arquivos no codigo inspecionado.

| Arquivo | Evidencia |
| --- | --- |
| `accounts/templates/acconts/cadastro_2.html` | Sem view, rota, include ou referencia; cadastro atual usa `cadastro.html`. |
| `accounts/templates/acconts/cadastro_3.html` | Mesmo caso; ainda apontava para rotas antigas inexistentes. |
| `app_futebol/static/css/Tela_loja.css` | Sem link/import; loja atual usa `loja_produtos.css` e `loja_detalhe.css`. |
| `app_futebol/static/css/bem_vindo.css` | Sem link/import ou carregador dinamico. |
| `app_futebol/static/css/demo.css` | Sem link/import ou carregador dinamico. |
| `app_futebol/static/css/style.css` | Sem link/import; base atual carrega `main.css`. |
| `app_futebol/static/js/desafio.js` | Exercicio de login com prompt e credenciais fixas, sem inclusao/referencia. |

Limpeza pontual adicional: imports sem uso em `accounts/views.py`, serializers, views, helpers e viewsets; funcao sem chamadas `get_socio_catalog_order`; propriedade `Clientes.is_authenticated` duplicada e sobrescrita; listener inexistente e parametro sem uso em `socios.js`; variavel local sem uso e comentarios legados em `get_historico_cliente`. Retornos descartados de `get_or_create` e das dimensoes A4 agora usam `_`, preservando as chamadas.

## 4. Suspeitos mantidos por seguranca

- `app_futebol/api.py` e `app_futebol/api_urls.py`: parecem legados e nao estao ligados ao ROOT_URLCONF atual (`urls_api.py`). Mantidos por serem possiveis pontos de integracao externa e para evitar mudanca desnecessaria de APIs.
- `.kilo/conflict_analysis/*.css`: copias de trabalho de analise de conflitos, fora da arvore de estaticos da aplicacao.
- `static/css/botoes_cores_fontes/{cores.css,fontes.css,teste_fontes.css,ver_botoes.html}`: material de demonstracao/design possivelmente consultado diretamente. `ver_botoes.css` tem referencias reais em templates e foi mantido.
- Escudos duplicados nas pastas `img/brasoes` e `img/icones`: caminhos podem vir do banco/catalogo e existem referencias em templates. Hash igual nao prova que um caminho pode ser excluido.
- `minigame/static/js/game_toturial.js` e `quiz_toturial.js`: conteudo igual, mas cada arquivo e carregado por seu proprio template ativo.
- Seletores de CSS ativo aparentemente sem uso, incluindo `.btn-socio`: mantidos para evitar alterar estados dinamicos, responsividade ou o layout. Nao foi feita purga automatica de seletores.
- Arquivos de descoberta do Django (`admin.py`, `tests.py`, migrations, models e templatetags) nao foram excluidos por falta de chamadas diretas. Frameworks podem carregar simbolos implicitamente.
- Alteracoes preexistentes do usuario em CSS, imagens, loja e template base foram preservadas. A exclusao preexistente de `img/banners/loja_roupas.png` nao faz parte desta limpeza.

## 5. Validacoes

- `python manage.py check`: sem problemas.
- `python manage.py test --settings=projeto_futebol.test_settings --verbosity 1`: 33 testes, incluindo 24 novos testes de seguranca e os 9 existentes.
- `node --check app_futebol/static/js/socios.js`: sintaxe valida.
- Pesquisa textual, analise AST de imports/variaveis/funcoes e comparacao SHA-256 de arquivos duplicados; candidatos foram revisados antes da remocao.

Os novos testes exercitam HTTP, middleware, sessoes, templates e ORM reais em SQLite descartavel, com email em memoria. Cobrem GET/POST diretos, fluxo normal, codigo incorreto, limite de tentativas, expiracao, reinicio, troca de conta, flag antiga, isolamento de sessoes, novo codigo em outra sessao, reutilizacao apos troca de senha, falha de email, regras de senha, ausencia de codigo em respostas/logs, API, CSRF, planos invalidos, URL adulterada, selecao expirada/de outro cliente, plano removido e consumo da selecao.

Limites: nao houve envio de email real, cobranca real, teste de concorrencia no MySQL ou comparacao visual em navegador. As migrations existentes contem SQL especifico de MySQL e os models usam tabelas externas (`managed=False`); por isso a configuracao de testes isola o banco e cria somente as tres tabelas externas necessarias, sem alterar banco de desenvolvimento/producao.
