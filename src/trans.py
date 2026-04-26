
import os
import copy
import decimal

from hlir import *
from error import *
from lexer import CmLexer
from parser import Parser
from common import settings

from value.bool import value_bool_create
from value.integer import value_integer_create
from value.rational import value_rational_create
from value.string import value_string_create, value_string_concat
from value.array import value_array_create, value_array_concat
from value.record import value_record_create
from value.word import value_word_create



lexer = CmLexer()
parser = Parser()



# сущность из текущего модуля
def is_local_entity(x):
	global cmodule
	if hasattr(x, 'definition') and x.definition != None:
		return x.definition.parent == cmodule
	return True



# Аннотация есть в ast объекте
def getAnno(x, aname):
	for a in x['anno']:
		if a['kind'] == aname:
			return a
	return None



def is_local_context():
	global cfunc
	return cfunc != None


from value.cons import value_cons_implicit, value_cons_implicit_check, value_cons_explicit, value_cons_default, value_cons_extra_arg


from symtab import Symtab
from util import nbits_for_num, nbytes_for_bits



global_prefix = ''

# current file directory
env_current_file_dir = ""


root_symtab = None  # symtab with base types & values

# All already translate imported modules
# path => module
modules = {}


cmodule = None  # Current module
cfunc = None	# current function

context = None  # current context (symtab)
cdef = None




def cmodule_use(x):
	#print("USE: " + str(x))
	global cmodule
	if not x in cmodule.helpers:
		cmodule.helpers.append(x)



# TODO: attribute 'unsafe' for cast operation
unsafe_mode = False
def is_unsafe_mode():
	return unsafe_mode


# тепреь вызывается только из конструктора строки (value)
def cmodule_strings_add(v):
	global cmodule
	cmodule.strings.append(v)




def context_push():
	global context
	context = {
		'public': context['public'].branch(),
		'private': context['private'].branch()
	}


def context_pop():
	global context
	context = {
		'public': context['public'].parent_get(),
		'private': context['private'].parent_get()
	}



def ctx_type_add(id_str, t, is_public):
	global context
	if is_public:
		context['public'].type_add(id_str, t)
	else:
		context['private'].type_add(id_str, t)


def ctx_type_get(id_str):
	global context
	if id_str in ['Char16', 'Char32', 'Str16', 'Str32']:
		# включаем в модуле поддержку unicode
		cmodule_use('use_unicode')

	t = context['private'].type_get(id_str)
	if t != None:
		return t
	return context['public'].type_get(id_str)


def ctx_value_add(id_str, v, is_public):
	global context
	if is_public:
		context['public'].value_add(id_str, v)
	else:
		context['private'].value_add(id_str, v)


def ctx_value_get(id_str, shallow=False):
	global context
	v = context['private'].value_get(id_str, shallow=shallow)
	if v != None:
		return v
	return context['public'].value_get(id_str, shallow=shallow)



def id_already_used(id_str, shallow=False):
	return ctx_value_get(id_str, shallow=shallow) != None



def cmodule_feature_add(s):
	cmodule.addAttribute(s)


typeSysWord = None
typeSysChar = None
typeSysInt = None
typeSysNat = None
typeSysFloat = None
typeSysStr = None
typeSysSize = None

valueNil = None
valueTrue = None
valueFalse = None


target_name = "<unknown>"
char_width = 0
int_width = 0
float_width = 0
pointer_width = 0


def valueZeroNumber(ti=None):
	gt = type_integer_create(ti=ti)
	return ValueLiteral(gt, asset=0, ti=ti)


# этот модуль по умолчанию импортирован в любой другой
# он позволяет получить данные о компиляторе, окружении и целевой платформе
builtin_module = None


def init():
	#lib_path = settings['lib']
	types.init(settings['pointer_width'])

	global target_name
	global char_width, int_width, float_width, pointer_width
	global typeSysWord, typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr, typeSysSize
	global builtin_module

	# max number of signs after .
	# decimal operation precision
	decimal.getcontext().prec = settings['precision']

	global root_symtab
	# init main context
	root_symtab = Symtab()

	root_symtab.type_add('Unit', typeUnit)
	root_symtab.type_add('Bool', typeBool)

	root_symtab.type_add('Integer', typeInteger)
	root_symtab.type_add('Rational', typeRational)

	root_symtab.type_add('Byte', typeByte)

	root_symtab.type_add('Word8', typeWord8)
	root_symtab.type_add('Word16', typeWord16)
	root_symtab.type_add('Word32', typeWord32)
	root_symtab.type_add('Word64', typeWord64)
	root_symtab.type_add('Word128', typeWord128)
	#root_symtab.type_add('Word256', typeWord256)

	root_symtab.type_add('Int8', typeInt8)
	root_symtab.type_add('Int16', typeInt16)
	root_symtab.type_add('Int32', typeInt32)
	root_symtab.type_add('Int64', typeInt64)
	root_symtab.type_add('Int128', typeInt128)
	#root_symtab.type_add('Int256', typeInt256)

	root_symtab.type_add('Nat8', typeNat8)
	root_symtab.type_add('Nat16', typeNat16)
	root_symtab.type_add('Nat32', typeNat32)
	root_symtab.type_add('Nat64', typeNat64)
	root_symtab.type_add('Nat128', typeNat128)
	#root_symtab.type_add('Nat256', typeNat256)

	#root_symtab.type_add('Float16', typeFloat16)
	root_symtab.type_add('Float32', typeFloat32)
	root_symtab.type_add('Float64', typeFloat64)

	root_symtab.type_add('Fixed32', typeFixed32)
	root_symtab.type_add('Fixed64', typeFixed64)

	#root_symtab.type_add('Decimal32', typeDecimal32)
	#root_symtab.type_add('Decimal64', typeDecimal64)
	#root_symtab.type_add('Decimal128', typeDecimal128)

	root_symtab.type_add('Char8', typeChar8)
	root_symtab.type_add('Char16', typeChar16)
	root_symtab.type_add('Char32', typeChar32)

	root_symtab.type_add('Str8', typeStr8)
	root_symtab.type_add('Str16', typeStr16)
	root_symtab.type_add('Str32', typeStr32)

	root_symtab.type_add('Ptr', typeFreePointer)

	root_symtab.type_add('__VA_List', type__VA_List)


	global valueTrue, valueFalse, valueNil
	valueNil = ValueLiteral(typeNil, 0)
	valueTrue = value_bool_create(1)
	valueFalse = value_bool_create(0)

	root_symtab.value_add('nil', valueNil)
	root_symtab.value_add('true', valueTrue)
	root_symtab.value_add('false', valueFalse)

	word_width = int(settings['word_width'])
	char_width = int(settings['char_width'])
	int_width = int(settings['integer_width'])
	float_width = int(settings['float_width'])
	pointer_width = int(settings['pointer_width'])

	typeSysWord = type_word_create(word_width)
	typeSysChar = type_select_char(char_width)
	typeSysInt = type_select_int(int_width)
	typeSysNat = type_select_nat(int_width)
	typeSysFloat = typeFloat64

	typeSysSize = type_select_nat(settings['size_width']).copy()
	typeSysSize.id = Id('Size')
	typeSysSize.id.c = 'size_t'

	root_symtab.type_add('Size', typeSysSize)

	undefinedVolume = ValueUndef(typeSysNat, ti=None)
	typeSysStr = TypePointer(TypeArray(typeSysChar, undefinedVolume))

	target_name = str(settings['target_name'])

	builtin_module = create_builtin_module()





def xcreate_const(symtab, id_str, value, type=None, ti=None):
	if type == None:
		type = value.type
	value = value_cons_implicit(type, value)
	const_value = ValueConst(type, Id(id_str), init_value=value, ti=ti)
	const_value.set_asset(value.asset)
	const_value.addAttribute('cbyvalue')
	symtab.value_add(id_str, const_value)
	return const_value


def create_builtin_module():
	global target_name
	global char_width
	global int_width
	global float_width
	global pointer_width
	# Set taget depended Int & Nat types
	# (used in index, extra agrs & generic numeric var definitions)

	builtin_symtab = Symtab()
	builtin_module = Module("builtin", ast=None, symtab_public=builtin_symtab, symtab_private=Symtab(), sourcename="__builtin_source__")

	target_symtab = Symtab()
	target_module = Module("target", ast=None, symtab_public=target_symtab, symtab_private=Symtab(), sourcename="__target_source__")

	import_target = StmtImport(impline="builtin/target", name="builtin", module=target_module, ti=None, include=False)
	builtin_module.imports_public["target"] = import_target

	compiler_symtab = Symtab()
	compiler_module = Module("compiler", ast=None, symtab_public=compiler_symtab, symtab_private=Symtab(), sourcename="__compiler_source__")

	import_compiler = StmtImport(impline="builtin/compiler", name="builtin", module=compiler_module, ti=None, include=False)
	builtin_module.imports_public["compiler"] = import_compiler


	#
	# builtin.compiler
	#

	# compiler name
	compilerNameConst = xcreate_const(compiler_symtab, "name", value_string_create("m2"))

	# compiler version
	compilerVersionMajor = ValueLiteral(typeNat32, 0)
	compilerVersionMinor = ValueLiteral(typeNat32, 7)
	compilerVersionPatch = ValueLiteral(typeNat32, 100)

	compiler_version_initializers = [
		Initializer(Id('major'), compilerVersionMajor),
		Initializer(Id('minor'), compilerVersionMinor),
		Initializer(Id('patch'), compilerVersionPatch),
	]
	compilerVersionRecord = value_record_create(compiler_version_initializers, ti=None)

	compilerVersionConst = xcreate_const(compiler_symtab, "version", compilerVersionRecord)

	# '__compiler' record
