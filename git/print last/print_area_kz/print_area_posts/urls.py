from django.urls import path, include
from print_area_posts import views
urlpatterns = [
    path('', views.post_list, name='post_list'),
    # path('by_tag/<str:tag_name>', views.post_list, name='posts_by_tag_name'),
    # path('create/', views.post_create, name='post_create'),
    path('post-detail/<str:slug>', views.post_detail, name='post_detail'),
    # path('landing/', views.landing, name='landing'),

]
