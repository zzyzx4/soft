# -*- coding: utf-8 -*-
from django.db import models

# Create your models here.

class Supplier(models.Model):
    title = models.CharField(max_length=50, verbose_name='Наименование поставщика')
    telno = models.CharField(max_length=40, blank=True, verbose_name='Телефон')
    note = models.CharField(max_length=100, blank=True, verbose_name='Коментарий (имя менеджера, с кем лучше разговаривать и т.д.)')
    def __unicode__ (self):
        return self.title
        
class MaterialType_group(models.Model):
    title = models.CharField(max_length=32, verbose_name='Группа типов материалов')
    def __unicode__(self):
        return self.title

class MaterialType(models.Model):
    title = models.CharField(max_length=50, verbose_name='Наименование типа материала')
    unit_of_meas = models.CharField(max_length=8, verbose_name="Единица измерения (кг, шт, лист и т.д.)")
    one_for_order = models.BooleanField(verbose_name='Один на тираж') #одно на тираж - например клише  
    type_group = models.ForeignKey(MaterialType_group, blank=True, null=True)
    class Meta:
        ordering = ["title"]
    def __unicode__(self):
        return self.title

class MaterialPrice(models.Model): #Цена конкретного поставщика
    material = models.ForeignKey('Material', verbose_name='Материал')
    supplier = models.ForeignKey(Supplier, verbose_name='Поставщик')
    nomen_title = models.CharField(blank=True, max_length=50, verbose_name='Номенклатурное наименование')
    start_date = models.DateField(verbose_name='Дата актульности')
    end_date = models.DateField(blank=True, null=True)
    packing = models.FloatField(verbose_name='Кол-во в упаковке') # Единица кратности / минимальное продаваемое кол-во
    price = models.FloatField(verbose_name='Цена за ед') 
    def __unicode__(self):
        return '%s (%s) - %s' % (self.material.title, self.supplier.title, self.price)

class Material(models.Model):
    title = models.CharField(max_length=50) # (MaterialType: бумага мелованная) глянцевая/матовая XXXг, (MaterialType: картон) односторонний/двусторонний XXXг,
    material_type = models.ForeignKey(MaterialType)
    length = models.IntegerField(null=True, blank=True)
    width = models.IntegerField(null=True, blank=True)
    thickness = models.FloatField(null=True, blank=True)
    density = models.IntegerField(null=True, blank=True)
    a_supplier = models.ManyToManyField(Supplier, through='MaterialPrice')
    messure_unit = models.CharField(blank=False, max_length=5) # Единица измерения для отображения в справочниках
    # depricate candidates
    height = models.IntegerField(null=True, blank=True)
    price = models.ForeignKey(MaterialPrice, related_name="the_price" , null=True, blank=True) # Цена для просчета.
                                                                                               # т.к. Связка поставщик-цена в случае материалов не очевидна
    
#    def __init__(self):
#        self.price = models.ForeignKey(MaterialPrice(), null=True) # Цена для просчета
#        super(Material,self).__init__()

    def __unicode__(self):
        return '%s - %s' % (self.material_type.title, self.title)

# class MaterialStore(models.Model):
#    a_date = models.DateField()
#    material_price = models.ForeignKey(MaterialPrice)
#    material_in = models.IntegerField(blank=True)
#    work_data
#    material_out = models.FloatField(blank=True)
    
class Client(models.Model):
    #name 
    #contact_name - нужно заменить на эти поля first_name и last_name 
    first_name = models.CharField(max_length=30, verbose_name='Имя') # переименовать в name 
    last_name = models.CharField(max_length=40, verbose_name='Фамилия', blank=True) # переименовать в contact_name
    tel = models.CharField(max_length=10, verbose_name='Телефон', blank=False)
    email = models.CharField(max_length=30, verbose_name='e-mail', blank=True)
    other_data = models.CharField(max_length=50, verbose_name='Другие данные', blank=True)
    def __unicode__ (self):
        return '%s %s' % (self.first_name, self.last_name)


