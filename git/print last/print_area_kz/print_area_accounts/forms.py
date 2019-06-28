from django import forms
from django.contrib.auth.forms import UserCreationForm
from print_area_accounts.models import User


class SignUpForm(UserCreationForm):

    class Meta:
        model = User
        fields = ('email', 'password1', 'password2',)
