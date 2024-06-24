
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
	unit_decl = hlir_def_type(hlir_id('Unit'), typeUnit, ti=None)
	unit_decl['att'].append('c-no-print')
	unit_decl['c_alias'] = 'void'
	unit_decl['llvm_alias'] = 'void'
	foundation['text'].append(unit_decl)

	typeBool = hlir_type_bool()
	bool_decl = hlir_def_type(hlir_id('Bool'), typeBool, ti=None)
	bool_decl['att'].append('c-no-print')
	bool_decl['c_alias'] = 'bool'
	bool_decl['llvm_alias'] = 'i1'
	foundation['text'].append(bool_decl)

	typeByte = hlir_type_integer(width=8, signed=False)
	typeByte['kind'] = 'byte'
	typeByte['ops'] = BYTE_OPS
	byte_decl = hlir_def_type(hlir_id('Byte'), typeByte, ti=None)
	byte_decl['att'].append('c-no-print')
	byte_decl['c_alias'] = 'uint8_t'
	byte_decl['llvm_alias'] = 'i8'
	foundation['text'].append(byte_decl)

	#
	typeChar8 = hlir_type_char(width=8)
	char8_decl = hlir_def_type(hlir_id('Char8'), typeChar8, ti=None)
	char8_decl['att'].append('c-no-print')
	char8_decl['c_alias'] = 'char'
	char8_decl['llvm_alias'] = 'i8'
	foundation['text'].append(char8_decl)

	typeChar16 = hlir_type_char(width=16)
	char16_decl = hlir_def_type(hlir_id('Char16'), typeChar16, ti=None)
	char16_decl['att'].append('c-no-print')
	char16_decl['c_alias'] = 'uint16_t'
	char16_decl['llvm_alias'] = 'i16'
	foundation['text'].append(typeChar16)

	typeChar32 = hlir_type_char(width=32)
	char32_decl = hlir_def_type(hlir_id('Char32'), typeChar32, ti=None)
	char32_decl['att'].append('c-no-print')
	char32_decl['c_alias'] = 'uint32_t'
	char32_decl['llvm_alias'] = 'i32'
	foundation['text'].append(char32_decl)

	#
	typeInt8 = hlir_type_integer(width=8)
	int8_decl = hlir_def_type(hlir_id('Int8'), typeInt8, ti=None)
	int8_decl['att'].append('c-no-print')
	int8_decl['c_alias'] = 'int8_t'
	int8_decl['llvm_alias'] = 'i8'
	foundation['text'].append(int8_decl)

	typeInt16 = hlir_type_integer(width=16)
	int16_decl = hlir_def_type(hlir_id('Int16'), typeInt16, ti=None)
	int16_decl['att'].append('c-no-print')
	int16_decl['c_alias'] = 'int16_t'
	int16_decl['llvm_alias'] = 'i16'
	foundation['text'].append(int16_decl)

	typeInt32 = hlir_type_integer(width=32)
	int32_decl = hlir_def_type(hlir_id('Int32'), typeInt32, ti=None)
	int32_decl['att'].append('c-no-print')
	int32_decl['c_alias'] = 'int32_t'
	int32_decl['llvm_alias'] = 'i32'
	foundation['text'].append(int32_decl)

	typeInt64 = hlir_type_integer(width=64)
	int64_decl = hlir_def_type(hlir_id('Int64'), typeInt64, ti=None)
	int64_decl['att'].append('c-no-print')
	int64_decl['c_alias'] = 'int64_t'
	int64_decl['llvm_alias'] = 'i64'
	foundation['text'].append(int64_decl)

	typeInt128 = hlir_type_integer(width=128)
	int128_decl = hlir_def_type(hlir_id('Int128'), typeInt128, ti=None)
	int128_decl['att'].append('c-no-print')
	int128_decl['c_alias'] = '__int128'
	int128_decl['llvm_alias'] = 'i128'
	foundation['text'].append(typeInt128)

	#
	typeNat8 = hlir_type_integer(width=8, signed=False)
	nat8_decl = hlir_def_type(hlir_id('Nat8'), typeNat8, ti=None)
	nat8_decl['att'].append('c-no-print')
	nat8_decl['c_alias'] = 'uint8_t'
	nat8_decl['llvm_alias'] = 'i8'
	foundation['text'].append(nat8_decl)

	typeNat16 = hlir_type_integer(width=16, signed=False)
	nat16_decl = hlir_def_type(hlir_id('Nat16'), typeNat16, ti=None)
	nat16_decl['att'].append('c-no-print')
	nat16_decl['c_alias'] = 'uint16_t'
	nat16_decl['llvm_alias'] = 'i16'
	foundation['text'].append(nat16_decl)

	typeNat32 = hlir_type_integer(width=32, signed=False)
	nat32_decl = hlir_def_type(hlir_id('Nat32'), typeNat32, ti=None)
	nat32_decl['att'].append('c-no-print')
	nat32_decl['c_alias'] = 'uint32_t'
	nat32_decl['llvm_alias'] = 'i32'
	foundation['text'].append(nat32_decl)

	typeNat64 = hlir_type_integer(width=64, signed=False)
	nat64_decl = hlir_def_type(hlir_id('Nat64'), typeNat64, ti=None)
	nat64_decl['att'].append('c-no-print')
	nat64_decl['c_alias'] = 'uint64_t'
	nat64_decl['llvm_alias'] = 'i64'
	foundation['text'].append(nat64_decl)

	typeNat128 = hlir_type_integer(width=128, signed=False)
	nat128_decl = hlir_def_type(hlir_id('Nat128'), typeNat128, ti=None)
	nat128_decl['att'].append('c-no-print')
	nat128_decl['c_alias'] = 'unsigned __int128'
	nat128_decl['llvm_alias'] = 'i128'
	foundation['text'].append(nat128_decl)

	#
	typeFloat16 = hlir_type_float(width=16)
	float16_decl = hlir_def_type(hlir_id('Float16'), typeFloat16, ti=None)
	float16_decl['att'].append('c-no-print')
	float16_decl['c_alias'] = 'half'
	float16_decl['llvm_alias'] = 'half'
	foundation['text'].append(float16_decl)

	typeFloat32 = hlir_type_float(width=32)
	float32_decl = hlir_def_type(hlir_id('Float32'), typeFloat32, ti=None)
	float32_decl['att'].append('c-no-print')
	float32_decl['c_alias'] = 'float'
	float32_decl['llvm_alias'] = 'float'
	foundation['text'].append(float32_decl)

	typeFloat64 = hlir_type_float(width=64)
	float64_decl = hlir_def_type(hlir_id('Float64'), typeFloat64, ti=None)
	float64_decl['att'].append('c-no-print')
	float64_decl['c_alias'] = 'double'
	float64_decl['llvm_alias'] = 'double'
	foundation['text'].append(float64_decl)

	#
	typeDecimal32 = hlir_type_float(width=32)
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
	foundation['text'].append(decimal128_decl)

	# type Nil = Generic(*Unit)
	typeNil = hlir_type_pointer(to=typeUnit)
	typeNil['generic'] = True

	# type FreePointer = *Unit
	typeFreePointer = hlir_type_pointer(to=typeUnit)
	# не нужно делать decl тк нет собственного имени у этого типа

	typeStr8 = hlir_type_array(of=typeChar8)
	typeStr8_decl = hlir_def_type(hlir_id('Str8'), typeStr8, ti=None)
	typeStr8_decl['att'].append('c-no-print')
	foundation['text'].append(typeStr8_decl)

	typeStr16 = hlir_type_array(of=typeChar16)
	typeStr16_decl = hlir_def_type(hlir_id('Str16'), typeStr16, ti=None)
	typeStr16_decl['att'].append('c-no-print')
	foundation['text'].append(typeStr16_decl)

	typeStr32 = hlir_type_array(of=typeChar32)
	typeStr32_decl = hlir_def_type(hlir_id('Str32'), typeStr32, ti=None)
	typeStr32_decl['att'].append('c-no-print')
	foundation['text'].append(typeStr32_decl)

	typeVA_List = {
		'isa': 'type',
		'kind': 'va_list',
		'generic': False,
		'width': 0,
		'size': 0,
		'align': 1,
		'width': 0,
		'declaration': None,
		'definition': None,
		'att': [],
		'ops': [],
		'ti': None
	}

	type_va_list_decl = hlir_def_type(hlir_id('VA_List'), typeVA_List, ti=None)
	type_va_list_decl['att'].append('c-no-print')
	type_va_list_decl['c_alias'] = 'va_list'
	foundation['text'].append(type_va_list_decl)


	#from main import settings
	#sizeof_width = int(settings.get('sizeof_width'))
	#typeSizeof = hlir_type_integer(width=sizeof_width)
	#typeSizeof['generic'] = True
	#typeSizeof['signed'] = False

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




