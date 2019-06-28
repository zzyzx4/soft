from django.contrib import admin
from .models import Post, Category, PostImage, Product, ProductImage


admin.site.register(Category)


# Post --------------------------------------------------------------------------
class PostImageInline(admin.TabularInline):
    model = PostImage
    extra = 3


class PostAdmin(admin.ModelAdmin):
    inlines = [PostImageInline, ]
    list_display = ('category', 'title', 'author', 'created_date', 'moderation')


admin.site.register(Post, PostAdmin)
# End Post -----------------------------------------------------------------------


# Product ------------------------------------------------------------------------
class ProductImageInline(admin.TabularInline):
    model = ProductImage
    extra = 3


class ProductAdmin(admin.ModelAdmin):
    inlines = [ProductImageInline, ]
    list_display = ('category', 'author', 'title', 'price', 'in_stock', 'created_date', 'city')


admin.site.register(Product, ProductAdmin)
