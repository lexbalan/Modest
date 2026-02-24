
from .types import *



def type_integer_create(width=0, ti=None):
	return TypeInteger(width, ti)
	#nt = TypeSimple(width, id=Id("Integer"), ops=NUMBER_OPS, kind=HLIR_TYPE_KIND_INTEGER, ti=ti)
	#nt.generic = True
	#return nt


def type_rational_create(ti=None):
	return TypeRational(ti=ti)
#	nt = TypeSimple(width=0, id=Id("Rational"), ops=NUMBER_OPS, kind=HLIR_TYPE_KIND_RATIONAL, ti=ti)
#	nt.generic = True
#	return nt


def type_string_create(char_width, length, ti=None):
	# Есть вариант сделать GenericArray of GenericChar и в этом есть плюсы (например индексирование)
	# НО есть и значительный минус - непонятно что делать при сравнении строк - тк типы зависят от длины строки
	nt = TypeSimple(width=0, id=Id("String"), ops=STRING_OPS, kind=HLIR_TYPE_KIND_STRING, ti=ti)
	nt.length = length
	nt.width=char_width
	nt.generic = True
	return nt


def type_word_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Word%d' % width)
	if width < 128:
		id.c = 'uint%d_t' % width
	else:
		id.c = 'unsigned __int%d' % width
	id.llvm = 'Word%d' % width
	return TypeSimple(width, HLIR_TYPE_KIND_WORD, id, WORD_OPS, ti)


def type_int_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Int%d' % width)
	if width < 128:
		id.c = 'int%d_t' % width
	else:
		id.c = '__int%d' % width
	id.llvm = 'Int%d' % width
	return TypeSimple(width, HLIR_TYPE_KIND_INT, id, INT_OPS, ti)


def type_nat_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Nat%d' % width)
	if width < 128:
		id.c = 'uint%d_t' % width
	else:
		id.c = 'unsigned __int%d' % width
	id.llvm = 'Nat%d' % width
	return TypeSimple(width, HLIR_TYPE_KIND_NAT, id, NAT_OPS, ti)


def type_char_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Char%d' % width)
	if width == 8:
		id.c = 'char'
	else:
		id.c = 'char%d_t' % width
	id.llvm = 'Char%d' % width
	return TypeSimple(width, HLIR_TYPE_KIND_CHAR, id, CHAR_OPS, ti)


def type_float_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Float%d' % width)
	if width == 32:
		id.c = 'float'
	else:
		id.c = 'double'
	id.llvm = 'Float%d' % width
	return TypeSimple(width, HLIR_TYPE_KIND_FLOAT, id, FLOAT_OPS, ti)


def type_fixed_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Fixed%d' % width)
	if width == 32:
		id.c = 'int32_t'
	else:
		id.c = 'int64_t'
	id.llvm = 'Fixed%d' % width
	nt = TypeSimple(width, HLIR_TYPE_KIND_FIXED, id, FLOAT_OPS, ti)
	nt.fraction = width / 2
	return nt




typeUnit = TypeRecord(fields=[])
typeUnit.id = Id('Unit')
typeUnit.id.c = 'void'
typeUnit.id.llvm = 'void'
typeUnit.id.c_type = 'void'



bool_id = Id('Bool')
bool_id.c = 'bool'
bool_id.llvm = 'Bool'
typeBool = TypeSimple(8, HLIR_TYPE_KIND_BOOL, bool_id, BOOL_OPS)

# generic built-in types
typeInteger = TypeInteger()
typeRational = TypeRational()

typeWord8 = type_word_create(width=8)
typeWord16 = type_word_create(width=16)
typeWord32 = type_word_create(width=32)
typeWord64 = type_word_create(width=64)
typeWord128 = type_word_create(width=128)
typeWord256 = type_word_create(width=256)

typeInt8 = type_int_create(width=8)
typeInt16 = type_int_create(width=16)
typeInt32 = type_int_create(width=32)
typeInt64 = type_int_create(width=64)
typeInt128 = type_int_create(width=128)
typeInt256 = type_int_create(width=256)

typeNat8 = type_nat_create(width=8)
typeNat16 = type_nat_create(width=16)
typeNat32 = type_nat_create(width=32)
typeNat64 = type_nat_create(width=64)
typeNat128 = type_nat_create(width=128)
typeNat256 = type_nat_create(width=256)

typeChar8 = type_char_create(width=8)
typeChar16 = type_char_create(width=16)
typeChar32 = type_char_create(width=32)

typeFloat32 = type_float_create(width=32)
typeFloat64 = type_float_create(width=64)

typeFixed32 = type_fixed_create(width=32)
typeFixed64 = type_fixed_create(width=64)



# type Nil = Generic(*Unit)
typeNil = TypePointer(to=typeUnit)
typeNil.generic = True

# type FreePointer = *Unit
typeFreePointer = TypePointer(to=typeUnit)
typeFreePointer.generic = True
# не нужно делать decl тк нет собственного имени у этого типа

typeSysNat = typeNat64
undefinedVolume = ValueUndef(typeSysNat, ti=None)
typeStr8 = TypeArray(typeChar8, undefinedVolume, ti=None)
typeStr8.id = Id('Str8')
typeStr8.id.c = None
typeStr8.att.append("zarray")

typeStr16 = TypeArray(typeChar16, undefinedVolume, ti=None)
typeStr16.id = Id('Str16')
typeStr16.id.c = None
typeStr16.att.append("zarray")

typeStr32 = TypeArray(typeChar32, undefinedVolume, ti=None)
typeStr32.id = Id('Str32')
typeStr32.id.c = None
typeStr32.att.append("zarray")

typeByte = typeWord8.copy()
typeByte.id = Id('Byte')
typeByte.id.c = 'uint8_t'


type__VA_List = TypeVaList()


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



def type_integer_for(num, ti=None):
	required_width = align_bits_up(nbits_for_num(num))
	return type_integer_create(width=required_width, ti=ti)



