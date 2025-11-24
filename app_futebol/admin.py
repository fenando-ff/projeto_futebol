from django.contrib import admin
from . import models


# Register your models here.
admin.site.register(models.Clientes)
admin.site.register(models.Produtos)
admin.site.register(models.Funcionarios)
admin.site.register(models.Pedido)
