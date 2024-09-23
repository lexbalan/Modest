
from hlir.type import *
from hlir.hlir import hlir_def_type

from symtab import Symtab

typeUnit = None
typeBool = None
#typeByte = None
typeChar8 = None
typeChar16 = None
typeChar32 = None
typeWord8 = None
typeWord16 = None
typeWord32 = None
typeWord64 = None
typeWord128 = None
typeWord256 = None
typeInt8 = None
typeInt16 = None
typeInt32 = None
typeInt64 = None
typeInt128 = None
typeInt256 = None
typeNat8 = None
typeNat16 = None
typeNat32 = None
typeNat64 = None
typeNat128 = None
typeNat256 = None
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
	global typeChar8, typeChar16, typeChar32
	global typeWord8, typeWord16, typeWord32, typeWord64, typeWord128, typeWord256
	global typeInt8, typeInt16, typeInt32, typeInt64, typeInt128, typeInt256
	global typeNat8, typeNat16, typeNat32, typeNat64, typeNat128, typeNat256
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

	"""typeByte = hlir_type_integer(width=8, signed=False)
	typeByte['kind'] = 'byte'
	typeByte['id'] = {'str': 'Byte', 'c': 'uint8_t'}
	typeByte['ops'] = BYTE_OPS
	typeByte['llvm_alias'] = 'i8'"""

	#
	typeChar8 = hlir_type_char(width=8)
	typeChar16 = hlir_type_char(width=16)
	typeChar32 = hlir_type_char(width=32)

	#
	typeWord8 = hlir_type_word(width=8)
	typeWord16 = hlir_type_word(width=16)
	typeWord32 = hlir_type_word(width=32)
	typeWord64 = hlir_type_word(width=64)
	typeWord128 = hlir_type_word(width=128)
	typeWord256 = hlir_type_word(width=256)

	#
	typeInt8 = hlir_type_integer(width=8)
	typeInt16 = hlir_type_integer(width=16)
	typeInt32 = hlir_type_integer(width=32)
	typeInt64 = hlir_type_integer(width=64)
	typeInt128 = hlir_type_integer(width=128)
	typeInt256 = hlir_type_integer(width=256)

	#
	typeNat8 = hlir_type_integer(width=8, signed=False)
	typeNat16 = hlir_type_integer(width=16, signed=False)
	typeNat32 = hlir_type_integer(width=32, signed=False)
	typeNat64 = hlir_type_integer(width=64, signed=False)
	typeNat128 = hlir_type_integer(width=128, signed=False)
	typeNat256 = hlir_type_integer(width=256, signed=False)

	#
	typeFloat32 = hlir_type_float(width=32)
	typeFloat64 = hlir_type_float(width=64)

	# type Nil = Generic(*Unit)
	typeNil = hlir_type_pointer(to=typeUnit)
	typeNil['generic'] = True

	# type FreePointer = *Unit
	typeFreePointer = hlir_type_pointer(to=typeUnit)
	# не нужно делать decl тк нет собственного имени у этого типа

	typeStr8 = hlir_type_array(of=typeChar8)
	typeStr8['id'] = {'str': 'Str8'}
	typeStr16 = hlir_type_array(of=typeChar16)
	typeStr16['id'] = {'str': 'Str16'}
	typeStr32 = hlir_type_array(of=typeChar32)
	typeStr32['id'] = {'str': 'Str32'}


	typeVA_List = {
		'isa': 'type',
		'kind': 'va_list',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 1,
		'width': 0,
		'id': {
			'isa': 'id',
			'str': 'va_list',
			'c':'va_list',
			'llvm':'i8*',
			'ti': None
		},
		'att': [],
		'ops': [],
		'ti': None
	}

	return foundation



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
	elif sz <= 256: t = typeInt256
	assert(t != None)
	return t


def type_select_nat(sz):
	t = None
	if sz <= 8: t = typeNat8
	elif sz <= 16: t = typeNat16
	elif sz <= 32: t = typeNat32
	elif sz <= 64: t = typeNat64
	elif sz <= 128: t = typeNat128
	elif sz <= 256: t = typeNat256
	assert(t != None)
	return t


def type_select_integer(sz, is_signed):
	if is_signed:
		if sz < 128: return type_select_int(sz + 1)
		else: return type_select_int(sz)
	return type_select_nat(sz)