#class SubjectDetail(models.Model): # Попытка использовать иерархическую структуру изделия
#    title = models.CharField(max_length=50)
#    masterdetail = models.ForeignKey(SubjectDetail) # Составная часть детали уровнем выше
#    material = models.ManyToManyField(MaterialType)
#    work = models.ManyToManyField(WorkType)
#    def __unicode__(self):
#        return '%s' % (self.title)


class Machine(models.Model): #Вспомогательная таблица - Тип печатного оборудования ПЕРЕИМЕНОВАТЬ В PressMachine
    m_name = models.CharField(max_length=31, verbose_name='Печатное оборудование') 
    note = models.CharField(max_length=127, blank=True)
    # master = models.ForeignKey(Material) #Какие используются пластины/мастера - ПОХОЖЕ ПОЛЕ НЕ АКТУАЛЬНО ТАК КАК В ЗАВИСИМОСТИ ОТ ТИПА ПЕЧАТИ может использоваться или калька или СТР-форма
    paper_type = models.ManyToManyField(MaterialType, verbose_name='Тип бумаги')
    pu_amount = models.IntegerField(verbose_name='Кол-во печатных секций') #Кол-во печатых секций
    power_consumption = models.FloatField() #кВт
    amortisation = models.IntegerField() #Амортизация в долларах в рабочий час (Кол-во рабочих часов в месяц определяется каждым предприятием по своему)
    using_square = models.IntegerField() #Площадь занимаемая данным производственным участком
#    perfection_unit = models.BooleanField() наличие модуля переворота
    density_min = models.IntegerField(verbose_name='Минимальная плотность')
    density_max = models.IntegerField(verbose_name='Максимальная плотность')
    width_min = models.IntegerField(verbose_name='Минимальная ширина бумаги')
    width_max = models.IntegerField(verbose_name='Максимальная ширина бумаги')
    height_min = models.IntegerField(verbose_name='Минимальная высота бумаги')
    height_max = models.IntegerField(verbose_name='Максимальная высота бумаги')
    head_space = models.IntegerField(verbose_name='Размер клапана')
    def __unicode__(self):
        return self.m_name

class Repair(models.Model):
    title = models.CharField(max_length=63, verbose_name='Наименование запчасти или ремонтных работ')
    note = models.CharField(max_length=127, blank=True)
    equipment_pm = models.ForeignKey(Machine)
#    equipment = # Другое типографское оборудование
    a_date = models.DateField()
    total = models.FloatField(verbose_name='На сумму')

class PressType(models.Model):
    title = models.CharField(max_length=50) # 1 цвет, 4 цвета ...
    machine = models.ForeignKey(Machine) # вспомогательное поле (для избежания ошибок менеджера)
    master = models.ForeignKey(Material, related_name='+')
    master_amount = models.IntegerField()
    master_lifecircle = models.IntegerField(verbose_name='Тиражестойкость мастера')
    paper_type = models.ForeignKey(MaterialType) # Обязательно для избежания ошибки менеджера
    perfection = models.BooleanField(verbose_name='Печать с переворотом')
    selfback = models.BooleanField(verbose_name='Печать со своим оборотом')
    fitting_time = models.FloatField(verbose_name='Время приладки одного прогона(ч)') # На двухкраске две краски за прогон
    fitting_paper = models.IntegerField(verbose_name='Требуется бумаги на приладку')
    fitting_impress = models.IntegerField(verbose_name='Требуется оттисков на приладку')
    press_speed = models.IntegerField() #Скорость печати в оттисках в час

    iter_amount = models.IntegerField() #Кол-во прогонов необходимое для данного типа печати на данном оборудовании
    material = models.ManyToManyField(Material, through='MaterialPerPress')    
    def __unicode__ (self):
        return '%s - %s - %s' % (self.paper_type.title, self.machine.m_name, self.title)

class MaterialPerPress(models.Model): # норма расхода материала на данный тип печати (масло, оксилан, спирт и т.д.)
                                          # норма трудозатрат учтена в таблице PressType
    press_type = models.ForeignKey(PressType)
    material = models.ForeignKey(Material)
    consumption = models.FloatField() # кол-во материала на оттиск(imprint)
    def __unicode__ (self):
        return '%s for %s' % (self.material.title, self.press_type.title)
  
