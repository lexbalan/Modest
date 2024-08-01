
import copy
from error import info, warning, error, fatal
import settings
from hlir.field import hlir_field


ptr_width = 0
flt_width = 0

def hlir_type_init():
	global ptr_width, flt_width
	ptr_width = int(settings.get('pointer_width'))
	flt_width = int(settings.get('float_width'))


from .id import hlir_id
from util import get_item_with_id, nbits_for_num, nbytes_for_bits


######################################################################
#							HLIR TYPE							   #
######################################################################


CONS_OP = ['cons']
EQ_OPS = ['eq', 'ne']
RELATIONAL_OPS = ['lt', 'gt', 'le', 'ge']
ARITHMETICAL_OPS = ['add', 'sub', 'mul', 'div', 'rem', 'negative']
LOGICAL_OPS = ['or', 'xor', 'and', 'not']

INT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS + LOGICAL_OPS
FLOAT_OPS = CONS_OP + EQ_OPS + RELATIONAL_OPS + ARITHMETICAL_OPS
BOOL_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
BYTE_OPS = CONS_OP + EQ_OPS + LOGICAL_OPS
CHAR_OPS = CONS_OP + EQ_OPS
ENUM_OPS = CONS_OP + EQ_OPS
PTR_OPS = CONS_OP + EQ_OPS + ['deref']
ARR_OPS = CONS_OP + EQ_OPS + ['add', 'index']
REC_OPS = CONS_OP + EQ_OPS + ['access']
STR_OPS = CONS_OP + EQ_OPS + ['add']

def hlir_type_bad(x):
	return {
		'isa': 'type',
		'kind': 'bad',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 1,
		'ast_type': x,
		'ops': [],
		'att': [],
		'ti': x['ti']
	}


uid = 0
def hlir_type_undefined(x):
	global uid
	uid = uid + 1
	return {
		'isa': 'type',
		'kind': 'undefined',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 1,
		'ast_type': x,
		'uid': uid,
		'ops': [],
		'att': [],
		'ti': x['ti']
	}


def hlir_type_unit():
	return {
		'isa': 'type',
		'kind': 'unit',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 0,
		'aka': 'Unit',
		'c_alias': 'void',
		'llvm_alias': 'void',
		'ops': CONS_OP,
		'att': [],
		'ti': None
	}


def hlir_type_bool():
	return {
		'isa': 'type',
		'kind': 'bool',
		'generic': False,
		'width': 1,
		'size': 1,
		'align': 1,
		'aka': 'Bool',
		'c_alias': 'bool',
		'llvm_alias': 'i1',
		'ops': BOOL_OPS,
		'att': [],
		'ti': None
	}



def hlir_type_char(width, ti=None):
	size = nbytes_for_bits(width)

	calias = 'char'
	if width > 8:
		calias = 'uint%d_t' % width
	return {
		'isa': 'type',
		'kind': 'char',
		'generic': False,
		'width': width,
		'size': size,
		'align': size,
		'aka': 'Char%d' % width,
		'c_alias': calias,
		'llvm_alias': 'i%d' % width,
		'ops': CHAR_OPS,
		'att': [],
		'ti': ti
	}


def hlir_type_integer(width, signed=True, ti=None):
	size = nbytes_for_bits(width)

	aka = None
	calias = None
	if signed:
		aka = 'Int%d' % width

		if width == 128:
			calias = '__int128'
		else:
			calias = 'int%d_t' % width
	else:
		aka = 'Nat%d' % width
		if width == 128:
			calias = 'unsigned __int128'
		else:
			calias = 'uint%d_t' % width

	return {
		'isa': 'type',
		'kind': 'int',
		'generic': False,
		'width': width,
		'size': size,
		'align': size,
		'signed': signed,
		'aka': aka,
		'c_alias': calias,
		'llvm_alias': 'i%d' % width,
		'ops': INT_OPS,
		'att': [],
		'ti': ti
	}


def hlir_type_float(width, ti=None):
	size = nbytes_for_bits(width)

	aka = 'Float%d' % width
	calias = 'float'
	if width > 32:
		calias = 'double'

	return {
		'isa': 'type',
		'kind': 'float',
		'generic': False,
		'width': width,
		'size': size,
		'align': size,
		'signed': True,
		'aka': 'Float32',
		'c_alias': calias,
		'llvm_alias': calias,
		'ops': FLOAT_OPS,
		'att': [],
		'ti': ti
	}


