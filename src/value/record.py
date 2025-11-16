
from hlir import *
from error import info, warning, error
import type as type
from type import type_print, record_field_get


# получает на вход список инициализаторов
# конструирует и возвращает GenericRecord value
def value_record_create(initializers, ti):
	#info("value_record_create()", ti)

	stage = HLIR_VALUE_STAGE_COMPILETIME

	# сперва пройдемся по инициализаторам
	# и выясним какие поля у нас здесь имеются
	# (для того чтобы сконструировать тип записи)
	type_fields = []
	for initializer in initializers:
		field_id = initializer.id
		init_value = initializer.value
		field_type = init_value.type
		field_ti = init_value.ti

		# если хотя бы один элемент - не immediate
		# -> весь литерал записи - не immediate
		if init_value.isValueRuntime():
			stage = HLIR_VALUE_STAGE_RUNTIME

		if init_value.isValueLinktime() and stage == HLIR_VALUE_STAGE_COMPILETIME:
			stage = HLIR_VALUE_STAGE_LINKTIME

		# создаем поле для типа generic record
		field = Field(field_id, field_type, init_value=ValueUndef(field_type), ti=field_ti)
		type_fields.append(field)

	record_type = TypeRecord(type_fields, ti)
	record_type.generic = True
	nv = ValueRecord(record_type, initializers=initializers, ti=ti)
	nv.stage = stage
	return nv



def record_can(to, from_type, method, ti):
	if not from_type.is_record():
		return False

	if from_type.is_generic():
		return True

	if method == 'implicit':
		return False

	# explicit cons record from another record

	# check if all fields in from_type present in t
	# and their types are equal (!)
	for field in from_type.fields:
		field2 = record_field_get(to, field.id.str)
		if field2 == None:
			return False  # if no field with that name
		if not Type.eq(field.type, field2.type):
			return False  # if field type not equal

	return True  # Record to Record



def value_record_cons(t, v, method, ti):
	#info("value_record_cons", ti)
	nv = ValueCons(t, v, method, rawMode=False, ti=ti)
	nv.stage = v.stage

	# литерал записи всегда имеет тип Generic(Array)
	# это позволяет конструировать из него разные записи

	if v.asset != None:
		# конструируем запись на основе другой generic записи
		items = []
		for field in t.fields:
			explicit_initializer = get_item_by_id(v.asset, field.id.str)

			iv = None
			if explicit_initializer:
				iv = explicit_initializer.value
			#elif field.init_value != None:
			#	iv = field.init_value
			else:
				iv = create_zero_literal(field.type, ti=ti)

			from .cons import value_cons_implicit_check
			iv = value_cons_implicit_check(field.type, iv)
			ni = Initializer(field.id, iv, ti=ti)
			items.append(ni)

		nv.asset = items

	return nv



def value_record_eq(l, r, op, ti):
	#info("value_record_eq()", ti)
	nv = ValueBin(typeBool, op, l, r, ti=ti)
	nv.stage = HLIR_VALUE_STAGE_RUNTIME

	if l.isValueImmediate() and r.isValueImmediate():
		eq_result = True

		for lx, rx in zip(l.asset, r.asset):
			from .value import value_eq
			if not value_eq(lx.value, rx.value, op, ti):
				eq_result = False
				break

		if op == HLIR_VALUE_OP_NE:
			eq_result = not eq_result

		nv.asset = int(eq_result)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME

	return nv



