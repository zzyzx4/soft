# Generated by Django 2.2.1 on 2019-05-15 10:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('sender', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Documents',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=100, verbose_name='Название')),
                ('description', models.CharField(max_length=100, verbose_name='Описание')),
                ('document', models.FileField(upload_to='Документы//%Y/%m/%d/%t')),
                ('uploaded_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'verbose_name': 'Документ1',
                'verbose_name_plural': 'Документы1',
            },
        ),
    ]
