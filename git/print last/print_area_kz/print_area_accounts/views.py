from django.shortcuts import render, redirect
from print_area_accounts.forms import SignUpForm
from django.contrib.auth import authenticate, login


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
            return render(request, 'print_area_accounts/registration_done.html')
    else:
        form = SignUpForm()
    return render(request, 'print_area_accounts/registration.html', {'form': form})

