from django.contrib import admin
from .models import models


# 2. Registros do banco padrão (default)
admin.site.register(models.Clientes)
admin.site.register(models.Produtos)
admin.site.register(models.Funcionarios)
admin.site.register(models.Pedido)
admin.site.register(models.EnderecoCliente)
admin.site.register(models.CategoriaProdutos)
admin.site.register(models.CategoriaCliente)
admin.site.register(models.Compra)
admin.site.register(models.ImagemProduto)
admin.site.register(models.Times)
admin.site.register(models.Jogos)