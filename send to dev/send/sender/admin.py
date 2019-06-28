from django.contrib import admin
from .models import Contact, Documents


class ContactAdmin(admin.ModelAdmin):
    list_display = ('user', 'phone', 'message', 'uploaded_at',)


admin.site.register(Contact, ContactAdmin)


class DocumentsAdmin(admin.ModelAdmin):
    list_display = ('title', 'description', 'document', 'uploaded_at',)


admin.site.register(Documents, DocumentsAdmin)
