# Generated by Django 2.2.1 on 2019-05-02 07:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('profiles', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='is_staff',
            field=models.BooleanField(default=True, verbose_name='is_staff'),
        ),
    ]
