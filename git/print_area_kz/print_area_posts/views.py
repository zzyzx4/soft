from django.shortcuts import render
from django.contrib import messages
from django.contrib.auth import get_user_model
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from django.db.models import Q, Count
from django.http import JsonResponse, HttpResponseForbidden, Http404
from django.shortcuts import render, get_object_or_404, redirect
from django.template.loader import render_to_string
from django.urls import reverse
from django.views.decorators.http import require_POST
from taggit.models import Tag
from .forms import CommentForm
from .models import Comment, Post


def post_list(request, **kwargs):
    posts = Post.objects.all()

    tag_name = kwargs.get('tag_name')
    if tag_name:
        tag = get_object_or_404(Tag, name=tag_name)
        posts = posts.filter(tags__name=tag)

    posts = posts.annotate(comments_total=Count('comments__pk'))
    posts = posts.order_by('-timestamp')
    paginator = Paginator(posts.distinct(), 30)
    page = paginator.get_page(request.GET.get('page'))

    context = {
        'page': page,
        'posts': posts,
    }
    return render(request, 'print_area_posts/post-list.html', context)


def search(request):
    posts = Post.objects.all()
    query = request.GET.get('q')
    if query:
        query_in_title = Q(title__icontains=query)
        query_in_cont = Q(content__icontains=query)
        query_in_tag = Q(tags__name__icontains=query)
        posts = posts.filter(query_in_title | query_in_tag | query_in_cont)
        if posts.exists() is False:
            messages.add_message(request, messages.INFO, 'Ничего не найдено')

    posts = posts.annotate(comments_total=Count('comments__pk'))
    posts = posts.order_by('-timestamp')
    paginator = Paginator(posts.distinct(), 30)
    page = paginator.get_page(request.GET.get('page'))

    context = {
        'page': page,
        'search_query': 'q={query}&',
    }
    return render(request, 'print_area_posts/post-list.html', context)


def post_detail(request, slug):
    """ Show single murr """
    post = get_object_or_404(Post, slug=slug)
    form = CommentForm()
    context = {'post': post, 'comment_form': form}

    try:
        author = Post.author
        client = request.user
        context.update({
                   'author': author, 'client': client})
    except AttributeError:
        pass
    return render(request, 'print_area_posts/post-detail.html', context)

