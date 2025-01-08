
import copy
from error import info, warning, error, fatal
import settings
from hlir.hlir import Id, Field, Value
from util import get_item_by_id, nbits_for_num, nbytes_for_bits, align_bits_up
from hlir.type import *



def type_number_for(num, signed=False, ti=None):
	required_width = align_bits_up(nbits_for_num(num))
	return TypeNumber(width=required_width, signed=signed, ti=ti)




def type_eq_integer(a, b, opt):
	return (a.width == b.width) and (a.signed == b.signed)


def type_eq_char(a, b, opt):
	return a.width == b.width


def type_eq_word(a, b, opt):
	return a.width == b.width


def type_eq_pointer(a, b, opt):
	return type_eq(a.to, b.to, opt)


def type_eq_array(a, b, opt):
	if Value.isUndefined(a.volume) or Value.isUndefined(b.volume):
		if Value.isUndefined(a.volume) and Value.isUndefined(b.volume):
			return type_eq(a.of, b.of, opt)
		return False

	# a.volume & b.volume defined

	if a.volume.isImmediate() and b.volume.isImmediate():
		if a.volume.asset != b.volume.asset:
			return False

	if a.of == None and b.of == None:
		return True

	return type_eq(a.of, b.of, opt)


def type_eq_func(a, b, opt):
	if not type_eq(a.to, b.to, opt):
		return False
	return type_eq_fields(a.params, b.params, opt)


def type_eq_fields(a, b, opt):
	if len(a) != len(b):
		return False

	for ax, bx in zip(a, b):
		if ax.id.str != bx.id.str:
			return False

		# (infinity recursion protection)
		if id(ax.type) == id(bx.type):
			return True

		if not type_eq(ax.type, bx.type, opt):
			return False

	return True


def type_eq_record(a, b, opt):
	if len(a.fields) != len(b.fields):
		return False
	return type_eq_fields(a.fields, b.fields, opt)


def type_eq_enum(a, b, opt):
	return id(a) == id(b)


def type_eq_float(a, b, opt):
	return a.width == b.width


# TODO: REMOVE IT!
def type_eq_undefined(a, b, opt):
	return id(a) == id(b)


def type_eq(a, b, opt=[]):
	if id(a) == id(b):
		return True

	if type_is_bad(a) or type_is_bad(b):
		return True

	if a.__class__.__name__ != b.__class__.__name__:
		return False

	# проверять аттрибуты (volatile, const)
	# использую для C чтобы можно было более строго проверить типы
	# напр для явного приведения в беканде C *volatile uint32_t -> uint32_t
	if 'att_checking' in opt:
		if a.att != b.att:
			return False

	# дженерик и не дженерик типы не равны
	# это важно для конструирования записей из джененрков
	# (в противном случае конструирование будет скипнуто тк они типа уже равны)
	if type_is_generic(a) != type_is_generic(b):
		return False

	# normal checking
	if isinstance(a, TypeInt): return type_eq_integer(a, b, opt)
	elif isinstance(a, TypeBool): return True
	elif isinstance(a, TypeNumber): return True
	elif isinstance(a, TypeFunc): return type_eq_func(a, b, opt)
	elif isinstance(a, TypeRecord): return type_eq_record(a, b, opt)
	elif isinstance(a, TypeArray): return type_eq_array(a, b, opt)
	elif isinstance(a, TypePointer): return type_eq_pointer(a, b, opt)
	elif isinstance(a, TypeChar): return type_eq_char(a, b, opt)
	elif isinstance(a, TypeWord): return type_eq_word(a, b, opt)
	elif isinstance(a, TypeFloat): return type_eq_float(a, b, opt)
	elif isinstance(a, TypeString): return True
	elif isinstance(a, TypeUnit): return True
	elif isinstance(a, TypeUndeifned): return type_eq_undefined(a, b, opt)
	elif isinstance(a, TypeVaList): return True
	#elif k == 'enum': return type_eq_enum(a, b, opt)
	assert(False)
	return False



def type_is_bad(t):
	return isinstance(t, TypeBad)


def type_is_undefined(t):
	return isinstance(t, TypeUndefined)


def type_is_defined(t):
	return not type_is_undefined(t)


def type_is_incomplete(t):
	return 'incomplete' in t.att


def type_is_unit(t):
	return isinstance(t, TypeUnit)


def type_is_bool(t):
	return isinstance(t, TypeBool)


def type_is_string(t):
	return isinstance(t, TypeString)


def type_is_number(t):
	return isinstance(t, TypeNumber)


def type_is_record(t):
	return isinstance(t, TypeRecord)


