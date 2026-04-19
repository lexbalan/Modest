
from hlir import *
from error import info, warning, error
from .char import utf32_chars_to_utfx_char_values



def value_array_create(items, ti):
	#info("value_array_create()", ti)

	length = len(items)
	item_type = typeUnit
	stage = HLIR_VALUE_STAGE_COMPILETIME
	if length > 0:
		# Получаем наиболее подходящий общий тип элементов массива
		item_type = items[0].type
		for item in items:
			item_type = Type.select_common_type(item_type, item.type, item.ti)
			if item_type == None or item_type.is_bad():
				error("value with unsuitable type", item.ti)
				return ValueBad({'ti': ti})
			if item.isValueRuntime():
				stage = HLIR_VALUE_STAGE_RUNTIME
			if item.isValueLinktime() and stage == HLIR_VALUE_STAGE_COMPILETIME:
				stage = HLIR_VALUE_STAGE_LINKTIME

	items = implicit_cons_list(items, item_type)

	from .integer import value_integer_create
	array_volume = value_integer_create(length)
	array_type = TypeArray(item_type, volume=array_volume, ti=ti)
	array_type.generic = True
	nv = ValueArray(array_type, items, ti)
	nv.stage = stage
	return nv


# TODO: see select_common_type!
def array_can(to, from_type, method, ti):
	# String -> []CharX
	if from_type.is_string():
		return to.of.is_char() or to.of.is_word()

	if not from_type.is_array():
		return False

	if not from_type.is_generic():
		return False

	if from_type.is_generic():
		# from an empty array literal `[]`
		if from_type.get_size() == 0 and from_type.of.is_unit():
			return True

	# Check item type
	# проверяем может ли тип элемента из v
	# быть приведен к типу элемента t
	# (это обязательное требование к типу v)
	ct = Type.select_common_type(to.of, from_type.of, ti)

	if ct == None:
		return False

	if not Type.eq(to.of, ct):
		return False

	if from_type.is_generic():
		# GenericArray -> Array
		if to.volume.isValueUndef():
			return True

		if not to.volume.isValueImmediate():
			return True

		# Check array length
		n_from = from_type.volume.asset
		n_to = to.volume.asset

		# (нельзя неявно построить меньший массив из большего)
		return n_from <= n_to

	if method == 'implicit':
		return False

	return True



def get_last_array_in_chain(t):
	if t.of.is_array():
		return get_last_array_in_chain(t.of)
	return t



# type   : [2][ ][ ][3]Int32
# v.type : [2][2][2][3]Integer
# result : [2][2][2][3]Int32


def is_holed(t):
	if t.is_array():
		if t.is_open_array():
			return True
		return is_holed(t.of)
	return False


def resolve(t1, t2):
	if t1.is_array():

		if t2.is_string():
			from .integer import value_integer_create
			volume = value_integer_create(t2.length)
			t2 = TypeArray(t1.of, volume=volume, ti=None)

		nt = t1
		if t1.is_open_array():
			nt = t2.copy()
			nt.generic = False
		nt.of = resolve(t1.of, t2.of)
		return nt
	return t1


def value_array_cons(t, v, method, ti):
	result_type = t


	if is_holed(t):
		result_type = resolve(t, v.type)
		#warning("holed, RT = %s" % result_type.to_str(), ti)


	# if t.hasAttribute('zarray'):
	# 	# конструируем zarray а это значит что он должен быть на 1 длиннее
	# 	from trans import do_value_bin_op
	# 	result_type.volume = do_value_bin_op(HLIR_VALUE_OP_ADD, result_type.volume, value_integer_create(1, ti=ti), ti)


	if method == 'implicit':
		n_to = result_type.volume.asset
		n_from = 0
		if v.type.is_string():
			# Пока Разрешаем конструировать массив из более короткой строки
			n_from = n_to #v.type.length
		else:
			n_from = v.type.volume.asset

		if n_from > 0 and n_from < n_to:
			pass
			#warning("implicit cons biggest array from smaller", ti)

	nv = ValueCons(result_type, t, v, method, ti=ti)
	nv.stage = v.stage

	if v.type.is_string():
		char_type = result_type.of
		items = utf32_chars_to_utfx_char_values(v.asset, char_type, ti)
		nv.set_asset(items)
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

	size = 0
	if v.isValueImmediate():
		items = []
		for item in v.asset:
			from .cons import value_cons_implicit_check
			casted_item = value_cons_implicit_check(result_type.of, item)
			casted_item.nl = item.nl
			size += casted_item.type.get_size()
			items.append(casted_item)
		nv.set_asset(items)

	nv.type.size = size
	return nv


# Concat two immediate arrays
def value_array_concat(l, r, ti):
	items = l.asset + r.asset
	length = len(items)
	from .integer import value_integer_create
	str_array_volume = value_integer_create(length)
	item_type = Type.select_common_type(l.type.of, r.type.of, ti)

	# неявно приводим все элементы к общему типу
	items = implicit_cons_list(items, item_type)

	assert(item_type != None)
	type_result = TypeArray(item_type, volume=str_array_volume, ti=ti)
	type_result.generic = True  # FIXIT!

	nv = ValueBin(type_result, HLIR_VALUE_OP_ADD, l, r, ti=ti)
	nv.set_asset(items)
	nv.stage = HLIR_VALUE_STAGE_COMPILETIME
	return nv



def implicit_cons_list(items, to_type):
	new_items = []
	from .cons import value_cons_implicit
	for item in items:
		new_item = value_cons_implicit(to_type, item)
		new_item.nl = item.nl
		new_items.append(new_item)
	return new_items


