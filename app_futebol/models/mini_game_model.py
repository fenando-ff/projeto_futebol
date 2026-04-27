from django.db import models

class MiniGameManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().using('minigame')

class MiniGame(models.Model):
    # campos...
    objects = models.Manager()  # manager padrão
    minigame_objects = MiniGameManager()  # manager para banco minigame