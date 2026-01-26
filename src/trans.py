
import os
import copy
import decimal

from hlir import *
from error import *
from lexer import CmLexer
from parser import Parser
from common import settings
import type as htype

from value.bool import value_bool_create
from value.num import value_number_create
from value.float import value_float_create
from value.array import value_array_create, value_array_add
from value.string import value_string_create, value_string_add
from value.record import value_record_create
from value.value import value_imm_literal_create
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


from value.value import *
from value.cons import value_cons_implicit, value_cons_implicit_check, value_cons_explicit, value_cons_default


from symtab import Symtab
from util import nbits_for_num, nbytes_for_bits



production = True

global_prefix = None

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


# for @brand types
brand_cnt = 0



def cmodule_use(x):
	global cmodule
	if not x in cmodule.att:
		cmodule.addAttribute(x)



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
	if (id_str == 'Char16') or (id_str == 'Char32'):
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



def cmodule_feature_add(s):
	cmodule.att.append(s)


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




def valueZeroNumber(ti=None):
	gt = TypeNumber(ti=ti)
	return value_imm_literal_create(gt, asset=0, ti=ti)


def init():
	#lib_path = settings['lib']

	# max number of signs after .
	# decimal operation precision
	decimal.getcontext().prec = settings['precision']

	global root_symtab
	# init main context
	root_symtab = Symtab()

	root_symtab.type_add('Unit', typeUnit)
	root_symtab.type_add('Bool', typeBool)

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
	valueNil = value_imm_literal_create(typeNil, 0)
	valueTrue = value_bool_create(1)
	valueFalse = value_bool_create(0)

#	trueId = Id('true')
#	valueTrue.id = trueId
#	valueTrue.id.c = trueId
#	valueTrue.id.llvm = trueId
#	falseId = Id('false')
#	valueFalse.id = falseId
#	valueFalse.id.c = falseId
#	valueFalse.id.llvm = falseId

	root_symtab.value_add('nil', valueNil)
	root_symtab.value_add('true', valueTrue)
	root_symtab.value_add('false', valueFalse)


	word_width = int(settings['word_width'])
	char_width = int(settings['char_width'])
	int_width = int(settings['integer_width'])
	flt_width = int(settings['float_width'])
	pointer_width = int(settings['pointer_width'])

	global typeSysWord, typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr, typeSysSize

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

	init_builtin_values()


def init_builtin_values():
	# Set taget depended Int & Nat types
	# (used in index, extra agrs & generic numeric var definitions)

	#
	# __compiler
	#

	# compiler name
	compilerNameString = "m2"
	compilerName = value_string_create(compilerNameString, ti=None)

	# compiler version
	compilerVersionMajor = value_imm_literal_create(typeNat32, 0)
	compilerVersionMinor = value_imm_literal_create(typeNat32, 7)

	compiler_version_initializers = [
		Initializer(Id('major'), compilerVersionMajor),
		Initializer(Id('minor'), compilerVersionMinor)
	]
	compilerVersion = value_record_create(compiler_version_initializers, ti=None)

	# '__compiler' record
	compiler_initializers = [
		Initializer(Id('name'), compilerName),
		Initializer(Id('version'), compilerVersion),
	]
	compiler = value_record_create(compiler_initializers, ti=None)
	root_symtab.value_add('__compiler', compiler)

	#
	# __target
	#

	#target_name = str(settings['target_name'])
	char_width = int(settings['char_width'])
	int_width = int(settings['integer_width'])
	flt_width = int(settings['float_width'])
	pointer_width = int(settings['pointer_width'])


	__targetName = value_string_create(settings['target_name'])
	__targetCharWidth = value_imm_literal_create(typeNat32, char_width)
	__targetIntWidth = value_imm_literal_create(typeNat32, int_width)
	__targetFloatWidth = value_imm_literal_create(typeNat32, flt_width)
	__targetPointerWidth = value_imm_literal_create(typeNat32, pointer_width)

	# '__target' record
	target_initializers = [
		Initializer(Id('name'), __targetName),
		Initializer(Id('charWidth'), __targetCharWidth),
		Initializer(Id('intWidth'), __targetIntWidth),
		Initializer(Id('floatWidth'), __targetFloatWidth),
		Initializer(Id('pointerWidth'), __targetPointerWidth),
	]
	target = value_record_create(target_initializers, ti=None)
	root_symtab.value_add('__target', target)



# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position no
# offset - real offset (address inside container struct)
def do_field(x):
	#info("do_field", x['ti'])
	id = do_id(x['id'])
	if id.str[0].isupper():
		error("field id must starts with small letter", id.ti)

	t = do_type(x['type'])

	#if t.is_forbidden_field():
	#	error("unsuitable type", t.ti)

	iv = do_value_immediate(x['init_value'])

	if not iv.isValueUndef():
		# у поля есть инициализатор
		pass

	iv = None
	if x['init_value'] != None:
		iv = do_value(x['init_value'])
	else:
		iv = ValueUndef(t)

	f = Field(id, t, init_value=iv, ti=x['ti'])
	f.nl = x['nl']

	if f.nl == 0:
		f.nl = 1

	f.access_level = x['access_modifier']

	#f.access_level = get_access_level(x)

	#add_spices_any(f, x['anno'])
	return f


