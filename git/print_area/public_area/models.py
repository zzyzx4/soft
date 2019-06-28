from django.db import models
from django.conf import settings
from django.utils import timezone
from autoslug import AutoSlugField
from print_accounts.models import User
from djmoney.models.fields import MoneyField
from cities_light.models import City


# Категории----------------------------------------------------------
class Category(models.Model):
    title = models.CharField(max_length=100, verbose_name='Категория')
    slug = AutoSlugField(populate_from='title', unique=True, verbose_name='url')
    parent = models.ForeignKey('self', blank=True, null=True,
                               related_name='children',
                               on_delete=models.CASCADE,
                               verbose_name='путь')

    class Meta:
        verbose_name = 'Категория'
        verbose_name_plural = 'Категории'
        unique_together = ('slug', 'parent',)

    def __str__(self):                           # __str__ method elaborated later in
        full_path = [self.title]                  # post.  use __unicode__ in place of
                                                 # __str__ if you are using python 2
        k = self.parent

        while k is not None:
            full_path.append(k.title)
            k = k.parent

        return ' -> '.join(full_path[::-1])


# Посты, статьи -------------------------------------------------------------------------------
class Post(models.Model):
    category = models.ForeignKey(Category, verbose_name='Категория', on_delete=models.CASCADE)
    title = models.CharField(max_length=100, verbose_name='Название статьи')
    text = models.TextField(verbose_name='Текст')
    # image = models.ImageField(verbose_name='Фотографии', upload_to="post/%Y/%m/%d")
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, verbose_name='Автор')
    created_date = models.DateTimeField(default=timezone.now, verbose_name='Создано')
    published_date = models.DateTimeField(blank=True, null=True, verbose_name='Дата публикации')
    slug = AutoSlugField(populate_from='title', unique_with=['author', 'published_date__month'])
    moderation = models.BooleanField(verbose_name='Модерация', default=False)

    class Meta:
        verbose_name = 'Статья'
        verbose_name_plural = 'Статьи'

    def publish(self):
        self.published_date = timezone.now()
        self.save()

    def __str__(self):
        return self.title


class PostImage(models.Model):
    post = models.ForeignKey(Post, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(verbose_name='Фотографии', upload_to="post/%Y/%m/%d")


# Продажа Товаров Б/У ---------------------------------------------------------------------------
class Product(models.Model):
    category = models.ForeignKey(Category, verbose_name='Категория', on_delete=models.CASCADE)
    title = models.CharField(max_length=120, verbose_name='Товар')
    description = models.TextField(verbose_name='Описание')
    price = MoneyField(max_digits=14, decimal_places=2, default_currency='KZT')
    in_stock = models.BooleanField(verbose_name='В наличии', default=True)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, verbose_name='Автор')
    created_date = models.DateTimeField(default=timezone.now, verbose_name='Создано')
    city = models.ForeignKey(City, verbose_name='Город', on_delete=models.CASCADE)
    slug = AutoSlugField(populate_from='title', unique=True, unique_with=['created_date'])

    class Meta:
        verbose_name = 'Продажа товара'
        verbose_name_plural = 'Продажа товаров'

    def __str__(self):
        return self.title


class ProductImage(models.Model):
    product = models.ForeignKey(Product, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(verbose_name='Фотографии', upload_to="product/%Y/%m/%d")
