import re

from django.contrib.auth.hashers import make_password
from django.db import transaction
from django.utils import timezone
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
from .views.helpers import build_public_image_url
from .views.socio_catalog import (
    build_pricing_snapshot,
    build_socio_api_plan,
    get_socio_desconto_percent,
    get_socio_tier,
)

class ClientesSerializer(serializers.ModelSerializer):
    categoria_clientes = serializers.SerializerMethodField(read_only=True)

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
            "categoria_clientes",
        ]

    def get_categoria_clientes(self, obj):
        categoria = getattr(obj, "categoria_cliente_id_categoria_cliente", None)
        if not categoria:
            return None

        return getattr(categoria, "nome_categoria_clientes", None)


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


class EsqueciSenhaSerializer(serializers.Serializer):
    email = serializers.EmailField(
        trim_whitespace=True,
        error_messages={
            "required": "Email é obrigatório.",
            "blank": "Email é obrigatório.",
            "invalid": "Email inválido.",
        },
    )

    def validate_email(self, value):
        return value.strip().lower()


class ValidarCodigoSerializer(serializers.Serializer):
    email = serializers.EmailField(
        trim_whitespace=True,
        error_messages={
            "required": "Email é obrigatório.",
            "blank": "Email é obrigatório.",
            "invalid": "Email inválido.",
        },
    )
    codigo = serializers.CharField(
        trim_whitespace=True,
        min_length=6,
        max_length=6,
        error_messages={
            "required": "Código é obrigatório.",
            "blank": "Código é obrigatório.",
            "min_length": "Código inválido.",
            "max_length": "Código inválido.",
        },
    )

    def validate_email(self, value):
        return value.strip().lower()

    def validate_codigo(self, value):
        return value.strip()


class RedefinirSenhaSerializer(serializers.Serializer):
    email = serializers.EmailField(
        trim_whitespace=True,
        error_messages={
            "required": "Email é obrigatório.",
            "blank": "Email é obrigatório.",
            "invalid": "Email inválido.",
        },
    )
    codigo = serializers.CharField(
        trim_whitespace=True,
        min_length=6,
        max_length=6,
        error_messages={
            "required": "Código é obrigatório.",
            "blank": "Código é obrigatório.",
            "min_length": "Código inválido.",
            "max_length": "Código inválido.",
        },
    )
    senha = serializers.CharField(
        write_only=True,
        trim_whitespace=False,
        error_messages={
            "required": "Senha é obrigatória.",
            "blank": "Senha é obrigatória.",
        },
    )
    confirmar_senha = serializers.CharField(
        write_only=True,
        trim_whitespace=False,
        error_messages={
            "required": "Confirmação de senha é obrigatória.",
            "blank": "Confirmação de senha é obrigatória.",
        },
    )

    def validate_email(self, value):
        return value.strip().lower()

    def validate_codigo(self, value):
        return value.strip()

    def validate(self, attrs):
        senha = attrs.get("senha") or ""
        confirmar_senha = attrs.get("confirmar_senha") or ""

        if senha != confirmar_senha:
            raise serializers.ValidationError({
                "confirmar_senha": "As senhas não coincidem."
            })

        if len(senha) < 8:
            raise serializers.ValidationError({
                "senha": "A senha deve ter pelo menos 8 caracteres."
            })

        if not re.search(r"\d", senha):
            raise serializers.ValidationError({
                "senha": "A senha deve conter pelo menos 1 número."
            })

        if not re.search(r"[A-Z]", senha):
            raise serializers.ValidationError({
                "senha": "A senha deve conter pelo menos 1 letra maiúscula."
            })

        return attrs


class CadastroConflictValidationError(serializers.ValidationError):
    status_code = 409


