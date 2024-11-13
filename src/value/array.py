
import hlir.type as hlir_type
import foundation
from hlir.type import type_print, select_common_type
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


	# Проверяем - immediate ли этот массив?
	# если хотя бы один элемент - не immediate
	# -> весь массив - не immediate
	is_immediate = True
	for item in items:
		if not value_is_immediate(item):
			is_immediate = False

	# Получаем наиболее подходящий общий тип элементов массива
	array_item_type = select_common_type_for_list(items)

	from .cons import implicit_cast_list
	# неявно приводим все элементы к этому типу
	casted_items = implicit_cast_list(items, array_item_type)

	v = _value_array_create(casted_items, array_item_type, length, True, ti)
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
	t = hlir_type.hlir_type_array(char_type, volume, ti)

	nv = value_cons_node(t, v, method, ti)
	nv['immediate'] = True
	nv['items'] = chars
	return nv


# TODO: see select_common_type!
def array_can(to, from_type, method):

	# String -> []CharX
	if hlir_type.type_is_string(from_type):
		return hlir_type.type_is_char(to['of']) or hlir_type.type_is_word(to['of'])

	if not hlir_type.type_is_array(from_type):
		return False

	# Check item type
	# проверяем может ли тип элемента из v
	# быть приведен к типу элемента t
	# (это обязательное требование к типу v)
	ct = select_common_type(to['of'], from_type['of'])

	if ct == None:
		return False

	if not hlir_type.type_eq(to['of'], ct):
		info("unsuitable item type", from_type['ti'])
		return False

	if hlir_type.type_is_generic(from_type):
		# GenericArray -> Array
		if to['volume'] == None:
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


def cons_items(items, to_type):
	casted_items = []
	for item in items:
		from .cons import value_cons_implicit
		from .cons import value_cons_implicit_check
		casted_item = value_cons_implicit_check(to_type, item)
		casted_items.append(casted_item)

	return casted_items


def value_array_cons(t, v, method, ti):
	#info("value_array_cons", ti)

	if hlir_type.type_is_string(v['type']):
		return value_array_create_from_string(t, v, method, ti)

	nv = value_cons_node(t, v, method, ti)

	#for valItem in v['items']:
	#	info("ITEM", valItem['ti'])

	#if value_is_immediate(v):
	nv['items'] = []
	if 'items' in v:
		nv['items'] = cons_items(v['items'], t['of'])
	nv['immediate'] = value_is_immediate(v)

	if not value_is_immediate(v):
		error("NOT IMMEDIATE", v['ti'])

		for item in v['items']:
			print(" k = %s" % item['kind'])
			print("-item: %d" % value_is_immediate(item))


	#if t['volume'] == None:
	#	return nv
	#nv['items'] = casted_items

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
	array_type = hlir_type.hlir_type_array(item_type, volume=array_volume, ti=ti)
	array_type['generic'] = is_generic
	nv = value_terminal(array_type, items, ti)
	nv['items'] = items
	return nv








def select_common_type_for_list(items):
	array_item_type = items[0]['type']
	i = 0
	while i < len(items):
		item = items[i]

		item_type = item['type']
		common_type = select_common_type(array_item_type, item_type)
		if common_type == None:
			error("value with unsuitable type", item['ti'])
		else:
			array_item_type = common_type
		i = i + 1

	return common_type




"""def rectification(items):
	# Получаем наиболее подходящий общий тип элементов массива
	array_item_type = select_common_type_for_list(items)

	# неявно приводим все элементы к этому типу
	casted_items = implicit_cast_list(items, array_item_type)

	return casted_items"""

