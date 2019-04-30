# -*- coding: utf-8 -*-
# Create your views here.

import re
import json

from django.http import HttpResponseRedirect
from django.shortcuts import render_to_response, get_object_or_404
from django.template import loader, Context, RequestContext

#from django.core import serializers
from django.views.generic import ListView

#from mysite.books.forms import BookletdataForm
from calc.forms import *

from django.shortcuts import get_object_or_404
from django.views.generic import ListView
from dojango.decorators import json_response, expect_post_request 
from calc.models import Order, Employee, WorkData, MaterialType, Machine, TripOrder, MaterialPrice


def index(request):
    return render_to_response('index.html')


def simple(request):
    return render_to_response('simple.html')
 

def trip_orders(request):
    if request.method == 'POST':
        form = TripOrderForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
        return render_to_response('triporders.html', {'form': form})
    else:
        form = TripOrderForm(
        initial={'density': '130', 'amount': '1000'})
    return render_to_response('triporders.html', {'form': form})
    



@expect_post_request
@json_response
def simple_ajax_set(request):
    ret={}
    firstname = request.POST['firstname']
    surname = request.POST['surname']
    if len(surname)<3:
        ret['error'] = 'Surname is too short.'
        ret['success'] = False
    if 'success' in ret.keys():
        if ret['success']:
            # Store the data here
            pass
    print firstname, surname
    return ret


#def bookletdata(request):
#   if request.method == 'POST':
#     form = BookletdataForm(request.POST)
#     if form.is_valid():
#       # cd = form.cleaned_data
#       
#       return HttpResponseRedirect('/bookletres/')
#   else:
#     form = BookletdataForm(
#       initial={'density': '130', 'amount': '1000'})
#   return render_to_response('bookletdata_form.html', {'form': form})


def dojango_test(request):
    return render_to_response('dojango_test.html', context_instance=RequestContext(request))

#-----------------------------------------------------------------------
def price(request):
    if request.method == 'POST':
        materialprice_form = MaterialpriceForm(request.POST)
#        editmaterialprice_form = editMaterialpriceForm(request.POST)
        if materialprice_form.is_valid():
            return render_to_response('price.html', {'materialprice_form': materialprice_form})
    else:
        materialprice_form = MaterialpriceForm() # Загружаем дефолтную форму если пришли сюда не по POST
#        editmaterialprice_form = editMaterialpriceForm() # Загружаем дефолтную форму если пришли сюда не по POST
    return render_to_response('price.html', {'materialprice_form': materialprice_form})

@expect_post_request
@json_response
def materialprice_ajaxpost(request):

    r = {}

    materialprice_id = request.POST.get('materialprice_id')
    material = Material.objects.get(id=request.POST['id_material'])
    supplier = Supplier.objects.get(id=request.POST['id_supplier'])
    nomen_title = request.POST['id_nomen_title']
    start_date = request.POST['id_start_date']
    end_date = request.POST['id_end_date']
    packing = request.POST['id_packing']
    price = request.POST['id_price']

    try:
        mp = MaterialPrice(id=materialprice_id, material = material, supplier = supplier, nomen_title = nomen_title, start_date = start_date, packing = packing, price = price)
        mp.save()
    except Exception as e:
        r["success"] = False
        r["message"] = e
        return r
        

    # if materialprice_form.is_valid(): Бесполезно проверять встроенными средствами
        #materialprice_form.save()
        
    r["success"] = True

    #else:
    #    r["errorcode"] = 1
    #    r["errors"] = materialprice_form.errors
    #    print r["errors"]
    
    return r
    


