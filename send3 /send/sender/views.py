import os
from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required

from sesame import utils
from django.core.mail import send_mail

from .forms import ContactForm, DocumentsForm
from .models import Contact, Documents

from django.contrib.admin.views.decorators import staff_member_required


# Отправка емайл сообщения для доступа на сайт
def login_page(request):
    if request.method == "POST":
        email = request.POST.get("emailId")
        user = User.objects.get(email=email)
        login_token = utils.get_query_string(user)
        login_link = "http://127.0.0.1:8000/{}".format(login_token)
        html_message = """
        <p>Здравствуйте, пользователь!</p>
        <p>Пожалуйста нажмите на ссылку для доступа <a href="{}">Ваша ссылка</a> </p>
        <p>Спасибо, с/у Service Press</p>
        """.format(login_link)
        send_mail(
            'Link',
            html_message,
            'dastik.93@zoho.com',
            [email],
            fail_silently=False,
            html_message=html_message
        )
        return render(request, "login.html", context={"message":"Please check your email for magic link."})
    return render(request, "login.html")


# Домашняя страница
@login_required
def home_page(request):
    return render(request, "homepage.html")


# страница о нас
@login_required
def about(request):
    return render(request, 'about.html')


# Связь с нами
@login_required
def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('homepage')
    else:
        form = ContactForm()
    return render(request, 'contact.html', context={'form': form})


@login_required
def document_upload(request):
    if request.method == 'POST':
        form = DocumentsForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('homepage')
    else:
            form = DocumentsForm(request.POST, request.FILES)
    return render(request, 'sender/upload_document.html', {'form': form})


# Отображение документов
@login_required
@staff_member_required
def document_list(request):
    documents = Documents.objects.all()
    return render(request, 'sender/documents.html', {'documents': documents})



