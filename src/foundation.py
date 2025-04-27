
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

	typeUnit = TypeUnit()
	typeBool = TypeBool()

	typeWord8 = TypeWord(width=8)
	typeWord16 = TypeWord(width=16)
	typeWord32 = TypeWord(width=32)
	typeWord64 = TypeWord(width=64)
	typeWord128 = TypeWord(width=128)
	typeWord256 = TypeWord(width=256)

	typeInt8 = TypeInt(width=8)
	typeInt16 = TypeInt(width=16)
	typeInt32 = TypeInt(width=32)
	typeInt64 = TypeInt(width=64)
	typeInt128 = TypeInt(width=128)
	typeInt256 = TypeInt(width=256)

	typeNat8 = TypeNat(width=8)
	typeNat16 = TypeNat(width=16)
	typeNat32 = TypeNat(width=32)
	typeNat64 = TypeNat(width=64)
	typeNat128 = TypeNat(width=128)
	typeNat256 = TypeNat(width=256)

	typeFloat32 = TypeFloat(width=32)
	typeFloat64 = TypeFloat(width=64)

	typeChar8 = TypeChar(width=8)
	typeChar16 = TypeChar(width=16)
	typeChar32 = TypeChar(width=32)

	# type Nil = Generic(*Unit)
	typeNil = TypePointer(to=typeUnit)
	typeNil.generic = True

	# type FreePointer = *Unit
	typeFreePointer = TypePointer(to=typeUnit)
	typeFreePointer.generic = True
	# не нужно делать decl тк нет собственного имени у этого типа

	typeSysNat = typeNat64
	from hlir.value import ValueUndef
	undefinedVolume = ValueUndef(typeSysNat, ti=None)
	typeStr8 = TypeArray(typeChar8, undefinedVolume, ti=None)
	typeStr8.id = Id().fromStr('Str8')
	typeStr8.id.c = None
	typeStr8.att.append("z-string")

	typeStr16 = TypeArray(typeChar16, undefinedVolume, ti=None)
	typeStr16.id = Id().fromStr('Str16')
	typeStr16.id.c = None
	typeStr16.att.append("z-string")

	typeStr32 = TypeArray(typeChar32, undefinedVolume, ti=None)
	typeStr32.id = Id().fromStr('Str32')
	typeStr32.id.c = None
	typeStr32.att.append("z-string")

	type__VA_List = TypeVaList()


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


