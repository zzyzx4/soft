# Generated by Django 2.2.1 on 2019-05-15 11:52

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('sender', '0004_delete_document'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='documents',
            options={'verbose_name': 'Документ', 'verbose_name_plural': 'Документы'},
        ),
    ]
