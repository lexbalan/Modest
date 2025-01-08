
from type import *
from hlir.hlir import *

from symtab import Symtab

typeUnit = None
typeBool = None
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
typeChar8 = None
typeChar16 = None
typeChar32 = None
typeStr8 = None
typeStr16 = None
typeStr32 = None
typeFreePointer = None
typeNil = None
type__VA_List = None



foundation_source_info = {
	'isa': 'source_info',
	'id': 'foundation',
	'path': '',
	'dir': '',
	'name': 'foundation',
}

foundation = {
	'isa': 'module',
	'id': "foudation",
	'source_info': foundation_source_info,
	'imports': [],
	'strings': [],
	'context': None,
	'options': [],
	'att': [],
	'defs': []
}


def init():
	global typeUnit
	global typeBool
	global typeWord8, typeWord16, typeWord32, typeWord64, typeWord128, typeWord256
	global typeInt8, typeInt16, typeInt32, typeInt64, typeInt128, typeInt256
	global typeNat8, typeNat16, typeNat32, typeNat64, typeNat128, typeNat256
	global typeFloat16, typeFloat32, typeFloat64
	global typeDecimal32, typeDecimal64, typeDecimal128
	global typeChar8, typeChar16, typeChar32
	global typeStr8, typeStr16, typeStr32
	global typeFreePointer
	global typeNil
	global type__VA_List
	global typeSizeof

	#from trans import hlir_def_type

	root_context = Symtab()
	foundation['context'] = root_context

	typeUnit = type_unit()
	typeBool = type_bool()

	typeWord8 = type_word(width=8)
	typeWord16 = type_word(width=16)
	typeWord32 = type_word(width=32)
	typeWord64 = type_word(width=64)
	typeWord128 = type_word(width=128)
	typeWord256 = type_word(width=256)

	typeInt8 = type_integer(width=8)
	typeInt16 = type_integer(width=16)
	typeInt32 = type_integer(width=32)
	typeInt64 = type_integer(width=64)
	typeInt128 = type_integer(width=128)
	typeInt256 = type_integer(width=256)

	typeNat8 = type_integer(width=8, signed=False)
	typeNat16 = type_integer(width=16, signed=False)
	typeNat32 = type_integer(width=32, signed=False)
	typeNat64 = type_integer(width=64, signed=False)
	typeNat128 = type_integer(width=128, signed=False)
	typeNat256 = type_integer(width=256, signed=False)

	typeFloat32 = type_float(width=32)
	typeFloat64 = type_float(width=64)

	typeChar8 = type_char(width=8)
	typeChar16 = type_char(width=16)
	typeChar32 = type_char(width=32)

	# type Nil = Generic(*Unit)
	typeNil = type_pointer(to=typeUnit)
	typeNil.generic = True

	# type FreePointer = *Unit
	typeFreePointer = type_pointer(to=typeUnit)
	# не нужно делать decl тк нет собственного имени у этого типа

	typeSysNat = typeNat64
	from value.value import ValueUndefined
	undefinedVolume = ValueUndefined(typeSysNat, ti=None)
	typeStr8 = type_array(typeChar8, undefinedVolume, ti=None)
	typeStr8.id = Id().fromStr('Str8')
	typeStr16 = type_array(typeChar16, undefinedVolume, ti=None)
	typeStr16.id = Id().fromStr('Str16')
	typeStr32 = type_array(typeChar32, undefinedVolume, ti=None)
	typeStr32.id = Id().fromStr('Str32')

	type__VA_List = type_va_list()



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


