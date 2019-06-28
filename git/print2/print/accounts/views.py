from django.shortcuts import render, redirect, render_to_response
from .forms import SignUpForm
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect, HttpResponse
from django.urls import reverse


# Регистрация пользователя ==============================
def signup(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            form.save()
            email = form.cleaned_data.get('email')
            my_password = form.cleaned_data.get('password1')
            user = authenticate(username=email, password=my_password)
            login(request, user)
            return render(request, 'registration/registration_done.html')
    else:
        form = SignUpForm()
    return render(request, 'registration/signup.html', {'form': form})


def user_login(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password1')
        user = authenticate(username=email, password=password)
        if user:
            if user.is_active:
                login(request,user)
                return HttpResponseRedirect(reverse('homepage'))
            else:
                return HttpResponse("Ваш аккаунт неактивен.")
        else:
            print("Someone tried to login and failed.")
            print("They used email: {} and password: {}".format(email, password))
            return HttpResponse("Неверный логин или пароль")
    else:
        return render(request, 'registration/login.html', {})