#
# Do Type
#

def do_type_named(x):
	global cmodule
	id = x['id']
	id_str = id['str']

	t = None
	if 'module' in x:
		module_id = x['module']['str']

		if not module_id in cmodule.imports:
			error("unknown namespace '%s'" % module_id, x['ti'])
			return TypeBad(x['ti'])

		imp_module = cmodule.imports[module_id].module
		t = imp_module.type_get_public(id_str)

		if t == None:
			t = imp_module.type_get_private(id_str)
			if t != None:
				error("access to private type", x['ti'])
			else:
				error("undefined type", x['ti'])
			return TypeBad(x['ti'])

		if t.is_incompleted():
			t = type_update_incompleted(imp_module, t, id_str)
	else:
		t = ctx_type_get(id_str)

	if t == None:
		error("undefined type", x['ti'])
		return TypeBad(x['ti'])


	# если дело происходит не в определении типа и пришел undefined тип
	if t.is_incompleted():
		if not cdef.is_stmt_def_type():
			error("forward references to non-struct type", x['ti'])
		cdef.deps.append(t)

	if t.hasAttribute2("deprecated"):
		warning("using a deprecated type", x['ti'])

	return t



def do_type_pointer(x):
	to = do_type(x['to'])
	return TypePointer(to, ti=x['ti'])


def do_type_array(x):
	of = do_type(x['of'])
	volume = do_value(x['size'])

	if volume.isValueBad():
		return TypeArray(of, volume, ti=x['ti'])

	if not volume.isValueUndef():
		if volume.isValueRuntime():
			if is_local_context():
				global cfunc
				cfunc.addAttribute('stacksave')
			else:
				error("non local VLA", t.size.ti)

	return TypeArray(of, volume, ti=x['ti'])


# Нужен для анонимных структур
# и чтобы отличать копии типа структура от реально другой структуры (C)
rec_uid = 0
def do_type_record(x):
	global rec_uid
	fields = []

	uid = rec_uid
	rec_uid = rec_uid + 1

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

	to = typeUnit
	if x['to'] != None:
		to = do_type(x['to'])

	if to.is_forbidden_retval():
		error("forbidden retval type", to.ti)

	return TypeFunc(params, to, x['arghack'], ti=x['ti'])




def add_spices_type(t, atts):
	global brand_cnt

	if atts == []:
		return t

	nt = Type.copy(t)

	for a in atts:
		k = a['kind']
		nt.annotations[k] = {}

		if k == 'brand':
			brand_cnt += 1
			nt.brand = brand_cnt

		# Для C некоторые атрибуты типа массива -
		# это атрибуты типа его элементов
		if nt.is_array():
			if k in ['const', 'volatile', 'restrict']:
				nt.of = Type.copy(nt.of)
				if k == 'const':
					nt.of.addAnnotation('const', {})
				if k == 'volatile':
					nt.of.addAnnotation('volatile', {})
				if k == 'restrict':
					nt.of.addAnnotation('restrict', {})

	return nt


def do_type(x):
	t = None
	k = x['kind']
	if k == 'named': t = do_type_named(x)
	elif k == 'func': t = do_type_func(x)
	elif k == 'pointer': t = do_type_pointer(x)
	elif k == 'array': t = do_type_array(x)
	elif k == 'record': t = do_type_record(x)
	else: t = bad_type(x['ti'])
	t.ti = x['ti']
	tt = add_spices_type(t, x['anno'])

	if k == 'record':
		# кароч прикол такой:
		# тк add_spices_type вызывается здесь и создает НОВЫЙ тип то в таблице cmodule.anon_recs
		# оказывается оригинальная структура, а при поиске для удаления ее оттуда ищется новая (обернутая)
		# поэтому этот костыль тут а не в do_type_record где ему казалось бы - место
		anon_tag = '__anonymous_struct_%d' % tt.uid
		tt.c_anon_id = anon_tag
		cmodule.anon_recs.append(tt)

	return tt



def do_value_shift(x):
	op = x['kind']  # HLIR_VALUE_OP_SHL | HLIR_VALUE_OP_SHR
	left = do_rvalue(x['left'])
	right = do_rvalue(x['right'])

	if not (left.type.is_word() or left.type.is_number()):
		error("expected word value", x['left']['ti'])
		return ValueBad(x['ti'])

	if left.type.is_generic() and not right.type.is_generic():
		error("expected non-generic value", left.ti)
		return ValueBad(x['ti'])

	if right.type.is_signed():
		error("expected natural value", x['right']['ti'])
		return ValueBad(x['ti'])

	nv = None
	if op == HLIR_VALUE_OP_SHL:
		nv = ValueShl(left.type, left, right, ti=x['ti'])
		if left.isValueImmediate() and right.isValueImmediate():
			nv.asset = int(left.asset << right.asset)
			nv.stage = HLIR_VALUE_STAGE_COMPILETIME

	else: #if op == HLIR_VALUE_OP_SHR:
		nv = ValueShr(left.type, left, right, ti=x['ti'])
		if left.isValueImmediate() and right.isValueImmediate():
			nv.asset = int(left.asset >> right.asset)
			nv.stage = HLIR_VALUE_STAGE_COMPILETIME

	return nv


