# Projeto Futebol

Breve aplicação Django para gerenciar uma loja/portal de futebol com perfil de usuário, loja, carrinho e histórico de compras.

**Última atualização:** 15/01/2026 — melhorias no `perfil` para exibir histórico de compras, conversão de horário para fuso local do dispositivo e interações acessíveis.

## Pré-requisitos

- Python 3.10+
- MySQL (para importar o dump de exemplo em `db/db_futebol_teste.sql`)
- Virtualenv (recomendado)

## Instalação

1. Criar e ativar um virtualenv:

```bash
python -m venv venv
venv\Scripts\activate
```

2. Instalar dependências:

```bash
pip install -r requirements.txt
```

3. Importar banco de dados de exemplo (opcional):

```sql
-- usar o cliente MySQL para importar
SOURCE db/db_futebol_teste.sql;
```

4. Ajustar `DATABASES` em `projeto_futebol/settings.py` conforme seu ambiente.

## Executando a aplicação

```bash
python manage.py migrate
python manage.py runserver
```

Abra `http://127.0.0.1:8000/` no navegador.

## Visualizar perfil e histórico de compras

- Faça login com um usuário válido. O sistema usa `request.session['cliente_id']` para identificar o cliente atualmente logado.
- A página de perfil está em `/perfil/` e exibe o histórico de compras montado server-side.
- As datas dos pedidos são armazenadas em ISO no HTML e convertidas no cliente para o fuso local do dispositivo usando a API `Intl.DateTimeFormat`.

## Arquivos modificados / notas de desenvolvimento

- `app_futebol/views.py` — novo helper `get_historico_cliente` e ajustes em `tela_perfil` para montar e serializar o histórico.
- `app_futebol/templates/app_futebol/perfil.html` — marcação do histórico, atributo `data-datetime` com ISO e fallback server-side para exibição de data.
- `app_futebol/static/js/perfil.js` — conversão de datetime para o fuso local do usuário e comportamentos de dropdown/toggle acessíveis.
- `app_futebol/static/css/perfil.css` — estilos e transições para `detalhes-pedido`.

## Testes

Rodar testes Django:

```bash
python manage.py test
```

## Contribuição

Abra uma issue ou envie um pull request. Mantenha as mudanças pequenas e documentadas.

## Observações

- Verifique o caminho das imagens dos produtos: dependendo de como foram armazenadas (media vs static), pode ser necessário ajustar `MEDIA_URL`/`STATIC_URL` ou o template para usar `{% static %}`.
- Se precisar que as datas sigam um formato específico (por exemplo, dia/mês/ano com horas), posso ajustar a formatação no cliente.

---

Se quiser, atualizo também exemplos de uso, badges ou instruções específicas para deploy (Docker, Heroku, etc.).
# Clube de Futebol – Equipe Drakos

A **Plataforma Digital da Equipe Drakos** é um sistema completo desenvolvido para oferecer uma **experiência única** tanto para os torcedores quanto para a administração do clube.  
O projeto foi idealizado para ser **robusto, escalável e integrado**, suportando múltiplos usuários e transações simultâneas sem perda de desempenho.

---

## Visão Geral do Projeto

A plataforma da **Equipe Drakos** é uma solução multiplataforma — com versões **Desktop**, **Web** e **Mobile** — todas conectadas a um **único banco de dados** centralizado no **MySQL Workbench**.

### Objetivo
Oferecer um ambiente digital que una:
- Torcedores engajados e conectados ao clube.
- Administração eficiente e organizada.
- Recursos comerciais sustentáveis e automatizados.

---

## Funcionalidades Principais

###  Versões da Plataforma

- **Versão Desktop:**  
  Voltada para funcionários e administradores do clube.  
  Permite acesso ao painel de controle completo, com gerenciamento de usuários, eventos, produtos e finanças.  
  Cada usuário acessa funcionalidades específicas de acordo com seu **login e nível de permissão**.

- **Versão Web (Responsiva):**  
  Desenvolvida para funcionar em qualquer navegador ou dispositivo.  
  Oferece uma experiência fluida e adaptável, ideal para torcedores e visitantes.

