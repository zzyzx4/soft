# Generated by Django 2.2.2 on 2019-06-05 06:48

import autoslug.fields
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('print_area_members', '0007_auto_20190605_1245'),
    ]

    operations = [
        migrations.AddField(
            model_name='systemuser',
            name='slug',
            field=autoslug.fields.AutoSlugField(default=1, editable=False, populate_from='first_name'),
            preserve_default=False,
        ),
    ]