from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from calc.views import OrderWorkout

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'sp_calc.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),
    
    url(r'^index/', 'calc.views.index'),

    url(r'^price/', 'calc.views.price'),
    url(r'^material_tree_ajaxget', 'calc.views.material_tree_ajaxget'),
    url(r'^material_data_ajaxget', 'calc.views.material_data_ajaxget'),
    url(r'^materialprice_ajaxpost', 'calc.views.materialprice_ajaxpost'),
    
    url(r'^order/', 'calc.views.order_data'),

    # url(r'^pressdata/', 'calc.views.press_data'),
    
    url(r'^workdata/', 'calc.views.work_data_ajaxget'),
    
    url(r'^triporders/', 'calc.views.trip_orders'),
    
    url(r'^c_press_paper_by_papertype_ajaxsel/', 'calc.views.c_press_paper_by_papertype_ajaxsel'),
    url(r'^c_press_machine_by_papertype_ajaxsel/', 'calc.views.c_press_machine_by_papertype_ajaxsel'),
    url(r'^c_press_presstype_by_papertypemachine_ajaxsel/', 'calc.views.c_press_presstype_by_papertypemachine_ajaxsel'),
    
    url(r'^calculate_order/','calc.views.calculate_order'),
    
    url(r'^workout/', 'calc.views.workout'),
    url(r'^workoutdata/(?P<order_id>\d+)/(?P<employee_id>\d+)/$', 'calc.views.workoutdata'),

    url(r'^ordertype/', 'calc.views.ordertype'),
    url(r'^orderworkout/(\w+)/$', OrderWorkout.as_view()),
    

    url(r'^simple/', 'calc.views.simple'),
    url(r'^simple-ajax-set/', 'calc.views.simple_ajax_set'),

    url(r'^dojango/', include('dojango.urls')),
    url(r'^dojango_test/', 'calc.views.dojango_test'),
    
    
    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),


)