class EvaluatedMpp(models.Model): # ПОДСЧИТАННАЯ норма расхода материала на данный вид печатных работ
    mpp = models.ForeignKey(MaterialPerPress)
    a_date = models.DateField() # дата актуальности значения
    consumption = models.FloatField() # фиксированное кол-во материала на оттиск(impress)
    def __unicode__ (self):
        return '%s for %s (%s) - %s' % (self.MFP.material.title, self.MFP.press_type.title, self.a_date, self.consumption)
  
  
class PressPrice(models.Model): # Вспомогательная таблица для облегчения просчета себестоимости 
                                # ПЕРЕХОДНОЙ КАСТЫЛЬ между текущим способом калькуляции и целевым
    press_type = models.ForeignKey(PressType)
    fitting_charge = models.FloatField(verbose_name='Стоимость приладки') # амортизация+аренда+зарплата - временные характеристики
    item_charge = models.FloatField() #Стоимость оттиска = амортизация+ремонт+аренда+зарплата
    start_date = models.DateField()
    def __unicode__ (self):
        return '%s' % (self.press_type.title)

class WorkType(models.Model): #Работа (фальцовка, подборка, склейка и т.д.)
    title = models.CharField(max_length=50)
    # Базовые характеристики
    fitting_time = models.FloatField(verbose_name='Время приладки(ч)')
    material_perworkfitting = models.ManyToManyField(Material, related_name='a_material' , through='MaterialPerWorkFitting')
    
    work_speed = models.IntegerField() #Скорость выполнения работ в экзеплярах на человеко-час
                                              
    material_perwork = models.ManyToManyField(Material, through='MaterialPerWork')
    
    def __unicode__ (self):
        return self.title

class MaterialPerWorkFitting(models.Model):
    work_type = models.ForeignKey(WorkType)
    material = models.ForeignKey(Material)
    consumption = models.FloatField() # фиксированное кол-во материала на приладку данного вида работ
    def __unicode__ (self):
        return '%s for %s' % (self.material.title, self.work_type.title)

class MaterialPerWork(models.Model): # норма расхода материала на данный тип работ (масло, марзаны, клей и т.д.)
                                          # норма трудозатрат учтена в таблице PressType
    work_type = models.ForeignKey(WorkType)
    material = models.ForeignKey(Material)
    consumption = models.FloatField() # фиксированное кол-во материала на единицу данного вида работ
    def __unicode__ (self):
        return '%s for %s' % (self.material.title, self.work_type.title)

class EvaluatedMpv(models.Model): # ПОДСЧИТАННАЯ норма расхода материала на данный вид работ
    mpw = models.ForeignKey(MaterialPerWork)
    a_date = models.DateField() # дата актуальности значения
    consumption = models.FloatField() # кол-во материала на единицу данного вида работ
    def __unicode__ (self):
        return '%s for %s - %s' % (self.material, self.work_type.title, self.amount)

#class WorkPrice(models.Model): # Вспомогательная таблица для облегчения просчета себестоимости 
                                # ПОХОЖЕ ЭТО ЛИШНЕЕ
#    work_type = models.ForeignKey(WorkType)
#    fitting_charge = models.FloatField(verbose_name='Цена приладки')  
#    item_charge = models.FloatField() #Цена работы
#    start_date = models.DateField()

class SizeType(models.Model): 
    title = models.CharField(max_length=50) #ГОСТ ?
    width = models.IntegerField()
    height = models.IntegerField()

    def __unicode__ (self):
        return self.title    


class OrderType(models.Model): # шаблон заказа который копируется в заказ
    title = models.CharField(max_length=50)
    description = models.CharField(max_length=255, blank=True)
    size_type = models.ManyToManyField(SizeType)
    press_type = models.ManyToManyField(PressType)
    work_type = models.ManyToManyField(WorkType, through='WorksOfOrderType')
    pageamount_multiple = models.IntegerField(verbose_name='Кол-во страниц кратно') #2,4,6,8,16 

    def __unicode__ (self):
        return self.title

