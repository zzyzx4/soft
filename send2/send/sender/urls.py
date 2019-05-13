from django.urls import path, include
from . import views

from django_downloadview import ObjectDownloadView
from .models import Document

download = ObjectDownloadView.as_view(model=Document, file_field='document')

urlpatterns = [
    path('login/', views.login_page, name='customers-login'),
    path('customers/', views.customers_home_page, name='home'),
    path('', views.home_page, name='homepage'),
    path('documents/', views.document_display, name='document'),
    path('^download/(?P<slug>[A-Za-z0-9_-]+)/$', download, name='download'),
    path('about/', views.about, name='about_us'),
    path('contact/', views.contact, name='contact_us')

]