#	compiler_initializers = [
#		Initializer(Id('name'), compilerName),
#		Initializer(Id('version'), compilerVersion),
#	]
#	compiler_iv = value_record_create(compiler_initializers, ti=None)
#	const_compiler = ValueConst(compiler_iv.type, Id("__compiler"), init_value=compiler_iv, ti=None)
#	const_compiler.set_asset(compiler_iv.asset)
#	const_compiler.stage = HLIR_VALUE_STAGE_COMPILETIME
#	builtin_symtab.value_add('compiler', const_compiler)

	#
	# builtin.target
	#

	targetNameConst = xcreate_const(target_symtab, "name", value_string_create("mac"))

	typeArch = type_string_create(32, 0, ti=None)
	typeArch.brand = get_brand()

	archX86 = xcreate_const(target_symtab, "archX86", value_string_create("x86"), type=typeArch)
	archX86_64 = xcreate_const(target_symtab, "archX86_64", value_string_create("x86_64"), type=typeArch)
	archArm = xcreate_const(target_symtab, "archArm", value_string_create("arm"), type=typeArch)
	archAarch64 = xcreate_const(target_symtab, "archAarch64", value_string_create("aarch64"), type=typeArch)
	archRiscv32 = xcreate_const(target_symtab, "archRiscv32", value_string_create("riscv32"), type=typeArch)
	archRiscv64 = xcreate_const(target_symtab, "archRiscv64", value_string_create("riscv64"), type=typeArch)

	typeOs = type_string_create(32, 0, ti=None)
	typeOs.brand = get_brand()
	osLinux = xcreate_const(target_symtab, "osLinux", value_string_create("linux"), type=typeOs)
	osWindows = xcreate_const(target_symtab, "osWindows", value_string_create("windows"), type=typeOs)
	osMacos = xcreate_const(target_symtab, "osMacos", value_string_create("darwin"), type=typeOs)
	osNoos = xcreate_const(target_symtab, "osNoos", value_string_create("noos"), type=typeOs)

	typeAbi = type_string_create(32, 0, ti=None)
	typeAbi.brand = get_brand()
	abiSysV = xcreate_const(target_symtab, "abiSysV", value_string_create("sysv"), type=typeAbi)
	abiWin32 = xcreate_const(target_symtab, "abiWin32", value_string_create("win32"), type=typeAbi)
	abiWin64 = xcreate_const(target_symtab, "abiWin64", value_string_create("win64"), type=typeAbi)
	abiEabi = xcreate_const(target_symtab, "abiEabi", value_string_create("eabi"), type=typeAbi)
	abiUnknown = xcreate_const(target_symtab, "abiUnknown", value_string_create("unknown_abi"), type=typeAbi)

	typeEndian = type_string_create(32, 0, ti=None)
	typeEndian.brand = get_brand()
	endianBig = xcreate_const(target_symtab, "endianBig", value_string_create("big-endian"), type=typeEndian)
	endianLittle = xcreate_const(target_symtab, "endianLittle", value_string_create("little-endian"), type=typeEndian)
	target_endian = xcreate_const(target_symtab, "endian", endianLittle, type=typeEndian)
	target_arch = xcreate_const(target_symtab, "arch", archAarch64, type=typeArch)
	target_os = xcreate_const(target_symtab, "os", osMacos, type=typeOs)
	target_abi = xcreate_const(target_symtab, "abi", abiSysV, type=typeAbi)
	target_char_width = xcreate_const(target_symtab, "charWidth", ValueLiteral(typeInteger, char_width))
	target_int_width = xcreate_const(target_symtab, "intWidth", ValueLiteral(typeInteger, int_width))
	target_int_width = xcreate_const(target_symtab, "floatWidth", ValueLiteral(typeInteger, float_width))
	target_int_width = xcreate_const(target_symtab, "pointerWidth", ValueLiteral(typeInteger, pointer_width))


	mw = type_word_create(width=32)
	mw.definition = StmtDefType("Word", mw, None, ti=None)
	target_symtab.type_add('Word', mw)
	builtin_symtab.type_add('Word', mw)

	mi = type_int_create(width=32)
	mi.definition = StmtDefType("Int", mi, None, ti=None)
	target_symtab.type_add('Int', mi)
	builtin_symtab.type_add('Int', mi)

	mn = type_nat_create(width=32)
	mn.definition = StmtDefType("Nat", mn, None, ti=None)
	target_symtab.type_add('Nat', mn)
	builtin_symtab.type_add('Nat', mn)

	# create '__target' record
#	target_initializers = [
#		Initializer(Id('name'), value_string_create(target_name)),
#		Initializer(Id('arch'), archAarch64),
#		Initializer(Id('os'), osMacos),
#		Initializer(Id('abi'), abiSysV),
#		Initializer(Id('endian'), endianLittle),
#		Initializer(Id('charWidth'), ValueLiteral(typeInteger, char_width)),
#		Initializer(Id('intWidth'), ValueLiteral(typeInteger, int_width)),
#		Initializer(Id('floatWidth'), ValueLiteral(typeInteger, float_width)),
#		Initializer(Id('pointerWidth'), ValueLiteral(typeInteger, pointer_width))
#	]
#	target_iv = value_record_create(target_initializers, ti=None)
#	const_target = ValueConst(target_iv.type, Id("__target"), init_value=target_iv, ti=None)
#	const_target.set_asset(target_iv.asset)
#	const_target.stage = HLIR_VALUE_STAGE_COMPILETIME
#
#	builtin_symtab.value_add('target', const_target)

	return builtin_module


# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position no
# offset - real offset (address inside container struct)
def do_field(x):
	id = do_id(x['id'])
	if id.str[0].isupper():
		error("field id must starts with small letter", id.ti)

	field_type, init_value = process_field_common(x)
	if field_type.is_forbidden_field():
		error("unsuitable type", x['ti'])

	f = Field(id, field_type, init_value=init_value, access_level = x['access_modifier'], ti=x['ti'])
	f.add_atts(x['anno'])
	f.nl = x['nl']
	return f


#
# Do Type
#


def get_module_by_path(path):
	global cmodule
	mod = cmodule
	with_private=True
	for id in path:
		if isinstance(id, Id):
			id_str = id.str
		else:
			id_str = id['str']
		imp = mod.get_import(id_str, with_private=True)
		with_private=False
		if imp == None:
			#error("module '%s' not found" % id_str, id.ti)
			return None  # not found
		mod = imp.module
	return mod


def do_type_named(x):
	global cmodule
	id = x['id']
	id_str = id['str']

	t = None
	if 'module_path' in x:
		module = get_module_by_path(x['module_path'])

		if module == None:
			error("unknown namespace", x['ti'])
			return TypeBad(x['ti'])

		t = module.type_get_public(id_str)

		if t == None:
			t = module.type_get_private(id_str)
			if t != None:
				error("access to private type", x['ti'])
			else:
				error("undefined type2", x['ti'])
			return TypeBad(x['ti'])

		if t.is_incompleted():
			t = type_update_incompleted(module, t, id_str)
	else:
		t = ctx_type_get(id_str)

	if t == None:
		error("undefined type", x['ti'])
		return TypeBad(x['ti'])


	# если дело происходит не в определении типа и пришел undefined тип
	if t.is_incompleted():
		#if not cdef.is_stmt_def_type():
		#	warning("forward references to non-struct type", x['ti'])
		cdef.deps.append(t)

	if t.hasAttribute("deprecated"):
		warning("using a deprecated type", x['ti'])

	return t



def do_type_pointer(x):
	#info("%s" % x, x['ti'])
	to = do_type_internal(x['to'])
	return TypePointer(to, ti=x['ti'])


def do_type_array(x):
	of = do_type_internal(x['of'])
	volume = do_value(x['size'])

	if volume.isValueBad():
		return TypeArray(of, volume, ti=x['ti'])

	if not volume.is_value_undefined():
		if volume.isValueRuntime():
			if is_local_context():
				global cfunc
				cfunc.addAttribute('stacksave')
			else:
				error("non local VLA", t.get_size().ti)

	nt = TypeArray(of, volume, ti=x['ti'])
	# [][] разрешено создавать, но они отольются в [] в backend, и чтобы снмим работать нужно привести явно к [n][m] (!)
	#if nt.is_open_array() and of.is_open_array():
	#	error("open arrays of open arrays are forbidden", of.ti)
	return nt


# Нужен для анонимных структур
# и чтобы отличать копии типа структура от реально другой структуры (C)
rec_uid = 0
def do_type_record(x):
	global rec_uid
	fields = []

	uid = rec_uid
	rec_uid += 1

	for ast_field in x['fields']:
		field = do_field(ast_field)

		# redefinition?
		field_id_str = field.id.str
		field_already_exist = get_item_by_id(fields, field_id_str)
		if field_already_exist != None:
			error("redefinition of '%s' field" % field_id_str, field.ti)
			continue

		#if 'comments' in field:
		for comment in ast_field['comments']:
			field.comments.append(do_stmt_comment(comment))

		if ast_field['line_comment']:
			field.line_comment = do_stmt_comment(ast_field['line_comment'])

		fields.append(field)

	rec = TypeRecord(fields, ti=x['ti'])
	rec.uid = uid
	return rec



def do_type_func(x, func_id="_"):
	params = []
	for _param in x['params']:
		param = do_field(_param)
		if param.type.is_forbidden_param():
			error("forbidden param type", param.ti)
		if param != None:
			params.append(param)

	to = do_type(x['to'])

	if to.is_forbidden_retval():
		error("forbidden retval type", to.ti)

	return TypeFunc(params, to, x['arghack'], ti=x['ti'])



def do_type_internal(x):
	t = None
	k = x['kind']
	if k == 'named': t = do_type_named(x)
	elif k == 'func': t = do_type_func(x)
	elif k == 'pointer': t = do_type_pointer(x)
	elif k == 'array': t = do_type_array(x)
	elif k == 'record': t = do_type_record(x)
	else: t = bad_type(x['ti'])
	t.ti = x['ti']

	if x['anno'] != []:
		t = t.copy_with_atts(x['anno'])

	if k == 'record' and not t.is_unit():
		# кароч прикол такой:
		# тк t.add_atts вызывается здесь и создает НОВЫЙ тип то в таблице cmodule.anon_recs
		# оказывается оригинальная структура, а при поиске для удаления ее оттуда ищется новая (обернутая)
		# поэтому этот костыль тут а не в do_type_record где ему казалось бы - место
		anon_tag = '__anonymous_struct_%d' % t.uid
		t.c_anon_id = anon_tag
		cmodule.anon_recs.append(t)

	return t


def do_type(x):
	#info("do_type", x['ti'])
	t = do_type_internal(x)

# TODO: not good for func type !
#	if t.is_incompleted():
#		error("using of an incompleted type", t.ti)

	if t.is_record():
		for f in t.fields:
			if f.type.is_incompleted():
				error("using of an incompleted type", f.type.ti)

	if t.is_array():
		if t.of.is_incompleted():
			error("using of an incompleted type", t.of.ti)

	return t


def do_value_shift(x):
	op = x['kind']  # HLIR_VALUE_OP_SHL | HLIR_VALUE_OP_SHR
	left = do_rvalue(x['left'])
	right = do_rvalue(x['right'])

	# Слева может быть только word или integer !
	if not (left.type.is_word() or left.type.is_integer()):
		error("expected word value", x['left']['ti'])
		return ValueBad(x['ti'])

	if left.type.is_generic():
		if not right.type.is_generic():
			error("expected non-generic value", left.ti)
			return ValueBad(x['ti'])


	if right.type.is_signed():
		error("expected natural value", x['right']['ti'])
		return ValueBad(x['ti'])

	nv = None
	asset = None
	stage = HLIR_VALUE_STAGE_RUNTIME

	type = left.type

	if op == HLIR_VALUE_OP_SHL:
		if left.isValueImmediate() and right.isValueImmediate():
			stage = HLIR_VALUE_STAGE_COMPILETIME
			if left.asset != None and right.asset != None:
				asset = int(left.asset << right.asset)

		if type.is_generic():
			need_width = nbits_for_num(asset, signed=False)
			type = type_word_create(width=need_width, ti=x['ti'])
			type.generic = True

		nv = ValueShl(type, left, right, ti=x['ti'])


	else: #if op == HLIR_VALUE_OP_SHR:
		if left.isValueImmediate() and right.isValueImmediate():
			stage = HLIR_VALUE_STAGE_COMPILETIME
			if left.asset != None and right.asset != None:
				asset = int(left.asset >> right.asset)

		if type.is_generic():
			need_width = nbits_for_num(asset, signed=False)
			type = type_word_create(width=need_width, ti=x['ti'])
			type.generic = True

		nv = ValueShr(type, left, right, ti=x['ti'])

	nv.set_asset(asset)
	nv.stage = stage
	return nv


