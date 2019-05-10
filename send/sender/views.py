from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required

from sesame import utils
from django.core.mail import send_mail


from django.conf import settings
from django.core.files.storage import FileSystemStorage


from .forms import DocumentForm
from .models import Document


def login_page(request):
    if request.method == "POST":
        email = request.POST.get("emailId")
        user = User.objects.get(email=email)
        login_token = utils.get_query_string(user)
        login_link = "http://127.0.0.1:8000/{}".format(login_token)

        html_message = """
        <p>Здравствуйте,</p>
        <p>Нажмите на ссылку для доступа <a href="{}">Ваша ссылка</a> </p>
        <p>Спасибо,</p>
        <p>Service Press</p>
        """.format(login_link)

        send_mail(
            'Link',
            html_message,
            'dastik0101@zoho.com',
            [email],
            fail_silently=False,
            html_message = html_message
        )
        return render(request, "login.html", context={"message":"Please check your email for magic link."})

    return render(request, "login.html")


@login_required
# def customers_home_page(request):
#     return render(request, "index.html")
def customers_home_page(request):
    if request.method == 'POST':
        form = DocumentForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('home')
    else:
        form = DocumentForm()
    return render(request, 'index.html', {'form': form})


@login_required
def home_page(request):
    return render(request, "homepage.html")







@login_required
def document_display(request):
    docs = Document.objects.all()
    # filename = Document.file.name.split('/')[-1]
    # response = HttpResponse(Document.file, content_type='text/plain')
    # response['Content-Disposition'] = 'attachment; filename=%s' % filename
    return render(request, 'sender/documents.html', context={'docs': docs})



