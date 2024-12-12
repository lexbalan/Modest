
from error import info, warning, error
import hlir.type as type
from hlir.hlir import *
from hlir.field import hlir_field
from hlir.type import type_print, record_field_get
from util import get_item_with_id
from .value import value_terminal, value_cons_node, value_zero, value_is_immediate, value_print, value_cons_immediate


# получает на вход список инициализаторов
# конструирует и возвращает GenericRecord value
def value_record_create(initializers=[], ti=None):
	# структура метится как immediate только когда все ее поля immediate
	is_immediate = True

	# сперва пройдемся по инициализаторам
	# и выясним какие поля у нас здесь имеются
	# (для того чтобы сконструировать тип записи)
	fields = []
	for initializer in initializers:
		field_id = initializer['id']
		init_value = initializer['value']
		field_type = init_value['type']
		field_ti = init_value['ti']

		# если хотя бы один элемент - не immediate
		# -> весь литерал записи - не immediate
		if not value_is_immediate(init_value):
			is_immediate = False

		# создаем поле для типа generic record
		field = hlir_field(field_id, field_type, ti=field_ti)
		fields.append(field)

	record_type = type.hlir_type_record(fields, ti)
	record_type['generic'] = True

	v = value_terminal(record_type, ti)
	v['fields'] = initializers
	v['immediate'] = is_immediate
	return v



"""def cons_initializers(initializers, rec_type, method):
	from value.cons import value_cons, value_cons_implicit
	import copy

	initializers2 = []
	for initializer in initializers:
		field_id = initializer['id']
		init_value = initializer['value']
		# получаем поле с таким именем
		f = get_item_with_id(rec_type['fields'], field_id['str'])

		# приводим инициализатор к типу поля
		#iv = value_cons_implicit(f['type'], init_value)
		iv = _value_cons(init_value, f['type'], init_value['ti'], method)

		ni = copy.copy(initializer)
		ni['value'] = iv
		initializers2.append(ni)

	return initializers2

"""


def cons_items(t, v, method, ti):
	#warning("cons_items", ti)
	items = []
	if len(v['type']['fields']) > 0:
		# 1. проходим по порядку определения по всем полям типа t (целевого)
		# 2. если поля с таким именеи нет в v:
			# 2.1 конструируем нулевое значение соотв типа
			# 2.2 При этом if method == 'implicit' - это ошибка (!)
		# 3. делаем implicit_cast() для поля из v к соотв полю из t
		# 4. проверяем тип
		# 5. пакуем
		prev_nl = 1  # nl для неявных инициализаторов (zeroinitializers)
		for field in t['fields']:
			field_name = field['id']['str']
			field_type = field['type']

			# получаем элемент с соотв именем из исходного значения
			item_value = None
			nl = 0

			initializers = v['fields']
			initializer = get_item_with_id(initializers, field_name)

			if initializer == None:
				# no field, create zero value stub
				item_value = value_zero(field_type, ti=ti)
				if method == 'implicit':
					# implicit cast требует наличия всех полей
					error("required field '%s'" % field_name, v['ti'])
					return None  # это cast, а cast не выдает ошибки
				nl = prev_nl
				ti = None
			else:
				item_value = initializer['value']
				nl = initializer['nl']
				ti = initializer['ti']

			prev_nl = nl

			#info("cons record item", item_value['ti'])

			# Если это GenericRecord и тип поля тоже Generic
			# То здесь можем поменять тип на более подходящий!
			# Это тонкий лед, нужно быть осторожным!
#			if type.type_is_generic(field_type):
#				field_type = type.select_common_type(field_type, item_value['type'])
#				field['type'] = field_type

			from .cons import value_cons_implicit_check
			nv = value_cons_implicit_check(field_type, item_value)

			"""print("%s" % nv['kind'])
			print(">>>>>>>>>>>>>")
			type_print(field_type)
			print()
			type_print(item_value['type'])
			print()
			type_print(nv['type'])
			print()
			print("<<<<<<<<<<<<<")"""

			p = hlir_initializer(field['id'], nv, ti=ti, nl=nl)
			items.append(p)

	return items



def record_can(to, from_type, method):
	if not type.type_is_record(from_type):
		return False

	if type.type_is_generic(from_type):
		return True

	if method == 'implicit':
		return False

	# check if all fields in from_type present in t
	# and their types are equal (!)
	for field in from_type['fields']:
		field2 = record_field_get(to, field['id']['str'])
		if field2 == None:
			return False  # if no field with that name
		if not type.type_eq(field['type'], field2['type']):
			return False  # if field type not equal

	return True # Record to Record



def value_record_cons(t, v, method, ti):
	#info("value_record_cons", ti)
	nv = value_cons_node(t, v, method, ti=ti)

	if type.type_is_generic(v['type']):
		nv['fields'] = cons_items(t, v, method, ti)
		nv['immediate'] = True

	return nv



def value_record_eq(l, r, ti):
	fatal("value_record_eq() not implemented!", ti)
	return False # TODO!