def do_value_bin(x):
	op = x['kind']
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	return do_value_bin_op(op, l, r, x['ti'])


def do_value_bin_op(op, l, r, ti):
	if l.isValueBad() or r.isValueBad():
		return ValueBad(ti)

	if l.is_value_undefined() or r.is_value_undefined():
		t = Type.select_common_type(l.type, r.type, ti)
		return ValueUndef(l.type)

	# Ops with different types
	if op == HLIR_VALUE_OP_ADD:
		if l.type.is_array() and r.type.is_array():
			return value_array_concat(l, r, ti)
		elif l.type.is_string() and r.type.is_string():
			return value_string_concat(l, r, ti)

	# Check type is valid for the operation

	if not l.type.supports(op):
		error("unsuitable value type for '%s' operation" % op, l.ti)
		return ValueBad(ti)

	if not r.type.supports(op):
		error("unsuitable value type for '%s' operation" % op, r.ti)
		return ValueBad(ti)



	#
	# Now and further types must be equal (!)
	#

	t = Type.select_common_type(l.type, r.type, ti)
	if t == None:
		error("different types in operation", ti)
		print("left type  = ", end='')
		Type.print(l.type)
		print()
		print("right type = ", end='')
		Type.print(r.type)
		print()
		return ValueBad(ti)


	l = value_cons_implicit(t, l)
	r = value_cons_implicit(t, r)

	if l.isValueBad() or r.isValueBad():
		return ValueBad(ti)

	if not Type.eq(l.type, r.type, []):
		error("different types in binary operation", ti)
		# print: @@ <left_type> & <right_type> @@
		print(color_code(CYAN), end='')
		print('@@ ', end='')
		Type.print(l.type)
		print(" & ", end='')
		Type.print(r.type)
		print(' @@', end='')
		print(color_code(ENDC), end='')
		print("\n")
		return ValueBad(ti)

	#if Type.eq(t, typeBool):
	#	if op == HLIR_VALUE_OP_OR: op = HLIR_VALUE_OP_LOGIC_OR
	#	elif op == HLIR_VALUE_OP_AND: op = HLIR_VALUE_OP_LOGIC_AND

	if op in EQ_OPS or op in RELATIONAL_OPS:
		t = typeBool



	asset = None
	stage = HLIR_VALUE_STAGE_RUNTIME
	# if left & right are immediate, we can fold const
	# and append field .asset to bin_value
	if l.isValueImmediate() and r.isValueImmediate():
		stage = HLIR_VALUE_STAGE_COMPILETIME
		if l.asset != None and r.asset != None:  # protection from ValueUndef
			asset = do_bin_immediate(op, l, r, ti)

		need_width = nbits_for_num(asset, signed=t.is_signed())

		if t.is_integer():
			t = type_integer_create(width=need_width, ti=ti)
		else:
			if need_width > t.width or (not t.is_signed() and asset < 0):
				error("integer overflow", ti)


	nv = ValueBin(t, op, l, r, ti=ti)
	nv.set_asset(asset)
	nv.stage = stage

	return nv


def do_bin_immediate(op, l, r, ti):
	if op == HLIR_VALUE_OP_DIV and r.asset == 0:
		error("division by zero", ti)
		return 0

	ops = {
		HLIR_VALUE_OP_LOGIC_OR: lambda a, b: a or b,
		HLIR_VALUE_OP_LOGIC_AND: lambda a, b: a and b,
		HLIR_VALUE_OP_BITWISE_OR: lambda a, b: a | b,
		HLIR_VALUE_OP_BITWISE_AND: lambda a, b: a & b,
		HLIR_VALUE_OP_BITWISE_XOR: lambda a, b: a ^ b,
		HLIR_VALUE_OP_LT: lambda a, b: a < b,
		HLIR_VALUE_OP_GT: lambda a, b: a > b,
		HLIR_VALUE_OP_LE: lambda a, b: a <= b,
		HLIR_VALUE_OP_GE: lambda a, b: a >= b,
		HLIR_VALUE_OP_ADD: lambda a, b: a + b,
		HLIR_VALUE_OP_SUB: lambda a, b: a - b,
		HLIR_VALUE_OP_MUL: lambda a, b: a * b,
		HLIR_VALUE_OP_DIV: lambda a, b: l.asset / r.asset,
		HLIR_VALUE_OP_REM: lambda a, b: a % b,
	}

	if (op == HLIR_VALUE_OP_DIV) and l.type.is_rational() and (r.asset == 0):
		error("division by zero", ti)
		return ValueBad(ti)

	asset = None
	if op in [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE]:
		asset = Value.eq(l, r, ti)
		if op == HLIR_VALUE_OP_NE:
			asset = not asset
	else:
		asset = ops[op](l.asset, r.asset)

	return asset



