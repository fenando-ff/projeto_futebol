from django.contrib import admin
from minigame import models
# Register your models here.

admin.site.register(models.Participantes)
admin.site.register(models.Questoes)
admin.site.register(models.Alternativas)
admin.site.register(models.Titulos)
admin.site.register(models.HistoricoTitulos)