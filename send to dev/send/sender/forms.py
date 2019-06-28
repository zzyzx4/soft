from django import forms
from .models import Contact, Documents


class ContactForm(forms.ModelForm):
    '''
    Форма контакта
    '''
    class Meta:
        model = Contact
        fields = ('user', 'phone', 'message',)


class DocumentsForm(forms.ModelForm):
    class Meta:
        model = Documents
        fields = ('title', 'description', 'document',)
