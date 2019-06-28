from django.db import models
from django.contrib.auth import get_user_model
from autoslug import AutoSlugField
from django.conf import settings


User = get_user_model()


# Класс тенантов ==================================================================================
class Tenant(models.Model):
    legal_name = models.CharField(verbose_name='Юридическое наименование', max_length=128)
    brand = models.CharField(verbose_name='Торговая марка', max_length=128)
    logo = models.ImageField(verbose_name='Логотип', upload_to='tenant/logo/%y/%m/%d')
    bin_code = models.IntegerField(verbose_name='БИН', blank=False)
    bank_choices = (
        ('Каспи', 'Каспибанк'),
        ('Сбер', 'Сбербанк'),
        ('АТФ', 'АТФБанк'),
        ('ЕБ', 'Евразийский банк'),
        ('КН', 'Kassa Nova банк'),
        ('ВТБ', 'Банк ВТБ'),
        ('АК', 'AsiaCredit Bank'),
        ('ХК', 'ДБ Хоум Кредит энд Финанс Банк'),
        ('АБ', 'ДБ Альфа-Банк'),
        ('НБ', 'Нурбанк'),
        ('РБК', 'Bank RBK'),
        ('ФБ', 'ForteBank'),
        ('ЦК', 'Банк ЦентрКредит'),
        ('НБК', 'Народный Банк'),
                )
    bank_props = models.CharField(verbose_name='Банк', max_length=7, choices=bank_choices, default='')
    bank_bic = models.CharField(verbose_name='БИК', max_length=25, blank=False)
    checking_account = models.IntegerField(verbose_name='Расчетный счет', blank=False)
    slug = AutoSlugField(populate_from='legal_name', unique_with=['brand'])

    class Meta:
        verbose_name = 'Тенант'
        verbose_name_plural = 'Тенанты'

    def __str__(self):
        return self.legal_name


class SystemUser(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name='Пользователь системы', on_delete=models.CASCADE)
    first_name = models.CharField(max_length=128, verbose_name='Имя')
    last_name = models.CharField(max_length=128, verbose_name='Фамилия')
    patronymic = models.CharField(max_length=128, verbose_name='Отчество')
    phone = models.CharField(max_length=40, verbose_name='телефон', blank=True)
    slug = AutoSlugField(populate_from='first_name')

    class Meta:
        verbose_name = 'Пользователь системы'
        verbose_name_plural = 'Пользователи системы'

    def __str__(self):
        return self.first_name