def hlir_type_pointer(to, ti=None):
	size = nbytes_for_bits(ptr_width)
	return {
		'isa': 'type',
		'kind': 'pointer',
		'generic': False,
		'width': ptr_width,
		'size': size,
		'align': size,
		'to': to,
		'ops': PTR_OPS,
		'att': [],
		'ti': ti
	}


# size - always hlir_value (!)
def hlir_type_array(of, volume=None, ti=None):
	item_size = 0
	item_align = 0
	if of != None:
		item_size = type_get_size(of)
		item_align = type_get_align(of)

	array_size = 0
	if volume != None:
		from value.value import value_is_immediate
		if value_is_immediate(volume):
			array_size = item_size * volume['asset']

	return {
		'isa': 'type',
		'kind': 'array',
		'generic': False,
		'width': 0, #'width': array_size * 8,
		'size': array_size,
		'align': item_align,
		'of': of,
		'volume': volume,
		'ops': ARR_OPS,
		'att': [],
		'ti': ti
	}


enum_uid = 0
def hlir_type_enum(ti=None):
	enum_width = 32
	enum_size = nbytes_for_bits(enum_width)

	global enum_uid
	enum_uid = enum_uid + 1

	return {
		'isa': 'type',
		'kind': 'enum',
		'generic': False,
		'width': enum_width,
		'size': enum_size,
		'align': enum_size,
		'items': [],
		'uid': enum_uid,
		'ops': ENUM_OPS,
		'att': [],
		'ti': ti
	}


from util import align_to
def hlir_type_record(fields, ti=None):

	field_no = 0
	offset = 0
	record_align = 1

	for field in fields:
		field['field_no'] = field_no
		field_no = field_no + 1

		field_size = type_get_size(field['type'])
		field_align = type_get_align(field['type'])

		# смещение поля должно быть выровнено
		# по требуемому для него шагу выравнивания
		offset = align_to(offset, field_align)
		field['offset'] = offset
		offset = offset + field_size

		# выравнивание структуры - макс выравнивание в ней
		record_align = max(record_align, field_align)

	# Afterall we need to align record_size to record_align (!)
	record_size = align_to(offset, record_align)

	return {
		'isa': 'type',
		'kind': 'record',
		'generic': False,
		'width': record_size * 8,
		'size': record_size,
		'align': record_align,
		'fields': fields,
		'ops': REC_OPS,
		'end_nl': 0,
		'att': [],
		'ti': ti
	}


def hlir_type_func(params, to, va_args, va_list_id, ti=None):
	return {
		'isa': 'type',
		'kind': 'func',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 1,
		'params': params,
		'to': to,
		'extra_args': va_args,
		'ops': [],
		'att': [],
		'ti': ti
	}


def hlir_type_string(char_width, length, ti=None):
	width = char_width
	size = nbytes_for_bits(width)
	return {
		'isa': 'type',
		'kind': 'string',
		'generic': True,  # 'string' is always generic!
		'width': width,
		'size': size,
		'align': size,
		'char_width': char_width,
		'length': length,
		'ops': STR_OPS,
		'att': [],
		'ti': ti
	}



def hlir_type_generic_int_for(num, signed=True, ti=None):
	required_width = nbits_for_num(num)
	t = hlir_type_integer(width=required_width, ti=ti)
	t['generic'] = True
	t['signed'] = signed
	return t



def type_eq_integer(a, b, opt):
	if a['width'] != b['width']:
		return False

	if a['signed'] != b['signed']:
		return False

	return True



def type_eq_char(a, b, opt):
	if a['width'] != b['width']:
		return False

	return True


def type_eq_pointer(a, b, opt):
	return type_eq(a['to'], b['to'], opt)


def type_eq_array(a, b, opt):
	if a['volume'] == None or b['volume'] == None:
		if a['volume'] == None and b['volume'] == None:
			return type_eq(a['of'], b['of'], opt)
		return False

	if a['volume'] != None and b['volume'] != None:
		from value.value import value_is_immediate
		if value_is_immediate(a['volume']) and value_is_immediate(b['volume']):
			if a['volume']['asset'] != b['volume']['asset']:
				return False

	if a['of'] == None or b['of'] == None:
		return a['of'] == None and b['of'] == None

	return type_eq(a['of'], b['of'], opt)



def get_type_root_id(t):
	if 'aka' in t:
		return t['aka']
	return None