@json_response
def material_tree_ajaxget(request):
    
    material_list = [{'id':"root", 'name':""}]
    
    materialtype_group_q = MaterialType_group.objects.order_by('title').values('id','title')
    
    for materialtype_group_i in materialtype_group_q:
        materialtype_group = {}
        materialtype_group['id'] = 'TG'+str(materialtype_group_i["id"])
        materialtype_group['parent'] = "root"
        materialtype_group['name'] = materialtype_group_i["title"]
        material_list.append(materialtype_group)
    
    materialtype_q = MaterialType.objects.order_by('title').values('id', 'title', 'type_group')
    for materialtype_i in materialtype_q:
        materialtype = {}
        materialtype['id'] = 'MT'+str(materialtype_i['id'])
        materialtype['parent'] = 'TG'+str(materialtype_i['type_group'])
        materialtype['name'] = materialtype_i['title']
        material_list.append(materialtype)

    material_q = Material.objects.order_by('title').values('id', 'title', 'material_type')
    for material_i in material_q:
        material = {}
        material['id'] = str(material_i['id'])
        material['parent'] = 'MT'+str(material_i['material_type'])
        material['name'] = material_i['title']
        material['rectype'] = 'm'
        material_list.append(material)

    return {'material_list':material_list}

#-----------------------------------------------------------------------
@json_response
def material_data_ajaxget(request):

    r = {}
    if request.method == 'GET':
        material_id=request.GET['material_id']
        m = re.match(r'\d+',material_id) # m = re.match(r'(M(\d+))',material_id)
        if m:
            id = m.group() # m.group(2)
            materialdata_q = MaterialPrice.objects.filter(material__exact=id).order_by('supplier__title').values('id','nomen_title','supplier__id','supplier__title','packing','price','start_date','end_date')
            r['material_data'] = materialdata_q
    else: 
        r['material_data'] = ''
    
    return r
#-----------------------------------------------------------------------

#--- НЕ АКТУАЛЬНО
#def press_data(request):
#    if request.method == 'POST':
#        papertype = get_object_or_404(MaterialType, id__exact=request.POST['paper_type'])
#        paper = get_object_or_404(Material, id__exact=request.POST['paper'])
#        machine = get_object_or_404(Machine, id__exact=request.POST['machine'])
#        presstype = get_object_or_404(PressType, id__exact=request.POST['press_type'])
#        pressdata_form = PressdataForm(papertype, paper, machine, request.POST)

#        #print '---request.POST'
#        #print request.POST

#        if pressdata_form.is_valid(): # просчитываем данные
          
#            circ = 1000 #Тираж
            
#            try:
#                press_price = PressPrice.objects.filter(press_type__exact=request.POST['press_type']).order_by('-start_date')[0]
#                fitting_charge = press_price.fitting_charge
#                item_charge = press_price.item_charge
#            except PressPrice.DoesNotExist: #Надо как-то нормально обрабатывать пока не знаю как
#                press_price = None
            
#            press_sum = (fitting_charge + item_charge*circ)*presstype.iter_amount
            
#            #press_type = PressType.objects.get(id=request.POST['presstype'])    
#            fitting_paper = presstype.fitting_paper
            
#           paper_sum = (circ+fitting_paper)*paper.price.price
            
#           master_id = machine.plate.id
#            #master_price = machine.plate.price.price #Цена форм/мастеров
            
#            materials_queryset = PressConsumptionNorm.objects.filter(press_type__exact=presstype)
#            materials_values = materials_queryset.values('material', 'amount', 'material__price__price')
#           material_sum=0
#            master_sum = 0
#            for i in materials_values:
#                if i['material'] == master_id:
#                  master_sum = master_sum+i['amount']*i['material__price__price']
#                else:
#                  material_sum = material_sum+i['amount']*i['material__price__price']
            
#            return render_to_response('pressdata_form.html', {'pressdata_form': pressdata_form, 'paper_sum': paper_sum, 'master_sum': master_sum, 'material_sum': material_sum, 'press_sum': press_sum})
      
#    else:
#        pressdata_form = PressdataForm() # Загружаем дефолтную форму если пришли сюда не по POST
#    return render_to_response('pressdata_form.html', {'pressdata_form': pressdata_form})

