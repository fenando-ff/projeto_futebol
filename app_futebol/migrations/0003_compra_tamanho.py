from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("app_futebol", "0002_accountsperfil_alternativas_authgroup_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="compra",
            name="tamanho",
            field=models.CharField(blank=True, max_length=2, null=True),
        ),
    ]
