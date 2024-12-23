
import type as htype
import foundation
from type import type_print, select_common_type
from error import info, warning, error
from .char import utf32_chars_to_utfx_chars
from .integer import value_integer_create
from .value import value_bad, value_terminal, value_is_undefined, value_is_immediate, value_cons_node, value_zero, value_bin, value_eq, value_print


# TODO: переделай здесь все - тут все плохо...
# получает на вход список элементов
# конструирует и возвращает GenericArray value
def value_array_create(items, ti=None):
	#info("value_array_create", ti)
	length = len(items)
	if length == 0:
		item_type = foundation.typeUnit  # not Null, becase it fail
		v = _value_array_create([], item_type, 0, True, ti)
		v['immediate'] = True  #!
		return v

	# Проверяем - immediate ли этот массив?
	# если хотя бы один элемент - не immediate
	# -> весь массив - не immediate
	is_immediate = True
	for item in items:
		if not value_is_immediate(item):
			is_immediate = False

	# Получаем наиболее подходящий общий тип элементов массива
	items_type = items[0]['type']
	for item in items:
		items_type = select_common_type(items_type, item['type'])
		if htype.type_is_bad(items_type):
			error("value with unsuitable type", item['ti'])
			return value_bad({'ti': ti})

	# неявно приводим все элементы к этому типу
	casted_items = implicit_cast_list(items, items_type)
	v = _value_array_create(casted_items, items_type, length, True, ti)
	v['immediate'] = is_immediate  #TODO: need to implement 'immediate' flag
	return v


"""
def value_array_create_from_string(t, v, method, ti=None):
	#info("value_array_create_from_string", ti)
	char_type = t['of']
	chars = utf32_chars_to_utfx_chars(v['asset'], char_type, ti)

	pad_rquired = t['volume']['asset'] - len(chars)
	if pad_rquired > 0:
		chars = chars + [value_zero(char_type, ti)] * pad_rquired

	nv = value_cons_node(t, v, method, ti)
	nv['immediate'] = True
	nv['items'] = chars
	return nv"""


# TODO: see select_common_type!
def array_can(to, from_type, method):

	# String -> []CharX
	if htype.type_is_string(from_type):
		return htype.type_is_char(to['of']) or htype.type_is_word(to['of'])

	if not htype.type_is_array(from_type):
		return False

	# Check item type
	# проверяем может ли тип элемента из v
	# быть приведен к типу элемента t
	# (это обязательное требование к типу v)
	ct = select_common_type(to['of'], from_type['of'])

	if ct == None:
		return False

	if not htype.type_eq(to['of'], ct):
		return False

	if htype.type_is_generic(from_type):
		# GenericArray -> Array
		if value_is_undefined(to['volume']):
			return True

		if not value_is_immediate(to['volume']):
			return True

		# Check array length
		n_from = from_type['volume']['asset']
		n_to = to['volume']['asset']

		# (нельзя неявно построить меньший массив из большего)
		return n_from <= n_to

	if method == 'implicit':
		return False

	return True



def value_array_cons(t, v, method, ti):
	#info("value_array_cons", ti)

	if value_is_undefined(t['volume']):
		# for case: `[]Int32 [1, 2, 3]`
		# we try to construct array with undefined volume from array with defined volume
		# in this case we take volume of value array
		#info("undefined volume", t['ti'])
		volume = -1
		if htype.type_is_array(v['type']):
			volume = v['type']['volume']
		elif htype.type_is_string(v['type']):
			srtlen = v['type']['length']
			volume = value_integer_create(srtlen)
		else:
			assert(False)

		t['volume'] = volume
		t['size'] = t['of']['size'] * volume['asset']


	nv = value_cons_node(t, v, method, ti)
	nv['immediate'] = v['immediate']

	if htype.type_is_string(v['type']):
		#info("value_array_create_from_string", ti)
		char_type = t['of']
		items = utf32_chars_to_utfx_chars(v['asset'], char_type, ti)

		pad_rquired = t['volume']['asset'] - len(items)
		if pad_rquired > 0:
			items = items + [value_zero(char_type, ti)] * pad_rquired

		nv['items'] = items
		return nv

	# литерал массива всегда имеет тип Generic(Array)
	# это позволяет конструировать из него разные массивы
	# ex:
	#	var int100: Int = 100
	#	var int200: Int = 200
	#	var int300: Int = 300
	#	// immutable, non immediate value (array)
	#	// with type GenericArray(Int)
	#	let init_array = [int100, int200, int300]
	#
	#	// Create non-generic array from GenericArray
	#	var a = [100]Int init_array
	#

	if 'items' in v:
		items = []

		for item in v['items']:
			from .cons import value_cons_implicit_check
			casted_item = value_cons_implicit_check(t['of'], item)
			casted_item['nl'] = item['nl']
			items.append(casted_item)

		zero_pad = []
		if value_is_immediate(t['volume']):
			# add Zero Pad (if need)
			vlen = len(items)
			tlen = t['volume']['asset']
			zero_pad_len = tlen - vlen
			if zero_pad_len > 0:
				zero_pad = [value_zero(t['of'], ti)] * zero_pad_len

		nv['items'] = items + zero_pad

	return nv



def _value_array_create(items, item_type, length, is_generic, ti):
	array_volume = value_integer_create(length)
	array_type = htype.type_array(item_type, volume=array_volume, ti=ti)
	array_type['generic'] = is_generic
	nv = value_terminal(array_type, ti)
	nv['items'] = items
	return nv



# Складывает два массива (оба - immediate!)
def value_array_add(l, r, ti):
	items = l['items'] + r['items']
	length = len(items)
	str_array_volume = value_integer_create(length)
	item_type = select_common_type(l['type']['of'], r['type']['of'])

	# неявно приводим все элементы к общему типу
	items = implicit_cast_list(items, item_type)

	assert(item_type != None)
	type_result = htype.type_array(item_type, volume=str_array_volume, ti=ti)
	type_result['generic'] = True  # FIXIT!

	nv = value_bin('add', l, r, type_result, ti=ti)
	nv['items'] = items
	nv['immediate'] = True
	return nv



# FIXIT: it is generic arrays EQ!
def value_array_eq(l, r, op, ti):
	from foundation import typeBool
	nv = value_bin(op, l, r, typeBool, ti=ti)

	if value_is_immediate(l) and value_is_immediate(r):
		eq_result = True
		lvolume = l['type']['volume']
		rvolume = r['type']['volume']
		if value_is_immediate(lvolume) and value_is_immediate(rvolume):
			if lvolume['asset'] != rvolume['asset']:
				eq_result = False
		else:
			fatal("dynamic immediate array volume not implemented", ti)

		for lx, rx in zip(l['items'], r['items']):
			if not value_eq(lx, rx, op, ti):
				eq_result = False
				break

		if op == 'ne':
			eq_result = not eq_result

		nv['asset'] = int(eq_result)
		nv['immediate'] = True

	return nv



def implicit_cast_list(items, to_type):
	casted_items = []
	from .cons import value_cons_implicit
	for item in items:
		casted_item = value_cons_implicit(to_type, item)
		if 'nl_end' in item:
			casted_item['nl_end'] = item['nl_end']
		casted_item['nl'] = item['nl']
		casted_items.append(casted_item)
	return casted_items


