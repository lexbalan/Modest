
import hlir.type as hlir_type
import foundation
from hlir.type import select_common_type
from error import info, warning, error
from .char import utf32_chars_to_utfx_chars
from .integer import value_integer_create
from .value import value_terminal, value_is_immediate, value_cons_node, value_cons_immediate, value_zero, value_bin, value_print



# TODO: переделай здесь все - тут все плохо...
# получает на вход список элементов
# конструирует и возвращает GenericArray value
def value_array_create(items, ti=None):
	length = len(items)
	if length == 0:
		item_type = foundation.typeUnit  # not Null, becase it fail
		v = _value_array_create([], item_type, 0, True, ti)
		v['immediate'] = True  #!
		return v


	# Получаем наиболее подходящий общий тип элементов массива
	array_item_type = items[0]['type']

	is_immediate = True

	i = 0
	while i < length:
		item = items[i]

		# если хотя бы один элемент - не immediate
		# -> весь литерал массива - не immediate
		if not value_is_immediate(item):
			is_immediate = False

		item_type = item['type']
		common_type = select_common_type(array_item_type, item_type)
		if common_type == None:
			error("value with unsuitable type", item['expr_ti'])
		else:
			array_item_type = common_type
		i = i + 1

	# неявно приводим все элементы к этому типу
	casted_items = []

	from .cons import value_cons_implicit
	i = 0
	while i < length:
		item = items[i]
		casted_item = value_cons_implicit(array_item_type, item)

		if 'nl_end' in item:
			casted_item['nl_end'] = item['nl_end']

		casted_items.append(casted_item)
		i = i + 1

	v = _value_array_create(casted_items, array_item_type, length, True, ti)
	v['immediate'] = is_immediate  #TODO: need to implement 'immediate' flag
	return v



def value_array_create_from_string(t, v, method, ti=None):
	#info("value_array_create_from_string", ti)
	char_type = t['of']

	length = 0
	if t['volume'] != None:
		length = t['volume']['asset']
	else:
		length = len(v['asset'])
		volume = value_integer_create(length)
		t = hlir_type.hlir_type_array(char_type, volume, ti)

	chars = utf32_chars_to_utfx_chars(v['asset'], char_type, ti)

	"""
	v = value_terminal(t, chars, ti)
	v['immediate'] = True
	return v
	"""

	nv = value_cons_node(t, v, method, ti)
	nv['immediate'] = True
	nv['asset'] = chars
	return nv



def value_array_cons(t, v, method, ti):
	#info("value_array_cons", ti)

	#
	# Check
	#

	if hlir_type.type_is_string(v['type']):
		return value_array_create_from_string(t, v, method, ti)

	if not hlir_type.type_is_array(v['type']):
		return None  # cannot cons array value from non-array value

	# Check item type
	# проверяем может ли тип элемента из v
	# быть приведен к типу элемента t
	# (это обязательное требование к типу v)
	ct = select_common_type(t['of'], v['type']['of'])

	if ct == None:
		return None

	if not hlir_type.type_eq(t['of'], ct):
		info("unsuitable item type", ti)
		return None

	# Check array length
	n_from = v['type']['volume']['asset']
	n_to = t['volume']['asset']

	#
	# Implicit cons
	#

	if hlir_type.type_is_generic(v['type']):
		# GenericArray -> Array

		# нельзя неявно построить меньший массив из большего
		if n_from > n_to:
			info("too many items (%d, %d)" % (n_from, n_to), ti)
			return None

		#warning("value_array_cons %s" % method, ti)
		return _do_cons_array(t, v, method, ti)


	if method != 'explicit':
		info("cannot implicitly cons Array value", ti)
		return None

	#
	# Explicit cons
	#

	# Array -> Array
	return _do_cons_array(t, v, 'explicit', ti)



def _cast_values(values, to_type):
	casted_items = []
	for item in values:
		from .cons import value_cons_implicit
		casted_item = value_cons_implicit(to_type, item)

		if not hlir_type.type_eq(to_type, casted_item['type']):
			if method == 'explicit':
				error("cannot construct value", item['ti'])
				continue

		casted_item['nl'] = item['nl']
		casted_items.append(casted_item)

	return casted_items



def _do_cons_array(t, v, method, ti):
	#info("_do_cons_array", ti)

	nv = value_cons_node(t, v, method, ti)

	if value_is_immediate(v):
		#warning("_do_cons_array immediate?", ti)
		casted_items = _cast_values(v['asset'], t['of'])

		# add Zero Pad (if need)
		zero_pad = 0
		vlen = v['type']['volume']['asset']
		tlen = t['volume']['asset']
		if vlen < tlen:
			zero_pad_len = tlen - vlen
			zero_pad = [value_zero(t['of'], None)] * zero_pad_len
			casted_items = casted_items + zero_pad

		nv['asset'] = casted_items
		nv['immediate'] = True
		#if len(casted_items) == 0:

	return nv



def _value_array_create(items, item_type, length, is_generic, ti):
	array_volume = value_integer_create(length)
	array_type = hlir_type.hlir_type_array(item_type, volume=array_volume, ti=ti)
	array_type['generic'] = is_generic
	return value_terminal(array_type, items, ti)


