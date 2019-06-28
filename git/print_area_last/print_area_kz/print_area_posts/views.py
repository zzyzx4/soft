from django.shortcuts import render
from django.contrib import messages
from django.contrib.auth import get_user_model
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from django.db.models import Q, Count
from django.http import JsonResponse, HttpResponseForbidden, Http404, HttpResponseRedirect
from django.shortcuts import render, get_object_or_404, redirect
from django.template.loader import render_to_string
from django.urls import reverse
from django.views.decorators.http import require_POST
from taggit.models import Tag
# from .forms import CommentForm
from .models import Comment, Post
from django.utils import timezone
from .forms import *
from django.forms import modelformset_factory
from .models import Post, PostImage

def index(request):
    return render(request, 'base.html')


def post_list(request):
    posts = Post.objects.filter(published_date__lte=timezone.now()).order_by('published_date')
    return render(request, 'print_area_posts/post-list.html', {'posts': posts})


def post_detail(request, slug):
    post = get_object_or_404(Post, slug=slug)
    image = PostImage.objects.all()
    return render(request, 'print_area_posts/post-detail.html', {'post': post, 'image': image})

def about(request):
    return render(request, 'about-us.htm')


def gallery(request):
    return render(request, 'gallery.htm')
