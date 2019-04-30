from django.contrib import admin
from calc.models import Machine, Client, PressType, PressPrice, WorkType, OrderType, WorksOfOrderType, Supplier, Order, WorkData, MaterialType_group, MaterialType, Material, MaterialPrice, PressData, Employee, Workout, Pressout
#SizeType, 
#Refbook, RouteRefbook, TripDK, TripOrder


class WorkdataAdmin(admin.ModelAdmin):
    list_display = ('order', ) #'work_type', 'work_amount')
    list_filter = ('order',)

class WorkoutAdmin(admin.ModelAdmin):
    list_display = ('a_date', 'work_data')
    list_filter = ('a_date',)
#    date_hierarchy = 'a_date'
#    filter_horizontal = ('a_date',)
#    raw_id_fields = ('employee',)

class PressoutAdmin(admin.ModelAdmin):
    list_display = ('employee', 'press_data', 'sheet_count', 'a_date', 'duration', 'note')
    list_filter = ('a_date',)

class MaterialPriceInline(admin.TabularInline):
    model = MaterialPrice
    extra = 1
class SupplierAdmin(admin.ModelAdmin):
    inlines = (MaterialPriceInline,)
class MaterialAdmin(admin.ModelAdmin):
    inlines = (MaterialPriceInline,)
    list_display = ('material_type','title',)
    list_filter = ('material_type',)
   

#class MFPConsumptionNormInline(admin.TabularInline):
#    model = MFPConsumptionNorm
#class PressTypeAdmin(admin.ModelAdmin):
#    inlines = (MFPConsumptionNormInline,)

#class WorkConsumptionNormInline(admin.TabularInline):
#    model = WorkConsumptionNorm
#class WorkTypeAdmin(admin.ModelAdmin):
#    inlines = (WorkConsumptionNormInline,)


admin.site.register(Client)

#admin.site.register(PressType, PressTypeAdmin)
admin.site.register(PressPrice)
#admin.site.register(MFPConsumptionNorm)

#admin.site.register(WorkType, WorkTypeAdmin)

#admin.site.register(WorkConsumptionNorm)

admin.site.register(OrderType)
admin.site.register(Supplier, SupplierAdmin)
admin.site.register(Order)
admin.site.register(Machine)
admin.site.register(WorkData, WorkdataAdmin)
admin.site.register(WorksOfOrderType)

admin.site.register(MaterialType_group)
admin.site.register(MaterialType)
admin.site.register(Material, MaterialAdmin)
admin.site.register(MaterialPrice)
admin.site.register(PressData)

#admin.site.register(SizeType)

admin.site.register(Employee)
admin.site.register(Workout, WorkoutAdmin)
admin.site.register(Pressout, PressoutAdmin)



#admin.site.register(Refbook)
#admin.site.register(RouteRefbook)
#admin.site.register(TripDK)
#admin.site.register(TripOrder)