def type_eq_func(a, b, opt):
	if not type_eq(a['to'], b['to'], opt): return False
	return type_eq_fields(a['params'], b['params'], opt)



def type_eq_fields(a, b, opt):
	if len(a) != len(b): return False
	for ax, bx in zip(a, b):
		if ax['id']['str'] != bx['id']['str']: return False

		# простейшая защита от бесконечной рекурсии
		# для случая когда запись содержит указатель на саму себя
		# (сравниваем типы полей по указателю)
		if ax['type'] == bx['type']:
			return True

		if not type_eq(ax['type'], bx['type'], opt): return False
	return True


def type_eq_record(a, b, opt, nominative=False):
	if nominative:
		a_root_id = get_type_root_id(a)
		b_root_id = get_type_root_id(b)

		if a_root_id != None and b_root_id != None:
			if a_root_id != b_root_id:
				return False

		elif a_root_id != None or b_root_id != None:
			return False

	if len(a['fields']) != len(b['fields']): return False
	return type_eq_fields(a['fields'], b['fields'], opt)


def type_eq_enum(a, b, opt, nominative=False):
	return a['uid'] == b['uid']


def type_eq_float(a, b, opt):
	return a['width'] == b['width']


def type_eq_undefined(a, b, opt):
	return a['uid'] == b['uid']  # maybe by UID?


def type_eq_alias(a, b, opt):
	return type_eq(a['of'], b['of'], opt)



def type_eq(a, b, opt=[]):
	# fast checking
	#if a == b: return True

	if a['kind'] == 'bad' or b['kind'] == 'bad': return True
	if a['kind'] != b['kind']: return False

	"""if ('aka' in a) or ('aka' in b):
		if ('aka' in a) and ('aka' in b):
			if a['aka'] == b['aka']:
				return True"""

	# проверять аттрибуты (volatile, const)
	# использую для C чтобы можно было более строго проверить типы
	# напр для явного приведения в беканде C *volatile uint32_t -> uint32_t
	if 'att_checking' in opt:
		if a['att'] != b['att']:
			return False

	# дженерик и не дженерик типы не равны
	# это важно при конструировании записей из джененрков
	# в противном случае конструирование будет скипнуто (тк уже равны)
	if type_is_generic(a) != type_is_generic(b):
		return False

	# normal checking
	k = a['kind']
	if k == 'int': return type_eq_integer(a, b, opt)
	elif k == 'unit': return True
	elif k == 'bool': return True
	elif k == 'byte': return True
	elif k == 'string': return True
	elif k == 'func': return type_eq_func(a, b, opt)
	elif k == 'record': return type_eq_record(a, b, opt)
	elif k == 'pointer': return type_eq_pointer(a, b, opt)
	elif k == 'array': return type_eq_array(a, b, opt)
	elif k == 'enum': return type_eq_enum(a, b, opt)
	elif k == 'float': return type_eq_float(a, b, opt)
	elif k == 'char': return type_eq_char(a, b, opt)
	elif k == 'undefined': return type_eq_undefined(a, b, opt)
	elif k == 'va_list': return b['kind'] == 'va_list'
	assert(False)
	return False


def type_is_bad(t):
	return t['kind'] == 'bad'


def type_is_defined(t):
	return t['kind'] != 'undefined'


def type_is_undefined(t):
	return t['kind'] == 'undefined'


def type_is_unit(t):
	return t['kind'] == 'unit'


def type_is_bool(t):
	return t['kind'] == 'bool'


def type_is_byte(t):
	return t['kind'] == 'byte'


def type_is_char(t):
	return t['kind'] == 'char'


def type_is_string(t):
	return t['kind'] == 'string'


def type_is_integer(t):
	return t['kind'] == 'int'


def type_is_float(t):
	return t['kind'] == 'float'


# numeric type supports arithmetical operations
def type_is_numeric(t):
	return t['kind'] in ['int', 'float']


def type_is_func(t):
	return t['kind'] == 'func'


def type_is_enum(t):
	return t['kind'] == 'enum'


def type_is_record(t):
	return t['kind'] == 'record'


def type_is_array(t):
	return t['kind'] == 'array'


# VLA - variable langth array
def type_is_vla(t):
	if t['kind'] == 'array':
		if t['volume'] != None:
			from value.value import value_is_immediate
			return not value_is_immediate(t['volume'])
	return False


def type_is_composite(t):
	return t['kind'] in ['array', 'record']


def type_is_pointer(t):
	return t['kind'] == 'pointer'



