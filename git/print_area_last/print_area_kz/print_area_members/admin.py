from django.contrib import admin
from .models import Tenant, SystemUser

admin.site.register(Tenant)

admin.site.register(SystemUser)
