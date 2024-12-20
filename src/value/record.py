
from error import info, warning, error
import type as type
from hlir.hlir import *
from hlir.field import hlir_field
from type import type_print, record_field_get
from util import get_item_with_id
from .value import value_terminal, value_cons_node, value_zero, value_is_immediate, value_print, value_cons_immediate, value_bin, value_eq


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

	record_type = type.type_record(fields, ti)
	record_type['generic'] = True

	v = value_terminal(record_type, ti)
	v['fields'] = initializers
	v['immediate'] = is_immediate
	return v



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
	nv['immediate'] = v['immediate']

	if 'fields' in v:
		# конструируем запись на основе другой generic записи
		fields = []
		for field in t['fields']:
			initializer = get_item_with_id(v['fields'], field['id']['str'])
			vv = None
			if initializer:
				from .cons import value_cons_implicit_check
				vv = value_cons_implicit_check(field['type'], initializer['value'])
			else:
				# Если инициализатора для поля нет, создадим zero-инициализатор
				vv = value_zero(field['type'], ti)
			initializer = hlir_initializer(field['id'], vv, ti=ti, nl=0)
			fields.append(initializer)

		nv['fields'] = fields

	return nv



def value_record_eq(l, r, op, ti):
	#info("value_record_eq()", ti)
	from foundation import typeBool
	nv = value_bin(op, l, r, typeBool, ti=ti)
	if value_is_immediate(l) and value_is_immediate(r):
		eq_result = True

		for lx, rx in zip(l['fields'], r['fields']):
			if not value_eq(lx['value'], rx['value'], op, ti):
				eq_result = False
				break

		if op == 'ne':
			eq_result = not eq_result

		nv['asset'] = int(eq_result)
		nv['immediate'] = True

	return nv



