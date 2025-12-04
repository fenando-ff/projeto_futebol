# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.utils import timezone
from datetime import timedelta

class CategoriaCliente(models.Model):
    id_categoria_cliente = models.AutoField(db_column='id_CATEGORIA_CLIENTE', primary_key=True)  # Field name made lowercase.
    nome_categoria_clientes = models.CharField(db_column='nome_CATEGORIA_CLIENTES', max_length=45)  # Field name made lowercase.
    descricao_categ_cli = models.TextField()
    preco_categoria = models.FloatField(db_column='preco_categ')

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
    categoria_cliente_id_categoria_cliente = models.ForeignKey(CategoriaCliente, models.DO_NOTHING, db_column='CATEGORIA_CLIENTE_id_CATEGORIA_CLIENTE')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'clientes'
        
    def __str__(self):
        return f"{self.nome_clientes} {self.sobrenome_clientes}"




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
        return f"{self.cliente_id_cliente.nome_clientes} {self.cliente_id_cliente.sobrenome_clientes}"


class SetorFuncionarios(models.Model):
    id_setor_funcionarios = models.AutoField(db_column='id_SETOR_FUNCIONARIOS', primary_key=True)  # Field name made lowercase.
    nome_setor_funcionarios = models.CharField(db_column='nome_SETOR_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    descricao_setor = models.TextField()

    class Meta:
        managed = False
        db_table = 'setor_funcionarios'
#

class Funcionarios(models.Model):
    id_funcionarios = models.AutoField(db_column='id_FUNCIONARIOS', primary_key=True)  # Field name made lowercase.
    senha_funcionarios = models.CharField(db_column='senha_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    login_funcionarios = models.CharField(db_column='login_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    telefone_funcionarios = models.CharField(db_column='telefone_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    email_funcionarios = models.CharField(db_column='email_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    sexo_funcionarios = models.CharField(db_column='sexo_FUNCIONARIOS', max_length=20)  # Field name made lowercase.
    nome_funcionarios = models.CharField(db_column='nome_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    setor_funcionarios_id_setor_funcionarios = models.ForeignKey(SetorFuncionarios, models.DO_NOTHING, db_column='SETOR_FUNCIONARIOS_id_SETOR_FUNCIONARIOS')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'funcionarios'
        
    def __str__(self):
        return self.nome_funcionarios
        
        
class EnderecoFuncionarios(models.Model):
    id_endereco_funcionarios = models.AutoField(db_column='id_ENDERECO_FUNCIONARIOS', primary_key=True)  # Field name made lowercase.
    cep_endereco_funcionarios = models.CharField(db_column='cep_ENDERECO_FUNCIONARIOS', max_length=8)  # Field name made lowercase.
    complemento_endereco_funcionarios = models.CharField(db_column='complemento_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    bairro_endereco_funcionarios = models.CharField(db_column='bairro_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    casa_endereco_funcionarios = models.CharField(db_column='casa_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    rua_endereco_funcionarios = models.CharField(db_column='rua_ENDERECO_FUNCIONARIOS', max_length=45)  # Field name made lowercase.
    funcionarios_id_funcionarios = models.OneToOneField(Funcionarios, models.DO_NOTHING, db_column='funcionarios_id_funcionarios')

    class Meta:
        managed = False
        db_table = 'endereco_funcionarios'


class Pedido(models.Model):
    id_pedido = models.AutoField(db_column='id_PEDIDO', primary_key=True)  # Field name made lowercase.
    data_pedido = models.DateTimeField(db_column='data_PEDIDO')  # Field name made lowercase.
    clientes_id_clientes = models.ForeignKey(Clientes, models.DO_NOTHING, db_column='CLIENTES_id_CLIENTES')  # Field name made lowercase.
    funcionarios_id_funcionarios = models.ForeignKey(Funcionarios, models.DO_NOTHING, db_column='FUNCIONARIOS_id_FUNCIONARIOS', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'pedido'

    def __str__(self):
        return f"{self.clientes_id_clientes.nome_clientes} {self.clientes_id_clientes.sobrenome_clientes} - {self.data_pedido.strftime('%d/%m/%Y')}"

class Produtos(models.Model):
    id_produtos = models.AutoField(db_column='id_PRODUTOS', primary_key=True)  # Field name made lowercase.
    nome_produtos = models.CharField(db_column='nome_PRODUTOS', max_length=45)  # Field name made lowercase.
    valor_produtos = models.FloatField(db_column='valor_PRODUTOS')  # Field name made lowercase.
    descricao_produtos = models.TextField(db_column='descricao_PRODUTOS')  # Field name made lowercase.
    quantidade_estoque_produtos = models.IntegerField(db_column='quantidade_estoque_PRODUTOS')  # Field name made lowercase.
    categoria_produtos_id_categoria_produtos = models.ForeignKey(CategoriaProdutos, models.DO_NOTHING, db_column='CATEGORIA_PRODUTOS_id_CATEGORIA_PRODUTOS')  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'produtos'
        
    def __str__(self):
        return self.nome_produtos
    
    
class Compra(models.Model):
    produtos_id_produtos = models.ForeignKey(Produtos, models.DO_NOTHING, db_column='PRODUTOS_id_PRODUTOS')  # Field name made lowercase.
    pedido_id_pedido = models.ForeignKey(Pedido, models.DO_NOTHING, db_column='PEDIDO_id_PEDIDO')  # Field name made lowercase.
    quantidade_pedido = models.IntegerField(db_column='quantidade_PEDIDO')  # Field name made lowercase.
    valor_compra = models.DecimalField(max_digits=10, decimal_places=0)

    class Meta:
        managed = False
        db_table = 'compra'
        
    def __str__(self):
        return f"{self.produtos_id_produtos.nome_produtos} - {self.pedido_id_pedido.clientes_id_clientes.nome_clientes}"
    

class RecuperacaoSenha(models.Model):
        cliente = models.ForeignKey(Clientes, on_delete=models.CASCADE, db_column='cliente_id')
        codigo = models.CharField(max_length=6)
        criado_em = models.DateTimeField(auto_now_add=True)

        class Meta:
            db_table = 'recuperacao_senha'
            managed = True

        def expirado(self):
            return timezone.now() > self.criado_em + timedelta(minutes=10)


