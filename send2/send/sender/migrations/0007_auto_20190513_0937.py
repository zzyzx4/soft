# Generated by Django 2.2.1 on 2019-05-13 09:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('sender', '0006_remove_contact_email'),
    ]

    operations = [
        migrations.AlterField(
            model_name='contact',
            name='message',
            field=models.TextField(verbose_name='Сообщение'),
        ),
    ]