def do_value_bin(x):
	op = x['kind']
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	return do_value_bin_op(op, l, r, x['ti'])


def do_value_bin_op(op, l, r, ti):
	if l.isValueBad() or r.isValueBad():
		return ValueBad(ti)

	if l.isValueUndef() or r.isValueUndef():
		t = htype.select_common_type(l.type, r.type, ti)
		return ValueUndef(t)

	# Ops with different types
	if op == HLIR_VALUE_OP_ADD:
		if l.type.is_array() and r.type.is_array():
			return value_array_add(l, r, ti)
		elif l.type.is_string() and r.type.is_string():
			return value_string_add(l, r, ti)

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

	t = htype.select_common_type(l.type, r.type, ti)
	if t == None:
		error("different types in operation", ti)
		print("left type  = ", end='')
		htype.type_print(l.type)
		print()
		print("right type = ", end='')
		htype.type_print(r.type)
		print()
		return ValueBad(ti)

	l = value_cons_implicit(t, l)
	r = value_cons_implicit(t, r)

	if not Type.eq(l.type, r.type, []):
		error("different types in binary operation", ti)
		# print: @@ <left_type> & <right_type> @@
		print(color_code(CYAN), end='')
		print('@@ ', end='')
		htype.type_print(l.type)
		print(" & ", end='')
		htype.type_print(r.type)
		print(' @@', end='')
		print(color_code(ENDC), end='')
		print("\n")
		return ValueBad(ti)

	if op in [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE]:
		return value_eq(l, r, op, ti)

	if Type.eq(t, typeBool):
		if op == HLIR_VALUE_OP_OR: op = HLIR_VALUE_OP_LOGIC_OR
		elif op == HLIR_VALUE_OP_AND: op = HLIR_VALUE_OP_LOGIC_AND

	if op in (htype.EQ_OPS + htype.RELATIONAL_OPS):
		t = typeBool

	if l.isValueBad() or r.isValueBad():
		return ValueBad(ti)

	nv = ValueBin(t, op, l, r, ti=ti)

	# if left & right are immediate, we can fold const
	# and append field .asset to bin_value
	if l.isValueImmediate() and r.isValueImmediate():
		ops = {
			HLIR_VALUE_OP_LOGIC_OR: lambda a, b: a or b,
			HLIR_VALUE_OP_LOGIC_AND: lambda a, b: a and b,
			HLIR_VALUE_OP_OR: lambda a, b: a | b,
			HLIR_VALUE_OP_AND: lambda a, b: a & b,
			HLIR_VALUE_OP_XOR: lambda a, b: a ^ b,
			HLIR_VALUE_OP_LT: lambda a, b: a < b,
			HLIR_VALUE_OP_GT: lambda a, b: a > b,
			HLIR_VALUE_OP_LE: lambda a, b: a <= b,
			HLIR_VALUE_OP_GE: lambda a, b: a >= b,
			HLIR_VALUE_OP_ADD: lambda a, b: a + b,
			HLIR_VALUE_OP_SUB: lambda a, b: a - b,
			HLIR_VALUE_OP_MUL: lambda a, b: a * b,
			HLIR_VALUE_OP_DIV: lambda a, b: l.asset // r.asset,
			HLIR_VALUE_OP_REM: lambda a, b: a % b,
			HLIR_VALUE_OP_EQ:  lambda a, b: a == b,
			HLIR_VALUE_OP_NE:  lambda a, b: a != b
		}

		asset = None
		if op == HLIR_VALUE_OP_DIV and t.is_float():
			asset = l.asset / r.asset
		else:
			asset = ops[op](l.asset, r.asset)

		if t.is_number():
			nv.type = type_number_for(asset, ti=ti)

		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		nv.asset = asset

	return nv


