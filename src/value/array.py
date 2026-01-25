
from hlir import *
import type as htype
from type import type_print, select_common_type
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
			item_type = select_common_type(item_type, item.type, item.ti)
			if item_type == None or item_type.is_bad():
				error("value with unsuitable type", item.ti)
				return ValueBad({'ti': ti})
			if item.isValueRuntime():
				stage = HLIR_VALUE_STAGE_RUNTIME
			if item.isValueLinktime() and stage == HLIR_VALUE_STAGE_COMPILETIME:
				stage = HLIR_VALUE_STAGE_LINKTIME

	items = implicit_cons_list(items, item_type)

	from .num import value_number_create
	array_volume = value_number_create(length)
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
		if from_type.size == 0 and from_type.of.is_unit():
			return True

	# Check item type
	# проверяем может ли тип элемента из v
	# быть приведен к типу элемента t
	# (это обязательное требование к типу v)
	ct = select_common_type(to.of, from_type.of, ti)

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



def value_array_cons(t, v, method, ti):
	#info("value_array_cons", ti)

	if t.volume.isValueUndef():
		# for case: `[]Int32 [1, 2, 3]`
		# we try to construct array with undefined volume from array with defined volume
		# in this case we take volume of value array
		#info("undefined volume", t['ti'])
		volume = -1
		if Type.is_array(v.type):
			volume = v.type.volume
		elif Type.is_string(v.type):
			srtlen = v.type.length
			from .num import value_number_create
			volume = value_number_create(srtlen)
		else:
			assert(False)

		t.volume = volume
		t.size = t.of.size * volume.asset

	if method == 'implicit':
		n_to = t.volume.asset
		n_from = 0
		if v.type.is_string():
			# Пока Разрешаем конструировать массив из более короткой строки
			n_from = n_to #v.type.length
		else:
			n_from = v.type.volume.asset

		if n_from > 0 and n_from < n_to:
			warning("implicit cons biggest array from smaller", ti)

	nv = ValueCons(t, v, method, rawMode=False, ti=ti)
	nv.stage = v.stage

	if Type.is_string(v.type):
		char_type = t.of
		items = utf32_chars_to_utfx_char_values(v.asset, char_type, ti)
		nv.asset = items
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
			casted_item = value_cons_implicit_check(t.of, item)
			casted_item.nl = item.nl
			size += casted_item.type.size
			items.append(casted_item)
		nv.asset = items

	nv.type.size = size
	return nv


# Concat two immediate arrays
def value_array_add(l, r, ti):
	items = l.asset + r.asset
	length = len(items)
	from .num import value_number_create
	str_array_volume = value_number_create(length)
	item_type = select_common_type(l.type.of, r.type.of, ti)

	# неявно приводим все элементы к общему типу
	items = implicit_cons_list(items, item_type)

	assert(item_type != None)
	type_result = TypeArray(item_type, volume=str_array_volume, ti=ti)
	type_result.generic = True  # FIXIT!

	nv = ValueBin(type_result, HLIR_VALUE_OP_ADD, l, r, ti=ti)
	nv.asset = items
	nv.stage = HLIR_VALUE_STAGE_COMPILETIME
	return nv



# FIXIT: it is generic arrays EQ!
def value_array_eq(l, r, op, ti):
	nv = ValueBin(typeBool, op, l, r, ti=ti)
	nv.stage = HLIR_VALUE_STAGE_RUNTIME

	if l.isValueImmediate() and r.isValueImmediate():
		eq_result = True
		lvolume = l.type.volume
		rvolume = r.type.volume
		if lvolume.isValueImmediate() and rvolume.isValueImmediate():
			if lvolume.asset != rvolume.asset:
				eq_result = False
		else:
			fatal("dynamic immediate array volume not implemented", ti)

		for lx, rx in zip(l.asset, r.asset):
			from .value import value_eq
			if not value_eq(lx, rx, op, ti):
				eq_result = False
				break

		if op == HLIR_VALUE_OP_NE:
			eq_result = not eq_result

		nv.asset = int(eq_result)
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


