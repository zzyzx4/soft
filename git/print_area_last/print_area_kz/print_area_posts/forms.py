import bleach
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Submit, Row, Column, HTML, Field
from django import forms
from tinymce.widgets import TinyMCE

from .models import Post, Comment, PostImage


class PostForm(forms.ModelForm):
    title = forms.CharField(max_length=128)
    content = forms.Textarea()


class PostImageForm(forms.ModelForm):
    image = forms.ImageField(label='Image')

    class Meta:
        model = PostImage
        fields = ('image', )