def do_value_not(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.is_value_undefined():
		return v

	vtype = v.type

# TODO: раздели операцию на logic&bitwise
#	if not vtype.supports(HLIR_VALUE_OP_NOT):
#		error("unsuitable type", v.ti)
#		return ValueBad(x['ti'])

	op = HLIR_VALUE_OP_BITWISE_NOT
	if vtype.is_bool():
		op = HLIR_VALUE_OP_LOGIC_NOT

	nv = ValueNot(vtype, v, ti=x['ti'])

	if v.isValueImmediate():
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		if v.asset != None:  # for ValueUndef
			# because: ~(1) = -1 (not 0) !
			if v.type.is_bool():
				nv.set_asset(not v.asset)
			else:
				nv.set_asset(~v.asset)


	return nv



def do_value_neg(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.is_value_undefined():
		return v

	vtype = v.type

	if not vtype.is_generic():
		if vtype.is_unsigned():
			error("expected value with signed type", v.ti)
	else:
		# is generic type
		vtype.signed = True
		vtype.unsigned = True

	nv = ValueNeg(vtype, v, ti=x['ti'])

	if v.isValueImmediate():
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		if v.asset != None:  # for ValueUndef
			nv.set_asset(-v.asset)

		if nv.type.is_generic():
			if isinstance(v.asset, int):
				nt = type_integer_for(v.asset, ti=v.ti)
			else:
				nt = type_rational_create(ti=v.ti)
			nv.change_type(nt)

	return nv


def do_value_pos(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.is_value_undefined():
		return v

	vtype = v.type

	if vtype.is_unsigned():
		error("expected value with signed type", v.ti)

	nv = ValuePos(vtype, v, ti=x['ti'])

	if v.isValueImmediate():
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		if v.asset != None:  # for ValueUndef
			nv.set_asset(+v.asset)

	if nv.type.is_generic():
		if isinstance(v.asset, int):
			nt = type_integer_for(v.asset, ti=v.ti)
		else:
			nt = type_rational_create(v.asset, ti=v.ti)
		nv.change_type(nt)

	return nv


def do_value_ref(x):
	v = do_value(x['value'])

	# FIXIT: Сейчас сам факт того что взяли указатель на переменную считается тем что она инициализирована,
	# что конечно неверно, но пока так. Однажды нужно придумать как проверить судьбу этого указателя.
	v.is_initialized = True

	if v.isValueBad() or v.is_value_undefined():
		return v

	ti = x['ti']
	op = x['kind']
	vtype = v.type

	if v.isValueImmutable():
		if not vtype.is_func() or vtype.is_incompleted():
			error("expected mutable value or function", v.ti)
			return ValueBad(ti)

	nv = ValueRef(v, ti=ti)
	if v.storage_class == HLIR_VALUE_STORAGE_CLASS_GLOBAL:
		nv.stage = HLIR_VALUE_STAGE_LINKTIME
	return nv


def do_value_new(x):
	v = do_value(x['value'])

	if v.isValueBad() or v.is_value_undefined():
		return ValueBad(x['ti'])

	if not v.type.is_aggregate():
		error("operation new requires value with aggregate type", v.ti)
		return ValueBad(x['ti'])

	# for C backend, because C cannot do lengthof(x)
	cmodule_use('use_malloc')

	nv = ValueNew(v)
	return nv


def do_value_deref(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.is_value_undefined():
		return v

	vtype = v.type
	if not vtype.is_pointer():
		error("expected pointer value", v.ti)
		return ValueBad(x['ti'])

	# you can't deref:
	#   - pointer to Unit
	#   - pointer to function
	#   - pointer to open array
	to = vtype.to
	is_func_ptr = to.is_func()
	is_free_ptr = to.is_free_pointer()
	is_open_array_ptr = to.is_open_array()
	is_vla = to.is_vla()
	if is_func_ptr or is_free_ptr or is_open_array_ptr:# or is_vla:
		error("cannot dereference the pointer", v.ti)

	nv = ValueDeref(v, ti=x['ti'])
	return nv




def do_value_lengthof_value(x):
	ti = x['ti']
	arg = do_value(x['value'])

	if arg.isValueBad() or arg.is_value_undefined():
		return arg

	if not (arg.type.is_array() or arg.type.is_string()):
		error("expected value with array type", x['value']['ti'])
		return ValueBad(ti)

	# for C backend, because C cannot do lengthof(x)
	cmodule_use('use_lengthof')

	return ValueLengthofValue(arg, ti)


def do_value_lengthof_type(x):
	ti = x['ti']
	t = do_type(x['type'])

	if t.is_bad(): #or arg.is_value_undefined():
		return ValueBad(ti)

	if not t.is_array():
		error("expected array type", x['type']['ti'])
		return ValueBad(ti)

	# for C backend, because C cannot do lengthof(x)
	cmodule_use('use_lengthof')

	return ValueLengthofType(t, ti)


def do_value_va_start(x):
	args = x['values']
	va_list = do_value(args[0])
	va_list.is_initialized = True
	last_param = do_rvalue(args[1])
	nv = ValueVaStart(typeUnit, va_list, last_param, x['ti'])
	return nv


def do_value_va_arg(x):
	va_list = do_value(x['va_list'])
	type = do_type(x['type'])
	nv = ValueVaArg(type, va_list, x['ti'])
	return nv


def do_value_va_end(x):
	va_list = do_value(x['value'])
	nv = ValueVaEnd(typeUnit, va_list, x['ti'])
	return nv


def do_value_va_copy(x):
	args = x['values']
	va_list0 = do_value(args[0])
	va_list1 = do_value(args[1])
	nv = ValueVaCopy(typeUnit, va_list0, va_list1, x['ti'])
	return nv


def do_value_defined_type(x):
	t = ctx_type_get(x['type']['id'].str)
	return t != None


def do_value_defined_value(x):
	v = ctx_value_get(x['value']['id'].str)
	return v != None


# проверяет и выполняет приведение при передаче значения
# - при присваивании
# - при передаче аргумента в функцию
# - при возарате значения из функции
def transmission(to_type, value, ti):
	return value_cons_implicit_check(to_type, value)




def do_value_call(x):
	fn = do_rvalue(x['left'])

	if fn.isValueBad() or fn.is_value_undefined():
		return fn

	if fn.isValueBad():
		#error("undefined value", fn.ti)
		return ValueBad(x['ti'])

	ftype = fn.type

	# pointer to function?
	if ftype.is_pointer():
		ftype = ftype.to

	if not ftype.is_func():
		error("expected function or pointer to function", x['ti'])
		return ValueBad(x['ti'])

	params = ftype.params

	npars = len(params)
	nargs = len(x['args'])

	if nargs > npars:
		if not ftype.extra_args:
			error("too many arguments", x['ti'])
			return ValueBad(x['ti'])


	def do_arg(param, arg, named=False):
		arg = transmission(param.type, arg, arg.ti)
		ini = Initializer(param.id, arg, named=named, ti=arg.ti, nl=arg.nl)
		return ini


	sorted_args = []

	#
	# process positional args
	#

	# Сперва обработаем позиционные аргументы
	# Для которых существует соотв. параметр
	i = 0
	while i < nargs and i < npars:
		param = params[i]
		#p_id_str = param.id.str
		a = x['args'][i]
		if a['key'] != None:
			break
		av = do_rvalue(a['value'])
		arg = do_arg(param, av)
		sorted_args.append(arg)
		i += 1

	# проверим все именованные аргументы на наличие одноименного параметра
	u = 0
	while u < nargs:
		a = x['args'][u]
		if a['key']:
			param_found = False
			for p in params:
				if p.id.str == a['key']['str']:
					param_found = True
					break
			if not param_found:
				error("unknown argument '%s'" % a['key']['str'], a['ti'])
		u += 1

	# для каждого парамерта ищем соотв. именованный аргумент
	# идем по порядку и формируем список передвавемых аргументов

	args_is_ct = True

	#
	# process named args
	#
	j = i
	while j < npars:
		param = params[j]
		p_id_str = param.id.str
		k = i
		found = False
		while k < nargs:
			a = x['args'][k]
			if a['key'] == None:
				error("positional argument follows keyword argument", a['ti'])
				break
			if param.id.str == a['key']['str']:
				found = True
				break
			k += 1


		vx = param.init_value
		if found:
			vx = do_rvalue(a['value'])
			if vx.stage != HLIR_VALUE_STAGE_COMPILETIME:
				args_is_ct = False
		else:
			if vx.is_value_undefined():
				error("unspecified parameter '%s'" % p_id_str, x['ti'])
		arg = do_arg(param, vx, named=True)
		sorted_args.append(arg)
		j += 1


	if len(sorted_args) < npars:
		error("not enough arguments", x['ti'])
		return ValueBad(x['ti'])

	#
	# process extra args
	#

	i = j

	# extra_args rest args
	while i < nargs:
		yy = x['args'][i]
		a = yy['value']
		arg = do_rvalue(a)

		if arg.stage != HLIR_VALUE_STAGE_COMPILETIME:
			args_is_ct = False

		if not arg.isValueBad():
			if arg.type.is_generic():
				warning("extra argument with generic type", a['ti'])
			arg = value_cons_extra_arg(arg)

			if arg.isValueRuntime():
				imm_args = False

			ini = Initializer(None, arg, ti=yy['ti'], nl=yy['nl'])
			sorted_args.append(ini)

		i += 1


	nv = ValueCall(ftype.to, fn, sorted_args, ti=x['ti'])

	if False:
		if fn.is_pure and args_is_ct:
			ct_call(fn, sorted_args, x['ti'])
			# Для композитных пока не делаем! Чет в принтере ломается
			if not nv.type.is_unit():
				nv.stage = HLIR_VALUE_STAGE_COMPILETIME
				if nv.type.is_aggregate():
					nv.set_asset([])
				else:
					nv.set_asset(0)


	# (!) Вызов функцией нечистой функции делает ее так же нечистой (!)
	if cfunc != None and not fn.is_pure:
		cfunc.is_pure = False

	return nv


def ct_call(fn, args, ti):
	warning("compile time call not implemented, will returned zero value!", ti)
	context_push()
	#create_params(fn)
	# 1. Формируем параметры в контексте (!)
	params = fn.type.params
	i = 0
	while i < len(params):
		#arg = args[i]
		param = params[i]
		param_value = ValueConst(param.type, param.id, init_value=ValueUndef(param.type), ti=param.ti)
		param_value.storage_class = HLIR_VALUE_STORAGE_CLASS_PARAM
		param_value.set_asset(args[i].value.asset)  # (!)
		ctx_value_add(param.id.str, param_value, is_public=False)
		i += 1

	# 2. Теперь обрабатываем блок функции

	for stmt in fn.definition.stmt.stmts:
		if stmt.is_stmt_return():
			print(stmt.value)

	context_pop()


def do_value_index(x):
	left = do_value(x['left'])

	if left.isValueBad():
		return ValueBad(x['ti'])

	if left.is_value_undefined():
		return ValueUndef(Type(x['ti']), x['ti'])

	left_type = left.type
	via_pointer = left_type.is_pointer()

	array_type = left_type
	if via_pointer:
		array_type = left_type.to

	if not array_type.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])

	# Can index *[]AnyNonArrayType
	# Can't index *[][]AnyType
	if array_type.is_array_of_open_array():
		error("cannot index an array of open array", x['ti'])
		return ValueBad(x['ti'])

	index = do_rvalue(x['index'])

	if array_type.is_generic() and index.isValueRuntime():
		error("cannot index array with generic type in runtime", x['ti'])

	#if index.isValueBad():
	if index.type.is_bad():
		return ValueBad(x['ti'])

	if not (index.type.is_int() or index.type.is_nat() or index.type.is_integer()):
		error("expected integral value", index.ti)
		return ValueBad(x['ti'])

	if index.type.is_generic():
		index = value_cons_implicit_check(typeSysInt, index)

	nv = ValueIndex(array_type.of, left, index, ti=x['ti'])

	if not left.type.is_pointer():
		nv.is_immutable = left.is_immutable
		array_type = left.type

		if left.isValueImmediate() and index.isValueImmediate():
			index_imm = index.asset

			if index_imm >= array_type.volume.asset:
				error("array index out of bounds", x['ti'])
				return ValueBad(x['ti'])

			if index_imm < len(left.asset):
				item = left.asset[index_imm]
			else:
				item = create_zero_literal(array_type.of)

			Value.cp_immediate(nv, item)
			nv.stage = HLIR_VALUE_STAGE_COMPILETIME
			return nv

	return nv


def do_value_slice(x):
	ti = x['ti']

	left = do_value(x['left'])
	if left.isValueBad():
		return ValueBad(x['ti'])

	index_from = None
	index_to = None

	if x['index_from'] != None:
		index_from = do_rvalue(x['index_from'])
		if index_from.isValueBad():
			return ValueBad(ti)
	else:
		index_from = valueZeroNumber()

	if x['index_to'] != None:
		index_to = do_rvalue(x['index_to'])
		if index_to.isValueBad():
			return ValueBad(ti)
	else:
		index_to = ValueUndef(type_integer_create(ti=x['ti']))

	via_pointer = left.type.is_pointer()
	array_type = left.type
	if via_pointer:
		array_type = left.type.to

	if not array_type.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])


	# Can slice *[]AnyNonArrayType
	# Can't slice *[][]AnyType
	if array_type.is_array_of_open_array():
		error("cannot slice array of an open array", x['ti'])
		return ValueBad(x['ti'])


	# получаем размер слайса
	# строим выражения для C бекенда в частности
	# тк volume of array должен быть выражением
	# а для слайса [a:b] это (b - a)
	slice_volume = do_value_bin_op(HLIR_VALUE_OP_SUB, index_to, index_from, x['ti'])

	if not (slice_volume.is_value_undefined() or slice_volume.is_value_undefined()):
		if slice_volume.isValueImmediate():
			if slice_volume.asset < 0:
				error("wrong slice direction", x['ti'])
				return ValueBad(x['ti'])

	type = TypeArray(array_type.of, slice_volume, generic=False, ti=x['ti'])
	nv = ValueSlice(type, left, index_from, index_to, x['ti'])
	if not left.type.is_pointer():
		nv.is_immutable = left.is_immutable
	return nv



def is_import_name(id_str):
	return id_str in cmodule.imports_private or id_str in cmodule.imports_public


def submodule_access(x):
	global cmodule

	mname = x['left']['str']
	iname = x['right']['str']
	ti = x['ti']

	imp = cmodule.imports_public[mname]
	submodule = imp.module

	v = submodule.value_get_public(iname)
	if v == None:
		v = submodule.value_get_private(iname)
		if v == None:
			error("access to undeclared value", x['ti'])
		else:
			error("attempt to access to private value", ti)
		return ValueBad(x['ti'])

	if v.type.is_incompleted():
		v = value_update_incompleted_type(submodule, v, iname)

	nv = ValueAccessModule(v.type, x['left'], x['right'], v, ti=x['ti'])
	nv.stage = v.stage
	return nv



def do_value_access(x):
	global cmodule
	#info("do_value_access", x['ti'])


	left = x['left']
	path = x['path']

	module = None

	if left['kind'] == 'id':
		left_val = ctx_value_get(left['str'])

		# если в контексте нет такого значения, то возможно это импорт и нужно пройти по пути импорта
		if left_val == None:
			i = 0
			# Сперва походим часть пути что импорты
			# и формируем module + left + path
			if is_import_name(left['str']):
				#info("left is imp", left['ti'])
				module = cmodule
				imp = module.get_import(left['str'], with_private=True)

				while imp != None:
					module = imp.module
					#print("FOUND MODULE", str(module))
					impstr = path[i]
					imp = module.get_import(impstr['str'], with_private=True) #False!
					if imp == None:
						break
					i += 1
				left = path[i]#['str']

			path = path[i+1:]

			if module == None:
				error("unknown entity '%s'" % left['str'], left['ti'])
				return ValueBad(x['ti'])

			left_val = module.value_get_public(left['str'])
	else:
		left_val = do_value(left)

	# идем дальше
	# left_val = None
	# if module != None:
	# 	left_val = module.value_get_public(left['str'])
	# else:
	# 	left_val = ctx_value_get(left['str'])

	if left_val == None:
		error("left not found", left['ti'])
		return ValueBad(x['ti'])

	if len(path) == 0:
		#print("FOUND: " + left['str'])
		return left_val


	for field_id in path:
		#print("P: " + str(field_id))
		left_val = acc(left_val, field_id, ti=None)  # ti ????

	return left_val



