from django.contrib import admin
from .models import Post, Comment, PostImage
# Register your models here.


class PostImageInline(admin.TabularInline):
    model = PostImage
    extra = 3


class PostAdmin(admin.ModelAdmin):
    inlines = [PostImageInline, ]
    list_display = ('title', 'author', 'created_date', 'moderation')
admin.site.register(Post, PostAdmin)
admin.site.register(Comment)