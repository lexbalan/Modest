
from hlir.type import *
from hlir.hlir import hlir_def_type

from symtab import Symtab

typeUnit = None
typeBool = None
typeByte = None
typeChar8 = None
typeChar16 = None
typeChar32 = None
typeInt8 = None
typeInt16 = None
typeInt32 = None
typeInt64 = None
typeInt128 = None
typeNat8 = None
typeNat16 = None
typeNat32 = None
typeNat64 = None
typeNat128 = None
typeFloat16 = None
typeFloat32 = None
typeFloat64 = None
typeDecimal32 = None
typeDecimal64 = None
typeDecimal128 = None
typeStr8 = None
typeStr16 = None
typeStr32 = None
typeFreePointer = None
typeNil = None
typeVA_List = None
#typeSizeof = None




foundation_source_info = {
	'id': 'foundation',
	'path': '_',
	'dir': '_',
	'name': 'foundation',
}

foundation = {
	'isa': 'module',
	'id': "foudation",
	'source_info': foundation_source_info,
	'imports': [],  #
	'strings': [],  # (used in LLVM backend)
	'context': None,
	'options': [],
	'att': [],
	'text': []
}


def init():
	global typeUnit
	global typeBool
	global typeByte
	global typeChar8, typeChar16, typeChar32
	global typeInt8, typeInt16, typeInt32, typeInt64, typeInt128
	global typeNat8, typeNat16, typeNat32, typeNat64, typeNat128
	global typeFloat16, typeFloat32, typeFloat64
	global typeDecimal32, typeDecimal64, typeDecimal128
	global typeStr8, typeStr16, typeStr32
	global typeFreePointer
	global typeNil
	global typeVA_List
	global typeSizeof

	#from trans import hlir_def_type

	root_context = Symtab()
	foundation['context'] = root_context

	typeUnit = hlir_type_unit()
	typeBool = hlir_type_bool()

	typeByte = hlir_type_integer(width=8, signed=False)
	typeByte['kind'] = 'byte'
	typeByte['aka'] = 'Byte'
	typeByte['ops'] = BYTE_OPS
	typeByte['c_alias'] = 'uint8_t'
	typeByte['llvm_alias'] = 'i8'

	#
	typeChar8 = hlir_type_char(width=8)
	typeChar16 = hlir_type_char(width=16)
	typeChar32 = hlir_type_char(width=32)

	#
	typeInt8 = hlir_type_integer(width=8)
	typeInt16 = hlir_type_integer(width=16)
	typeInt32 = hlir_type_integer(width=32)
	typeInt64 = hlir_type_integer(width=64)
	typeInt128 = hlir_type_integer(width=128)


	#
	typeNat8 = hlir_type_integer(width=8, signed=False)
	typeNat16 = hlir_type_integer(width=16, signed=False)
	typeNat32 = hlir_type_integer(width=32, signed=False)
	typeNat64 = hlir_type_integer(width=64, signed=False)
	typeNat128 = hlir_type_integer(width=128, signed=False)


	#
	"""typeFloat16 = hlir_type_float(width=16)
	typeFloat16['aka'] = 'Half'
	typeFloat16['c_alias'] = 'half'
	typeFloat16['llvm_alias'] = 'half'"""


	typeFloat32 = hlir_type_float(width=32)
	typeFloat64 = hlir_type_float(width=64)


	#
	"""typeDecimal32 = hlir_type_float(width=32)
	decimal32_decl = hlir_def_type(hlir_id('Decimal32'), typeDecimal32, ti=None)
	decimal32_decl['att'].append('c-no-print')
	decimal32_decl['c_alias'] = '_Decimal32'
	decimal32_decl['llvm_alias'] = 'float'
	foundation['text'].append(decimal32_decl)

	typeDecimal64 = hlir_type_float(width=64)
	decimal64_decl = hlir_def_type(hlir_id('Decimal64'), typeDecimal64, ti=None)
	decimal64_decl['att'].append('c-no-print')
	decimal64_decl['c_alias'] = '_Decimal64'
	decimal64_decl['llvm_alias'] = 'double'
	foundation['text'].append(decimal64_decl)

	typeDecimal128 = hlir_type_float(width=128)
	decimal128_decl = hlir_def_type(hlir_id('Decimal128'), typeDecimal128, ti=None)
	decimal128_decl['att'].append('c-no-print')
	decimal128_decl['c_alias'] = '_Decimal128'
	decimal128_decl['llvm_alias'] = 'double'
	foundation['text'].append(decimal128_decl)"""

	# type Nil = Generic(*Unit)
	typeNil = hlir_type_pointer(to=typeUnit)
	typeNil['generic'] = True

	# type FreePointer = *Unit
	typeFreePointer = hlir_type_pointer(to=typeUnit)
	# не нужно делать decl тк нет собственного имени у этого типа

	typeStr8 = hlir_type_array(of=typeChar8)
	typeStr8['aka'] = 'Str8'
	typeStr16 = hlir_type_array(of=typeChar16)
	typeStr16['aka'] = 'Str16'
	typeStr32 = hlir_type_array(of=typeChar32)
	typeStr32['aka'] = 'Str32'


	typeVA_List = {
		'isa': 'type',
		'kind': 'va_list',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 1,
		'width': 0,
		'aka': 'VA_List',
		'c_alias': 'va_list',
		'llvm_alias': 'i8*',
		'att': [],
		'ops': [],
		'ti': None
	}

	return foundation




"""def hlir_type_generic_int_for(num, signed=True, ti=None):
	required_width = nbits_for_num(num)
	t = hlir_type_integer(width=required_width, ti=ti)
	t['generic'] = True
	t['signed'] = unsigned
	return t"""


def type_select_char(sz):
	t = None
	if sz <= 8: t = typeChar8
	elif sz <= 16: t = typeChar16
	elif sz <= 32: t = typeChar32
	assert(t != None)
	return t


def type_select_int(sz):
	t = None
	if sz <= 8: t = typeInt8
	elif sz <= 16: t = typeInt16
	elif sz <= 32: t = typeInt32
	elif sz <= 64: t = typeInt64
	elif sz <= 128: t = typeInt128
	assert(t != None)
	return t


def type_select_nat(sz):
	t = None
	if sz <= 8: t = typeNat8
	elif sz <= 16: t = typeNat16
	elif sz <= 32: t = typeNat32
	elif sz <= 64: t = typeNat64
	elif sz <= 128: t = typeNat128
	assert(t != None)
	return t


def type_select_integer(sz, is_signed):
	if is_signed:
		if sz < 128: return type_select_int(sz + 1)
		else: return type_select_int(sz)
	return type_select_nat(sz)




