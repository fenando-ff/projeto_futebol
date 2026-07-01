from rest_framework import serializers
from .models import (
    Alternativas,
    CategoriaCliente,
    CategoriaProdutos,
    Clientes,
    Compra,
    EnderecoCliente,
    Funcionarios,
    HistoricoTitulos,
    ImagemProduto,
    Jogos,
    Pedido,
    Produtos,
    ProgressoFases,
    Questoes,
    RecuperacaoSenha,
    Respostas,
    SetorFuncionarios,
    Times,
    Titulos,
)

class ClientesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Clientes
        fields = [
            "id_clientes",
            "nome_clientes",
            "sobrenome_clientes",
            "email_clientes",
            "sexo_clientes",
            "telefone_clientes",
            "cpf_clientes",
            "status_clientes",
            "url_foto_clientes",
            "categoria_cliente_id_categoria_cliente",
            "score_rank",
            "total_acertos",
            "total_questoes",
            "precisao",
            "tempo",
        ]


class CategoriaProdutosSerializer(serializers.ModelSerializer):
    class Meta:
        model = CategoriaProdutos
        fields = '__all__'


class ProdutosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Produtos
        fields = '__all__'


class CategoriaClienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = CategoriaCliente
        fields = '__all__'


class EnderecoClienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = EnderecoCliente
        fields = '__all__'


class PedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pedido
        fields = '__all__'


class CompraSerializer(serializers.ModelSerializer):
    produtos = serializers.StringRelatedField()
    pedido = serializers.StringRelatedField()

    class Meta:
        model = Compra
        fields = '__all__'


class JogosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Jogos
        fields = '__all__'


class FuncionariosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Funcionarios
        exclude = ['senha_funcionarios']


class QuestoesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Questoes
        fields = '__all__'


class RespostasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Respostas
        fields = '__all__'


class RecuperacaoSenhaSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecuperacaoSenha
        fields = '__all__'


class ProgressoFasesSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProgressoFases
        fields = ["cliente", "fase2_liberada"]


class TitulosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Titulos
        fields = '__all__'


class HistoricoTitulosSerializer(serializers.ModelSerializer):
    cliente = ClientesSerializer(read_only=True)
    titulo = TitulosSerializer(read_only=True)

    class Meta:
        model = HistoricoTitulos
        fields = '__all__'