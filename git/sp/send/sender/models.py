from django.db import models
from django.contrib.auth.models import User


# Модель контакта
class Contact(models.Model):
    user = models.CharField(max_length=100, verbose_name='Имя')
    phone = models.CharField(max_length=100, verbose_name='Телефон')
    message = models.TextField(verbose_name='Сообщение', blank=False, null=False)

    class Meta:
        verbose_name = 'Контакт'
        verbose_name_plural = 'Контакты'

    def __str__(self):
        return self.user


class Documents(models.Model):
    title = models.CharField(max_length=100, verbose_name='Имя')
    description = models.CharField(max_length=100, verbose_name='Описание')
    document = models.FileField(upload_to='Документы//%Y/%m/%d/%t')
    uploaded_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = 'Документ'
        verbose_name_plural = 'Документы'

    def __str__(self):
        return self.title