- **Versão Mobile:**  
  Aplicativo dedicado para smartphones, garantindo **acesso rápido e prático** aos conteúdos do clube, compras, notificações e eventos.

---

## Gestão de Usuários

O sistema conta com um **módulo de autenticação e controle de acesso**, incluindo:
- Cadastro e login de torcedores.  
- Gerenciamento de perfis e informações pessoais.  
- Áreas exclusivas para **sócios** e **administradores**.  
- Personalização de contas e permissões específicas.

---

## Área Comercial e Monetização

A plataforma conta com uma forte vertente comercial, abrangendo:

- **Planos de Sócio:**  
  Torcedores podem adquirir planos para acesso a bastidores, promoções e descontos exclusivos.  

- **Venda de Ingressos:**  
  Compra e escolha de assentos diretamente pela plataforma, com integração de pagamento e QR Code de entrada.

- **E-commerce Oficial:**  
  Loja virtual com produtos oficiais do clube (camisetas, bonés, itens personalizados etc.).  

- **Publicidade e Parcerias:**  
  Espaços para divulgação de marcas e patrocinadores do setor esportivo.  

- **Conteúdos Premium:**  
  Transmissões exclusivas, eventos online com jogadores e personalização de perfis com emblemas especiais.

**Resultado:** Geração de receita contínua e engajamento duradouro da comunidade Drakos.

---

## Banco de Dados Transversal

Todas as versões (Desktop, Web e Mobile) estão conectadas a um **único banco de dados MySQL**, garantindo:
- Sincronização em tempo real.  
- Atualizações automáticas de dados de usuários, eventos e transações.  
- Segurança e integridade das informações.

---

## Tecnologias Utilizadas

### Front-end
| Tecnologia | Função |
|-------------|--------|
| **HTML5** | Estruturação das páginas e organização dos elementos visuais. |
| **CSS3** | Estilização e design responsivo da interface. |
| **JavaScript** | Interatividade, dinamismo e lógica de comportamento do usuário. |

### Back-end
| Tecnologia | Função |
|-------------|--------|
| **Python** | Linguagem principal pela sua simplicidade e escalabilidade. |
| **Django** | Framework web robusto e seguro para autenticação, rotas, administração e integração com o banco de dados. |

### Banco de Dados
| Ferramenta | Função |
|-------------|--------|
| **MySQL Workbench** | Modelagem, gerenciamento e manutenção do banco relacional da plataforma. |

---

## Rodando localmente

Clone o projeto

```bash
  git clone https://github.com/fenando-ff/projeto_futebol
```

Entre no diretório do projeto

```bash
  cd projeto_futebol
```

Instale as dependências

```bash
  pip install -r requirements.txt
```
Copie o banco de dados contido em script.db e ajuste o settings.py e rode o comando

```bash
  python manage.py makemigrations
```
Inicie o servidor

```bash
  python manage.py runserver
```

## Estrutura de Desenvolvimento

- **Arquitetura escalável e modular**
- **Integração entre versões (Desktop, Web e Mobile)**
- **Sincronização automática de dados**
- **Painel administrativo completo**
- **Design responsivo e intuitivo**

---

## Benefícios do Sistema

Experiência unificada entre todas as plataformas  
Acesso rápido e seguro para diferentes tipos de usuários  
Fortalecimento da comunidade e da marca Drakos  
Sustentabilidade financeira com múltiplas fontes de receita  
Base sólida para futuras expansões e integrações

---

## Conclusão

A **Plataforma Drakos** não é apenas um sistema digital — é um **ecossistema completo** que conecta o clube, os torcedores e os parceiros comerciais.  
Com ela, a **Equipe Drakos** fortalece sua presença digital e constrói uma comunidade fiel e apaixonada pelo futebol.

---

### Contato
Em caso de dúvidas ou sugestões, entre em contato com a equipe de desenvolvimento Drakos.
- pedro56438076@senac.edu.pa.br
- fernando10744196@edu.pa.senac.br
- nayane53507206@edu.pa.senac.br
- emanuel57997516@edu.pa.senac.br

**#EquipeDrakos • Unidos pela Paixão do Futebol**