def type_is_array(t):
	return isinstance(t, TypeArray)


def type_is_word(t):
	return isinstance(t, TypeWord)


def type_is_integer(t):
	return isinstance(t, TypeInt)


def type_is_float(t):
	return isinstance(t, TypeFloat)


def type_is_char(t):
	return isinstance(t, TypeChar)


# numeric type supports arithmetical operations
def type_is_numeric(t):
	return isinstance(t, TypeInt) or isinstance(t, TypeNumber) or isinstance(t, TypeFloat)


def type_is_func(t):
	return isinstance(t, TypeFunc)




# VLA - variable langth array
def type_is_vla(t):
	if not type_is_array(t):
		return False

	if Value.isUndefined(t.volume):
		return False

	return not t.volume.isImmediate()


def type_is_composite(t):
	return type_is_array(t) or type_is_record(t)


def type_is_pointer(t):
	return isinstance(t, TypePointer)


def type_is_va_list(t):
	return isinstance(t, TypeVaList)


def type_is_generic(t):
	return t.generic


def type_is_generic_char(t):
	return type_is_char(t) and type_is_generic(t)


def type_is_generic_record(t):
	return type_is_record(t) and type_is_generic(t)


def type_is_generic_array(t):
	return type_is_array(t) and type_is_generic(t)


def type_is_generic_array_of_char(t):
	if type_is_generic_array(t):
		if t.of != None: # in case of empty array field #of can be None
			return type_is_char(t.of)

	return False



def type_is_closed_array(t):
	if type_is_array(t):
		return t.volume != None
	return False


def type_is_open_array(t):
	if type_is_array(t):
		return Value.isUndefined(t.volume)
	return False


def type_is_array_of_char(t):
	if type_is_array(t):
		return type_is_char(t.of)
	return False


def type_is_generic_pointer(t):
	if type_is_generic(t):
		return type_is_pointer(t)
	return False


def type_is_free_pointer(t):
	if type_is_pointer(t):
		return type_is_unit(t.to)
	return False


def type_is_pointer_to_record(t):
	if type_is_pointer(t):
		return type_is_record(t.to)
	return False


def type_is_pointer_to_array(t):
	if type_is_pointer(t):
		return type_is_array(t.to)
	return False


def type_is_pointer_to_array_of_char(t):
	if type_is_pointer(t):
		return type_is_array_of_char(t.to)
	return False


def type_is_pointer_to_func(t):
	if type_is_pointer(t):
		return type_is_func(t.to)
	return False


def type_is_pointer_to_open_array(t):
	if type_is_pointer(t):
		return type_is_open_array(t.to)
	return False


def type_is_pointer_to_closed_array(t):
	if type_is_pointer(t):
		return type_is_closed_array(t.to)
	return False


def type_is_signed(t):
	return t.signed == True


def type_is_unsigned(t):
	return t.signed == False







# cannot create variable with type
def type_is_forbidden_var(t, zero_array_forbidden=True):
	if type_is_undefined(t) or type_is_unit(t) or type_is_func(t):
		return True

	if type_is_array(t):
		# [_]<Forbidden>
		if type_is_forbidden_var(t.of):
			return True

		# []Int
		if type_is_open_array(t):
			return True

		# [0]Int
		from trans import is_unsafe_mode
		if zero_array_forbidden or not is_unsafe_mode():
			if t.volume.isImmediate():
				if t.volume.asset == 0:
					return True

		return type_is_forbidden_var(t.of)

	return False



# ищем поле с таким id в типе record
def record_field_get(t, id):
	return get_item_by_id(t.fields, id)



def print_list_by(lst, method):
	i = 0
	while i < len(lst):
		if i > 0:
			print(", ")
		method(lst[i])
		i = i + 1
	return



def type_print_record(t, print_aka=True):
	if type_is_generic_record(t):
		print("Record{...}", end='')
		return

#			for f in t.fields:
#				print("\t%s: " % f.id.str, end='')
#				type_print(f.type)
#				print()
#			print("}")
#			return

	print("record {")
	fields = t.fields
	i = 0
	while i < len(fields):
		field = fields[i]
		if i > 0:
			print(',')
		print("\n\t");
		field_print(field)

		i = i + 1
	print("\n}")



def type_print_array(t, print_aka=True):
	if t.of == None:
		print("EmptyArray", end='')
		if t.generic:
			print(")", end='')
		return

	print("[", end='')
	array_size = t.volume

	if not Value.isUndefined(array_size):
		if type_is_vla(t):
			print("<VAR>", end='')
		else:
			sz = array_size.asset
			print("%d" % sz, end='')

	print("]", end='')
	type_print(t.of)



