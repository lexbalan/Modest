
import hlir.type as hlir_type
import foundation
from hlir.type import select_common_type
from error import info, error
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

		if is_immediate:
			is_immediate = value_is_immediate(item)

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

		if 'asset' in item:
			casted_item['asset'] = item['asset']

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
	length = t['volume']['asset']
	assert(length != None)

	chars = utf32_chars_to_utfx_chars(v['asset'], char_type, ti)
	v = value_terminal(t, chars, ti)
	v['immediate'] = True
	return v



# concatenation of two immediate arrays
def value_array_concat(l, r, ti):
	#info("value_array_concat", ti)
	asset = l['asset'] + r['asset']
	length = len(asset)

	str_array_volume = value_integer_create(length)
	item_type = select_common_type(l['type']['of'], r['type']['of'])
	assert(item_type != None)
	t = hlir_type.hlir_type_array(item_type, volume=str_array_volume, ti=ti)
	t['generic'] = True

	nv = value_bin('concat_array', l, r, t, ti=ti)
	nv['asset'] = asset
	nv['immediate'] = True
	nv['nl_end'] = r['nl_end']
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
	# нельзя построить меньший массив из большего
	n_from = v['type']['volume']['asset']
	n_to = t['volume']['asset']
	if n_from > n_to:
		info("too many items (%d, %d)" % (vvol, tvol), v['ti'])
		return None

	#
	# Implicit cons
	#

	if hlir_type.type_is_generic(v['type']):
		# GenericArray -> Array
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

	if hlir_type.type_is_generic(v['type']):
		nv = value_terminal(t, v['asset'], ti)
		nv['nl_end'] = v['nl_end'] # 'nl_end' present only in generic values
	else:
		nv = value_cons_node(t, v, method, ti)

	if value_is_immediate(v):
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

	if 'id' in v:
		nv['id'] = v['id']

	return nv



def _value_array_create(items, item_type, length, is_generic, ti):
	array_volume = value_integer_create(length)
	array_type = hlir_type.hlir_type_array(item_type, volume=array_volume, ti=ti)
	array_type['generic'] = is_generic
	return value_terminal(array_type, items, ti)


