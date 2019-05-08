`django-sesame`_ provides one-click login for your Django project. It uses
specially crafted URLs containing an authentication token, for example:
https://example.com/?url_auth_token=AAAAARchl18CIQUlImmbV9q7PZk%3A89AEU34b0JLSrkT8Ty2RPISio5

It's useful if you want to share private content without requiring your
visitors to remember a username and a password or to go through an
authentication process involving a third-party.

django-sesame is tested with:

- Django 1.8 (LTS), 1.9 and 1.10.
- all supported Python versions.

It requires ``django.contrib.auth``. It's compatible with custom user models.
It uses ``django.contrib.session`` when it's available.

Technically, django-sesame can provide stateless authenticated navigation
without ``django.contrib.sessions``, provided all internal links include the
authentication token, but that increases the security issues explained below.

