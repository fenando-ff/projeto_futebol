# Generated migration for ImagemProduto model

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('app_futebol', '0004_alter_produtos_options'),
    ]

    operations = [
        migrations.CreateModel(
            name='ImagemProduto',
            fields=[
                ('id_imagem_produto', models.AutoField(db_column='id_IMAGEM_PRODUTO', primary_key=True, serialize=False)),
                ('imagem', models.CharField(db_column='imagem_IMAGEM', max_length=255)),
                ('ordem', models.IntegerField(db_column='ordem_IMAGEM', default=0)),
                ('produtos_id_produtos', models.ForeignKey(db_column='PRODUTOS_id_PRODUTOS', on_delete=django.db.models.deletion.CASCADE, related_name='imagens', to='app_futebol.Produtos')),
            ],
            options={
                'db_table': 'imagem_produto',
                'ordering': ['ordem'],
                'managed': True,
            },
        ),
    ]
