from django.contrib import admin
from .models import Post, Category, Tags, Comments

admin.site.register(Post)
admin.site.register(Category)
admin.site.register(Tags)
admin.site.register(Comments)