#-----------------------------------------------------------------------

@json_response
def work_data_ajaxget(request):

    a_ordertype_id = request.GET["order_type_id"]
    works_q = WorksOfOrderType.objects.filter(ordertype_id=a_ordertype_id).order_by('sort_index').values('id', 'worktype__title', 'eachother_exclude', 'workamount_default', 'workamount_min', 'workamount_max')
    work_list = []
    for work in works_q:
        i_work = {}
        i_work['id'] = work['id']
        i_work['title'] = work['worktype__title']
        i_work['eachother_exclude'] = work['eachother_exclude']
        i_work['workamount_default'] = work['workamount_default']
        i_work['workamount_min'] = work['workamount_min']
        i_work['workamount_max'] = work['workamount_max']
        work_list.append(i_work)
    print work_list
    # order = get_object_or_404(WorkData, id__iexact=request.GET)

    r = {}
    if request.method == 'GET': # Сюда попадаем только по GET
        workdata_form = WorkdataForm(works=work_list) # Получаем дефолтную форму
        r ['html'] = workdata_form.as_table()
    return r

#-----------------------------------------------------------------------
def ordertype(request):
    if request.method == 'GET':
        ordertype_form = OrdertypeForm(request.GET)
        if ordertype_form.is_valid():
            return HttpResponseRedirect('/orderdata/')
    
        ordertype_form = OrdertypeForm()
    return render_to_response('ordertype.html', {'ordertype_form': ordertype_form})



def order_data(request):
    #work_list = [{'id': 1, 'title': 'работа1', 'required': True,  'eachother_exclude': 0, 'workamount_default': 1, 'workamount_min': 0, 'workamount_max': 1},
    #             {'id': 2, 'title': 'работа2', 'required': False, 'eachother_exclude': 0, 'workamount_default': 0, 'workamount_min': 0, 'workamount_max': 1},
    #             {'id': 3, 'title': 'работа3', 'required': False, 'eachother_exclude': 0, 'workamount_default': 1, 'workamount_min': 1, 'workamount_max': 1},
    #             {'id': 4, 'title': 'работа4', 'required': False, 'eachother_exclude': 0, 'workamount_default': 2, 'workamount_min': 1, 'workamount_max': 3}]

    if request.method == 'POST': #Приход сюда по POST никогда не должен произойти ???
        commondata_form = CommondataForm(request.POST)
        #pressdata_form = PressdataForm(request.POST)
        #workdata_form = WorkdataForm(request.POST, works=work_list)
        if commondata_form.is_valid(): # and pressdata_form.is_valid():
            return render_to_response('calc.html', {'commondata_form': commondata_form})
    else: # Если пришли не по POST загружаем пустые формы
        ordertype_form = OrdertypeForm()
        commondata_form = CommondataForm()
        pressdata_form = PressdataForm()
        #workdata_form = WorkdataForm(works=work_list)
    return render_to_response('calc.html', {'ordertype_form': ordertype_form,  'commondata_form': commondata_form, 'pressdata_form': pressdata_form })

@expect_post_request
@json_response
def c_press_machine_by_papertype_ajaxsel(request):
    print 'c_press_machine_by_papertype_ajaxsel ---'
    paper_type_id = request.POST['paper_type_id']
    try:
        p = MaterialType.objects.get(id=paper_type_id)
        #   PaperType
    except Exception as e:
        print e 
    
    m = p.machine_set.all().values('id', 'm_name')
    #data = serializers.serialize('json', m, fields=('m_name',))
    #print 'dATA:' 
    #print data
    r = {}
    for i in m:
        r [i["id"]] = i["m_name"]
    #print r
    return r
    
