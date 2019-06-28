from django.db import models
from django.utils import timezone
from django.conf import settings
from django.urls import reverse
from autoslug import AutoSlugField
from django.contrib.contenttypes.models import ContentType


class Category(models.Model):
    title = models.CharField(max_length=100, verbose_name='Категория')
    slug = AutoSlugField(populate_from='title')

    class Meta:
        verbose_name = 'Категория'
        verbose_name_plural = 'Категории'
        ordering = ('title',)

    def __str__(self):
        return self.title


class Tags(models.Model):
    title = models.CharField(max_length=50, verbose_name='Тэги')
    slug = AutoSlugField(populate_from='title')

    class Meta:
        verbose_name = 'Тэг'
        verbose_name_plural = 'Тэги'
        ordering = ('title',)

    def __str__(self):
        return self.title


class Post(models.Model):
    category = models.ForeignKey(Category, verbose_name='Категория', related_name='post_category', on_delete=models.CASCADE)
    tag = models.ManyToManyField(Tags, verbose_name='Тэг', related_name='post_tag')
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

    # @property
    # def comments(self):
    #     instance = self
    #     qs = Comments.objects.filter_by_instance(instance)
    #     return qs
    #
    # @property
    # def get_content_type(self):
    #     instance = self
    #     content_type = ContentType.objects.get_for_model(instance.__class__)
    #     return content_type

    def __str__(self):
        return self.title


class Comments(models.Model):
    post = models.ForeignKey(Post,
                             verbose_name='коментарии к посту',
                             on_delete=models.CASCADE,
                             related_name='post_comment')
    email = models.EmailField(verbose_name='email', blank=True, null=True)
    name = models.CharField(max_length=60, verbose_name='Имя', blank=False)
    comment = models.CharField(max_length=500, verbose_name='коментарии')
    created_date = models.DateTimeField(default=timezone.now)
    moderation = models.BooleanField(default=False, verbose_name='Модерация')

    class Meta:
        verbose_name = 'Комментарий'
        verbose_name_plural = 'Комментарии'

    def __str__(self):
        return self.name