class WorksOfOrderType(models.Model):
    ordertype = models.ForeignKey(OrderType)
    worktype = models.ForeignKey(WorkType)
    sort_index = models.IntegerField()
    #Данный вид работ производится в количестве:  
    workamount_default = models.IntegerField(verbose_name='Кол-во работ по умолчанию', default=1) #1 - одна работа на каждую единицу продукции, 2 - 2 работы на каждую ед продукции
    workamount_min = models.IntegerField(verbose_name='Мин кол-во работ', default=1)
    workamount_max = models.IntegerField(verbose_name='Макс кол-во работ', default=1)
    
    eachother_exclude = models.IntegerField(verbose_name='Индекс взаимного исключения работ', default=0) # 0 - не используется
                                                                                              # n - если используется тогда min,max не используется (в этой реализации)
    relate_to_pageamount = models.IntegerField(default=0) #ПЕРЕИМЕНОВАТЬ relate_to_pagegroup #0 - не применимо, 16,32 - шитье, комплектация на каждые 16,32 страницы
    relate_to_circ = models.BooleanField() # данный тип работ один на тираж (можно указать их кол-во на тираж в )

class Order(models.Model):
    order_no = models.CharField(max_length=8, verbose_name='Номер заказа')
    client = models.ForeignKey(Client, verbose_name='Клиент')
    order_type = models.ForeignKey(OrderType, verbose_name='Тип продукции') # ссылка на шаблон заказа
    order_datetime = models.DateTimeField(verbose_name='Дата расчета/размещения заказа') # дата размещения / расчета 

    title = models.CharField(max_length=100, verbose_name='Наименование заказа/расчета')
    deadline_date = models.DateField(blank = True, null = True, verbose_name='Последний срок сдачи')
    start_date = models.DateField(blank = True, null = True, verbose_name='Фактическое начало работ')
    end_date = models.DateField(blank = True, null = True, verbose_name='Фактическое окончание работ')
    size_type = models.ForeignKey(SizeType, verbose_name='Размер') # формат изделия - доступный перечень берется из OrderType
    #pressdata - учтено
    #workdata - учтено
    page_amount = models.IntegerField(blank=True, null = True, verbose_name='Кол-во страниц')
    circ = models.PositiveIntegerField(verbose_name='Тираж') #тираж
    price = models.FloatField(blank = True, null = True, verbose_name='Расчетная цена за экземпляр') 
    given_price = models.FloatField(blank = True, null = True, verbose_name='Отпускная цена за экземпляр')
    def __unicode__ (self):
        return '%s (%s)' % (self.title, self.order_datetime)
        
#class PriceCutoff(models.Model): # Срез цен на материалы по заказу - НЕ АКТУАЛЬНО
#    order = models.ForeignKey(Order)
#    material_price = models.ManyToManyField(MaterialPrice)

    

class PressData(models.Model):
    order = models.ForeignKey(Order, verbose_name='Заказ/Просчет')
    press_type = models.ForeignKey(PressType, verbose_name='Тип печати', null = True)
    sheet_per_presssheet = models.IntegerField(verbose_name='Листов на печатном листе')
    presssheet_amount = models.IntegerField(verbose_name='Кол-во печатных листов печатаемых таким способом')
    sheetcopy_amount = models.IntegerField(verbose_name='Кол-во одинаковых печатных листов в экземпляре продукции')
    paper_amount = models.IntegerField(verbose_name='Общее кол-во бумаги печатного формата на тираж с учетом приладки')#Вычисляемое поле
    
    paper = models.ForeignKey(Material, verbose_name='Бумага')
    # material_price = models.ForeignKey(PriceCutoff) #Срез цен по материалам востанавливается по полю Order
    # press_price = models.ForeignKey(PressPrice) # Цена работ восстанавливается по нормам и зарплате по дате

    # subject_detail = models.ForeignKey(SubjectDetail, verbose_name='Деталь')    
    note  = models.CharField(max_length=200, blank=True, verbose_name='Примечание')
    def __unicode__(self):
        return '%s (%s) - %s' % (self.order.title, self.presstype.title, self.sheet_amount)
    