def do_value_not(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.isValueUndef():
		return v

	vtype = v.type

	if not vtype.supports(HLIR_VALUE_OP_NOT):
		error("unsuitable type", v.ti)
		return ValueBad(x['ti'])

	op = HLIR_VALUE_OP_NOT
	if vtype.is_bool():
		op = HLIR_VALUE_OP_LOGIC_NOT

	nv = ValueNot(vtype, v, ti=x['ti'])

	if v.isValueImmediate():
		# because: ~(1) = -1 (not 0) !
		if v.type.is_bool():
			nv.asset = not v.asset
		else:
			nv.asset = ~v.asset

		nv.stage = HLIR_VALUE_STAGE_COMPILETIME

	return nv



def do_value_neg(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.isValueUndef():
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
		nv.asset = -v.asset
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME

		if nv.type.is_generic():
			nv.type = type_number_for(v.asset, ti=v.ti)

	return nv


def do_value_pos(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.isValueUndef():
		return v

	vtype = v.type

	if vtype.is_unsigned():
		error("expected value with signed type", v.ti)

	nv = ValuePos(vtype, v, ti=x['ti'])

	if v.isValueImmediate():
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		nv.asset = +v.asset

	if nv.type.is_generic():
		nv.type = type_number_for(v.asset, ti=v.ti)

	return nv


def do_value_ref(x):
	v = do_value(x['value'])

	# FIXIT: Сейчас сам факт того что взяли указатель на переменную считается тем что она инициализирована,
	# что конечно неверно, но пока так. Однажды нужно придумать как проверить судьбу этого указателя.
	v.is_initialized = True

	if v.isValueBad() or v.isValueUndef():
		return v

	ti = x['ti']
	op = x['kind']
	vtype = v.type

	if v.isValueImmutable():
		if not vtype.is_func() or vtype.is_incompleted():
			error("expected mutable value or function", v.ti)
			return ValueBad(ti)

	nv = ValueRef(v, ti=ti)
	if v.is_global_flag:
		nv.stage = HLIR_VALUE_STAGE_LINKTIME
	return nv


def do_value_new(x):
	v = do_value(x['value'])

	if v.isValueBad() or v.isValueUndef():
		return v

	nv = ValueNew(v)
	return nv


def do_value_deref(x):
	v = do_rvalue(x['value'])

	if v.isValueBad() or v.isValueUndef():
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
		error("cannot dereference pointer", v.ti)

	nv = ValueDeref(v, ti=x['ti'])
	return nv




def do_value_lengthof_value(x):
	ti = x['ti']
	arg = do_rvalue(x['value'])

	if arg.isValueBad() or arg.isValueUndef():
		return arg

	if not (arg.type.is_array() or arg.type.is_string()):
		error("expected value with array type", x['value']['ti'])
		return ValueBad({'ti': ti})

	# for C backend, because C cannot do lengthof(x)
	cmodule_use('use_lengthof')

	return ValueLengthof(arg, ti)


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


def do_value___defined_type(x):
	t = ctx_type_get(x['type']['id'].str)
	return t != None


def do_value___defined_value(x):
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

	if fn.isValueBad() or fn.isValueUndef():
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
			if vx.isValueUndef():
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
			arg = value_cons_default(arg)

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
				if nv.type.is_composite():
					nv.asset = []
				else:
					nv.asset = 0


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
		param_value.asset = args[i].value.asset  # (!)
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

	if left.isValueUndef():
		return ValueUndef(Type(x['ti']), x['ti'])

	left_type = left.type
	via_pointer = left_type.is_pointer()

	array_typ = left_type
	if via_pointer:
		array_typ = left_type.to

	if not array_typ.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])

	# Can index *[]AnyNonArrayType
	# Can't index *[][]AnyType
	if array_typ.is_array_of_open_array():
		error("cannot index array of open array", x['ti'])
		return ValueBad(x['ti'])

	index = do_rvalue(x[HLIR_VALUE_OP_INDEX])

	#if index.isValueBad():
	if index.type.is_bad():
		return ValueBad(x['ti'])

	if not (index.type.is_arithmetical() or index.type.is_number()):
		error("expected integer value", index.ti)
		return ValueBad(x['ti'])

	if index.type.is_generic():
		index = value_cons_implicit_check(typeSysInt, index)

	nv = ValueIndex(array_typ.of, left, index, ti=x['ti'])

	if not left.type.is_pointer():
		nv.is_immutable = left.is_immutable
		array_typ = left.type

		if left.isValueImmediate() and index.isValueImmediate():
			index_imm = index.asset

			if index_imm >= array_typ.volume.asset:
				error("array index out of bounds", x['ti'])
				return ValueBad(x['ti'])

			if index_imm < len(left.asset):
				item = left.asset[index_imm]
			else:
				item = create_zero_literal(array_typ.of)

			cp_immediate(nv, item)
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
		index_to = ValueUndef(TypeNumber(ti=x['ti']))

	via_pointer = left.type.is_pointer()
	array_type = left.type
	if via_pointer:
		array_type = left.type.to

	if not array_type.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])


	# получаем размер слайса
	# строим выражения для C бекенда в частности
	# тк volume of array должен быть выражением
	# а для слайса [a:b] это (b - a)
	slice_volume = do_value_bin_op(HLIR_VALUE_OP_SUB, index_to, index_from, x['ti'])

	if not (slice_volume.isValueUndef() or slice_volume.isValueUndef()):
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
	return id_str in cmodule.imports


def submodule_access(x):
	global cmodule

	mname = x['left']['str']
	iname = x['right']['str']
	ti = x['ti']

	imp = cmodule.imports[mname]
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
	# access to submodule?
	if x['left']['kind'] == 'id':
		# если нет значения с таким именем, тогда возможно это модуль
		# (смотрим сперва значения, чтобы они имели приоритет
		# над одноименными модулями)
		v = ctx_value_get(x['left']['str'])
		if v == None:
			if is_import_name(x['left']['str']):
				return submodule_access(x)

	#
	# access to object
	#

	left = do_value(x['left'])

	if left.isValueBad():
		return ValueBad(x['ti'])

	field_id = do_id(x['right'])

	# доступ через переменную-указатель
	via_pointer = left.type.is_pointer()

	record_type = left.type
	if via_pointer:
		record_type = left.type.to

	# check if is record
	if not record_type.is_record():
		error("expected record or pointer to record", x['left']['ti'])
		return ValueBad(x['ti'])

	field = htype.record_field_get(record_type, field_id.str)

	# if field not found
	if field == None:
		error("undefined field '%s'" % field_id.str, x['right']['ti'])
		return ValueBad(x['ti'])

	if field.type.is_bad():
		return ValueBad(x['ti'])

	# Check access permissions

	# не у всех типов есть 'definition' (его нет у анонимных записей например)
	if not is_local_entity(record_type):
		if field.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
			error("access to private field of record", x['right']['ti'])

	nv = ValueAccessRecord(field.type, left, field, ti=x['ti'])

	if not left.type.is_pointer():
		nv.is_immutable = left.is_immutable

		if left.isValueImmediate():
			initializer = get_item_by_id(left.asset, field.id.str)
			cp_immediate(nv, initializer.value)

	return nv


