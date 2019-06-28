from django.db import models
from django.utils import timezone
from django.conf import settings
from django.urls import reverse
from autoslug import AutoSlugField


class Post(models.Model):
    title = models.CharField(max_length=200, verbose_name='Название')
    content = models.TextField(verbose_name='Контент')
    image = models.ImageField(upload_to='post/%Y/%m', verbose_name='фото')
    date_posted = models.DateTimeField(default=timezone.now)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name='Автор', on_delete=models.CASCADE)
    slug = AutoSlugField(verbose_name='url', populate_from='title')

    class Meta:
        verbose_name = 'Пост'
        verbose_name_plural = 'Посты'

    def get_absolute_url(self):
        return reverse('post-detail', kwargs={'pk': self.pk})

    def __str__(self):
        return self.title
