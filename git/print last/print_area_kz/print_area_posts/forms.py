import bleach
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Layout, Submit, Row, Column, HTML, Field
from django import forms
from tinymce.widgets import TinyMCE

from .models import Post, Comment


class TinyMCEWidget(TinyMCE):
    def use_required_attribute(self, *args):
        return False


class CustomCheckbox(Field):
    template = 'print_area_posts/custom_checkbox.html'


class PostForm(forms.ModelForm):
    content = forms.CharField(
        widget=TinyMCEWidget(
            attrs={'required': False, 'cols': 30, 'rows': 15},
            mce_attrs=({'menubar': False,
                        'plugins': ['advlist autolink lists link image imagetools charmap print preview anchor',
                                    'textcolor searchreplace code insertdatetime media',
                                    'table contextmenu paste code help wordcount autoresize'],
                        'autoresize_min_height': 250,
                        'autoresize_on_init': False,
                        'toolbar': '''
                                insert | undo redo |  formatselect | bold italic backcolor  | 
                                alignjustify | bullist numlist outdent indent | 
                                removeformat | help',
                                ''',
                        'toolbar2': '''''',
                        'content_css': ['//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
                                        'https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css'],
                        'content_css_cors': 'true',
                        'branding': False,
                        'content_style': 'img {max-width: 100%; height:auto;}',
                        'imagetools_toolbar': "rotateleft rotateright | flipv fliph | editimage imageoptions",
                        })
        )
    )

    class Meta:
        model = Post
        fields = ('title', 'content', 'tags',)



class CommentForm(forms.ModelForm):
    _attrs = {'class': 'form-control', 'placeholder': 'введите ваш комментарий', 'rows': '2'}

    content = forms.CharField(widget=forms.Textarea(attrs=_attrs), label='')

    class Meta:
        model = Comment
        fields = ('content',)

    def clean_content(self):
        content = self.cleaned_data.get('content')
        content = bleach.clean(content, tags=[], strip=True).strip()
        return content