def do_value_cons(x):
	v = do_rvalue(x['value'])
	t = do_type(x['type'])
	if v.isValueBad() or t.is_bad():
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
		if v.isValueVar() and v.is_global_flag:
			cfunc.is_pure = False


	global cdef

	if v.isValueBad():
		return v

	if v.hasAttribute2("deprecated"):
		warning("using a deprecated value", x['ti'])

	if v.type.is_incompleted():
		v_upd = value_update_incompleted_type(cmodule, v, v.id.str)

		if v_upd == None:
			error("use of incomplete value", x['ti'])
			return ValueBad(x['ti'])

		cdef.deps.append(v_upd)
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
		return do_value_float(x)

	return do_value_integer(x)



def do_value_integer(x):
	num_string_len = len(x['str'])
	base = 10
	if num_string_len > 2:
		if x['str'][0] == '0':
			if x['str'][1] == 'x':
				num_string_len = num_string_len - 2
				base = 16
				num = int(x['str'], base)

				if nbits_for_num(num) > 64:
					cmodule_use('use_bigint')

				v = value_word_create(num, x['ti'])
				v.nsigns = num_string_len
				v.addAttribute('hexadecimal')
				return v


	num = int(x['str'], base)

	if nbits_for_num(num) > 64:
		cmodule_use('use_bigint')

	v = value_number_create(num, ti=x['ti'])
	v.nsigns = num_string_len

	if base == 16:
		v.addAnnotation('hexadecimal', {})

	return v



def do_value_float(x):
	# in compile time floats stores as decimal (!)
	fval = decimal.Decimal(x['str'])
	fv = value_float_create(fval, ti=x['ti'])
	return fv


def do_value_sizeof_type(x):
	t = do_type(x['type'])
	return ValueSizeofType(t, ti=x['ti'])


def do_value_sizeof_value(x):
	v = do_value(x['value'])
	return ValueSizeofValue(v, ti=x['ti'])



def do_value_alignof(x):
	of = do_type(x['type'])
	return ValueAlignof(of, ti=x['ti'])


def do_value_offsetof(x):
	of = do_type(x['type'])
	field_id = x['field']
	return ValueOffsetof(of, field_id, ti=x['ti'])



bin_ops = [
	HLIR_VALUE_OP_OR, HLIR_VALUE_OP_XOR, HLIR_VALUE_OP_AND,
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
	ti = x['ti']
	if not 'unsafe' in cmodule.att:
		error("for use 'unsafe' operator required -funsafe option", ti)

	global unsafe_mode
	prev_unsafe_mode = unsafe_mode
	unsafe_mode = True

	rv = do_rvalue(x['value'])

	unsafe_mode = prev_unsafe_mode
	return rv


def do_value_bad(x):
	return ValueBad(x['ti'])


def do_value_undefined(x):
	t = htype.TypeBad(x['ti'])
	#t = htype.TypeUndefined(x['ti'])
	return ValueUndef(t, x['ti'])


def do_rvalue(x):
	v = do_value(x)
	if not v.is_initialized:
		warning("attempt to use an uninitialized variable", x['ti'])
	return v


def do_value_subexpr(x):
	v = do_value(x['value'])
	nv = ValueSubexpr(v, ti=x['ti'])
	cp_immediate(nv, v)
	return nv



def add_spices_value(v, atts):
	if atts != []:
		v = Value.copy(v)
	for a in atts:
		v.att.append(a['kind'])
	return v


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
	elif k == HLIR_VALUE_OP_NOT: v = do_value_not(x)
	elif k == HLIR_VALUE_OP_DEREF: v = do_value_deref(x)
	elif k == HLIR_VALUE_OP_INDEX: v = do_value_index(x)
	elif k == 'slice': v = do_value_slice(x)
	elif k == HLIR_VALUE_OP_ACCESS: v = do_value_access(x)
	elif k == HLIR_VALUE_OP_NEG: v = do_value_neg(x)
	elif k == HLIR_VALUE_OP_POS: v = do_value_pos(x)
	elif k == HLIR_VALUE_OP_SHL: v = do_value_shift(x)
	elif k == HLIR_VALUE_OP_SHR: v = do_value_shift(x)
	elif k == 'new': v = do_value_new(x)
	elif k == 'unsafe': v = do_value_unsafe(x)
	elif k == 'subexpr': v = do_value_subexpr(x)
	elif k == 'sizeof_value': v = do_value_sizeof_value(x)
	elif k == 'sizeof_type': v = do_value_sizeof_type(x)
	elif k == HLIR_VALUE_OP_ALIGNOF: v = do_value_alignof(x)
	elif k == HLIR_VALUE_OP_OFFSETOF: v = do_value_offsetof(x)
	elif k == 'lengthof_value': v = do_value_lengthof_value(x)
	elif k == '__va_arg': v = do_value_va_arg(x)
	elif k == '__va_start': v = do_value_va_start(x)
	elif k == '__va_copy': v = do_value_va_copy(x)
	elif k == '__va_end': v = do_value_va_end(x)
	elif k == '__defined_type': v = do_value___defined_type(x)
	elif k == '__defined_value': v = do_value___defined_value(x)
	elif k == 'undefined': v = do_value_undefined(x)
	elif k == 'bad': v = do_value_bad(x)

	assert(v != None)
	v.ti = x['ti']
	return add_spices_value(v, x['anno'])


#
# Do Statement
#


def do_stmt_const(x):
	definition = def_const_common(x)
	definition.parent = cfunc
	definition.value.parent = cfunc
	definition.value.storage_class = HLIR_VALUE_STORAGE_CLASS_LOCAL
	return definition



def do_stmt_var(x):
	global cfunc

	already = ctx_value_get(x['id']['str'], shallow=True)
	if already != None:
		error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])

	df = def_var_common(x)

	if not df.init_value.isValueUndef():
		df.value.is_initialized = True

	df.id.prefix = None
	df.value.id.prefix = None
	#df.module = None
	#df.access_level = mass

	df.value.storage_class = HLIR_VALUE_STORAGE_CLASS_LOCAL
	df.value.is_global_flag = False
	df.parent = cfunc
	return df



