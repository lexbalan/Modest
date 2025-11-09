
from .types import *



def type_number_create(width=0, ti=None):
	nt = TypeSimple(width, HLIR_TYPE_KIND_NUMBER, Id(None), NUM_OPS, ti)
	nt.generic = True
	return nt



def type_string_create(char_width, length, ti=None):
	nt = TypeSimple(char_width, HLIR_TYPE_KIND_STRING, None, STR_OPS, ti=ti)
	nt.length = length
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
	nt = TypeSimple(width, HLIR_TYPE_KIND_INT, id, INT_OPS, ti)
	return nt


def type_nat_create(width, ti=None):
	width = align_bits_up(width)
	id = Id('Nat%d' % width)
	if width < 128:
		id.c = 'uint%d_t' % width
	else:
		id.c = 'unsigned __int%d' % width
	id.llvm = 'Nat%d' % width
	nt = TypeSimple(width, HLIR_TYPE_KIND_NAT, id, NAT_OPS, ti)
	return nt


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
	nt = TypeSimple(width, HLIR_TYPE_KIND_FLOAT, id, FLOAT_OPS, ti)
	return nt



unit_id = Id('Unit')
unit_id.c = 'void'
unit_id.llvm = 'void'
typeUnit = TypeSimple(0, HLIR_TYPE_KIND_UNIT, unit_id, UNIT_OPS)

bool_id = Id('Bool')
bool_id.c = 'bool'
bool_id.llvm = 'Bool'
typeBool = TypeSimple(8, HLIR_TYPE_KIND_BOOL, bool_id, BOOL_OPS)

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
typeStr8.att.append("z-string")

typeStr16 = TypeArray(typeChar16, undefinedVolume, ti=None)
typeStr16.id = Id('Str16')
typeStr16.id.c = None
typeStr16.att.append("z-string")

typeStr32 = TypeArray(typeChar32, undefinedVolume, ti=None)
typeStr32.id = Id('Str32')
typeStr32.id.c = None
typeStr32.att.append("z-string")

type__VA_List = TypeVaList()