def type_is_va_list(t):
	return t['kind'] == 'va_list'



def type_is_generic_char(t):
	return type_is_generic(t) and type_is_char(t)


def type_is_generic_integer(t):
	return type_is_generic(t) and type_is_integer(t)


def type_is_generic_record(t):
	return type_is_generic(t) and type_is_record(t)


def type_is_generic_array(t):
	return type_is_generic(t) and type_is_array(t)


def type_is_generic_array_of_char(t):
	if type_is_generic_array(t):
		if t['of'] != None: # in case of empty array field #of == None
			return type_is_char(t['of'])

	return False



def type_is_closed_array(t):
	if type_is_array(t):
		return t['volume'] != None
	return False


def type_is_open_array(t):
	if type_is_array(t):
		return t['volume'] == None
	return False


def type_is_array_of_char(t):
	if type_is_array(t):
		return type_is_char(t['of'])
	return False


def type_is_generic_pointer(t):
	if type_is_generic(t):
		return type_is_pointer(t)
	return False


def type_is_free_pointer(t):
	if type_is_pointer(t):
		return type_is_unit(t['to'])
	return False


def type_is_pointer_to_record(t):
	if type_is_pointer(t):
		return type_is_record(t['to'])
	return False


def type_is_pointer_to_array(t):
	if type_is_pointer(t):
		return type_is_array(t['to'])
	return False



def type_is_pointer_to_array_of_char(t):
	if type_is_pointer(t):
		return type_is_array_of_char(t['to'])
	return False



def type_is_generic(t):
	return t['generic']


def type_is_signed(t):
	if 'signed' in t:
		return t['signed']
	return False


def type_is_unsigned(t):
	if 'signed' in t:
		return not t['signed']
	return False



# cannot create variable with type
def type_is_forbidden_var(t, zero_array_forbidden=True):
	if type_is_undefined(t) or type_is_unit(t) or type_is_func(t):
		return True

	if type_is_array(t):
		# [_]<Forbidden>
		if type_is_forbidden_var(t['of']):
			return True

		# []Int
		if type_is_open_array(t):
			return True

		# [0]Int
		from trans import is_unsafe_mode
		from value.value import value_is_immediate
		if zero_array_forbidden or not is_unsafe_mode():
			if value_is_immediate(t['volume']):
				if t['volume']['asset'] == 0:
					return True

		return type_is_forbidden_var(t['of'])


	return False




# TODO!
def type_attribute_add(t, a):
	t['att'].append(a)



# ищем поле с таким id в типе record
def record_field_get(t, id):
	return get_item_with_id(t['fields'], id)


# копирование типов следует использовать только в случае
# необходимости изменения его аттрибутов.
def type_copy(t):
	nt = copy.copy(t)
	# именно так!	иначе добавим в att t тк это ссылка на лист!
	# (!) создаем новый массив аттрибутов,
	# чтобы не испортить оригинальный (!)
	nt['att'] = []
	nt['att'].extend(t['att'])
	return nt



def type_get_size(t):
	assert(not type_is_vla(t))  #TODO: временная защита
	return t['size']


def type_get_align(t):
	return t['align']


def array_root_item_type(t):
	assert(type_is_array(t))
	of = t['of']
	while type_is_array(of):
		of = of['of']
	return of





def print_list_by(lst, method):
	i = 0
	while i < len(lst):
		if i > 0:
			print(", ")
		method(lst[i])
		i = i + 1
	return




def type_id(t):
	if 'aka' in t:
		return t['aka']
	return None


# возвращает корневой тип
# например Int32 --> Int --> MyInt
# type#id = MyInt
# root#id = Int32
def type_root_id(t):
	if 'aka' in t:
		return t['aka']
	return None



def type_print(t, print_aka=True):
	assert(t['isa'] == 'type')

	if 'volatile' in t['att']:
		print("volatile_", end='')
	if 'const' in t['att']:
		print("const_", end='')

	if t['generic']:
		print("Generic(", end='')

	k = t['kind']

	if print_aka:
		_id = type_id(t)

		if _id != None:
			print(_id, end='')

			_root_id = type_root_id(t)
			if _root_id != None:
				if _root_id != _id:
					print(" (%s is alias of %s)" % (_id, _root_id), end='')
			return


	if type_is_record(t):
