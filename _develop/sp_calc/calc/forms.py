# -*- coding: utf-8 -*-

from calc.models import *
from dojango import forms
from dojango.forms import ModelForm
 
class TripOrderForm(ModelForm):
    class Meta:
       model = TripOrder
       field = ['a_date', 'destination.dest_name', 'destination.distance']
#        labels = {'Дата', 'Пункт назначения'}

class OrdertypeForm(forms.Form):
    order_type = forms.ModelChoiceField (label='Тип заказа', 
                                         queryset=OrderType.objects.all(),
                                         widget=forms.Select(attrs={'id':'ordertype_selection', 'data-dojo-props':'onChange: function(value){OrderType_change(value);}'})
                                        )

class CommondataForm(ModelForm):
    circ = forms.IntegerField(min_value=1, max_value=1000000, initial=1000)
    class Meta:
        model = Order
        fields = ['order_no', 'title', 'size_type', 'circ']
        # labels = {'circ': 'Тираж',}

    
class PressdataForm(ModelForm):
   
    # идет первым для удобства пользователя - чтобы сократить список с выбором бумаги
    paper_type = forms.ModelChoiceField (label='Тип бумаги', 
                                         queryset=MaterialType_group.objects.get(pk=1).materialtype_set.all(), # Все типы материалов в группе "Бумага"
                                         widget=forms.Select(attrs={'data-dojo-props':'value: "", onChange: function(value){ChainDataGet("c_press_machine_by_papertype_ajaxsel", {"paper_type_id": value}, "id_machine"); ChainDataGet("c_press_paper_by_papertype_ajaxsel", {"paper_type_id": value}, "id_paper"); ChainDataGet("c_press_presstype_by_papertypemachine_ajaxsel", {"paper_type_id": dijit.byId("id_paper_type").get("value"), "machine_id":value}, "id_press_type");}'}),
                                         empty_label="Select ...")
    paper = forms.ModelChoiceField(label='Бумага', 
                                   queryset=Material.objects.none())

    machine = forms.ModelChoiceField(
                                     queryset=Machine.objects.none(),
                                     widget=forms.Select(attrs={'data-dojo-props':'value: "", onChange: function(value){ChainDataGet("c_press_presstype_by_papertypemachine_ajaxsel", {"paper_type_id": dijit.byId("id_paper_type").get("value"), "machine_id":value}, "id_press_type");}'}),
                                     empty_label="Select ..."
                                    )
    machine.label = 'Печатное оборудование'
    press_type = forms.ModelChoiceField(label='Тип печати (тип бумаги - машина - цветность)', 
                                        queryset=PressType.objects.none())
    sheet_per_presssheet = forms.IntegerField(label='Листов на печатном листе  ',
                                                   min_value=1,
                                                   widget=forms.NumberTextInput(attrs={'id':'ShPerPressSh_numberinput'}))
    presssheet_amount = forms.IntegerField(min_value=1,
                                      widget=forms.NumberTextInput(attrs={'id':'SheetAmount_numberinput'}))
                                      
    presssheet_amount.label = 'Печатных листов'
    class Meta:
        model = PressData
        fields = ('paper_type', 'paper', 'machine', 'press_type', 'sheet_per_presssheet', 'presssheet_amount', 'sheetcopy_amount', 'note')
    
    #def __init__(self, a_papertype=None, a_paper=None, a_machine=None, *args, **kwargs): Способ получения фильтрованных данных без AJAX, для валидации, а также видимо для сохранения данных в БД
    #   super(PressdataForm, self).__init__(*args, **kwargs) 
    #   self.fields['paper'].queryset = Material.objects.filter(material_type=a_papertype)
    #   self.fields['machine'].queryset = Machine.objects.filter(paper_type=a_machine)
    #   self.fields['press_type'].queryset = PressType.objects.filter(machine=a_machine, paper_type=a_papertype)
        

class WorkdataForm(forms.Form):
    #page_amount = forms.IntegerField(label='Кол-во стр к обработке (берется из данных по печати или перегружается)', min_value=1, widget=forms.NumberTextInput()) #Кол-во страниц в заказе

    def __init__(self, *args, **kwargs):
        works = kwargs.pop('works')
        #print works
        super(WorkdataForm, self).__init__(*args, **kwargs)
        for i, work in enumerate(works):
            if work['eachother_exclude']==0:
                if work['workamount_min']==0 and work['workamount_max']==1: # Редактируемый чекбокс
                    if work['workamount_default']==1:
                        a_attrs = {'checked': 'checked'}
                    else: 
                        a_attrs = {}
                    self.fields['work_%s' % i] = forms.BooleanField(required=False,
                                                                    label=work['title'],
                                                                    widget=forms.CheckboxInput(attrs=a_attrs))
                        
                elif work['workamount_min']==1 and work['workamount_max']==1: # Нередактируемый чекбокс
                    a_attrs = {'checked': 'checked', 'disabled': 'disabled'}
                    self.fields['work_%s' % i] = forms.BooleanField(required=False,
                                                                    label=work['title'],
                                                                    widget=forms.CheckboxInput(attrs=a_attrs))
                elif work['workamount_min']>0 and work['workamount_max']-work['workamount_min']>1: #Редактируемый спин
                    self.fields['work_%s' % i] = forms.IntegerField(label=work['title'],
                                                                    min_value=work['workamount_min'],
                                                                    max_value=work['workamount_max'],
                                                                    initial=work['workamount_default'])
            #else Взаимоисключающие работы
        
class OrderWorkdataAddForm(forms.Form): # Форма добавления работы к данному заказу
    work = forms.ModelChoiceField(label='Доавить работу к перечню работ по заказу', queryset=WorkType.objects.all()) 
    # НУЖНО ФИЛЬТРОВАТЬ ТЕ РАБОТЫ КОТОРЫЕ УЖЕ ДОБАВЛЕННЫ К ЭТОМУ ЗАКАЗУ

class WorkoutForm(forms.Form):
    employee = forms.ModelChoiceField (label='Сотрудник', queryset=Employee.objects.all())
    order = forms.ModelChoiceField (label='Заказ', queryset=Order.objects.all())
    
class WorkoutdataForm(ModelForm):
    employee = forms.ModelChoiceField (queryset=Employee.objects.all(),
                                       widget = forms.HiddenInput())
    #workdata = forms.ModelChoiceField (label='Перечень работ')
    class Meta:
        model = Workout  
        #exclude = ('employee',)
    def __init__(self, a_order=None, *args, **kwargs): 
       super(WorkoutdataForm, self).__init__(*args, **kwargs) 
       self.fields['work_data'].queryset = WorkData.objects.filter(order=a_order)
    
#class newMaterialpriceForm(ModelForm):
#    material = forms.ModelChoiceField(label='Материал', queryset=Material.objects.all(), widget=forms.Select(attrs={'disabled': 'disabled'}))
#    #supplier
#    #nomen_title
#    #start_date
#    end_date = forms.DateField(widget = forms.HiddenInput())
#    #packing
#    #price
#    class Meta:
#        model = MaterialPrice

class MaterialpriceForm(ModelForm):
    material = forms.ModelChoiceField(label='Материал', queryset=Material.objects.all(), widget=forms.Select(attrs={'data-dojo-type': 'dijit.form.FilteringSelect', 'disabled': 'disabled'}))
    supplier = forms.ModelChoiceField(label='Поставщик', queryset=Supplier.objects.all().order_by('title'), widget=forms.Select(attrs={'data-dojo-type': 'dijit.form.FilteringSelect', 'maxHeight': -1}))
    
    class Meta:
        model = MaterialPrice
        localized_fields = ('start_date',)