@expect_post_request
@json_response
def c_press_paper_by_papertype_ajaxsel(request):
    print 'c_press_paper_by_papertype_ajaxsel ---'
    paper_type_id = request.POST['paper_type_id']
    try:
        pt = MaterialType.objects.get(id=paper_type_id)
    except Exception as e:
        print e 
    
    p = pt.material_set.all().values('id', 'title')
    #data = serializers.serialize('json', m, fields=('m_name',))
    #print 'dATA:' 
    #print data
    r = {}
    
    for i in p:
        r [i["id"]] = i["title"]
    return r

@expect_post_request
@json_response    
def c_press_presstype_by_papertypemachine_ajaxsel(request):
    print 'c_press_presstype_by_papertypemachine_ajaxsel ---'

    paper_type_id = request.POST.get('paper_type_id',)
    print 'paper_type_id=', paper_type_id
    machine_id = request.POST.get('machine_id',)
    print 'machine_id=', machine_id
    try:    
        presstype_list = PressType.objects.filter(paper_type=paper_type_id, machine=machine_id).values('id', 'title')
    except Exception as e:
        print e
    r = {}
    for i in presstype_list:
        r [i["id"]] = i["title"]
    return r

#@expect_post_request
#@json_response    
#def pressjob_list_ajaxlist(request):
#    order_id = request.POST['order_id']
#    try:
#        pressjob_list = PressData.objects.filter()
    
@expect_post_request
@json_response
def calculate_order(request):
    
    client = request.POST['client']
    title = request.POST['title']
    id_sizetype = request.POST['id_sizetype']
    circ = request.POST['circ']
    pressdata_json = request.POST['pressdata'] #getlist(,)
    pressdata = json.loads(pressdata_json)
    #workdata_json = request.POST['workdata']
    #workdata = json.loads(workdata_json)

    for i_pd in pressdata:
        # Обработка задания на печать
        # СтоимостьПечати = КолвоПрогоновНаЛист*КолвоЛистов*(ЦенаПриладки+ЦенаОттиска*Тираж+ОплатаПечатникуЗаПрогон)
        # ЦенаПриладки = ВремяНаПриладку*(ЭлектроэнергияВЧас+АрендаВЧас+АмортизацияВЧас)+МатРасходыНаОттиск*ОттисковНаПриладку
        # ЦенаОттиска = (ЭлектроэнергияВЧас+АрендаВЧас+АмортизацияВЧас)/ОттисковВЧас+МатРасходыНаОттиск
        # ОплатаПечатникуЗаПрогон = (ВремяПриладки+Тираж/ОттисковВЧас)*СтоимостьЧеловекоЧаса
        
        # СтоимостьБумаги = ЦенаПечЛиста*(Тираж+ЛистовНаПриладку)*КолвоЛистов
        
        #print i_pd
        presstype = PressType.objects.get(id=i_pd['id_press_type'])
        
        machine = Machine.objects.get(id=i_pd['id_machine'])

        rent_ph = Refbook.objects.filter(name='Аренда 1квм цеха (тенге за рабочий час)').order_by('-a_date')[:1]
        #course_usd = Refbook.objects.filter(name='1 USD').order_by('-a_date')[:1]
        
        fitting_time = presstype.fitting_time #
        power_consumption = machine.power_consumption #
        rent_sum = rent_ph*machine.using_square #
        #amortisation_ph = course_usd*machine.amortisation # --------------?
        
        
        #repexpenses_pi - На ремонт с оттиска (запчасти и работы)

        #matexpenses_pi - Потребление расходников на оттиск (масло, смывка, краска, тряпки, резина, порошок, мыло и т.д.)
        # просчет нормы потребления производится на дату новой закупки расходника
        matexpenses_pi = 0
        for material_id in MaterialForPress.objects.filter(mfp__press_type=i_pd['id_press_type']).values('material_id'):
            matexpenses_pi=matexpenses_pi + MFPConsumptionNorm.objects.filter(mfp__press_type=i_pd['id_press_type'], mfp__material=material_id).order_by('-a_date')[:1].values('consumption')

        #expenses_pi  - МатРасходыНаОттиск
        expenses_pi = matexpenses_pi + repexpenses_pi
        
           
        
        fitting_impress = presstype.fitting_impress # Оттисков на приладку
        press_speed = presstype.press_speed #
        cicr_pd = cicr * i_pd.sheetcopy_amount # - Бывает тираж внутри тиража (повторяющиеся листы)
        
        employee_salary_ph = PositionSalary.objects.filter(employee_position__title="Печатник").order_by('-start_date')[:1].human_hour_salary
        iter_amount = presstype.iter_amount # Кол-во прогонов необходимое для данного типа печати на данном оборудовании
        sheet_amount = press_data.sheet_amount
        paper_price = press_data.paper.price
        fitting_paper = presstype.fitting_paper #
        
        
        # amortization_ph -----------?
        
        # pi - per impress (c машинного оттиска - щелчка счетчика)
        # ЦенаПриладки = ВремяНаПриладку*(ЭлектроэнергияВЧас+АрендаВЧас+АмортизацияВЧас)+МатРасходыНаОттиск*ОттисковНаПриладку
        FittingFee = fitting_time*(power_consumption+rent_ph+amortisation_ph)+expenses_pi*fitting_imprint
        # ЦенаОттиска = (ЭлектроэнергияВЧас+АрендаВЧас+АмортизацияВЧас)/ОттисковВЧас+МатРасходыНаОттиск
        ImpressFee = (power_consumption+rent_ph+amortisation_ph)/press_speed+expenses_pi
        
        # ОплатаПечатникуЗаПрогон = (ВремяПриладки+Тираж/ОттисковВЧас)*СтоимостьЧеловекоЧаса (нужно считать)
        SalaryPerIter = (fitting_time+cicr_pd/press_speed)*employee_salary_ph
        # СтоимостьПечати = КолвоПрогоновНаЛист*КолвоЛистов*(ЦенаПриладки+ЦенаОттиска*Тираж+ОплатаПечатникуЗаПрогон)
        PressFee = iter_amount*sheet_amount*(FittingFee+ImpressFee*cicr_pd+SalaryPerIter)
        # СтоимостьБумаги
        PaperCost = paper_price*(circ_pd+fitting_paper)*sheet_amount
        
    
    r = {}
    r["press_price"] = 0
    r["work_price"] = 0
    r["order_price"] = 0
    return r
    