def acc(left, field_id, ti):
	#print("LEF = " + str(left))
	#print("ACC to " + field_id['str'])

	# доступ через переменную-указатель
	via_pointer = left.type.is_pointer()

	record_type = left.type
	if via_pointer:
		record_type = left.type.to

	# check if is record
	if not record_type.is_record():
		error("expected record or pointer to record", left.ti)
		return ValueBad(ti)

	field = TypeRecord.record_field_get(record_type, field_id['str'])

	# if field not found
	if field == None:
		error("undefined field '%s'" % field_id['str'], field_id['ti'])
		return ValueBad(ti)

	if field.type.is_bad():
		return ValueBad(ti)

	# Check access permissions

	# не у всех типов есть 'definition' (его нет у анонимных записей например)
	if not is_local_entity(record_type):
		if field.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
			error("access to private field of record", field.ti)#x['right']['ti'])

	nv = ValueAccessRecord(field.type, left, field, ti=ti)

	if not left.type.is_pointer():
		nv.is_immutable = left.is_immutable

	if left.isValueImmediate() and not via_pointer:
		initializer = get_item_by_id(left.asset, field_id['str'])
		Value.cp_immediate(nv, initializer.value)

	return nv


def do_value_cons(x):
	v = do_rvalue(x['value'])
	if v.isValueBad():
		return ValueBad(x['ti'])

	t = do_type(x['type'])
	if t.is_bad():
		return ValueBad(x['ti'])

	return value_cons_explicit(t, v, x['ti'])



def do_value_id(x):
	id_str = x['str']
	v = ctx_value_get(id_str)

	if v == None:
		error("undefined value '%s'" % id_str, x['ti'])
		# чтобы не генерил ошибки дальше
		# создадим bad value и пропишем его глобально (wrong!)
		v = ValueBad(x['ti'])
		ctx_value_add(id_str, v, is_public=False)
		return v

	# Если в теле функции происходит доступ к глобальной переменной
	# значит она не "чистая"
	if cfunc != None:
		if v.isValueVar() and v.storage_class == HLIR_VALUE_STORAGE_CLASS_GLOBAL:
			cfunc.is_pure = False


	global cdef

	if v.isValueBad():
		return v

	if v.hasAttribute("deprecated"):
		warning("using a deprecated value", x['ti'])

	if v.type.is_incompleted():
		v_upd = value_update_incompleted_type(cmodule, v, v.id.str)

		if v_upd == None:
			error("use of incomplete value", x['ti'])
			return ValueBad(x['ti'])

		cdef.deps.append(v_upd)
		if cfunc != None:
			cfunc.definition.deps.append(v_upd)
		return v_upd

#	if 'usecnt' in v:
#		v['usecnt'] = v['usecnt'] + 1

	return v



def do_value_string(x):
	return value_string_create(x['str'], ti=x['ti'])



# было решено не пытаться приводить generic элементы массива
# к общему знаменателю, а оставить как есть;
# потом, когда массив будет приводиться к конкретному типу
# всплывут ошибки типизации если они есть.
# Сейчас не знаю правильно ли, но вроде так хоть работает

def do_value_array(x):
	#info("do_value_array", x['ti'])
	items = []
	for item in x['items']:
		# skip comments
		#if item['isa'] == 'ast_comment':
		#	continue
		if item['isa'] == 'ast_kv':
			item_value = do_rvalue(item['value'])
			item_value.nl = item['nl']
			items.append(item_value)
	v = value_array_create(items, ti=x['ti'])
	return v


# Создает value с типом GenericRecord
# которое далее уже можно привести к конкретной записи
def do_value_record(x):
	#info("do_value_record", x['ti'])
	initializers = []
	for item in x['items']:
		# skip comments
		if item['isa'] == 'ast_comment':
			continue

		if item['isa'] == 'ast_kv':
			item_value = do_rvalue(item['value'])
			p = Initializer(
				do_id(item['key']),
				item_value,
				ti=item['ti'],
				nl=item['nl']
			)
			initializers.append(p)

	v = value_record_create(initializers, ti=x['ti'])
	return v



def do_value_number(x):
	if '.' in x['str']:
		return do_value_rational(x)

	return do_value_integer(x)



def do_value_integer(x):
	base = 10
	s = x['str']
	num_string_len = len(s)
	if num_string_len > 2 and x['str'][0:2] == '0x':
		num_string_len -= 2
		base = 16

	num = int(s, base)
	if nbits_for_num(num) > 64:
		cmodule_use('use_bigint')

	v = value_integer_create(num, ti=x['ti'])
#	if base == 10:
#		v = value_integer_create(num, ti=x['ti'])
#	else:
#		v = value_word_create(num, x['ti'])

	v.nsigns = num_string_len

	if base == 16:
		v.addAttribute('hexadecimal', {})

	return v



def do_value_rational(x):
	return value_rational_create(x['str'], ti=x['ti'])


def do_value_sizeof_type(x):
	t = do_type(x['type'])
	return ValueSizeofType(t, ti=x['ti'])


def do_value_sizeof_value(x):
	v = do_value(x['value'])
	return ValueSizeofValue(v, ti=x['ti'])



def do_value_alignof_type(x):
	of = do_type(x['type'])
	return ValueAlignofType(of, ti=x['ti'])


def do_value_alignof_value(x):
	of = do_value(x['value'])
	return ValueAlignofValue(of, ti=x['ti'])


def do_value_offsetof(x):
	of = do_type(x['type'])
	field_id = do_id(x['field'])
	return ValueOffsetof(of, field_id, ti=x['ti'])



bin_ops = [
	HLIR_VALUE_OP_LOGIC_OR, HLIR_VALUE_OP_LOGIC_AND,
	HLIR_VALUE_OP_BITWISE_OR, HLIR_VALUE_OP_BITWISE_XOR, HLIR_VALUE_OP_BITWISE_AND,
	HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE, HLIR_VALUE_OP_LT, HLIR_VALUE_OP_GT, HLIR_VALUE_OP_LE, HLIR_VALUE_OP_GE,
	HLIR_VALUE_OP_ADD, HLIR_VALUE_OP_SUB, HLIR_VALUE_OP_MUL, HLIR_VALUE_OP_DIV, HLIR_VALUE_OP_REM
]


def do_value_immediate(x, allow_ptr_to_str=False):
	v = do_value(x)

	if v.isValueBad():
		return v

	if not v.isValueImmediate():
		if allow_ptr_to_str:
			if v.type.is_pointer_to_str():
				return v
		error("expected immediate value2", x['ti'])
		return ValueBad(x['ti'])

	return v


def do_value_immediate_string(x):
	v = do_value_immediate(x)

	if v.isValueBad():
		return v

	if not v.type.is_string():
		error("expected string value", x['ti'])

	return v



def do_value_unsafe(x):
	if not cmodule.hasAttribute('unsafe'):
		error("for use 'unsafe' operator required -funsafe option", x['ti'])

	global unsafe_mode
	prev_unsafe_mode = unsafe_mode
	unsafe_mode = True
	rv = do_rvalue(x['value'])
	unsafe_mode = prev_unsafe_mode
	return rv


def do_value_bad(x):
	return ValueBad(x['ti'])


def do_value_undefined(x):
	#t = TypeBad(x['ti'])
	t = TypeUndefined(x['ti'])
	return ValueUndef(t, x['ti'])


def do_rvalue(x):
	v = do_value(x)
	if not v.is_initialized:
		error("attempt to use an uninitialized value", x['ti'])
	return v


def do_value_subexpr(x):
	v = do_value(x['value'])
	if v.isValueBad():
		return ValueBad(x['ti'])
	nv = ValueSubexpr(v, ti=x['ti'])
	Value.cp_immediate(nv, v)
	return nv




def do_value(x):
	assert(x['isa'] == 'ast_value')
	v = None

	k = x['kind']
	if k == 'id': v = do_value_id(x)
	elif k == 'number': v = do_value_number(x)
	elif k == 'string': v = do_value_string(x)
	elif k == 'record': v = do_value_record(x)
	elif k == 'array': v = do_value_array(x)
	elif k == HLIR_VALUE_OP_CONS: v = do_value_cons(x)
	elif k == HLIR_VALUE_OP_CALL: v = do_value_call(x)
	elif k in bin_ops: v = do_value_bin(x)
	elif k == HLIR_VALUE_OP_REF: v = do_value_ref(x)
	elif k == HLIR_VALUE_OP_LOGIC_NOT: v = do_value_not(x)
	elif k == HLIR_VALUE_OP_BITWISE_NOT: v = do_value_not(x)
	elif k == HLIR_VALUE_OP_DEREF: v = do_value_deref(x)
	elif k == HLIR_VALUE_OP_INDEX: v = do_value_index(x)
	elif k == HLIR_VALUE_OP_SLICE: v = do_value_slice(x)
	elif k == HLIR_VALUE_OP_ACCESS: v = do_value_access(x)
	elif k == HLIR_VALUE_OP_NEG: v = do_value_neg(x)
	elif k == HLIR_VALUE_OP_POS: v = do_value_pos(x)
	elif k == HLIR_VALUE_OP_SHL: v = do_value_shift(x)
	elif k == HLIR_VALUE_OP_SHR: v = do_value_shift(x)
	elif k == HLIR_VALUE_OP_NEW: v = do_value_new(x)  # just experimental
	elif k == HLIR_VALUE_OP_UNSAFE: v = do_value_unsafe(x)
	elif k == HLIR_VALUE_OP_SUBEXPR: v = do_value_subexpr(x)
	elif k == HLIR_VALUE_OP_SIZEOF_TYPE: v = do_value_sizeof_type(x)
	elif k == HLIR_VALUE_OP_SIZEOF_VALUE: v = do_value_sizeof_value(x)
	elif k == HLIR_VALUE_OP_ALIGNOF_TYPE: v = do_value_alignof_type(x)
	elif k == HLIR_VALUE_OP_ALIGNOF_VALUE: v = do_value_alignof_value(x)
	elif k == HLIR_VALUE_OP_OFFSETOF: v = do_value_offsetof(x)
	elif k == HLIR_VALUE_OP_LENGTHOF_VALUE: v = do_value_lengthof_value(x)
	elif k == HLIR_VALUE_OP_LENGTHOF_TYPE: v = do_value_lengthof_type(x)
	elif k == HLIR_VALUE_OP_VA_ARG: v = do_value_va_arg(x)
	elif k == HLIR_VALUE_OP_VA_START: v = do_value_va_start(x)
	elif k == HLIR_VALUE_OP_VA_END: v = do_value_va_end(x)
	elif k == HLIR_VALUE_OP_VA_COPY: v = do_value_va_copy(x)
	elif k == HLIR_VALUE_OP_DEFINED_TYPE: v = do_value_defined_type(x)
	elif k == HLIR_VALUE_OP_DEFINED_VALUE: v = do_value_defined_value(x)
	elif k == 'undefined': v = do_value_undefined(x)
	elif k == 'bad': v = do_value_bad(x)

	assert(v != None)
	v.ti = x['ti']
	return v.add_atts(x['anno'])


#
# Do Statement
#


def do_stmt_const(x):
	global cfunc
	if id_already_used(x['id']['str'], shallow=True):
		error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])
	df = def_const_common(x)
	df.parent = cfunc
	df.value.parent = cfunc
	df.value.storage_class = HLIR_VALUE_STORAGE_CLASS_LOCAL
	return df