class CadastroSerializer(serializers.Serializer):
    nome = serializers.CharField(
        trim_whitespace=True,
        error_messages={
            "required": "Nome é obrigatório.",
            "blank": "Nome é obrigatório.",
        },
    )
    sobrenome = serializers.CharField(
        trim_whitespace=True,
        error_messages={
            "required": "Sobrenome é obrigatório.",
            "blank": "Sobrenome é obrigatório.",
        },
    )
    email = serializers.EmailField(
        trim_whitespace=True,
        error_messages={
            "required": "Email é obrigatório.",
            "blank": "Email é obrigatório.",
            "invalid": "Email inválido.",
        },
    )
    telefone = serializers.CharField(required=False, allow_blank=True, default="")
    cpf = serializers.CharField(
        trim_whitespace=True,
        error_messages={
            "required": "CPF é obrigatório.",
            "blank": "CPF é obrigatório.",
        },
    )
    senha = serializers.CharField(
        write_only=True,
        trim_whitespace=False,
        min_length=6,
        error_messages={
            "required": "Senha é obrigatória.",
            "blank": "Senha é obrigatória.",
            "min_length": "Senha deve ter pelo menos 6 caracteres.",
        },
    )
    sexo = serializers.CharField(required=False, allow_blank=True, default="Não informado")
    rua = serializers.CharField(required=False, allow_blank=True, default="")
    casa_numero = serializers.CharField(required=False, allow_blank=True, default="")
    bairro = serializers.CharField(required=False, allow_blank=True, default="")
    cep = serializers.CharField(required=False, allow_blank=True, default="")
    complemento = serializers.CharField(required=False, allow_blank=True, default="")

    def validate_email(self, value):
        value = value.strip().lower()
        if Clientes.objects.filter(email_clientes=value).exists():
            raise CadastroConflictValidationError({"email": "Esse email já está cadastrado."})
        return value

    def validate_cpf(self, value):
        value = value.strip()
        if len(value) < 11:
            raise serializers.ValidationError("CPF inválido.")
        if Clientes.objects.filter(cpf_clientes=value).exists():
            raise CadastroConflictValidationError({"cpf": "Esse CPF já está cadastrado."})
        return value

    def validate_nome(self, value):
        return value.strip()

    def validate_sobrenome(self, value):
        return value.strip()

    def validate_telefone(self, value):
        return value.strip()

    def validate_sexo(self, value):
        value = (value or "Não informado").strip()
        return value or "Não informado"

    def validate_rua(self, value):
        return value.strip()

    def validate_casa_numero(self, value):
        return value.strip()

    def validate_bairro(self, value):
        return value.strip()

    def validate_cep(self, value):
        return value.strip()

    def validate_complemento(self, value):
        return value.strip()

    def create(self, validated_data):
        nome = validated_data["nome"]
        sobrenome = validated_data["sobrenome"]
        email = validated_data["email"]
        telefone = validated_data["telefone"]
        cpf = validated_data["cpf"]
        senha = validated_data["senha"]
        sexo = validated_data.get("sexo") or "Não informado"
        rua = validated_data.get("rua", "")
        casa_numero = validated_data.get("casa_numero", "")
        bairro = validated_data.get("bairro", "")
        cep = validated_data.get("cep", "")
        complemento = validated_data.get("complemento", "")

        categoria = CategoriaCliente.objects.filter(id_categoria_cliente=5).first()
        if not categoria:
            categoria = CategoriaCliente.objects.first()
            if not categoria:
                raise ValueError("Sem categoria cadastrada no banco.")

        with transaction.atomic():
            cliente = Clientes.objects.create(
                nome_clientes=nome,
                sobrenome_clientes=sobrenome,
                email_clientes=email,
                cpf_clientes=cpf,
                telefone_clientes=telefone,
                sexo_clientes=sexo,
                status_clientes=1,
                categoria_cliente_id_categoria_cliente=categoria,
                senha_clientes=make_password(senha),
            )

            if rua and casa_numero and bairro and cep:
                EnderecoCliente.objects.create(
                    cliente_id_cliente=cliente,
                    rua_endereco_cliente=rua,
                    casa_endereco_cliente=casa_numero,
                    bairro_endereco_cliente=bairro,
                    cep_endereco_cliente=cep,
                    complemento_endereco_cliente=complemento or "",
                )

        return cliente