def do_stmt_if(x):
	cond = do_rvalue(x['cond'])

	if cond.isValueBad():
		return StmtBad(x['ti'])

	if not cond.type.is_bool():
		error("expected bool value", cond.ti)
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
		error("expected bool value", cond.ti)
		return StmtBad(x['ti'])

	block = do_stmt(x['stmt'])

	if block.is_stmt_bad():
		return StmtBad(x['ti'])

	return StmtWhile(cond, block, ti=x['ti'])



def do_stmt_return(x):
	global cfunc

	func_ret_type = cfunc.type.to
	ret_val_present = x['value'] != None

	# если забыли вернуть значение
	# или возвращаем его там, где оно не ожидется
	is_no_ret_func = func_ret_type.is_unit()
	if ret_val_present == is_no_ret_func:
		if ret_val_present:
			error("unexpected return value", x['value']['ti'])
		else:
			error("expected return value", x['ti'])
		return StmtBad(x['ti'])

	# (!) in return statement retval can be None (!)
	retval = None
	if ret_val_present:
		rv = do_rvalue(x['value'])
		retval = transmission(func_ret_type, rv, rv.ti)

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
#		if l.type.of.size != r.type.of.size:
#			cmodule_use('use_lengthof')
#			cmodule_use('use_arrcpy')
# поэтому пока ВСЕГДА использую ARRCPY
	if l.type.is_array() and r.type.is_array():
		if l.type.of.size != r.type.of.size:
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

	if not v.type.is_arithmetical():
		error("expected value with integer type", v.ti)
		return StmtBad(x['ti'])

	one = value_imm_literal_create(v.type, 1, ti=x['ti'])
	nv = ValueBin(v.type, op, v, one, ti=x['ti'])
	return StmtAssign(v, nv, ti=x['ti'])



def do_stmt_value(x):
	v = do_rvalue(x['value'])

	if v.isValueBad():
		return StmtBad(x['ti'])

	if not v.type.is_unit():
		if not v.type.hasAttribute2('unused'):
			warning("unused result of %s expression" % x['value']['kind'], v.ti)

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
	elif k == 'comment-line': s = do_stmt_comment_line(x)
	elif k == 'comment-block': s = do_stmt_comment_block(x)
	elif k == 'asm': s = do_stmt_asm(x)
	else: s = StmtBad(x['ti'])

	assert(s != None)
	s.nl = x['nl']

	if 'comment' in x and x['comment'] != None:
		s.comment = do_stmt_comment(x['comment'])

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
	global global_prefix

	id = do_id(x['id'])
	id.prefix = global_prefix

	definition = StmtDefType(id, nt, None, x['ti'])
	definition.module = cmodule
	definition.parent = cmodule
	definition.access_level = get_access_level(x)
	definition.nl = x['nl']

#	info("%s" % get_access_level(x), x['ti'])

	prev_cdef = cdef
	cdef = definition

	ty = do_type(x['type'])

	if ty.is_record():
		# 'default' -> 'private' &
		# 'default' -> 'public' for @public record
		for f in ty.fields:
			if f.access_level == HLIR_ACCESS_LEVEL_UNDEFINED:
				if ty.hasAttribute2("public"):
					f.access_level = HLIR_ACCESS_LEVEL_PUBLIC
				else:
					f.access_level = HLIR_ACCESS_LEVEL_PRIVATE

	if ty.is_bad():
		return None

	definition.original_type = ty

	# поскольку этот тип здесь связывается с идентификатором
	# он уже не анонимный
	if ty in cmodule.anon_recs:
		cmodule.anon_recs.remove(ty)

	# Замещаем внутренности undefined типа на тип справа
	# НО! имя даем новое
	deps = nt.deps
	Type.update(nt, ty)
	nt.deps = deps
	nt.id = id
	nt.definition = definition
	nt.parent = cmodule  # добавляем заново тк очистили его выше!
	nt.ti_def = id.ti

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
	df = add_spices_def(df, x['anno'])
	return df