def do_stmt_var(x):
	#info("do_stmt_var", x['ti'])
	global cfunc

	if id_already_used(x['id']['str'], shallow=True):
		error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])

	df = def_var_common(x)

	if df.is_stmt_bad():
		return df

	df.value.storage_class = HLIR_VALUE_STORAGE_CLASS_LOCAL
	df.parent = cfunc

	for a in x['anno']:
		if a['kind'] == 'static':
			df.addAttribute('static')

	return df



def do_stmt_if(x):
	cond = do_rvalue(x['cond'])

	if cond.isValueBad():
		return StmtBad(x['ti'])

	if not cond.type.is_bool():
		error("expected value with Bool type", cond.ti)
		return StmtBad(x['ti'])

	_then = do_stmt(x['then'])

	if _then.is_stmt_bad():
		return StmtBad(x['ti'])

	_else = None
	if x['else'] != None:
		_else = do_stmt(x['else'])
		if _else.is_stmt_bad():
			return StmtBad(x['else'])

	return StmtIf(cond, _then, _else, ti=x['ti'])



def do_stmt_while(x):
	cond = do_rvalue(x['cond'])

	if cond.isValueBad():
		return StmtBad(x['ti'])

	if not cond.type.is_bool():
		error("expected value with Bool type", cond.ti)
		return StmtBad(x['ti'])

	block = do_stmt(x['stmt'])

	if block.is_stmt_bad():
		return StmtBad(x['ti'])

	return StmtWhile(cond, block, ti=x['ti'])



def do_stmt_return(x):
	global cfunc

	func_ret_type = cfunc.type.to
	#ret_val_present = x['value'] != None

	# если забыли вернуть значение
	# или возвращаем его там, где оно не ожидется
#	is_no_ret_func = func_ret_type.is_unit()
#	if ret_val_present == is_no_ret_func:
#		if ret_val_present:
#			error("unexpected return value", x['value']['ti'])
#		else:
#			error("expected return value", x['ti'])
#		return StmtBad(x['ti'])

	# (!) in return statement retval can be None (!)
	retval = None
	if x['value'] != None:
		rv = do_rvalue(x['value'])
		retval = transmission(func_ret_type, rv, rv.ti)
	elif not cfunc.type.to.is_unit():
		error("expected return value", x['ti'])

	return StmtReturn(retval, ti=x['ti'])


def do_stmt_type(x):
	nt = Type(x['ti'])
	df = def_type_common(x, nt)
	df.id.llvm = cfunc.id.str + '.' + df.id.str
	ctx_type_add(df.id.str, nt, is_public=False)
	cfunc.typedefs.append(df)
	return df


def do_stmt_again(x):
	return StmtAgain(x['ti'])


def do_stmt_break(x):
	return StmtBreak(x['ti'])



def do_stmt_assign(x):
	l = do_value(x['left'])
	r = do_rvalue(x['right'])

	if l.isValueBad() or r.isValueBad():
		return StmtBad(x['ti'])

	if not l.isLvalue():
		error("expected lvalue", l.ti)
		return StmtBad(x['ti'])

	if l.isValueImmutable():
		error("expected mutable value", l.ti)
		return StmtBad(x['ti'])

	if l.isValueVar():
		l.is_initialized = True
	elif l.isValueIndex() or l.isValueAccessRecord():
		# FIXIT: Пока считаем что если мы присвоили что то элементу массива или записи
		# значит их (массив/запись) можно считать инициализированными, но это конечно полуправда
		l.left.is_initialized = True

# Есть проблема - generic массив справа неявно приводится к типу массива слева
# и как следствие right имеет тип левого (из ValueLiteral он превращается в ValueCons)
# НО ведь в коде реально right может иметь другой тип, и это приводит к пиздецу..
# (кароче присваивание generic массива )
#	if l.type.is_array() and r.type.is_array():
#		if l.type.of.get_size() != r.type.of.get_size():
#			cmodule_use('use_lengthof')
#			cmodule_use('use_arrcpy')
# поэтому пока ВСЕГДА использую ARRCPY
	if l.type.is_array() and r.type.is_array():
		if l.type.of.get_size() != r.type.of.get_size():
			if not r.isValueZero():
				cmodule_use('use_lengthof')
				cmodule_use('use_arrcpy')


	r = transmission(l.type, r, x['ti'])
	return StmtAssign(l, r, ti=x['ti'])



def do_stmt_incdec(x, op=HLIR_VALUE_OP_ADD):
	v = do_value(x['value'])

	if v.isValueBad():
		return StmtBad(x['ti'])

	if v.isValueImmutable():
		error("expected mutable value", v.ti)
		return StmtBad(x['ti'])

	if not (v.type.is_int() or v.type.is_nat()):
		error("expected value with integer type", v.ti)
		return StmtBad(x['ti'])

	one = ValueLiteral(v.type, 1, ti=x['ti'])
	nv = ValueBin(v.type, op, v, one, ti=x['ti'])
	return StmtAssign(v, nv, ti=x['ti'])



def do_stmt_value(x):
	v = do_rvalue(x['value'])

	if v.isValueBad():
		return StmtBad(x['ti'])

	if not v.type.is_unit():
		if not v.type.hasAttribute('unused'):
			#warning("unused result of %s expression" % x['value']['kind'], v.ti)
			pass

	return StmtValueExpression(v, ti=x['ti'])



def do_stmt_comment(x):
	if x['kind'] == 'comment-line':
		return do_stmt_comment_line(x)
	elif x['kind'] == 'comment-block':
		return do_stmt_comment_block(x)
	return None


def do_stmt_comment_line(x):
	lines = []
	for xl in x['lines']:
		lines.append(xl)
	return StmtCommentLine(lines, ti=x['ti'], nl=x['nl'])


def do_stmt_comment_block(x):
	return StmtCommentBlock(x['text'], ti=x['ti'], nl=x['nl'])



def do_stmt_asm(x):
	# asm реализован как вызов функции:
	# __asm(
	#	"add %0, %1, %2",       // asm text
	#	[["=r", sum]],          // outputs
	#	[["r", a], ["r", b]],   // inputs
	#	["cc"]                  // clobbers
	# )
	#
	xargs = x['args']

	asm_text = do_rvalue(xargs[0]['value'])

	xoutputs = xargs[1]['value']
	xinputs = xargs[2]['value']
	xclobbers = xargs[3]['value']

	outputs = []
	for x in xoutputs['items']:
		items = x['value']['items']
		spec = do_rvalue(items[0]['value'])
		val = do_value(items[1]['value'])
		val.is_initialized = True
		pair = (spec, val)
		outputs.append(pair)

	inputs = []
	for x in xinputs['items']:
		items = x['value']['items']
		spec = do_rvalue(items[0]['value'])
		val = do_rvalue(items[1]['value'])
		pair = (spec, val)
		inputs.append(pair)

	clobbers = []
	for x in xclobbers['items']:
		spec = do_rvalue(x['value'])
		clobbers.append(spec)

	return StmtAsm(asm_text, outputs, inputs, clobbers, x['ti'])



def do_stmt(x):
	s = None

	k = x['kind']
	if k == 'value': s = do_stmt_value(x)
	elif k == 'assign': s = do_stmt_assign(x)
	elif k == 'const': s = do_stmt_const(x)
	elif k == 'var': s = do_stmt_var(x)
	elif k == 'block': s = do_stmt_block(x)
	elif k == 'if': s = do_stmt_if(x)
	elif k == 'while': s = do_stmt_while(x)
	elif k == 'return': s = do_stmt_return(x)
	elif k == 'again': s = do_stmt_again(x)
	elif k == 'break': s = do_stmt_break(x)
	elif k == 'inc': s = do_stmt_incdec(x, HLIR_VALUE_OP_ADD)
	elif k == 'dec': s = do_stmt_incdec(x, HLIR_VALUE_OP_SUB)
	elif k == 'type': s = do_stmt_type(x)
	elif k == 'comment-line':
		print("------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		s = do_stmt_comment_line(x)
	elif k == 'comment-block': s = do_stmt_comment_block(x)
	elif k == 'asm': s = do_stmt_asm(x)
	else: s = StmtBad(x['ti'])

	assert(s != None)
	s.nl = x['nl']

	if 'comment' in x and x['comment'] != None:
		s.comment = do_stmt_comment(x['comment'])


	#for a in x['anno']:
	#	if x['kind'] == 'static':

	return s



def do_stmt_block(x, parent=None):
	context_push()

	block = StmtBlock([], ti=x['ti'])
	block.parent = parent

	stmts = []
	for stmt in x['stmts']:
		s = do_stmt(stmt)
		if not s.is_stmt_bad():
			s.parent = block
			block.stmts.append(s)

	context_pop()

	return block



def do_id(x):
	return Id(x['str'], ti=x['ti'])


def def_type_common(x, nt):
	global cmodule
	global cdef

	id = do_id(x['id'])
	definition = StmtDefType(id, nt, None, x['ti'])
	definition.module = cmodule
	definition.parent = cmodule
	definition.access_level = get_access_level(x)
	definition.nl = x['nl']

#	info("%s" % get_access_level(x), x['ti'])

	prev_cdef = cdef
	cdef = definition

	ty = do_type(x['type'])

	is_open_record = False
	if ty.is_record():
		# 'default' -> 'private' &
		# 'default' -> 'public' for @public record
		for f in ty.fields:
			if f.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
				is_open_record = True
			elif f.access_level == HLIR_ACCESS_LEVEL_UNDEFINED:
				if ty.hasAttribute("public"):
					f.access_level = HLIR_ACCESS_LEVEL_PUBLIC
					is_open_record = True
				else:
					f.access_level = HLIR_ACCESS_LEVEL_PRIVATE

	if ty.is_bad():
		return None

	definition.original_type = ty

	# поскольку этот тип здесь связывается с идентификатором
	# он уже не анонимный
	if ty in cmodule.anon_recs:
		cmodule.anon_recs.remove(ty)
	ty.c_anon_id = None

	# Замещаем внутренности undefined типа на тип справа
	# НО! имя даем новое
	deps = nt.deps
	Type.update(nt, ty)
	nt.deps = deps
	nt.id = id

	#info("?%d?" % hasattr(ty, 'id'), x['ti'])

	nt.definition = definition
	nt.parent = cmodule  # добавляем заново тк очистили его выше!
	nt.module = cmodule
	nt.ti_def = id.ti
	nt.is_open_record = is_open_record
	nt.is_open_access = is_open_record or hasattr(ty, 'id')

	# Проверяем если наши прямые зависимости не зависят от нас напрямую
	# Это ошибочная ситуация, так как сложные типы не могут взаимно напрямую включать друг друга
	xdeps = nt.get_dir_deps([])

	if nt in xdeps:
		error("rec dep!", nt.ti)

	for dep in xdeps:
		if dep.is_incompleted():
			error("is_incompleted", dep.ti)

	assert(nt.definition != None)
	cdef = prev_cdef
	return definition




def def_type_global(x):
	# глобальный тип уже был задекларирован при первом проходе,
	# теперь доопределяем его
	nt = ctx_type_get(x['id']['str'])
	if not nt.is_incompleted():
		error("type redefinition", x['ti'])
		return None
	df = def_type_common(x, nt)
	df = def_add_annotations(df, x['anno'])
	return df




def process_field_common(x, allow_cons_default=False):
	var_type = None
	if x['type'] != None:
		var_type = do_type(x['type'])

	init_value = do_rvalue(x['init_value'])

	if var_type != None:
		init_value = value_cons_implicit(var_type, init_value)
		if var_type.is_holed():
			var_type = init_value.type

	else: # var_type == None:
		if init_value.is_value_undefined():
			# ERROR: type & value are undefined!
			nv = ValueBad(x['ti'])
			ctx_value_add(x['id']['str'], nv, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)
			return nv.type, nv

		if allow_cons_default:
			init_value = value_cons_default(init_value)
		var_type = Type.copy(init_value.type)

	# убираем 'const' если есть
	if var_type.hasAttribute('const'):
		var_type = var_type.copy()
		var_type.delAttribute('const')

	return var_type, init_value







# common method for global & local consts
def def_const_common(x):
	global cmodule
	global cdef

	id = do_id(x['id'])
	definition = StmtDefConst(id, const_value=None, init_value=None, ti=x['ti'])
	definition.module = cmodule
	#definition.parent = cmodule
	definition.access_level = get_access_level(x)
	definition.nl = x['nl']

	prev_cdef = cdef
	cdef = definition

	const_type, init_value = process_field_common(x)

	if const_type.is_forbidden_const():
		error("unsuitable type", x['ti'])

	const_type = const_type.copy()
	const_type.addAttribute('const', {})

	const_value = ValueConst(const_type, id, init_value=init_value, ti=id.ti)
	const_value.is_initialized = True#not init_value.is_value_undefined()
	const_value.stage = init_value.stage
	ctx_value_add(id.str, const_value, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)

	if init_value.isValueImmediate():
		Value.cp_immediate(const_value, init_value)

	#definition = StmtDefConst(id, const_value, init_value, x['ti'])
	definition.value = const_value
	definition.init_value = init_value
	const_value.definition = definition

	cdef = prev_cdef
	return definition



def def_var_common(x):
	global cdef

	id = do_id(x['id'])

	definition = StmtDefVar(id, var_value=None, init_value=None, ti=x['ti'])
	definition.module = cmodule
	definition.access_level = get_access_level(x)
	definition.nl = x['nl']

	if definition.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
		if settings['public_vars_forbidden']:
			error("public variables are forbidden", x['ti'])

	prev_cdef = cdef
	cdef = definition

	var_type, init_value = process_field_common(x, allow_cons_default=True)
	if var_type.is_forbidden_var(open_array_forbidden=False):
		error("unsuitable type", x['ti'])

	var_value = ValueVar(var_type, id, init_value=init_value, ti=id.ti)
	var_value.is_initialized = not init_value.is_value_undefined()
	var_value.stage = HLIR_VALUE_STAGE_RUNTIME
	ctx_value_add(id.str, var_value, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)

	definition.value = var_value
	definition.init_value = init_value
	var_value.definition = definition

	cdef = prev_cdef
	return definition





# TODO: centity -> instead cmodule/cfunc;
# rm Value#module -> tree instead

def def_const_global(x):
	global cmodule

	if id_already_used(x['id']['str']):
		error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])

	df = def_const_common(x)
	df.parent = cmodule
	df.value.parent = cmodule
	df.value.storage_class = HLIR_VALUE_STORAGE_CLASS_GLOBAL

	iv = df.init_value
	if not iv.is_value_undefined():
		if iv.isValueRuntime():
			#print(iv.stage)
			print(iv)
			error("expected immediate value", iv.ti)

	df = def_add_annotations(df, x['anno'])
	return df



