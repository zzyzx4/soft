from django.shortcuts import render
from .models import Product, Post, Category


def index(request):
    products = Product.objects.all()
    posts = Post.objects.all()
    categories = Category.objects.all()
    context = {'products': products, 'posts': posts, 'categories': categories}
    return render(request, 'public_area/index.html', context)
