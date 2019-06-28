from django.db import models
from autoslug import AutoSlugField
from tinymce.models import HTMLField
from taggit.managers import TaggableManager
from django.contrib.auth import get_user_model
from django.urls import reverse
from django.conf import settings
from django.utils import timezone
User = get_user_model()


# class Tags(models.Model):
#     title = models.CharField(max_length=30, verbose_name='Тэг')
#     slug = AutoSlugField(populate_from='title')
#
#     class Meta:
#         verbose_name = 'Тэг'
#         verbose_name_plural = 'Тэги'
#
#     def __str__(self):
#         return self.title


class Post(models.Model):
    title = models.CharField(max_length=78, verbose_name='Заголовок', help_text="Максимум 78 символов")
    content = HTMLField(verbose_name='Контент')
    tags = TaggableManager(blank=True, verbose_name='Теги', help_text="Список тегов через запятую")
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='author')
    created_date = models.DateTimeField(default=timezone.now)
    published_date = models.DateTimeField(blank=True, null=True)
    slug = AutoSlugField(populate_from='title')
    moderation = models.BooleanField(default=False, verbose_name='Модерация')

    class Meta:
        verbose_name = 'Пост'
        verbose_name_plural = 'Посты'

    def __str__(self):
        return self.title

    def publish(self):
        self.published_date = timezone.now()
        self.save()

    def get_absolute_url(self):
        return reverse('post_detail', kwargs={'pk': self.id})

    def get_update_url(self):
        return reverse('post_update', kwargs={'pk': self.id})

    def get_delete_url(self):
        return reverse('post_delete', kwargs={'pk': self.id})


class PostImage(models.Model):
    post = models.ForeignKey(Post, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(verbose_name='Фотографии', upload_to="post/%Y/%m/%d")


class Comment(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)
    content = models.TextField()
    post = models.ForeignKey(Post, related_name='comments', on_delete=models.CASCADE)
    reply = models.ForeignKey("self", verbose_name="Комментарии", on_delete=models.SET_NULL,
                                blank=True,
                                null=True,
                                related_name='children',
                                )

    class Meta:
        verbose_name = 'Коментарии'
        verbose_name_plural = 'Коментарий'

    def __str__(self):
        return self.post.title