class CategoriaProdutosSerializer(serializers.ModelSerializer):
    class Meta:
        model = CategoriaProdutos
        fields = '__all__'


class ProdutosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Produtos
        fields = '__all__'


class ProdutoAPISerializer(serializers.ModelSerializer):
    preco_produtos = serializers.FloatField(source="valor_produtos", read_only=True)
    estoque_produtos = serializers.IntegerField(source="quantidade_estoque_produtos", read_only=True)
    categoria_produtos = serializers.CharField(
        source="categoria_produtos_id_categoria_produtos.nome_categoria_produtos",
        read_only=True,
    )
    preco_original = serializers.SerializerMethodField()
    preco_final = serializers.SerializerMethodField()
    economia = serializers.SerializerMethodField()
    desconto_percent = serializers.SerializerMethodField()
    beneficios_plano = serializers.SerializerMethodField()
    plano_atual = serializers.SerializerMethodField()
    url_imagem_produtos = serializers.SerializerMethodField()
    imagem_principal = serializers.SerializerMethodField()
    imagens = serializers.SerializerMethodField()
    status_produtos = serializers.SerializerMethodField()

    class Meta:
        model = Produtos
        fields = [
            "id_produtos",
            "nome_produtos",
            "descricao_produtos",
            "preco_produtos",
            "preco_original",
            "preco_final",
            "economia",
            "desconto_percent",
            "beneficios_plano",
            "plano_atual",
            "estoque_produtos",
            "categoria_produtos",
            "url_imagem_produtos",
            "imagem_principal",
            "imagens",
            "status_produtos",
        ]

    def _get_imagens_queryset(self, obj):
        imagens_qs = getattr(obj, "imagens", None)
        if imagens_qs is not None and hasattr(imagens_qs, "all"):
            return imagens_qs.all()

        return ImagemProduto.objects.filter(
            produtos_id_produtos=getattr(obj, "id_produtos", None)
        ).order_by("ordem_imagem", "id_imagem_produto")

    def _get_cliente_categoria(self):
        request = self.context.get("request")
        cliente = getattr(request, "user", None) if request else None
        if isinstance(cliente, Clientes):
            return getattr(cliente, "categoria_cliente_id_categoria_cliente", None)
        return None

    def _get_pricing(self, obj):
        return build_pricing_snapshot(
            getattr(obj, "valor_produtos", 0),
            self._get_cliente_categoria(),
            1,
        )

    def get_preco_original(self, obj):
        return self._get_pricing(obj)["preco_original_unitario"]

    def get_preco_final(self, obj):
        return self._get_pricing(obj)["preco_final_unitario"]

    def get_economia(self, obj):
        return self._get_pricing(obj)["economia_unitaria"]

    def get_desconto_percent(self, obj):
        return self._get_pricing(obj)["desconto_percent"]

    def get_beneficios_plano(self, obj):
        cliente_categoria = self._get_cliente_categoria()
        if not cliente_categoria:
            return []

        from .views.socio_catalog import build_socio_api_plan

        return build_socio_api_plan(cliente_categoria).get("beneficios", [])

    def get_plano_atual(self, obj):
        cliente_categoria = self._get_cliente_categoria()
        if not cliente_categoria:
            return None

        return build_socio_api_plan(cliente_categoria)

    def get_url_imagem_produtos(self, obj):
        return self.get_imagem_principal(obj)

    def get_imagem_principal(self, obj):
        imagem_principal = build_public_image_url(getattr(obj, "imagem_produtos", None))
        if imagem_principal:
            return imagem_principal

        imagens = list(self._get_imagens_queryset(obj))
        if imagens:
            primeira_imagem = imagens[0]
            return build_public_image_url(getattr(primeira_imagem, "imagem_imagem", None))

        return None

    def get_imagens(self, obj):
        imagens = list(self._get_imagens_queryset(obj))

        return [
            {
                "id_imagem_produto": imagem.id_imagem_produto,
                "imagem": build_public_image_url(getattr(imagem, "imagem_imagem", None)),
                "ordem": getattr(imagem, "ordem_imagem", None),
            }
            for imagem in imagens
        ]

    def get_status_produtos(self, obj):
        return 1 if int(obj.quantidade_estoque_produtos or 0) > 0 else 0


