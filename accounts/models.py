from django.db import models
from django.contrib.auth.models import User


class Perfil(models.Model):
    user= models.OneToOneField(User,on_delete=models.CASCADE)
    sexo= models.CharField(max_length=10,null=True,blank=True)
    cpf= models.CharField(max_length=14,unique=True)
    telefone= models.CharField(max_length=20, null=True, blank=True)

    def __str__(self):
        return self.user.username
# Create your models here.