# common method for global & local consts
def def_const_common(x):
	global cmodule
	id = do_id(x['id'])

	# check if identifier is free
	pre_exist = ctx_value_get(id.str, shallow=True)
	if pre_exist != None:
		error("redefinition of '%s'" % id.str, id.ti)

	iv = do_rvalue(x['init_value'])

	t = None
	if x['type'] != None:
		t = Type.copy(do_type(x['type']))
		iv = value_cons_implicit_check(t, iv)

	if t == None:
		t = Type.reborn(iv.type)

	const_value = ValueConst(t, id, init_value=iv, ti=id.ti)

	const_value.stage = iv.stage
	if iv.isValueImmediate():
		cp_immediate(const_value, iv)

	const_value.type.addAnnotation('const', {})

	ctx_value_add(id.str, const_value, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)

	definition = StmtDefConst(id, const_value, iv, x['ti'])
	definition.module = cmodule
	definition.access_level = get_access_level(x)
	definition.nl = x['nl']
	const_value.definition = definition
	return definition



def def_const_global(x):
	global global_prefix
	df = def_const_common(x)

	#if df.value.isValueRuntime():
	#	error("runtime!", x['ti'])

	# TODO: centity -> instead cmodule/cfunc;
	# rm Value#module -> tree instead
	df.parent = cmodule
	df.value.parent = cmodule

	df.value.is_global_flag = True
	df.value.storage_class = HLIR_VALUE_STORAGE_CLASS_GLOBAL

	df.id.prefix = global_prefix

	iv = df.init_value
	if not iv.isValueUndef():
		if iv.isValueRuntime():
			#print(iv.stage)
			error("expected immediate value", iv.ti)

	df = add_spices_def(df, x['anno'])
	return df



def def_var_common(x):
	global cdef
	global global_prefix

	id = do_id(x['id'])
	id.prefix = global_prefix

	definition = StmtDefVar(id, None, None, x['ti'])
	definition.module = cmodule
	definition.parent = cmodule
	definition.access_level = get_access_level(x)
	if definition.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
		if settings['public_vars_forbidden']:
			error("public variables are forbidden", x['ti'])

	definition.nl = x['nl']
	prev_cdef = cdef
	cdef = definition

	t = None
	if x['type'] != None:
		t = do_type(x['type'])

	iv = do_rvalue(x['init_value'])

	tu = t == None
	vu = iv.isValueUndef()

	# error: no type, no init valuetu = type_is_incompleted(t)
	if tu == True and vu == True:
		# ERROR: type & value undefined
		nv = ValueBad(x['ti'])
		ctx_value_add(id.str, nv, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)
		return StmtBad(x['ti'])

	elif tu == True and vu == False:
		# type undef, value ok
		#if iv.type.is_generic():
		#	error("variable with generic type", x['ti'])
		iv = value_cons_default(iv)
		t = Type.reborn(iv.type)

	elif tu == False and vu == False:
		# type ok, value ok
		if t.is_open_array():
			if iv.type.is_string():
				# for case:
				# var arrayFromString: []Char8 = "abc"
				str_length = len(iv.asset)
				volume = value_number_create(str_length)
				t = TypeArray(t.of, volume, ti=x['ti'])
			elif iv.type.is_array():
				# for case:
				# var a: []*Str8 = ["Ab", "aB", "AAb"]
				volume = value_number_create(iv.type.volume.asset)
				t = TypeArray(t.of, volume, ti=x['ti'])

	# type & init value present
	if t != None:
		if not iv.isValueUndef():
			iv = value_cons_implicit_check(t, iv)
	else:
		if iv.type.is_generic():
			iv = value_cons_default(iv)

		t = Type.reborn(iv.type)

	# Переменная может быть типа []X если она внешняя
	is_not_extern = getAnno(x, 'extern') == None
	if t.is_forbidden_var(open_array_forbidden=is_not_extern):
		error("unsuitable variable type", x['type']['ti'])

	var_value = ValueVar(t, id, init_value=iv, ti=id.ti)
	var_value.storage_class = HLIR_VALUE_STORAGE_CLASS_GLOBAL
	ctx_value_add(id.str, var_value, is_public=get_access_level(x) == HLIR_ACCESS_LEVEL_PUBLIC)
	var_value.is_global_flag = True

	definition.value = var_value
	definition.init_value = iv
	var_value.definition = definition

	#var_value.parent = cmodule

	cdef = prev_cdef
	return definition


def def_var_global(x):
	# already defined? (check identifier)
	already = ctx_value_get(x['id']['str'])
	if already != None:
		error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])

	df = def_var_common(x)
	df.value.is_initialized = True
	df = add_spices_def(df, x['anno'])
	return df



# Чистый тип функции не принимает и не возвращает указатели
def is_pure_type(t):
	if t.to.is_pointer():
		return False
	for param in t.params:
		if param.type.is_pointer():
			return False
	return True



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
	global global_prefix

	# значение функции уже существует, (возможно - undefined)
	# тк мы ранее сделали проход
	fn = ctx_value_get(x['id']['str'])
	fn.id.prefix = global_prefix

	cdef = fn.definition

	if fn.type.is_incompleted():
		fn.type = do_type_func(x['type'])
		if fn.type.is_incompleted():
			return None

	if fn.type.is_bad():
		return None

	if fn.id.str == 'main':
		fn.id.addAttribute('nodecorate')
		fn.id.addAttribute('entrypoint')

	if x['stmt'] == None:
		df = add_spices_def(fn.definition, x['anno'])
		return df

	# not above (!)
	fn.is_pure = is_pure_type(fn.type)

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

	df = add_spices_def(fn.definition, x['anno'])
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




