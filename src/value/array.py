
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



def value_array_create_from_string(t, v, method, ti=None):
	#info("value_array_create_from_string", ti)
	char_type = t['of']

	chars = utf32_chars_to_utfx_chars(v['asset'], char_type, ti)
	length = len(chars)

	# Если длина конструируемого массива
	# больше чем длина строки из которой его конструируют (в кодах символов):
	# var arr_utf8: [8]Char8 = "Hi!\n"
	if t['volume'] != None:
		t_length = t['volume']['asset']
		if t_length > length:
			length = t_length

	volume = value_integer_create(length)
	t = htype.type_array(char_type, volume, ti)

	nv = value_cons_node(t, v, method, ti)
	nv['immediate'] = True
	nv['items'] = chars
	return nv


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
		#try:
		n_from = from_type['volume']['asset']
		n_to = to['volume']['asset']

		# (нельзя неявно построить меньший массив из большего)
		return n_from <= n_to
		"""except:
			info("???", from_type['ti'])
			print(to['volume'])"""

	if method == 'implicit':
		return False

	return True



def value_array_cons(t, v, method, ti):
	#info("value_array_cons", ti)

	if htype.type_is_string(v['type']):
		return value_array_create_from_string(t, v, method, ti)

	nv = value_cons_node(t, v, method, ti)

	items = []
	if 'items' in v:
		for item in v['items']:
			from .cons import value_cons_implicit_check
			casted_item = value_cons_implicit_check(t['of'], item)
			items.append(casted_item)

	nv['items'] = items
	nv['immediate'] = value_is_immediate(v)

	if value_is_immediate(t['volume']):
		# add Zero Pad (if need)
		zero_pad = 0
		vlen = v['type']['volume']['asset']
		tlen = t['volume']['asset']
		if vlen < tlen:
			zero_pad_len = tlen - vlen
			zero_pad = [value_zero(t['of'], None)] * zero_pad_len
			nv['items'] = nv['items'] + zero_pad

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
	i = 0
	while i < len(items):
		item = items[i]
		casted_item = value_cons_implicit(to_type, item)

		if 'nl_end' in item:
			casted_item['nl_end'] = item['nl_end']

		casted_items.append(casted_item)
		i = i + 1
	return casted_items