def def_var_global(x):
	global cmodule

	if id_already_used(x['id']['str']):
		error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])

	df = def_var_common(x)
	df.parent = cmodule
	df.value.parent = cmodule
	df.value.storage_class = HLIR_VALUE_STORAGE_CLASS_GLOBAL
	df.value.is_initialized = True

	df = def_add_annotations(df, x['anno'])
	return df



def create_params(fn):
	params = fn.type.params

	i = 0
	while i < len(params):
		param = params[i]
		param_value = ValueConst(param.type, param.id, init_value=ValueUndef(param.type), ti=param.ti)
		param_value.storage_class = HLIR_VALUE_STORAGE_CLASS_PARAM
		#param_value.stage = HLIR_VALUE_STAGE_RUNTIME
		ctx_value_add(param.id.str, param_value, is_public=False)
		i += 1


def def_func(x):
	global cdef
	global cfunc
	global cmodule

	# значение функции уже существует, (возможно - undefined)
	# тк мы ранее сделали проход
	fn = ctx_value_get(x['id']['str'])

	cdef = fn.definition


	if fn.type.is_incompleted():
		ft = do_type_func(x['type'])
		fn.change_type(ft)
		if fn.type.is_incompleted():
			return None

	if fn.type.is_bad():
		return None

	if fn.id.str == 'main':
		#fn.id.prefix = None
		cdef.addAttribute('nonstatic')
		fn.id.addAttribute('nodecorate')
		fn.id.addAttribute('entrypoint')

	if x['stmt'] == None:
		df = def_add_annotations(fn.definition, x['anno'])
		return df

	# not above (!)
	fn.is_pure = fn.type.is_pure_func()

	context_push()  # create params context

	prev_cfunc = cfunc
	cfunc = fn

	create_params(fn)

#	params = fn.type.params
#
#
#	i = 0
#	while i < len(params):
#		param = params[i]
#		param_value = ValueConst(param.type, param.id, init_value=ValueUndef(param.type), ti=param.ti)
#		param_value.storage_class = HLIR_VALUE_STORAGE_CLASS_PARAM
#		#param_value.stage = HLIR_VALUE_STAGE_RUNTIME
#		ctx_value_add(param.id.str, param_value, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)
#		i += 1

	# for C backend, for #include <stdarg.h>
	if fn.type.extra_args:
		cmodule_use('use_va_arg')

	# check unuse
	#for param in params:
	#	check_unuse(param)

	stmt = None

	if x['stmt'] != None:
		stmt = do_stmt_block(x['stmt'], parent=fn)
		check_block(stmt)

		# check if return present
		if not fn.type.to.is_unit():
			stmts = stmt.stmts
			if len(stmts) == 0:
				warning("expected return operator at end", stmt.ti)
			#elif stmts[-1]['kind'] != 'return':
			elif not stmts[-1].is_stmt_return():
				warning("expected return operator at end", stmt.ti)

	fn.definition.stmt = stmt

	context_pop()  # remove params context
	cfunc = prev_cfunc
	cdef = None

#	if fn.is_pure:
#		info("pure function", x['ti'])

	df = def_add_annotations(fn.definition, x['anno'])
	return df



def check_unuse(v):
	if v == None:
		return

	if not 'usecnt' in v:
		return

	if v['usecnt'] > 0:
		return

	id_str = v['id'].str
	info("value '%s' defined but not used" % id_str, v.ti)



# check block for unused vars
def check_block(block):
	for stmt in block.stmts:
	#	check_stmt(stmt)
		pass



def check_stmt(stmt):
	return
	k = stmt['kind']
	if k == 'let':
		check_unuse(stmt['init_value'])
	elif k == 'def_var':
		check_unuse(stmt['var'])
	elif k == 'if':
		check_block(stmt['then'])
		if stmt['else'] != None:
			check_stmt(stmt['else'])
	elif k == 'while':
		check_block(stmt['stmt'])




import_stack = []

def do_import(x):
	global modules
	global cmodule

	access_level = get_access_level(x)
	#print(access_level)

	import_expr = do_value_immediate_string(x['expr'])

	if import_expr.isValueBad():
		return None

	# Literal string to python string
	impline = import_expr.asset
	#log('do_import("%s")' % impline)

	_as = None
	if x['as'] != None:
		_as = x['as']['str']
	else:
		_as = impline.split("/")[-1]


	abspath = get_import_abspath(impline, ext='.m')
	if abspath == None:
		error("module %s not found" % impline, import_expr.ti)
		return None

	# recursive import protection
	err = False
	pos = 0
	kk = [abspath, cmodule.sourcename, _as]
	ii = len(import_stack) - 1
	while ii >= 0:
		im = import_stack[ii]
		if im[0] == abspath:
			err = True
			pos = ii
		ii -= 1
	if err:
		error("recursive import detected", x['ti'])
		j = pos
		while j < len(import_stack):
			print("    " * (j-pos) + "`-> %s (from '%s')" % (import_stack[j][2], import_stack[j][1]))
			j += 1
		fatal("recursive import '%s'" % abspath)
	import_stack.append(kk)


	m = None

	# Seek in global modules pool
	if abspath in modules:
		m = modules[abspath]

	is_include_form = x['is_include']

	if m == None:
		m = translate(abspath, is_include=is_include_form)
		modules[abspath] = m

		mid = impline.split("/")[-1]

		if m == None:
			fatal("cannot import module")

		if m.hasAttribute('c_no_print'):
			for xx in m.defs:
				xx['anno'].append('c_no_print')

	# recursive import protection
	import_stack.remove(kk)

	if is_include_form:
		# INCLUDE
		# забираем публичные символы
		# и забираем все определения (исключая дубликаты!)

		# public include
		cmodule.symtab_public.extend(m.symtab_public)

		# копируем все c_include из импортированного модуля себе
		# это костыль, но пока так
		for d in m.defs:
			if isinstance(d, StmtDirectiveCInclude):
				cmodule.defs.append(d)

		cmodule.included_modules.append(m)
		return

	y = StmtImport(impline, _as, module=m, ti=x['ti'], include=False)

	if access_level == 'private':
		cmodule.imports_private[_as] = y
	elif access_level == 'public':
		cmodule.imports_public[_as] = y
	else:
		1/0

	return y



def do_directive(x):
	global cmodule
	global global_prefix

	y = None
	if x['kind'] == 'pragma':
		args = x['args']
		s0 = args[0]
		if s0 == 'do_not_include':
			cmodule.addAttribute('do_not_include')
		elif s0 == 'c_include':
			y = StmtDirectiveCInclude(args[1])
		elif s0 == 'c_no_print':
			cmodule.addAttribute('c_no_print')
		elif s0 == 'feature':
			cmodule_feature_add(args[0])
		elif s0 == 'unsafe':
			cmodule_feature_add('unsafe')
		elif s0 == 'public_module':
			cmodule_feature_add('public_module')
		elif s0 == 'insert':
			print("-INSERT " + args[1])
			y = StmtDirectiveInsert(args[1], x['ti'])
		elif s0 == 'prefix':
			prefix = args[1]
			#cmodule.setPrefix(prefix)
			global_prefix = prefix

	elif x['kind'] == 'module':
		print("MODULE('%s')" % x['line']['str'])
	elif x['kind'] == 'import':
		y = do_import(x)
	elif x['kind'] == 'include':
		y = do_import(x)

	return y



