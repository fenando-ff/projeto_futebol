def forwards(apps, schema_editor):
    connection = schema_editor.connection
    with connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT COUNT(*)
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
              AND table_name = 'compra'
              AND column_name = 'tamanho'
            """
        )
        (exists,) = cursor.fetchone()
        if not exists:
            cursor.execute(
                """
                ALTER TABLE compra
                ADD COLUMN tamanho VARCHAR(2) NULL
                """
            )


def backwards(apps, schema_editor):
    connection = schema_editor.connection
    with connection.cursor() as cursor:
        cursor.execute(
            """
            SELECT COUNT(*)
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
              AND table_name = 'compra'
              AND column_name = 'tamanho'
            """
        )
        (exists,) = cursor.fetchone()
        if exists:
            cursor.execute(
                """
                ALTER TABLE compra
                DROP COLUMN tamanho
                """
            )


from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("app_futebol", "0003_compra_tamanho"),
    ]

    operations = [
        migrations.RunPython(forwards, reverse_code=backwards),
    ]
