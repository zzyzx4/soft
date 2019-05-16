from django import forms
# from sender.models import Document, Contact
from .models import Document, Contact

class DocumentForm(forms.ModelForm):
    class Meta:
        model = Document
        fields = ('description', 'document', )


class ContactForm(forms.ModelForm):
    class Meta:
        model = Contact
        fields = '__all__'

    def clean(self):
        cleaned_data = super(ContactForm, self).clean()
        user = cleaned_data.get('user')
        message = cleaned_data.get('message')
        if not user and not message:
            raise forms.ValidationError('You have to write something!')