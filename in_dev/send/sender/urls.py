from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_page, name='customers-login'),
    path('', views.home_page, name='homepage'),
    path('about/', views.about, name='about_us'),
    path('contact/', views.contact, name='contact_us'),
    path('documents/upload/', views.document_upload, name='upload_document'),
    path('documents/', views.document_list, name='documents_list'),

]
