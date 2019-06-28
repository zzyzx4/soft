from django.urls import path, include
from print_area_posts import views
urlpatterns = [
    path('', views.index, name='homepage'),
    path('posts/', views.post_list, name='post-list'),
    path('post/detail/<str:slug>/', views.post_detail, name='post-detail'),
    path('about/', views.about, name='about_us'),
    path('gallery/', views.gallery, name='our_gallery')

]
