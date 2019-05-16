from django.contrib.auth.decorators import login_required
from profiles.forms import SignUpForm
from django.contrib.auth import login, authenticate
from django.shortcuts import render, redirect

from django.views import View
from django.http import HttpResponse

from django.contrib.sites.shortcuts import get_current_site
from django.utils.encoding import force_bytes, force_text
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from .tokens import account_activation_token
from django.core.mail import EmailMessage




from django.contrib.auth import get_user_model, login, update_session_auth_hash
from django.contrib.auth.forms import PasswordChangeForm



#
# def process_response(request, response):
#     # if user and no cookie, set cookie
#     if request.user.is_authenticated() and not request.COOKIES.get('user'):
#         response.set_cookie("user", 'Hello Cookie')
#     elif not request.user.is_authenticated() and request.COOKIES.get('user'):
#         # else if if no user and cookie remove user cookie, logout
#         response.delete_cookie("user")
#     return response


def index(request):
        return render(request, 'index.html')


class Signup(View):
    # def signup(request):
    #     if request.method == 'POST':
    #         form = SignUpForm(request.POST)
    #         if form.is_valid():
    #             form.save()
    #             username = form.cleaned_data.get('username')
    #             raw_password = form.cleaned_data.get('password1')
    #             user = authenticate(username=username, password=raw_password)
    #             return redirect('login')
    #     else:
    #         form = SignUpForm()
    #     return render(request, 'registration/registration.html', {'form': form})

    def get(self, request):
        form = SignUpForm()
        return render(request, 'registration/registration.html', {'form': form})

    def post(self, request):
        form = SignUpForm(request.POST)
        if form.is_valid():
            # Create an inactive user with no password:
            user = form.save(commit=False)
            user.is_active = False
            user.set_unusable_password()
            user.save()

            # Send an email to the user with the token:
            mail_subject = 'Activate your account.'
            current_site = get_current_site(request)
            uid = urlsafe_base64_encode(force_bytes(request.user.pk))
            token = account_activation_token.make_token(user)
            activation_link = "{0}/?uid={1}&token{2}".format(current_site, uid, token)
            message = "Hello {0},\n {1}".format(user.email, activation_link)
            to_email = form.cleaned_data.get('email')
            email = EmailMessage(mail_subject, message, to=[to_email])
            email.send()
            return HttpResponse('Please confirm your email address to complete the registration')
        else:
            return HttpResponse('Please confirm your email address to complete the registration')


class Activate(View):
    def get(self, request, uidb64, token):
        try:
            uid = force_text(urlsafe_base64_decode(uidb64))
            user = request.User.objects.get(pk=uid)
        except(TypeError, ValueError, OverflowError, request.User.DoesNotExist):
            user = None
        if user is not None and account_activation_token.check_token(user, token):
            # activate user and login:
            user.is_active = True
            user.save()
            login(request, user)

            form = PasswordChangeForm(request.user)
            return render(request, 'registration/activation.html', {'form': form})

        else:
            return HttpResponse('Activation link is invalid!')

    def post(self, request):
        form = PasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            user = form.save()
            update_session_auth_hash(request, user) # Important, to update the session with the new password
            return HttpResponse('Password changed successfully')