class CategoriaClienteSerializer(serializers.ModelSerializer):
    class Meta:
        model = CategoriaCliente
        fields = '__all__'


class CategoriaClientePlanoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CategoriaCliente
        fields = "__all__"

    def to_representation(self, instance):
        return build_socio_api_plan(instance)


class CategoriaClienteAssinaturaSerializer(CategoriaClientePlanoSerializer):
    pass


class AssinarPlanoSerializer(serializers.Serializer):
    plano_id = serializers.IntegerField(
        min_value=1,
        error_messages={
            "required": "plano_id é obrigatório.",
            "invalid": "plano_id inválido.",
        },
    )


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


class CompraHistoricoSerializer(serializers.ModelSerializer):
    id_pedido = serializers.IntegerField(source="pedido_id_pedido.id_pedido", read_only=True)
    data_pedido = serializers.SerializerMethodField()
    status_pedido = serializers.CharField(source="pedido_id_pedido.status", read_only=True)
    produto_id = serializers.IntegerField(source="produtos_id_produtos.id_produtos", read_only=True)
    produto_nome = serializers.CharField(source="produtos_id_produtos.nome_produtos", read_only=True)
    produto_imagem = serializers.SerializerMethodField()
    valor = serializers.SerializerMethodField()
    quantidade = serializers.IntegerField(source="quantidade_pedido", read_only=True)

    class Meta:
        model = Compra
        fields = [
            "id_compra",
            "id_pedido",
            "data_pedido",
            "status_pedido",
            "produto_id",
            "produto_nome",
            "produto_imagem",
            "tamanho",
            "quantidade",
            "valor",
        ]

    def get_data_pedido(self, obj):
        pedido = getattr(obj, "pedido_id_pedido", None)
        if not pedido or not getattr(pedido, "data_pedido", None):
            return None

        try:
            return timezone.localtime(pedido.data_pedido).isoformat()
        except Exception:
            return pedido.data_pedido.isoformat()

    def get_produto_imagem(self, obj):
        produto = getattr(obj, "produtos_id_produtos", None)
        if not produto:
            return None

        return build_public_image_url(getattr(produto, "imagem_produtos", None))

    def get_valor(self, obj):
        return float(obj.valor_compra or 0)


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


class MinhaCompraItemSerializer(serializers.Serializer):
    id_compra = serializers.IntegerField()
    produto_id = serializers.IntegerField()
    produto_nome = serializers.CharField()
    produto_imagem = serializers.CharField(allow_null=True)
    quantidade = serializers.IntegerField()
    valor = serializers.FloatField()
    tamanho = serializers.CharField(allow_null=True, required=False)
    subtotal = serializers.FloatField()


class MinhaCompraSerializer(serializers.Serializer):
    id_pedido = serializers.IntegerField()
    data_pedido = serializers.CharField()
    status = serializers.CharField()
    valor_total = serializers.FloatField()
    quantidade_total = serializers.IntegerField()
    itens = MinhaCompraItemSerializer(many=True)


class MinhasComprasSerializer(serializers.Serializer):
    pedidos = MinhaCompraSerializer(many=True)


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


class CheckoutItemSerializer(serializers.Serializer):
    produto_id = serializers.IntegerField(min_value=1)
    quantidade = serializers.IntegerField(min_value=1)
    tamanho = serializers.CharField(required=False, allow_blank=True, allow_null=True, max_length=2)

    def validate_tamanho(self, value):
        if value in (None, ""):
            return None

        tamanho = str(value).strip().upper()
        if tamanho not in {"P", "M", "G", "GG"}:
            raise serializers.ValidationError("Tamanho inválido. Use P, M, G ou GG.")
        return tamanho


class CheckoutSerializer(serializers.Serializer):
    itens = CheckoutItemSerializer(many=True)

    def validate_itens(self, value):
        if not value:
            raise serializers.ValidationError("Carrinho vazio.")
        return value
