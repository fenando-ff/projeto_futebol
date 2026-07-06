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


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField(
        error_messages={
            "required": "Email e senha são obrigatórios.",
            "blank": "Email e senha são obrigatórios.",
            "invalid": "Email inválido.",
        }
    )
    senha = serializers.CharField(
        write_only=True,
        trim_whitespace=True,
        error_messages={
            "required": "Email e senha são obrigatórios.",
            "blank": "Email e senha são obrigatórios.",
        },
    )

    def validate_email(self, value):
        return value.strip().lower()

    def validate(self, attrs):
        senha = attrs.get("senha", "").strip()
        if not senha:
            raise serializers.ValidationError({"senha": "Email e senha são obrigatórios."})
        attrs["senha"] = senha
        return attrs


class LoginResponseSerializer(serializers.Serializer):
    token = serializers.CharField()
    cliente = ClientesSerializer(read_only=True)


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
    produtos = serializers.SerializerMethodField()
    pedido = serializers.SerializerMethodField()

    class Meta:
        model = Compra
        fields = '__all__'

    def get_produtos(self, obj):
        produto = obj.produtos_id_produtos
        return {
            "id": produto.id_produtos,
            "nome_produtos": produto.nome_produtos,
            "imagem_produtos": produto.imagem_produtos,
            "valor_produtos": float(produto.valor_produtos),
        }

    def get_pedido(self, obj):
        pedido = obj.pedido_id_pedido
        return {
            "id_pedido": pedido.id_pedido,
            "data_pedido": pedido.data_pedido.strftime("%d/%m/%Y %H:%M"),
            "status": pedido.status,
        }


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


class TimesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Times
        fields = '__all__'


class ProdutoCarrinhoSerializer(serializers.ModelSerializer):
    categoria_nome = serializers.CharField(source="categoria_produtos_id_categoria_produtos.nome_categoria_produtos", read_only=True)
    imagem = serializers.CharField(source="imagem_produtos", read_only=True)

    class Meta:
        model = Produtos
        fields = [
            "id_produtos",
            "nome_produtos",
            "descricao_produtos",
            "valor_produtos",
            "quantidade_estoque_produtos",
            "categoria_nome",
            "imagem",
        ]


class CarrinhoItemSerializer(serializers.ModelSerializer):
    produto = ProdutoCarrinhoSerializer(read_only=True)
    subtotal = serializers.SerializerMethodField()
    produto_id = serializers.IntegerField(write_only=True)
    quantidade = serializers.IntegerField(min_value=1)

    class Meta:
        model = Compra
        fields = [
            "id_compra",
            "produto",
            "produto_id",
            "quantidade",
            "valor_compra",
            "subtotal",
        ]
        read_only_fields = ["id_compra", "valor_compra", "subtotal"]

    def get_subtotal(self, obj):
        valor = float(obj.valor_compra or 0)
        quantidade = int(obj.quantidade_pedido or 1)
        return valor * quantidade


class CarrinhoSerializer(serializers.Serializer):
    items = CarrinhoItemSerializer(many=True, read_only=True)
    quantidade_total = serializers.IntegerField(read_only=True)
    valor_total = serializers.FloatField(read_only=True)
