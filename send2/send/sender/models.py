from django.db import models
from django.contrib.auth.models import User


class Document(models.Model):
    description = models.CharField(max_length=255, blank=True, verbose_name='Описание, пожелания')
    document = models.FileField(upload_to='documents/%Y/%m/%d/')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.description


class Contact(models.Model):
    user = models.CharField(max_length=100, verbose_name='Имя')
    message = models.TextField(verbose_name='Сообщение')

    def __str__(self):
        return self.user

