
from hlir import *
from error import info, warning, error



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
	if to.is_unit():
		return (from_type.is_unit()) or method != 'implicit'

	if not from_type.is_record():
		return False

	# Record can be constructed only from generic record
	if not from_type.is_generic():
		return False

	# check if all fields present in t
	# and their types are correct
	for field_src in from_type.fields:
		field_dst = TypeRecord.record_field_get(to, field_src.id.str)
		if field_dst == None:
			return False  # No field with that name

		from value.cons import cons_can
		if not cons_can(field_dst.type, field_src.type, method=method, ti=field_src.ti):
			return False  # Field type not equal

	return True



def value_record_cons(t, v, method, ti):
	#info("value_record_cons", ti)
	nv = ValueCons(t, v, method, ti=ti)
	nv.stage = v.stage

	if t.is_unit():
		nv.asset = []
		stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	if not v.type.is_generic(): #and not v.isValueImmediate():
		if t.uid != v.type.uid:
			# Если это реально разные типы-записи то да нужен будет raw cast (по крайней мере в C)
			from trans import cmodule_use
			cmodule_use('use_raw_cast')

	# литерал записи всегда имеет тип Generic(Array)
	# это позволяет конструировать из него разные записи

	if v.asset != None:
		# конструируем запись на основе другой generic записи
		items = []
		for field in t.fields:
			nl = 1
			explicit_initializer = get_item_by_id(v.asset, field.id.str)

			iv = None
			if explicit_initializer != None:
				iv = explicit_initializer.value
				nl = explicit_initializer.nl
			elif field.init_value != None:
				iv = field.init_value
			else:
				iv = create_zero_literal(field.type, ti=ti)

			from .cons import value_cons_implicit_check
			iv = value_cons_implicit_check(field.type, iv)
			ni = Initializer(field.id, iv, ti=ti)
			#info(field.id.c, ti)
			ni.nl = nl
			items.append(ni)

		nv.set_asset(items)

	return nv



