from django.db import models
from autoslug import AutoSlugField
from tinymce.models import HTMLField
from taggit.managers import TaggableManager
from django.contrib.auth import get_user_model
from django.urls import reverse

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
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='author')
    timestamp = models.DateTimeField(auto_now_add=True)
    slug = AutoSlugField(populate_from='title', unique_with='author')

    class Meta:
        verbose_name = 'Пост'
        verbose_name_plural = 'Посты'

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return reverse('post_detail', kwargs={'pk': self.id})

    def get_update_url(self):
        return reverse('post_update', kwargs={'pk': self.id})

    def get_delete_url(self):
        return reverse('post_delete', kwargs={'pk': self.id})

    @property
    def get_comments(self):
        return self.comments.order_by('-timestamp')

    @property
    def comment_count(self):
        return Comment.objects.filter(murr=self).count()

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        super(Post, self).save()


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