#		if type_is_generic_record(t):
#			print("GenericRecord {")
#			for f in t['fields']:
#				print("\t%s: " % f['id']['str'], end='')
#				type_print(f['type'])
#				print()
#			print("}")
#			return

		print("record {")
		fields = t['fields']
		i = 0
		while i < len(fields):
			field = fields[i]
			if i > 0:
				print(',')
			print("\n\t"); type_print(field['type'])

			i = i + 1
		print("\n}")

	elif type_is_bool(t):
		print("Bool", end='')
	elif type_is_byte(t):
		print("Byte", end='')
	elif type_is_char(t):
		print("Char%d" % t['width'], end='')

	elif type_is_enum(t):
		if t['id'] != None:
			print(t['id'], end='')
		print("enum_%s" % str(t['uid']), end='')

	elif type_is_pointer(t):
		print("*", end=''); type_print(t['to'])

	elif type_is_array(t):
		if t['of'] == None:
			print("EmptyArray", end='')
			if t['generic']:
				print(")", end='')
			return

		print("[", end='')
		array_size = t['volume']

		if array_size != None:
			if type_is_vla(t):
				print("<VAR>", end='')
			else:
				sz = array_size['asset']
				print("%d" % sz, end='')

		print("]", end='')
		type_print(t['of'])

	elif type_is_func(t):
		print("(", end='')
		print_list_by(t['params'], lambda f: type_print(f['type']))
		print(")", end='')
		print(" -> ", end='')
		type_print(t['to'])

	elif type_is_integer(t):
		if type_is_signed(t):
			print('Int%d' % t['width'], end='')
		else:
			print('Nat%d' % t['width'], end='')

	elif type_is_float(t):
		print('Float%d' % t['width'], end='')

	elif type_is_string(t):
		print("String", end='')

	elif type_is_undefined(t):
		print('undefined', end='')

	else:
		print("<type:%s>" % k, end='')

	if t['generic']:
		print(")", end='')




# получает на вход два типа GenericRecord
# и создает третий тип который является общим для двух входных
# (тк в случае записей ни один из двух может не подходить как общий)
def select_common_record_type(a, b):
	#print("select_common_record_type")
	if len(a['fields']) != len(b['fields']):
		return None

	fields = []
	for fieldA, fieldB in zip(a['fields'], b['fields']):
		if fieldA['id']['str'] != fieldB['id']['str']:
			return None

		fieldId = fieldA['id']
		fieldType = select_common_type(fieldA['type'], fieldB['type'])
		newField = hlir_field(fieldId, fieldType, ti=fieldId['ti'])
		fields.append(newField)

	newRecord = hlir_type_record(fields, ti=a['ti'])
	newRecord['generic'] = True
	return newRecord




# выбирает наиболее подходящий тип для двух входных
# (наименьшее общее кратное)
# CAN RETURN NONE!
def select_common_type(a, b):

	# вид типа должен совпадать
	if a['kind'] != b['kind']:
		# но есть исключения

		# c == "A"
		if a['kind'] == 'char':
			if type_is_string(b):
				return a

		# "A" == c
		if b['kind'] == 'char':
			if type_is_string(a):
				return b


		if a['kind'] == 'byte':
			if b['kind'] == 'int':
				return a


		if b['kind'] == 'byte':
			if a['kind'] == 'int':
				return b

		# array && string | string && array
		if a['kind'] == 'array':
			if b['kind'] == 'string':
				return a

		if b['kind'] == 'array':
			if a['kind'] == 'string':
				return b


		if a['kind'] == 'unit':
			return b

		if b['kind'] == 'unit':
			return a

		if a['kind'] == 'bad':
			return b

		if b['kind'] == 'bad':
			return a

		if type_is_float(a):
			if type_is_integer(b):
				return a

		if type_is_float(b):
			if type_is_integer(a):
				return b

		print("select_common_type(%s %s) not impl." % (a['kind'], b['kind']))
		return None



	if type_is_generic(a) != type_is_generic(b):
		if type_is_string(a):
			if type_is_string(b):
				if a['char_width'] > b['char_width']:
					return a
				else:
					return b


		if type_is_generic(a):
			return b

		if type_is_generic(b):
			return a


	elif type_is_generic(a) and type_is_generic(b):
		if type_is_array(a) and type_is_array(b):
				# TODO: тут все плохо (тк должна быть рекурсия но пока без нее)
				if type_is_generic(a['of']):
					return b
				if type_is_generic(b['of']):
					return a

				# not implemented!
				return a




	if a['width'] > b['width']:
		return a
	else:
		return b