def field_print(f):
	print("%s: " % f.id.str, end='')
	type_print(f.type)


def type_print_func(t, print_aka=True):
	print("(", end='')
	print_list_by(t.params, lambda f: field_print(f))
	print(")", end='')
	print(" -> ", end='')
	type_print(t.to)


def type_print(t, print_aka=True):
	assert isinstance(t, Type)

	if 'volatile' in t.att:
		print("volatile_", end='')
	if 'const' in t.att:
		print("const_", end='')

	if t.generic:
		print("Generic(", end='')


	if print_aka:
		pass
		#print(" (%s is alias of %s)" % (id1, id2), end='')


	if type_is_record(t):
		type_print_record(t, print_aka)

	elif type_is_bool(t):
		print("Bool", end='')

	elif type_is_char(t):
		print(t.id.str, end='')

#	elif type_is_enum(t):
#		if t.id != None:
#			print(t.id, end='')
#		print("enum_%s" % str(id(t)), end='')

	elif type_is_pointer(t):
		print("*", end=''); type_print(t.to)

	elif type_is_array(t):
		type_print_array(t, print_aka)

	elif type_is_func(t):
		type_print_func(t, print_aka)

	elif type_is_word(t):
		print(t.id.str, end='')

	elif type_is_integer(t):
		print(t.id.str, end='')

	elif type_is_float(t):
		print(t.id.str, end='')

	elif type_is_string(t):
		print("String", end='')

	elif type_is_undefined(t):
		print('undefined', end='')

	elif type_is_unit(t):
		print('Unit', end='')

	else:
		print("<type:%s>" % k, end='')

	if t.generic:
		print(")", end='')




# получает на вход два типа GenericRecord
# и создает третий тип который является общим для двух входных
# (тк в случае записей ни один из двух может не подходить как общий)
def select_common_record_type(a, b):
	#print("select_common_record_type")
	if len(a.fields) != len(b.fields):
		return None

	fields = []
	for fieldA, fieldB in zip(a.fields, b.fields):
		if fieldA.id.str != fieldB.id.str:
			return None

		fieldId = fieldA.id
		fieldType = select_common_type(fieldA.type, fieldB.type)
		newField = Field(fieldId, fieldType, ti=fieldId.ti)
		fields.append(newField)

	newRecord =TypeRecord(fields, ti=a.ti)
	newRecord.generic = True
	return newRecord



# выбирает общий тип для двух входных
# CAN RETURN NONE!
def select_common_type(a, b):

	if type_eq(a, b):
		return a

	if a.__class__.__name__ == b.__class__.__name__:
		if type_is_generic(a) and type_is_generic(b):
			if type_is_record(a):
				return select_common_record_type(a, b)
			elif type_is_array(a):
				# TODO: тут все плохо (тк должна быть рекурсия но пока без нее)
				if type_is_generic(a.of):
					return b
				if type_is_generic(b.of):
					return a

				# not implemented!
				return a

			else:
				if a.width > b.width:
					return a
				else:
					return b

		elif type_is_generic(a) or type_is_generic(b):
			if type_is_string(a):
				if type_is_string(b):
					if a.char_width > b.char_width:
						return a
					else:
						return b

			if type_is_generic(a):
				return b

			if type_is_generic(b):
				return a

		else:
			return TypeBad(None)


	if a.__class__.__name__ != b.__class__.__name__:
		# вид типа обычно должен совпадать
		# но есть и исключения

		# c == "A"
		if type_is_char(a):
			if type_is_string(b):
				return a

		# "A" == c
		if type_is_char(b):
			if type_is_string(a):
				return b


		if type_is_word(a):
			if type_is_integer(b) and b.generic:
				return a


		if type_is_word(b):
			if type_is_integer(a) and a.generic:
				return b

		# array && string | string && array
		if type_is_array(a):
			if type_is_string(b):
				return a

		if type_is_array(b):
			if type_is_string(a):
				return b


		if type_is_unit(a):
			return b

		if type_is_unit(b):
			return a

		if type_is_bad(a):
			return b

		if type_is_bad(b):
			return a

		if type_is_float(a):
			if type_is_integer(b):
				return a

		if type_is_float(b):
			if type_is_integer(a):
				return b

		if type_is_number(a):
			if type_is_integer(b) or type_is_word(b) or type_is_float(b):
				return b

		if type_is_integer(a) or type_is_word(a) or type_is_float(a):
			if type_is_number(b):
				return a

	print("select_common_type(%s %s) not implenemted" % (a.__class__.__name__, b.__class__.__name__))
	return TypeBad(None)