class WorkData(models.Model): # ПЕРЕИМЕНОВАТЬ OrderWorkData
    order = models.ForeignKey(Order)
    work_type = models.ForeignKey(WorkType) #поле загружает данные из order_type либо переопределяет 
                                            #здесь уже определено тип и кол-во используемых материалов
    inst_workamount = models.IntegerField() #Кол-во данного типа работ на экземпляр. Наследуемое перегружаемое поле
    circ_workamount = models.IntegerField(default=0) #Кол-во данного типа работ на тираж. Вычисляемое поле.
    note  = models.CharField(max_length=200, blank=True)
    
    # material_price = models.ForeignKey(PriceCutoff) #Срез цен по материалам - востанавливается по полю Order
    
    def __unicode__(self):
        return '%s - %s' % (self.order.title, self.work_type.title)

class EmployeePosition(models.Model):
    title = models.CharField(max_length=15)
    

class Employee(models.Model):
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30, blank=True)
    position = models.ForeignKey(EmployeePosition)
    salary = models.IntegerField() #ВРЕМЕННЫЙ КОСТЫЛЬ до перехода на сдельную оплату
    hire_date = models.DateField() #дата приема на работу
    dismissal_date = models.DateField(blank=True) #дата увольнения
    def __unicode__(self):
        return '%s %s' % (self.first_name, self.last_name)
    
class PositionSalary(models.Model): 
    employee_position = models.ForeignKey(EmployeePosition)
    salary = models.IntegerField(blank=True, null=True) #Оклад сотрудника (по отработанному времени)
    human_hour_salary = models.IntegerField(blank=True, null=True) #Оплата за человеко-час - за выработку
    start_date = models.DateField(blank=False, null=False)
    
class Workout(models.Model): #Выработка
    a_date = models.DateField(verbose_name='Дата выполнения') 
    employee = models.ForeignKey(Employee, verbose_name='Сотрудник')
    work_data = models.ForeignKey(WorkData)
    count = models.IntegerField() #skolko sdelano
    duration = models.FloatField() # продолжительность выполения (информация для статистики)
    note  = models.CharField(max_length=200, blank=True)
    def __unicode__(self):
        return '%s - %s' % (self.work_data.work_type.title, self.count)

class Pressout(models.Model): #Выработка по печати
    employee = models.ForeignKey(Employee)
    press_data = models.ForeignKey(PressData)
    sheet_count = models.IntegerField() #skolko otpechatano listov-спусков
    a_date = models.DateField()
    duration = models.FloatField() # информация для статистики
    note  = models.CharField(max_length=200, blank=True)
    def __unicode__(self):
        return '%s - %s(%s)' % (self.employee.first_name, self.press_data.press_type.title, self.press_data.order.title)

class Refbook(models.Model): # Справочник 
    name = models.CharField(max_length=128, blank=False)
    a_date = models.DateField() # Дата начала действия значения
    num_value = models.FloatField(null=True, blank=True)
    str_value = models.CharField(max_length=128, null=True, blank=True)
    def __unicode__(self):
        return '%s = %s%s' % (self.name, self.num_value, self.str_value)
            
class RouteRefbook(models.Model): # Справочник маршрутов
    dest_name = models.CharField(max_length=128, blank=False)
    distance = models.FloatField()
    def __unicode__(self):
        return self.dest_name

class TripDK(models.Model): # Расчеты с водителем
    a_date = models.DateField() #дата движения баланса средств
    employee = models.ForeignKey(Employee)
    kt = models.FloatField() # Водитель наездил
    dt = models.FloatField() # Водителю выплатили
    balance_out = models.FloatField() # Исходящий баланс
    def __unicode__(self):
        return '%s -> kt=%s - dt=$s' % (self.balance_in, self.kt, self.dt)
        
class TripOrder(models.Model): # Поездки
    a_date = models.DateField()
    employee = models.ForeignKey(Employee)
    destination = models.ForeignKey(RouteRefbook)
    dk = models.ForeignKey(TripDK, null=True, blank=True)
    def __unicode__(self):
        return self.destination.dest_name
        
