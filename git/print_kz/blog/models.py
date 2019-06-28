from django.db import models
from autoslug import AutoSlugField
from django.conf import settings
from tinymce.models import HTMLField
from django.utils import timezone
from django.urls import reverse

class Category(models.Model):
    '''
    Создание категории
    '''
    title = models.CharField(max_length=200, verbose_name='Название')
    slug = AutoSlugField(populate_from='title')

    class Meta:
        verbose_name = "Категория"
        verbose_name_plural = "Категории"
        ordering = ['-title']

    def __str__(self):
        return self.title


class Post(models.Model):
    '''
    Создание модели поста
    '''
    category = models.ForeignKey(Category, verbose_name="Категория", on_delete=models.CASCADE)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name="Автор", on_delete=models.CASCADE)
    title = models.CharField(max_length=200, verbose_name="Название")
    content = models.TextField(verbose_name="Контент")
    image = models.ImageField(upload_to="post/%Y/%m", verbose_name='картинки')
    created_date = models.DateTimeField(default=timezone.now, verbose_name='Создано')
    published_date = models.DateTimeField(blank=True, null=True)
    is_published = models.BooleanField(default=False, verbose_name="Опубликовано?")
    slug = AutoSlugField(populate_from='title')

    class Meta:
        verbose_name = "Пост"
        verbose_name_plural = "Посты"
        ordering = ['-created_date']

    def publish(self):
        self.published_date = timezone.now()
        self.save()

    def get_absolute_url(self):
        return reverse('post-detail', kwargs={'pk': self.pk})

    def __str__(self):
        return self.title