def translate(abspath, is_include=False):
	log("\"%s\":" % abspath)
	log_push()
	assert(abspath != None)
	assert(abspath != "")

	if not os.path.exists(abspath):
		return None

	global env_current_file_dir
	prev_builtin_current_file_dir = env_current_file_dir
	env_current_file_dir = os.path.dirname(abspath)

	tokens = lexer.run(abspath)
	ast = parser.parse(tokens)

	m = None
	if ast != None:
		idStr = abspath.split('/')[-1][:-2]
		m = process_module(idStr, abspath, ast, is_include=is_include)
		#m.prefix = m.id
		m.source_abspath = abspath

	env_current_file_dir = prev_builtin_current_file_dir

	log_pop()
	log("")
	return m




def process_module(idStr, sourcename, ast, is_include):
	global cmodule, global_prefix
	prev_module = cmodule
	prev_global_prefix = global_prefix
	global_prefix = idStr + '_'

	symtab_public = root_symtab.branch()
	symtab_private = Symtab()

	global context
	prev_context = context
	context = {
		'public': symtab_public,
		'private': symtab_private
	}

	cmodule = Module(idStr, ast, symtab_public, symtab_private, sourcename)

	import_builtin = StmtImport(impline="builtin", name="builtin", module=builtin_module, ti=None, include=False)
	cmodule.imports_private["builtin"] = import_builtin

	# 0. do imports & directives
	i = 0
	while i < len(ast):
		x = ast[i]
		isa = x['isa']
		y = None
		if isa == 'ast_directive':
			y = do_directive(x)
			if y != None:
				cmodule.defs.append(y)
				y.parent = cmodule
		elif isa == 'ast_comment':
			#y = do_stmt_comment(x)
			pass
		else:
			break

		#if y != None:
		#	cmodule.defs.append(y)
		#	y.parent = cmodule

		i += 1

	def_phase1(ast, is_include=is_include)
	def_phase2(ast, is_include=is_include)

	m = cmodule

	cmodule = prev_module
	context = prev_context

	global_prefix = prev_global_prefix
	return m



def type_update_incompleted(module, t, idStr):
	print("type_update_incompleted('%s', '%s')" % (module.id, idStr))

	for x in module.ast:
		if x['isa'] != 'ast_definition':
			continue

		if x['id']['str'] != idStr:
			continue

		#v = ctx_value_get(idStr)
		print("- UPDATED!")
		tx = do_type(x['type'])
		Type.update(t, tx)

		return tx

	return t


def value_update_incompleted_type(module, v, idStr):
	#print("value_update_incompleted_type('%s', '%s')" % (module.id, idStr))

	for x in module.ast:
		if x['isa'] != 'ast_definition':
			continue

		if x['id']['str'] != idStr:
			continue

		#v = ctx_value_get(idStr)
		t = do_type(x['type'])
		Type.update(v.type, t)

		return v



def get_access_level(x):
	if is_local_context():
		return HLIR_ACCESS_LEVEL_LOCAL

	if x['access_modifier'] == HLIR_ACCESS_LEVEL_UNDEFINED:
		if cmodule.hasAttribute('public_module'):
			return HLIR_ACCESS_LEVEL_PUBLIC
		else:
			return HLIR_ACCESS_LEVEL_PRIVATE
	return x['access_modifier']



def def_phase1(ast, is_include=False):
	global cmodule

	# 1. Проходим по всем типам, создаем их undefined "прототипы".
	# 2. Проходим по всем функциям, создаем их undefined "прототипы".
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if isa == 'ast_definition':
			is_public = get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC
			id = x['id']
			ti = id['ti']

			if kind == 'type':
				t = Type(x['ti'])  # Incomplete type (!)
				if not is_include:
					t.parent = cmodule

				ctx_type_add(id['str'], t, is_public=is_public)
				t.is_global_type = True

			elif kind == 'func':
				# Create function value with incomplete type
				t = Type(x['ti'])  # Incomplete type (!)
				v = ValueFunc(t, do_id(x['id']), x['ti'])

				definition = StmtDefFunc(v.id, v, None, x['ti'])
				definition.id = v.id
				definition.parent = cmodule
				definition.module = cmodule
				definition.access_level = get_access_level(x)
				definition.nl = x['nl']
				v.definition = definition

				if not is_include:
					v.parent = cmodule
				ctx_value_add(id['str'], v, is_public=is_public)
				v.storage_class == HLIR_VALUE_STORAGE_CLASS_GLOBAL



def def_phase2(ast, is_include=False):
	global global_prefix
	# Идем по всем элементам с самого начала и определяем их.
	# Если элемент использует undefined - заносим его в список зависимостей эл-та
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		# for verbose mode
		if not x['isa'] in ['ast_comment', 'ast_directive', 'ast_import', 'ast_include']:
			log("define %s %s" % (x['kind'], x['id']['str']))

		if isa == 'ast_definition':
			df = None
			if kind == 'type':
				df = def_type_global(x)
			elif kind == 'const':
				df = def_const_global(x)
			elif kind == 'func':
				df = def_func(x)
			elif kind == 'var':
				df = def_var_global(x)

			if df != None:
				if get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC:
					df.id.prefix = global_prefix

				if 'comment' in x and x['comment'] != None:
					df.comment = do_stmt_comment(x['comment'])

				if not is_include:
					df.parent = cmodule

				cmodule.defs.append(df)

		elif isa == 'ast_comment':
			comment = do_stmt_comment(x)
			cmodule.defs.append(comment)

	return


# получает строку импорта (и неявно глобальный контекст)
# и возвращает полный путь к модулю
def get_import_abspath(s, ext='.m'):
	fname = s + ext

	local_name = fname
	if env_current_file_dir != "":
		local_name = env_current_file_dir + '/' + fname

	full_name = ''

	is_local = fname[0:2] == './' or fname[0:3] == '../'
	if is_local:
		full_name = local_name
	elif os.path.exists(local_name):
		full_name = local_name
	else:
		full_name = settings['lib'] + '/' + fname

	if not os.path.exists(full_name):
		return None

	return os.path.abspath(full_name)


# example: path = "value.type"
def getObjAttrByPath(x, path):
	steps = path.split(".")
	for step in steps:
		if not hasattr(x, step):
			fatal("Object %s has not attribute %s" % (str(x), step))
			return None
		x = getattr(x, step)
	return x


def setObjAttrByPath(x, path, value):
	steps = path.split(".")
	for step in steps[0:-1]:
		if not hasattr(x, step):
			fatal("Object %s has not attribute %s" % (str(x), step))
			return
		x = getattr(x, step)

	if x != None:
		setattr(x, steps[-1], value)




def def_add_annotations(x, ast_atts):
	for a in ast_atts:
		kind = a['kind']
		#print(kind)
		annotation = {}

		if len(a['args']) == 1:
			annotation = do_value(a['args'][0]['value'])
		else:
			for arg in a['args']:
				k = None
				if arg['key'] != None:
					k = arg['key']['str']
				v = do_value(arg['value'])
				annotation[k] = v

		x.attributes.update({kind: annotation})

		# ['inline', 'used', 'unused', 'inlinehint', 'noinline', 'nonstatic']
		if kind in ['alignment', 'section', 'inline', 'used', 'unused', 'inlinehint', 'noinline', 'nonstatic']:
			pass
		elif kind == 'alias':
			# 1. @alias("alias")
			# 2. @alias("llvm", "llvm_alias")
			args = a['args']
			if len(args) == 2:
				backend = args[0]['value']['str']
				identifier = args[1]['value']['str']

				if backend == 'c':
					x.id.c_alias = identifier
				elif backend == 'llvm':
					x.id.llvm_alias = identifier

			elif len(args) == 1:
				identifier = args[0]['value']['str']
				x.id.common = identifier

			add_att(x, 'id:nodecorate')

		elif kind == 'extern':
			# 1. @extern()
			# 2. @extern("C")
			add_att(x, "extern")
			args = a['args']
			if len(args) > 0:
				arg = args[0]['value']['str']
				if arg == 'C':
					add_att(x, 'id:nodecorate')
		elif kind == 'nodecorate':
			add_att(x, 'id:nodecorate')

		elif kind == 'c_no_print':
			add_att(x, "c_no_print")

		elif kind == 'deprecated':
			add_att(x, "deprecated")

		elif kind == 'cbyvalue':
			add_att(x, "cbyvalue")
			x.value.addAttribute("cbyvalue")

		elif kind == 'inline':
			#print("WALDAMLWMALDWMKLMKLDWMALKMDLMALWDMLAMWLDKMALKWMDLKAMWLKDMAL")
			#add_att(x, "inline")
			pass

		else:
			warning("unsupported annotation", a['ti'])
#			exit(1)
#			key = a['args'][0]['value']['str']
#			print(key)
#			add_att(x, key)
	return x


def add_att(x, att):
	# Add Properties
	lr = att.split(":")
	if len(lr) == 1:
		att = lr[0]
		x.addAttribute(att)
	elif len(lr) > 1:
		x2 = getObjAttrByPath(x, lr[0])
		if x2 != None:
			x2.addAttribute(lr[1])


# for check print/scanf params
# returns list of specifiers
# ex: "%s = %d" -> ['c', 'd']
#def get_cspecs(s):
#	specs = []
#	i = 0
#	while i < len(s):
#		c = s[i]
#		if c == '%':
#			i += 1
#			c = s[i]
#			specs.append(c)
#		i += 1
#	return specs


# check extra arguments of print, scanf, etc.
# requires specs from get_cspecs & extra_args list
# expected_pointers for case of scanf("%d", &x)
#def extra_args_check(specs, extra_args, expected_pointers):
#	i = 0
#	# extra_args rest args
#	nargs = len(extra_args)
#	nspec = len(specs)
#	while i < nargs and i < nspec:
#		arg = extra_args[i]
#		arg_type = arg.type
#
#		if arg.isValueBad():
#			i += 1
#			continue
#
#		spec = specs[i]
#
#		if expected_pointers:
#			if not arg_type.is_pointer():
#				warning("expected pointer", arg.ti)
#				i += 1
#				continue
#
#			arg_type = arg_type.to
#
#
#		if spec in ['i', 'd']:
#			if arg_type.is_int():
#				if arg_type.is_unsigned():
#					warning("expected signed integer value", arg.ti)
#			else:
#				warning("expected integer value2", arg.ti)
#
#		elif spec == 'x':
#			if not arg_type.is_int():
#				warning("expected integer value3", arg.ti)
#
#		elif spec == 'u':
#			if arg_type.is_int():
#				if arg_type.is_signed():
#					warning("expected unsigned integer value", arg.ti)
#			else:
#				warning("expected integer value4", arg.ti)
#
#		elif spec == 's':
#			if not arg_type.is_pointer_to_str():
#				warning("expected pointer to string", arg.ti)
#
#		elif spec == 'f':
#			if not arg_type.is_float():
#				warning("expected float value", arg.ti)
#
#		elif spec == 'c':
#			if not arg_type.is_char():
#				warning("expected char value", arg.ti)
#
#		elif spec == 'p':
#			if not arg_type.is_pointer():
#				warning("expected pointer value", arg.ti)
#
#		i += 1
#	return