# пропускать остальные ветви (elseif & else) условной директивы
# тк основная ветвь была выполнена
#skipp = False
#prev_skipp = False

import_stack = []

def do_import(x):
	global modules
	global cmodule

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
	cmodule.imports[_as] = y
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
		elif s0 == 'module_nodecorate':
			cmodule.addAttribute('nodecorate')
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
			cmodule.setPrefix(prefix)
		elif s0 == 'append_prefix':
			prefix = args[1]
			#print('append_prefix = %s' % prefix)
			global_prefix = prefix
			pass
		elif s0 == 'remove_prefix':
			prefix = args[1]
			#print('remove_prefix = %s' % prefix)
			global_prefix = global_prefix.removesuffix(prefix)

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
	prev_env_current_file_dir = env_current_file_dir
	env_current_file_dir = os.path.dirname(abspath)

	tokens = lexer.run(abspath)
	ast = parser.parse(tokens)

	m = None
	if ast != None:
		idStr = abspath.split('/')[-1][:-2]
		m = process_module(idStr, abspath, ast, is_include=is_include)
		#m.prefix = m.id
		m.source_abspath = abspath

	env_current_file_dir = prev_env_current_file_dir

	log_pop()
	log("")
	return m



def process_module(idStr, sourcename, ast, is_include):
	global skipp, production

	global cmodule
	prev_module = cmodule

	symtab_public = root_symtab.branch()
	symtab_private = Symtab()

	global context
	prev_context = context
	context = {
		'public': symtab_public,
		'private': symtab_private
	}

	cmodule = Module(idStr, ast, symtab_public, symtab_private, sourcename)

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
		if 'public_module' in cmodule.att:
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
				t.is_global_flag = True

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
				v.is_global_flag = True



def def_phase2(ast, is_include=False):
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




def add_spices_def(x, ast_atts):
	for a in ast_atts:
		kind = a['kind']
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

		x.annotations.update({kind: annotation})

		if kind in [
			'used', 'unused', 'inline',
			'inlinehint', 'noinline', 'alignment',
			'section', 'nonstatic'
		]:
			pass
		elif kind == 'alias':
			# 1. @alias("alias")
			# 2. @alias("llvm", "llvm_alias")
			args = a['args']
			if len(args) == 2:
				backend = args[0]['value']['str']
				identifier = args[1]['value']['str']
				setObjAttrByPath(x, "id.%s" % backend, identifier)
			elif len(args) == 1:
				identifier = args[0]['value']['str']
				setObjAttrByPath(x, "id.c", identifier)
				setObjAttrByPath(x, "id.cm", identifier)
				setObjAttrByPath(x, "id.llvm", identifier)
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

		else:
			print(a)
			exit(1)
			key = a['args'][0]['value']['str']
			print(key)
			add_att(x, key)
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
def get_cspecs(s):
	specs = []
	i = 0
	while i < len(s):
		c = s[i]
		if c == '%':
			i += 1
			c = s[i]
			specs.append(c)
		i += 1
	return specs


# check extra arguments of print, scanf, etc.
# requires specs from get_cspecs & extra_args list
# expected_pointers for case of scanf("%d", &x)
def extra_args_check(specs, extra_args, expected_pointers):
	i = 0
	# extra_args rest args
	nargs = len(extra_args)
	nspec = len(specs)
	while i < nargs and i < nspec:
		arg = extra_args[i]
		arg_type = arg.type

		if arg.isValueBad():
			i += 1
			continue

		spec = specs[i]

		if expected_pointers:
			if not arg_type.is_pointer():
				warning("expected pointer", arg.ti)
				i += 1
				continue

			arg_type = arg_type.to


		if spec in ['i', 'd']:
			if arg_type.is_int():
				if arg_type.is_unsigned():
					warning("expected signed integer value", arg.ti)
			else:
				warning("expected integer value2", arg.ti)

		elif spec == 'x':
			if not arg_type.is_int():
				warning("expected integer value3", arg.ti)

		elif spec == 'u':
			if arg_type.is_int():
				if arg_type.is_signed():
					warning("expected unsigned integer value", arg.ti)
			else:
				warning("expected integer value4", arg.ti)

		elif spec == 's':
			if not arg_type.is_pointer_to_str():
				warning("expected pointer to string", arg.ti)

		elif spec == 'f':
			if not arg_type.is_float():
				warning("expected float value", arg.ti)

		elif spec == 'c':
			if not arg_type.is_char():
				warning("expected char value", arg.ti)

		elif spec == 'p':
			if not arg_type.is_pointer():
				warning("expected pointer value", arg.ti)

		i += 1
	return



def cp_immediate(to, _from):
	if _from.asset != None:
		to.asset = _from.asset

	to.is_immutable = _from.is_immutable
	to.stage = _from.stage
	return


