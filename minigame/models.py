# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Alternativas(models.Model):
    id_alternativa = models.IntegerField(primary_key=True)
    opcao_resposta = models.CharField(max_length=500)
    resposta_correta = models.IntegerField()
    ponto = models.IntegerField()
    questao = models.ForeignKey('Questoes', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'alternativas'
        
    def __str__(self):
        return f"{self.opcao_resposta} - {'Correta' if self.resposta_correta else 'Incorreta'}"


class Participantes(models.Model):
    id_participante = models.AutoField(primary_key=True)
    nome_participante = models.CharField(max_length=45)
    tempo = models.TimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'participantes'
        
    def __str__(self):
        return self.nome_participante


class Questoes(models.Model):
    id_questao = models.IntegerField(primary_key=True)
    pergunta = models.TextField()

    class Meta:
        managed = False
        db_table = 'questoes'
        
    def __str__(self):
        return f"Questão {self.id_questao}: {self.pergunta[:50]}..."


class Respostas(models.Model):
    pk = models.CompositePrimaryKey('participante_id', 'questao_id')
    participante = models.ForeignKey(Participantes, models.DO_NOTHING)
    questao = models.ForeignKey(Questoes, models.DO_NOTHING)
    alternativa = models.ForeignKey(Alternativas, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'respostas'
        
