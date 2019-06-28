from django.urls import path
from public_area import views


urlpatterns = [
    path('', views.index, name='home')
]
