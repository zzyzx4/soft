from django.contrib import admin
from .models import Contact, Documents


class ContactAdmin(admin.ModelAdmin):
    list_display = ('user', 'message',)


admin.site.register(Contact, ContactAdmin)


admin.site.register(Documents)
