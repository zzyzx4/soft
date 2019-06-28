from django.db import models
from print_accounts.models import User
from cities_light.models import City
from autoslug import AutoSlugField


class Profile(models.Model):
    username = models.CharField(verbose_name='Имя пользователя', max_length=100)
    email = models.EmailField(verbose_name='Почта')
    city = models.ForeignKey(City, verbose_name='Город', on_delete=models.CASCADE)
    phone = models.CharField(max_length=20, verbose_name='Телефон')
    photo = models.ImageField(verbose_name='Фотография', upload_to="profile_photo/%Y/%m/%d")
    slug = AutoSlugField(populate_from='email', unique_with=['city'], unique=True, verbose_name='url')

    class Meta:
        verbose_name = 'Профиль пользователя'
        verbose_name_plural = 'Профили пользователей'

    def __str__(self):
        return self.username


