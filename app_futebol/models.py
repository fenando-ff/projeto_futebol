# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class AccountsPerfil(models.Model):
    id = models.BigAutoField(primary_key=True)
    sexo = models.CharField(max_length=10, blank=True, null=True)
    cpf = models.CharField(unique=True, max_length=14)
    telefone = models.CharField(max_length=20, blank=True, null=True)
    user_id = models.IntegerField(unique=True)

    class Meta:
        
        

        
        managed = False
        db_table = 'accounts_perfil'


    def __str__(self):
        return str(self.user_id)


class Alternativas(models.Model):
    id_alternativa = models.AutoField(primary_key=True)
    opcao_resposta = models.CharField(max_length=500)
    resposta_correta = models.IntegerField()
    ponto = models.IntegerField()
    questao = models.ForeignKey('Questoes', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'alternativas'


    def __str__(self):
        return self.opcao_resposta


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group_id = models.IntegerField()
    permission_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group_id', 'permission_id'),)


    def __str__(self):
        return f"{self.group_id} - {self.permission_id}"


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type_id = models.IntegerField()
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type_id', 'codename'),)


    def __str__(self):
        return f"{self.name} ({self.codename})"


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


    def __str__(self):
        return self.username


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user_id = models.IntegerField()
    group_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user_id', 'group_id'),)


    def __str__(self):
        return f"{self.user_id} - {self.group_id}"


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user_id = models.IntegerField()
    permission_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user_id', 'permission_id'),)


    def __str__(self):
        return f"{self.user_id} - {self.permission_id}"


class CategoriaCliente(models.Model):
    id_categoria_cliente = models.AutoField(db_column='id_CATEGORIA_CLIENTE', primary_key=True)  # Field name made lowercase.
    nome_categoria_clientes = models.CharField(db_column='nome_CATEGORIA_CLIENTES', max_length=45)  # Field name made lowercase.
    descricao_categ_cli = models.TextField()
    preco_categ = models.FloatField()

    class Meta:
        managed = False
        db_table = 'categoria_cliente'


    def __str__(self):
        return self.nome_categoria_clientes


class CategoriaProdutos(models.Model):
    id_categoria_produtos = models.AutoField(db_column='id_CATEGORIA_PRODUTOS', primary_key=True)  # Field name made lowercase.
    nome_categoria_produtos = models.CharField(db_column='nome_CATEGORIA_PRODUTOS', max_length=45)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'categoria_produtos'


    def __str__(self):
        return self.nome_categoria_produtos


class Clientes(models.Model):
    id_clientes = models.AutoField(db_column='id_CLIENTES', primary_key=True)  # Field name made lowercase.
    senha_clientes = models.CharField(db_column='senha_CLIENTES', max_length=255)  # Field name made lowercase.
    sexo_clientes = models.CharField(db_column='sexo_CLIENTES', max_length=20)  # Field name made lowercase.
    telefone_clientes = models.CharField(db_column='telefone_CLIENTES', max_length=15)  # Field name made lowercase.
    email_clientes = models.CharField(db_column='email_CLIENTES', max_length=50)  # Field name made lowercase.
    nome_clientes = models.CharField(db_column='nome_CLIENTES', max_length=45)  # Field name made lowercase.
    sobrenome_clientes = models.CharField(db_column='sobrenome_CLIENTES', max_length=45)  # Field name made lowercase.
    cpf_clientes = models.CharField(db_column='cpf_CLIENTES', max_length=14)  # Field name made lowercase.
    status_clientes = models.IntegerField(db_column='status_CLIENTES')  # Field name made lowercase.
    url_foto_clientes = models.CharField(db_column='url_foto_CLIENTES', max_length=255, blank=True, null=True)  # Field name made lowercase.
    categoria_cliente_id_categoria_cliente = models.ForeignKey(CategoriaCliente, models.DO_NOTHING, db_column='CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE')  # Field name made lowercase.
    score_rank = models.IntegerField(blank=True, null=True)
    total_acertos = models.IntegerField(blank=True, null=True)
    total_questoes = models.IntegerField(blank=True, null=True)
    precisao = models.FloatField(blank=True, null=True)
    tempo = models.TimeField(blank=True, null=True)

    # aliases de compatibilidade (equivalente a Participantes)
    @property
    def nome_participante(self):
        return self.nome_clientes

    @property
    def id_participante(self):
        return self.id_clientes

    class Meta:
        managed = False
        db_table = 'clientes'


    def __str__(self):
        return f"{self.nome_clientes} ({self.cpf_clientes})"


class Compra(models.Model):
    id_compra = models.AutoField(primary_key=True)
    produtos_id_produtos = models.ForeignKey('Produtos', models.DO_NOTHING, db_column='PRODUTOS_id_PRODUTOS')  # Field name made lowercase.
    pedido_id_pedido = models.ForeignKey('Pedido', models.DO_NOTHING, db_column='PEDIDO_id_PEDIDO')  # Field name made lowercase.
    quantidade_pedido = models.IntegerField(db_column='quantidade_PEDIDO')  # Field name made lowercase.
    valor_compra = models.DecimalField(max_digits=10, decimal_places=0)

    class Meta:
        managed = False
        db_table = 'compra'


    def __str__(self):
        return f"Compra {self.id_compra}"


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type_id = models.IntegerField(blank=True, null=True)
    user_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'django_admin_log'


    def __str__(self):
        return f"{self.object_repr}"


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


    def __str__(self):
        return f"{self.app_label}.{self.model}"


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


    def __str__(self):
        return f"{self.app}: {self.name}"


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class EnderecoCliente(models.Model):
    id_endereco_cliente = models.AutoField(db_column='id_ENDERECO_CLIENTE', primary_key=True)  # Field name made lowercase.
    cep_endereco_cliente = models.CharField(db_column='cep_ENDERECO_CLIENTE', max_length=8)  # Field name made lowercase.
    complemento_endereco_cliente = models.CharField(db_column='complemento_ENDERECO_CLIENTE', max_length=45)  # Field name made lowercase.
    bairro_endereco_cliente = models.CharField(db_column='bairro_ENDERECO_CLIENTE', max_length=45)  # Field name made lowercase.
    casa_endereco_cliente = models.CharField(db_column='casa_ENDERECO_CLIENTE', max_length=45)  # Field name made lowercase.
    rua_endereco_cliente = models.CharField(db_column='rua_ENDERECO_CLIENTE', max_length=45)  # Field name made lowercase.
    cliente_id_cliente = models.OneToOneField(Clientes, models.DO_NOTHING, db_column='cliente_id_cliente')

    class Meta:
        managed = False
        db_table = 'endereco_cliente'


    def __str__(self):
        return f"Endereço: {self.rua_endereco_cliente}, {self.casa_endereco_cliente}"


class EnderecoFuncionarios(models.Model):
    id_endereco_funcionarios = models.AutoField(db_column='id_ENDERECO_FUNCIONARIOS', primary_key=True)  # Field name made lowercase.
    cep_endereco_funcionarios = models.CharField(db_column='cep_ENDERECO_FUNCIONARIOS', max_length=8)  # Field name made lowercase.
    complemento_endereco_funcionarios = models.CharField(db_column='complemento_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    bairro_endereco_funcionarios = models.CharField(db_column='bairro_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    casa_endereco_funcionarios = models.CharField(db_column='casa_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    rua_endereco_funcionarios = models.CharField(db_column='rua_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    funcionarios_id_funcionarios = models.OneToOneField('Funcionarios', models.DO_NOTHING, db_column='funcionarios_id_funcionarios')

    class Meta:
        managed = False
        db_table = 'endereco_funcionarios'


    def __str__(self):
        return f"Endereço: {self.rua_endereco_funcionarios}, {self.casa_endereco_funcionarios}"


class Funcionarios(models.Model):
    id_funcionarios = models.AutoField(db_column='id_FUNCIONARIOS', primary_key=True)  # Field name made lowercase.
    senha_funcionarios = models.CharField(db_column='senha_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    login_funcionarios = models.CharField(db_column='login_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    telefone_funcionarios = models.CharField(db_column='telefone_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    email_funcionarios = models.CharField(db_column='email_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    sexo_funcionarios = models.CharField(db_column='sexo_FUNCIONARIOS', max_length=20)  # Field name made lowercase.
    nome_funcionarios = models.CharField(db_column='nome_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    setor_funcionarios_id_setor_funcionarios = models.ForeignKey('SetorFuncionarios', models.DO_NOTHING, db_column='SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'funcionarios'


    def __str__(self):
        return f"{self.nome_funcionarios} ({self.login_funcionarios})"


class HistoricoTitulos(models.Model):
    id_historico = models.AutoField(primary_key=True)
    titulo = models.ForeignKey('Titulos', models.DO_NOTHING)
    cliente = models.ForeignKey(Clientes, models.DO_NOTHING)
    ativo = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'historico_titulos'


    def __str__(self):
        return f"Histórico: {self.cliente} - {self.titulo}"


class ImagemProduto(models.Model):
    id_imagem_produto = models.AutoField(db_column='id_IMAGEM_PRODUTO', primary_key=True)  # Field name made lowercase.
    imagem_imagem = models.CharField(db_column='imagem_IMAGEM', max_length=255)  # Field name made lowercase.
    ordem_imagem = models.IntegerField(db_column='ordem_IMAGEM')  # Field name made lowercase.
    produtos_id_produtos = models.IntegerField(db_column='PRODUTOS_id_PRODUTOS')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'imagem_produto'


    def __str__(self):
        return f"Imagem {self.id_imagem_produto} - {self.imagem_imagem}"


class Jogos(models.Model):
    id_jogos = models.AutoField(primary_key=True)
    dia_jogo = models.DateField()
    hora_jogo = models.TimeField()
    local_jogo = models.CharField(max_length=50)
    casa_fora = models.CharField(max_length=4)
    times_id_times = models.ForeignKey('Times', models.DO_NOTHING, db_column='times_id_times')

    class Meta:
        managed = False
        db_table = 'jogos'


    def __str__(self):
        return f"{self.local_jogo} - {self.dia_jogo} {self.hora_jogo}"


class Pedido(models.Model):
    id_pedido = models.AutoField(db_column='id_PEDIDO', primary_key=True)  # Field name made lowercase.
    data_pedido = models.DateTimeField(db_column='data_PEDIDO')  # Field name made lowercase.
    status = models.CharField(max_length=9)
    clientes_id_clientes = models.ForeignKey(Clientes, models.DO_NOTHING, db_column='CLIENTES_id_CLIENTES')  # Field name made lowercase.
    funcionarios_id_funcionarios = models.ForeignKey(Funcionarios, models.DO_NOTHING, db_column='FUNCIONARIOS_id_FUNCIONARIOS', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'pedido'


    def __str__(self):
        return f"Pedido {self.id_pedido} - {self.clientes_id_clientes}"


class Produtos(models.Model):
    id_produtos = models.AutoField(db_column='id_PRODUTOS', primary_key=True)  # Field name made lowercase.
    nome_produtos = models.CharField(db_column='nome_PRODUTOS', max_length=45)  # Field name made lowercase.
    valor_produtos = models.FloatField(db_column='valor_PRODUTOS')  # Field name made lowercase.
    descricao_produtos = models.TextField(db_column='descricao_PRODUTOS')  # Field name made lowercase.
    quantidade_estoque_produtos = models.IntegerField(db_column='quantidade_estoque_PRODUTOS')  # Field name made lowercase.
    categoria_produtos_id_categoria_produtos = models.ForeignKey(CategoriaProdutos, models.DO_NOTHING, db_column='CATEGORIA_PRODUTOS_id_CATEGORIA_PRODUTOS')  # Field name made lowercase.
    imagem_produtos = models.CharField(db_column='imagem_PRODUTOS', max_length=255, blank=True, null=True)  # Field name made lowercase.
    jogos_id_jogos = models.ForeignKey(Jogos, models.DO_NOTHING, db_column='jogos_id_jogos', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'produtos'


    def __str__(self):
        return f"{self.nome_produtos} - R$ {self.valor_produtos}"


class ProgressoFases(models.Model):
    cliente = models.OneToOneField(Clientes, models.DO_NOTHING, primary_key=True)
    fase2_liberada = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'progresso_fases'


    def __str__(self):
        return f"Progresso: {self.cliente} - Fase2: {'Liberada' if self.fase2_liberada else 'Bloqueada'}"


class Questoes(models.Model):
    id_questao = models.AutoField(primary_key=True)
    pergunta = models.TextField()

    class Meta:
        managed = False
        db_table = 'questoes'


    def __str__(self):
        return self.pergunta[:80]


class RecuperacaoSenha(models.Model):
    id = models.BigAutoField(primary_key=True)
    codigo = models.CharField(max_length=6)
    criado_em = models.DateTimeField()
    cliente_id = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'recuperacao_senha'


    def __str__(self):
        return f"Código: {self.codigo} - Cliente: {self.cliente_id}"


class Respostas(models.Model):
    pk = models.CompositePrimaryKey('cliente_id', 'questao_id')
    cliente = models.ForeignKey(Clientes, models.DO_NOTHING)
    questao = models.ForeignKey(Questoes, models.DO_NOTHING)
    alternativa = models.ForeignKey(Alternativas, models.DO_NOTHING)
    combo_max = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'respostas'


    def __str__(self):
        return f"{self.cliente} - {self.questao} - {self.alternativa}"


class SetorFuncionarios(models.Model):
    id_setor_funcionarios = models.AutoField(db_column='id_SETOR_FUNCIONARIOS', primary_key=True)  # Field name made lowercase.
    nome_setor_funcionarios = models.CharField(db_column='nome_SETOR_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    descricao_setor = models.TextField()

    class Meta:
        managed = False
        db_table = 'setor_funcionarios'


    def __str__(self):
        return self.nome_setor_funcionarios


class Times(models.Model):
    id_times = models.AutoField(primary_key=True)
    nome_time = models.CharField(max_length=45)
    url_brasao = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'times'


    def __str__(self):
        return self.nome_time


class Titulos(models.Model):
    id_titulo = models.AutoField(primary_key=True)
    nome_titulo = models.CharField(max_length=45)

    class Meta:
        managed = False
        db_table = 'titulos'

    def __str__(self):
        return self.nome_titulo