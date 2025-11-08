
import copy

from hlir import *
from error import info, warning, error, fatal
from util import nbytes_for_bits, align_bits_up




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
	if t.is_generic_record():
		print("GenericRecord{...}", end='')
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

	if not array_size.isValueUndef():
		if t.is_vla():

			print("%s" % str(array_size), end='')
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
	from backend.cm import str_type
	print(str_type(t), end='')
	return

	#if t.generic:
	#	print(")", end='')

	"""
	if t.hasAttribute2('volatile'):
		print("volatile_", end='')
	if t.hasAttribute2('const'):
		print("const_", end='')

	if t.generic:
		print("Generic(", end='')


	if print_aka:
		pass
		#print(" (%s is alias of %s)" % (id1, id2), end='')


	if t.is_record():
		type_print_record(t, print_aka)

	elif t.is_bool():
		print("Bool", end='')

	elif t.is_number():
		print("Number", end='')

	elif t.is_char():
		print(t.id.str, end='')

#	elif t.is_enum():
#		if t.id != None:
#			print(t.id, end='')
#		print("enum_%s" % str(id(t)), end='')

	elif t.is_nil():
		print("Nil")

	elif t.is_pointer():
		print("*", end=''); type_print(t.to)

	elif t.is_array():
		type_print_array(t, print_aka)

	elif t.is_func():
		type_print_func(t, print_aka)

	elif t.is_word():
		print(t.id.str, end='')

	elif t.is_int() or t.is_nat():
		print(t.id.str, end='')

	elif t.is_float():
		print(t.id.str, end='')

	elif t.is_string():
		print("String(len=%d)" % t.length, end='')

	elif t.is_incompleted():
		print('undefined', end='')

	elif t.is_unit():
		print('Unit', end='')

	else:
		print(str(t), end='')

	if t.generic:
		print(")", end='')
	"""



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
		newField = Field(fieldId, fieldType, init_value=ValueUndef(fieldType), ti=fieldId.ti)
		fields.append(newField)

	newRecord =TypeRecord(fields, ti=a.ti)
	newRecord.generic = True
	return newRecord



# выбирает общий тип для двух входных
# CAN RETURN NONE!
def select_common_type(a, b, ti=None):

	if Type.eq(a, b):
		return a

	if a.__class__.__name__ == b.__class__.__name__:
		if a.is_generic() and b.is_generic():
			if a.is_record():
				return select_common_record_type(a, b)
			elif a.is_array():
				# TODO: тут все плохо (тк должна быть рекурсия но пока без нее)
				if a.of.is_generic():
					return b
				if b.of.is_generic():
					return a

				# not implemented!
				return a

			else:
				if a.width > b.width:
					return a
				else:
					return b

		elif a.is_generic() or b.is_generic():
			if a.is_string():
				if b.is_string():
					if a.char_width > b.char_width:
						return a
					else:
						return b

			if a.is_generic():
				return b

			if b.is_generic():
				return a

		else:
			return None


	if a.__class__.__name__ != b.__class__.__name__:
		# вид типа обычно должен совпадать
		# но есть и исключения

		# c == "A"
		if a.is_char():
			if b.is_string():
				return a

		# "A" == c
		if b.is_char():
			if a.is_string():
				return b

		if a.is_word():
			if b.is_arithmetical() and b.generic:
				return a


		if b.is_word():
			if a.is_arithmetical() and a.generic:
				return b

		# array && string | string && array
		if a.is_array():
			if b.is_string():
				return a

		if b.is_array():
			if a.is_string():
				return b


		# array && string | string && array
		if a.is_pointer():
			if b.is_string():
				return a

		if b.is_pointer():
			if a.is_string():
				return b


		if a.is_unit():
			return b

		if b.is_unit():
			return a

		if a.is_bad():
			return b

		if b.is_bad():
			return a

		if a.is_float():
			if b.is_arithmetical():
				return a

		if b.is_float():
			if a.is_arithmetical():
				return b

		if a.is_number():
			if b.is_arithmetical() or b.is_word() or b.is_float():
				return b

		if a.is_arithmetical() or a.is_word() or a.is_float():
			if b.is_number():
				return a

	print("select_common_type(%s %s) not implenemted" % (a.__class__.__name__, b.__class__.__name__))
	return None