def workout(request):
    if request.method == 'POST':
        workout_form = WorkoutForm(request.POST)
        if workout_form.is_valid():
            return HttpResponseRedirect('/workoutdata/'+request.POST['order']+'/'+request.POST['employee'])
    else:
        workout_form = WorkoutForm()
    return render_to_response('workout.html', {'workout_form': workout_form})

def workoutdata(request, order_id, employee_id):
    order = get_object_or_404(Order, id__iexact=order_id)
    employee = get_object_or_404(Employee, id__iexact=employee_id)
    if request.method == 'POST':

        workoutdata_form = WorkoutdataForm(order, request.POST)
        
        if workoutdata_form.is_valid():
            #workoutdata_form.cleaned_data['subject']
            workoutdata_form.save(commit=True)
            
            workoutdata_form = WorkoutdataForm(a_order=order, initial={'employee': employee})

            return render_to_response('workoutdata.html', {'workoutdata_form': workoutdata_form, 'order': order, 'employee': employee})
    else:

        workoutdata_form = WorkoutdataForm(a_order=order, initial={'employee': employee})
    return render_to_response('workoutdata.html', {'workoutdata_form': workoutdata_form, 'order': order, 'employee': employee})
    
            
class OrderWorkout(ListView):
    context_object_name = "workdata_list"
    template_name = "workoutbyorder_form.html"
    
    def get_queryset(self):
        order = get_object_or_404(Order, id__iexact=self.args[0])
        
        return WorkData.objects.filter(order=order)

