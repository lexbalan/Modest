
import os

import copy

from error import *

from lexer import CmLexer
from parser import Parser

from util import get_item_by_id
from common import settings, features
import type as htype
from hlir.hlir import *

import foundation

from value.bool import value_bool_create
from value.num import value_number_create
from value.float import value_float_create
from value.array import value_array_create, value_array_add
from value.string import value_string_create, value_string_add
from value.record import value_record_create
from value.value import value_imm_literal_create
from value.word import value_word_create

import decimal


lexer = CmLexer()
parser = Parser()



# сущность из текущего модуля
def is_local_entity(x):
	global cmodule
	if hasattr(x, 'definition') and x.definition != None:
		return x.definition.parent == cmodule
	return True





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
# TODO: разберись с контекстом- сейчас он только symtab_public!
context = None  # current context (symtab)
cdef = None


# for @distinct types
distinct_cnt = 0



def cmodule_use(x):
	global cmodule
	if not x in cmodule.att:
		cmodule.att.append(x)



# TODO: attribute 'unsafe' for cast operation
unsafe_mode = False
def is_unsafe_mode():
	return unsafe_mode


# тепреь вызывается только из конструктора строки (value)
def cmodule_strings_add(v):
	global cmodule
	cmodule.strings.append(v)


def cmodule_value_add(id_str, v, is_public=False):
	global cmodule
	cmodule.value_add(id_str, v, is_public=is_public)


def cmodule_type_add(id_str, t, is_public=False):
	global cmodule
	cmodule.type_add(id_str, t, is_public=is_public)



# ONLY FOR LOCALS:

def ctx_type_add(id_str, t, is_public=False):
	global context
	if is_public:
		context['public'].type_add(id_str, t)
	else:
		context['private'].type_add(id_str, t)


def ctx_value_add(id_str, v, is_public=False):
	global context
	if is_public:
		context['public'].value_add(id_str, t)
	else:
		context['private'].value_add(id_str, v)



def ctx_type_get(id_str):
	global context
	#print("ctx_type_get %s" % id_str)
	t = context['private'].type_get(id_str)
	if t == None:
		t = context['public'].type_get(id_str)
	return t


def ctx_value_get(id_str, shallow=False):
	global context
	#print("ctx_value_get %s" % id_str)
	v = context['private'].value_get(id_str, shallow=shallow)
	if v == None:
		v = context['public'].value_get(id_str, shallow=shallow)
	return v



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




def add_spices_any(v, atts):
	for a in atts:
		k = a['kind']
		v.att.append(k)
	return v




def insert(s):
	global cmodule
	directive_insert = {
		'isa': 'directive',
		'kind': 'insert',
		'str': s,
		'att': [],
		'nl': 1,
		'ti': None
	}
	cmodule.defs.append(directive_insert)


def feature_add(s):
	features.append(s)


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

foundation_module = None



def valueZeroNumber():
	gt = TypeNumber()
	return value_imm_literal_create(gt, 0)


def init():
	global foundation_module
	#lib_path = settings['lib']

	# max number of signs after .
	# decimal operation precision
	decimal.getcontext().prec = settings['precision']


	foundation_module = foundation.init()

	global root_symtab
	# init main context
	root_symtab = Symtab()

	root_symtab.type_add('Unit', foundation.typeUnit)
	root_symtab.type_add('Bool', foundation.typeBool)

	root_symtab.type_add('Word8', foundation.typeWord8)
	root_symtab.type_add('Word16', foundation.typeWord16)
	root_symtab.type_add('Word32', foundation.typeWord32)
	root_symtab.type_add('Word64', foundation.typeWord64)
	root_symtab.type_add('Word128', foundation.typeWord128)
	root_symtab.type_add('Word256', foundation.typeWord256)

	root_symtab.type_add('Int8', foundation.typeInt8)
	root_symtab.type_add('Int16', foundation.typeInt16)
	root_symtab.type_add('Int32', foundation.typeInt32)
	root_symtab.type_add('Int64', foundation.typeInt64)
	root_symtab.type_add('Int128', foundation.typeInt128)
	root_symtab.type_add('Int256', foundation.typeInt256)

	root_symtab.type_add('Nat8', foundation.typeNat8)
	root_symtab.type_add('Nat16', foundation.typeNat16)
	root_symtab.type_add('Nat32', foundation.typeNat32)
	root_symtab.type_add('Nat64', foundation.typeNat64)
	root_symtab.type_add('Nat128', foundation.typeNat128)
	root_symtab.type_add('Nat256', foundation.typeNat256)

	#root_symtab.type_add('Float16', foundation.typeFloat16)
	root_symtab.type_add('Float32', foundation.typeFloat32)
	root_symtab.type_add('Float64', foundation.typeFloat64)

	#root_symtab.type_add('Decimal32', foundation.typeDecimal32)
	#root_symtab.type_add('Decimal64', foundation.typeDecimal64)
	#root_symtab.type_add('Decimal128', foundation.typeDecimal128)

	root_symtab.type_add('Char8', foundation.typeChar8)
	root_symtab.type_add('Char16', foundation.typeChar16)
	root_symtab.type_add('Char32', foundation.typeChar32)

	root_symtab.type_add('Str8', foundation.typeStr8)
	root_symtab.type_add('Str16', foundation.typeStr16)
	root_symtab.type_add('Str32', foundation.typeStr32)

	root_symtab.type_add('Ptr', foundation.typeFreePointer)

	root_symtab.type_add('__VA_List', foundation.type__VA_List)


	global valueTrue, valueFalse, valueNil
	valueNil = value_imm_literal_create(foundation.typeNil, 0)
	valueTrue = value_bool_create(1)
	valueFalse = value_bool_create(0)

	root_symtab.value_add('nil', valueNil)
	root_symtab.value_add('true', valueTrue)
	root_symtab.value_add('false', valueFalse)


	word_width = int(settings['word_width'])
	char_width = int(settings['char_width'])
	int_width = int(settings['integer_width'])
	flt_width = int(settings['float_width'])
	pointer_width = int(settings['pointer_width'])

	global typeSysWord, typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr, typeSysSize

	typeSysWord = TypeWord(word_width)
	typeSysChar = foundation.type_select_char(char_width)
	typeSysInt = foundation.type_select_int(int_width)
	typeSysNat = foundation.type_select_nat(int_width)
	typeSysFloat = foundation.typeFloat64

	typeSysSize = foundation.type_select_nat(settings['size_width']).copy()
	typeSysSize.id = Id().fromStr('Size')
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
	compilerVersionMajor = value_imm_literal_create(foundation.typeNat32, 0)
	compilerVersionMinor = value_imm_literal_create(foundation.typeNat32, 7)

	compiler_version_initializers = [
		Initializer(Id().fromStr('major'), compilerVersionMajor),
		Initializer(Id().fromStr('minor'), compilerVersionMinor)
	]
	compilerVersion = value_record_create(compiler_version_initializers)

	# '__compiler' record
	compiler_initializers = [
		Initializer(Id().fromStr('name'), compilerName),
		Initializer(Id().fromStr('version'), compilerVersion),
	]
	compiler = value_record_create(compiler_initializers)
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
	__targetCharWidth = value_imm_literal_create(foundation.typeNat32, char_width)
	__targetIntWidth = value_imm_literal_create(foundation.typeNat32, int_width)
	__targetFloatWidth = value_imm_literal_create(foundation.typeNat32, flt_width)
	__targetPointerWidth = value_imm_literal_create(foundation.typeNat32, pointer_width)

	# '__target' record
	target_initializers = [
		Initializer(Id().fromStr('name'), __targetName),
		Initializer(Id().fromStr('charWidth'), __targetCharWidth),
		Initializer(Id().fromStr('intWidth'), __targetIntWidth),
		Initializer(Id().fromStr('floatWidth'), __targetFloatWidth),
		Initializer(Id().fromStr('pointerWidth'), __targetPointerWidth),
	]
	target = value_record_create(target_initializers)
	root_symtab.value_add('__target', target)



# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position no
# offset - real offset (address inside container struct)
def do_field(x):
	#info("do_field", x['ti'])
	id = Id(x['id'])
	if id.str[0].isupper():
		error("field id must starts with small letter", id.ti)

	t = do_type(x['type'])
	iv = do_value(x['init_value'])

	if not iv.isUndef():
		# у поля есть инициализатор
		pass

	iv = None
	if x['init_value'] != None:
		iv = do_value(x['init_value'])

	f = Field(id, t, init_value=iv, ti=x['ti'])
	f.nl = x['nl']

	if f.nl == 0:
		f.nl = 1

	f.access_level = x['access_modifier']

	add_spices_any(f, x['atts'])
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
			error("unknown namespace '%s'" % module_id)
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
		if not isinstance(cdef, StmtDefType):
			error("forward references to non-struct type", x['ti'])
		cdef.deps.append(t)

	return t



def do_type_pointer(x):
	to = do_type(x['to'])
	return TypePointer(to, ti=x['ti'])


def do_type_array(x):
	of = do_type(x['of'])
	volume = do_value(x['size'])

	if volume.isBad():
		return TypeArray(of, volume, ti=x['ti'])

	if not volume.isUndef():
		if volume.isRuntimeValue():
			#info("VLA", t['ti'])
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

	for field in x['fields']:
		f = do_field(field)

		# redefinition?
		field_id_str = f.id.str
		field_already_exist = get_item_by_id(fields, field_id_str)
		if field_already_exist != None:
			error("redefinition of '%s' field" % field_id_str, field.ti)
			continue

		#if 'comments' in field:
		for comment in field['comments']:
			f.comments.append(do_stmt_comment(comment))

		if field['line_comment']:
			f.line_comment = do_stmt_comment(field['line_comment'])

		fields.append(f)

	rec = TypeRecord(fields, ti=x['ti'])
	rec.uid = uid

	# add anon record (before)
	anon_tag = '__anonymous_struct_%d' % uid
	rec.c_anon_id = anon_tag

	cmodule.anon_recs.append(rec)
	return rec



def do_type_func(x, func_id="_"):
	params = []
	for _param in x['params']:
		param = do_field(_param)
		if param != None:
			params.append(param)

	to = foundation.typeUnit
	if x['to'] != None:
		to = do_type(x['to'])

	return TypeFunc(params, to, x['arghack'], ti=x['ti'])




def add_spices_type(t, atts):
	global distinct_cnt

	if atts != []:
		t = Type.copy(t)

	for a in atts:
		k = a['kind']
		t.att.append(k)

		if k == 'distinct':
			#info("distinct type", t.ti)
			# Type.brand must be > 0 (!)
			distinct_cnt += 1
			t.brand = distinct_cnt

		elif k == 'refined':
			#info("refined type", t.ti)
			t.refine = t.brand
			distinct_cnt += 1
			t.brand = distinct_cnt

		if t.is_array():
			#mass
			if k == 'const':
				t.of = Type.copy(t.of)
				t.of.att.append('const')
			if k == 'volatile':
				t.of = Type.copy(t.of)
				t.of.att.append('volatile')

	return t


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
	return add_spices_type(t, x['atts'])



def do_value_shift(x):
	op = x['kind']  # 'shl' | 'shr'
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])

	if not l.type.is_word():
		error("expected word value", x['left'])
		return ValueBad(x['ti'])

	if r.type.is_signed():
		error("expected natural value", x['right'])
		return ValueBad(x['ti'])

	nv = None
	if op == 'shl': nv = ValueShl(l, r, ti=x['ti'])
	elif op == 'shr': nv = ValueShr(l, r, ti=x['ti'])

	if l.type.is_generic():
		error("expected non-generic value", l.ti)
		return ValueBad(x['ti'])

	return nv


def do_value_bin(x):
	op = x['kind']
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	return do_value_bin2(op, l, r, x['ti'])


def do_value_bin2(op, l, r, ti):
	if l.isBad() or r.isBad():
		return ValueBad(ti)

	if l.isUndef() or r.isUndef():
		t = htype.select_common_type(l.type, r.type)
		return ValueUndef(t)


	# Ops with different types
	if op == 'add':
		# массивы могут быть разной длины (то есть с разными типами)
		# поэтому сложение immediate массивов требует обхода проверок типа ниже
		if l.type.is_array() and r.type.is_array():
			return value_array_add(l, r, ti)
		# у string тип всегда одинаковый и приводить их не нужно
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

	t = htype.select_common_type(l.type, r.type)
	if t == None:
		error("different types in operation", ti)
		return ValueBad(ti)

	l = value_cons_implicit(t, l)
	r = value_cons_implicit(t, r)

	if not Type.eq(l.type, r.type, ti):
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

	if op in ['eq', 'ne']:
		return Value.eq(l, r, op, ti)

	if Type.eq(t, foundation.typeBool):
		if op == 'or': op = 'logic_or'
		elif op == 'and': op = 'logic_and'

	if op in (htype.EQ_OPS + htype.RELATIONAL_OPS):
		t = foundation.typeBool

	return ValueBin(t, op, l, r, ti=ti)


def do_value_not(x):
	v = do_rvalue(x['value'])

	if v.isBad() or v.isUndef():
		return v

	vtype = v.type

	if not vtype.supports('not'):
		error("unsuitable type", v.ti)
		return ValueBad(x['ti'])

	op = 'not'
	if vtype.is_bool():
		op = 'logic_not'

	return ValueNot(vtype, v, ti=x['ti'])


def do_value_neg(x):
	v = do_rvalue(x['value'])

	if v.isBad() or v.isUndef():
		return v

	vtype = v.type

	if not vtype.is_generic():
		if vtype.is_unsigned():
			error("expected value with signed type", v.ti)
	else:
		vtype.signed = True

	return ValueNeg(vtype, v, ti=x['ti'])


def do_value_pos(x):
	v = do_rvalue(x['value'])

	if v.isBad() or v.isUndef():
		return v

	vtype = v.type

	if vtype.is_unsigned():
		error("expected value with signed type", v.ti)

	return ValuePos(vtype, v, ti=x['ti'])


def do_value_ref(x):
	v = do_value(x['value'])

	if v.isBad() or v.isUndef():
		return v

	ti = x['ti']
	op = x['kind']
	vtype = v.type

	if v.isImmutable():
		if not vtype.is_func() or vtype.is_incompleted():
			error("expected mutable value or function", v.ti)
			return ValueBad(ti)

	return ValueRef(v, ti=ti)


def do_value_new(x):
	v = do_value(x['value'])

	if v.isBad() or v.isUndef():
		return v

	return ValueNew(v)


def do_value_deref(x):
	v = do_rvalue(x['value'])

	if v.isBad() or v.isUndef():
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

	return ValueDeref(v, ti=x['ti'])



def sort_args(params, args):
	# выходной вектор в котором лежат отсортированные аргументы
	# в порядке их реальной преедачи в функцию
	outvec = []

	# получаем направляющий вектор
	vec0=[]
	for param in params:
		vec0.append(param.id.str)

	# получаем вектор идентификаторов (или None)
	vec1=[]
	vec1.extend(args)

	# теперь разбрасываем аргументы
	for param_id_str in vec0:
		# ищем аргумент с именем параметра (param_id_str)
		k = -1 # -1 значит не найден
		i = 0
		while i < len(vec1):
			item = vec1[i]
			if item != None:
				if item['key'] != None:
					if item['key']['str'] == param_id_str:
						k = i
						break
			i += 1

		j = 0
		if k >= 0:
			j = k

		arg = vec1[j]
		vec1.pop(j)
		outvec.append(arg)

	return outvec



def do_value_lengthof_value(x):
	ti = x['ti']
	arg = do_rvalue(x['value'])

	if arg.isBad() or arg.isUndef():
		return arg

	if not arg.type.is_array():
		error("expected value with array type", x['value'])
		return ValueBad({'ti': ti})

	# for C backend, because C cannot do lengthof(x)
	cmodule_use('use_lengthof')

	return ValueLengthof(arg, ti)


def do_value_va_start(x):
	args = x['values']
	va_list = do_value(args[0])
	last_param = do_rvalue(args[1])
	return ValueVaStart(va_list, last_param, x['ti'])


def do_value_va_arg(x):
	va_list = do_value(x['va_list'])
	type = do_type(x['type'])
	return ValueVaArg(type, va_list, x['ti'])


def do_value_va_end(x):
	va_list = do_value(x['value'])
	return ValueVaEnd(va_list, x['ti'])


def do_value_va_copy(x):
	args = x['values']
	va_list0 = do_value(args[0])
	va_list1 = do_value(args[1])
	return ValueVaCopy(va_list0, va_list1, x['ti'])


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
def transmission(to_type, value):
	return value_cons_implicit_check(to_type, value)



def do_value_call(x):
	fn = do_rvalue(x['left'])

	if fn.isBad() or fn.isUndef():
		return fn

	if fn.isBad():
		#error("undefined value", fn.ti)
		return ValueBad(x['ti'])


	ftype = fn.type

	# pointer to function?
	if ftype.is_pointer():
		ftype = ftype.to

	if not ftype.is_func():
		error("expected function or pointer to function", x)

	params = ftype.params
	args = x['args']

	npars = len(params)
	nargs = len(args)

	if nargs < npars:
		error("not enough args", x)
		return ValueBad(x['ti'])

	if nargs > npars:
		if not ftype.extra_args:
			error("too many args", x)
			return ValueBad(x['ti'])

	sorted_args = sort_args(params, x['args'])


	imm_args = True  # all arguments are immediate?

	args = []

	# normal args
	i = 0
	while i < npars:
		param = params[i]
		param_id_str = param.id.str
		a = sorted_args[i]

		# check param name (if assigned)
		if a['key'] != None:
			tasrget_param_id_str = a['key']['str']
			if tasrget_param_id_str != param_id_str:
				error("bad parameter id", a['key']['ti'])

		arg = do_rvalue(a['value'])


		if not arg.isBad():
			arg = transmission(param.type, arg)

			if not arg.isImmediate():
				imm_args = False

			id = None
			if a['key'] != None:
				id = Id(a['key'])
			args.append(Initializer(id, arg, ti=a['ti'], nl=a['nl']))

		i += 1

	#
	# extra args
	#

	extra_args = []

	i_before_extra = i

	# extra_args rest args
	while i < nargs:
		ini = x['args'][i]
		a = ini['value']
		argval = do_rvalue(a)

		if not argval.isBad():
			if argval.type.is_generic():
				warning("extra argument with generic type", a['ti'])
			argval = value_cons_default(argval)

			if argval.isRuntimeValue():
				imm_args = False

			extra_args.append(Initializer(id, argval, ti=ini['ti'], nl=ini['nl']))

		i += 1

	return ValueCall(ftype.to, fn, args + extra_args, ti=x['ti'])






def do_value_index(x):
	left = do_rvalue(x['left'])

	if left.isBad():
		return ValueBad(x['ti'])

	if left.isUndef():
		return ValueUndef(x['ti'])

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

	index = do_rvalue(x['index'])

	#if index.isBad():
	if index.type.is_bad():
		return ValueBad(x['ti'])

	if not (index.type.is_arithmetical() or index.type.is_num()):
		error("expected integer value2", x['index'])
		return ValueBad(x['ti'])

	if index.type.is_generic():
		index = value_cons_implicit_check(typeSysInt, index)

	return ValueIndex(array_typ.of, left, index, ti=x['ti'])



def do_value_slice(x):
	#info("do_value_slice", x['ti'])
	ti = x['ti']

	left = do_value(x['left'])
	if left.isBad():
		return ValueBad(x['ti'])

	index_from = None
	if x['index_from'] != None:
		index_from = do_rvalue(x['index_from'])
		if index_from.isBad():
			return ValueBad(ti)
	else:
		index_from = valueZeroNumber()

	index_to = None
	if x['index_to'] != None:
		index_to = do_rvalue(x['index_to'])
		if index_to.isBad():
			return ValueBad(ti)
	else:
		index_to = ValueUndef(TypeNumber())


	left_type = left.type
	via_pointer = left_type.is_pointer()
	array_type = left_type
	if via_pointer:
		array_type = left_type.to

	if not array_type.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])


	# получаем размер слайса
	# строим выражения для C бекенда в частности
	# тк volume of array должен быть выражением
	# а для слайса [a:b] это (b - a)
	slice_volume = do_value_bin2('sub', index_to, index_from, x['ti'])

	slice_len = 0  # len as integer
	if slice_volume.isImmediate():
		slice_len = slice_volume.asset
		if slice_len < 0:
			error("wrong slice direction", x['ti'])
			return ValueBad(x['ti'])

	type = TypeArray(array_type.of, slice_volume, generic=False, ti=x['ti'])
	return ValueSlice(type, left, index_from, index_to, x['ti'])



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
		if v != None:
			error("access to module private item", ti)

	if v == None:
		error("module '%s' does not have value '%s'" % (mname, iname), x['ti'])
		return ValueBad(x['ti'])

	if v.type.is_incompleted():
		v = value_update_incompleted_type(submodule, v, iname)

	return ValueAccessModule(v.type, x['left'], x['right'], v, ti=x['ti'])



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

	left = do_rvalue(x['left'])

	if left.isBad():
		return ValueBad(x['ti'])

	field_id = Id(x['right'])

	# доступ через переменную-указатель
	via_pointer = left.type.is_pointer()

	record_type = left.type
	if via_pointer:
		record_type = left.type.to

	# check if is record
	if not record_type.is_record():
		error("expected record or pointer to record", x)
		return ValueBad(x['ti'])

	field = htype.record_field_get(record_type, field_id.str)

	# if field not found
	if field == None:
		error("undefined field '%s'" % field_id.str, x['ti'])
		return ValueBad(x['ti'])

	if field.type.is_bad():
		return ValueBad(x['ti'])


	# Check access permissions

	# не у всех типов есть 'definition' (его нет у анонимных записей например)
	if not is_local_entity(record_type):
		if field.access_level == 'private':
			error("access to private field of record", x['right']['ti'])

	return ValueAccessRecord(field.type, left, field, ti=x['ti'])



def do_value_cons(x):
	v = do_rvalue(x['value'])
	t = do_type(x['type'])
	if v.isBad() or t.is_bad():
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
		v.addAttribute('unknown')
		ctx_value_add(id_str, v)
		return v


	global cdef

	if v.isBad():
		return v

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
				Id(item['key']),
				#item['key'],
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

	#if base == 16:
	#	v.addAttribute('hexadecimal')

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
	'or', 'xor', 'and',
	'eq', 'ne', 'lt', 'gt', 'le', 'ge',
	'add', 'sub', 'mul', 'div', 'rem'
]


def do_value_immediate(x, allow_ptr_to_str=False):
	v = do_value(x)

	if v.isBad():
		return v

	if not v.isImmediate():
		if allow_ptr_to_str:
			if v.type.is_pointer_to_str():
				return v
		error("expected immediate value", x['ti'])
		return ValueBad(x['ti'])

	return v


def do_value_immediate_string(x):
	v = do_value_immediate(x)

	if v.isBad():
		return v

	if not v.type.is_string():
		error("expected string value", x['ti'])

	return v



def do_value_unsafe(x):
	#info("do_value_unsafe", ti)
	ti = x['ti']
	if not 'unsafe' in features:
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
	return ValueUndef(t, x['ti'])


def do_rvalue(x):
	return do_value(x)


def do_value_subexpr(x):
	v = do_value(x['value'])
	return ValueSubexpr(v, ti=x['ti'])



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
	elif k == 'cons': v = do_value_cons(x)
	elif k == 'call': v = do_value_call(x)
	elif k in bin_ops: v = do_value_bin(x)
	elif k == 'ref': v = do_value_ref(x)
	elif k == 'not': v = do_value_not(x)
	elif k == 'deref': v = do_value_deref(x)
	elif k == 'index': v = do_value_index(x)
	elif k == 'slice': v = do_value_slice(x)
	elif k == 'access': v = do_value_access(x)
	elif k == 'neg': v = do_value_neg(x)
	elif k == 'pos': v = do_value_pos(x)
	elif k == 'shl': v = do_value_shift(x)
	elif k == 'shr': v = do_value_shift(x)
	elif k == 'new': v = do_value_new(x)
	elif k == 'unsafe': v = do_value_unsafe(x)
	elif k == 'subexpr': v = do_value_subexpr(x)
	elif k == 'sizeof_value': v = do_value_sizeof_value(x)
	elif k == 'sizeof_type': v = do_value_sizeof_type(x)
	elif k == 'alignof': v = do_value_alignof(x)
	elif k == 'offsetof': v = do_value_offsetof(x)
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
	return add_spices_value(v, x['atts'])


#
# Do Statement
#


def do_stmt_const(x):
	global cfunc
	v = do_const(x)
	v.type.att.append('const')
	v.addAttribute('local') # need for LLVM printer (!)
	ctx_value_add(v.id.str, v)
	definition = StmtDefConst(v.id, v, v.init_value, ti=x['ti'])
	definition.parent = cfunc
	v.definition = definition
	return definition



def do_stmt_var(x):
	global cfunc
	var_id = Id(x['id'])
	t = None
	if x['type'] != None:
		t = do_type(x['type'])

	v = do_rvalue(x['init_value'])

	tu = t == None
	vu = v.isUndef()

	# error: no type, no init valuetu = type_is_incompleted(t)
	if tu == True and vu == True:
		# type & value undefined
		ctx_value_add(var_id.str, ValueBad(x['ti']))
		return StmtBad(x)

	if tu == True and vu == False:
		# type undef, value ok
		#Type.update(nt, v.type)
		if v.type.is_generic():
			error("variable with generic type", x['ti'])
			v = value_cons_default(v)
		t = Type.copy(v.type)
		t.att = []

	#if not t.is_incompleted():
	#	if t.is_bad():
	#		ctx_value_add(var_id.str, ValueBad(x['ti']))
	#		return StmtBad(x)
	#
		if t.is_forbidden_var():
			error("unsuitable type1", x['type']['ti'])

	# type & init value present
	if t != None and not v.isUndef():
		v = value_cons_implicit_check(t, v)

	if t == None:
		if v.type.is_generic():
			v = value_cons_default(v)

		t = Type.copy(v.type)
		t.att = []

	# check if identifier is free (in current block)
	already = ctx_value_get(var_id.str, shallow=True)
	if already != None:
		error("local id redefinition", x['id']['ti'])
		info("firstly defined here", already.id.ti)
		return StmtBad(x)

	var_value = add_local_var(var_id, t, var_id.ti)
	definition = StmtDefVar(var_id, var_value, v, ti=x['ti'])
	definition.parent = cfunc
	return definition



def do_stmt_if(x):
	cond = do_rvalue(x['cond'])

	if cond.isBad():
		return StmtBad(x)

	if not cond.type.is_bool():
		error("expected bool value", cond.ti)
		return StmtBad(x)

	_then = do_stmt(x['then'])

	if _then.is_bad():
		return StmtBad(x)

	_else = None
	if x['else'] != None:
		_else = do_stmt(x['else'])
		if _else.is_bad():
			return StmtBad(x['else'])

	return StmtIf(cond, _then, _else, ti=x['ti'])



def do_stmt_while(x):
	cond = do_rvalue(x['cond'])

	if cond.isBad():
		return StmtBad(x)

	if not cond.type.is_bool():
		error("expected bool value", cond.ti)
		return StmtBad(x)

	block = do_stmt(x['stmt'])

	if block.is_bad():
		return StmtBad(x)

	return StmtWhile(cond, block, ti=x['ti'])



def do_stmt_return(x):
	global cfunc

	func_ret_type = cfunc.type.to

	is_no_ret_func = func_ret_type.is_unit()
	ret_val_present = x['value'] != None

	# если забыли вернуть значение
	# или возвращаем его там, где оно не ожидется
	if ret_val_present == is_no_ret_func:
		if ret_val_present:
			error("unexpected return value", x['value']['ti'])
		else:
			error("expected return value", x['ti'])
		return StmtBad(x)

	# (!) in return statement retval can be None (!)
	retval = None
	if ret_val_present:
		rv = do_rvalue(x['value'])
		retval = transmission(func_ret_type, rv)

	return StmtReturn(retval, ti=x['ti'])


def do_stmt_type(x):
	fatal("do_stmt_type() not implemented")


def do_stmt_again(x):
	return StmtAgain(x['ti'])


def do_stmt_break(x):
	return StmtBreak(x['ti'])



def add_local_var(id, typ, ti):
	iv = ValueUndef(typ)
	var_value = ValueVar(typ, id, init_value=iv, ti=ti)
	var_value.addAttribute('local')
	ctx_value_add(id.str, var_value)
	return var_value




def do_stmt_assign(x):
	l = do_value(x['left'])
	r = do_rvalue(x['right'])

	if l.isBad():
		if x['left']['kind'] == 'id':
			# if left is 'unknown id':
			id = Id(x['left'])
			t = r.type
			l = add_local_var(id, t, id.ti)

	if l.isBad() or r.isBad():
		return StmtBad(x)

	if not l.isLvalue():
		error("expected lvalue", l.ti)
		return StmtBad(x)

	if l.isImmutable():
		error("expected mutable value", l.ti)
		return StmtBad(x)

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
		if not r.isZero():
			cmodule_use('use_lengthof')
			cmodule_use('use_arrcpy')


	r = transmission(l.type, r)
	return StmtAssign(l, r, ti=x['ti'])



def do_stmt_incdec(x, op='add'):
	v = do_value(x['value'])

	if v.isBad():
		return StmtBad(x)

	if v.isImmutable():
		error("expected mutable value", v.ti)
		return StmtBad(x)

	if not v.type.is_arithmetical():
		error("expected value with integer type", v.ti)
		return StmtBad(x)

	one = value_imm_literal_create(v.type, 1, ti=x['ti'])
	xv = ValueBin(v.type, op, v, one, ti=x['ti'])
	return StmtAssign(v, xv, ti=x['ti'])



def do_stmt_value(x):
	v = do_rvalue(x['value'])

	if v.isBad():
		return StmtBad(x)

	if not v.type.is_unit():
		if not v.hasAttribute('unused'):
			warning("unused result of %s expression" % x['value']['kind'], v.ti)

	return StmtValueExpression(v, ti=x['ti'])



def do_stmt_comment(x):
	if x['kind'] == 'comment-line':
		return do_stmt_comment_line(x)
	elif x['kind'] == 'comment-block':
		return do_stmt_comment_block(x)
	return None


def do_stmt_comment_line(x):
	return StmtCommentLine(x['lines'], ti=x['ti'], nl=x['nl'])


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
		val = do_rvalue(items[1]['value'])
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
	elif k == 'inc': s = do_stmt_incdec(x, 'add')
	elif k == 'dec': s = do_stmt_incdec(x, 'sub')
	elif k == 'type': s = do_stmt_type(x)
	elif k == 'comment-line': s = do_stmt_comment_line(x)
	elif k == 'comment-block': s = do_stmt_comment_block(x)
	elif k == 'asm': s = do_stmt_asm(x)
	else: s = StmtBad(x)

	assert(s != None)
	s.nl = x['nl']

	return s



def do_stmt_block(x, parent=None):
	context_push()

	block = StmtBlock([], ti=x['ti'])
	block.parent = parent

	stmts = []
	for stmt in x['stmts']:
		s = do_stmt(stmt)
		if not s.is_bad():
			s.parent = block
			block.stmts.append(s)

	context_pop()

	return block





def def_type(x):
	global cmodule
	global cdef
	global global_prefix

	id = Id(x['id'])
	log("def_type: %s" % id.str)
	id.prefix = global_prefix

	# тип уже был задекларирован при первом проходе, теперь определяем его
	nt = ctx_type_get(id.str)
	if not nt.is_incompleted():
		error("type redefinition", x['ti'])
		return None

	definition = StmtDefType(id, nt, None, x['ti'])
	definition.module = cmodule
	definition.parent = cmodule
	definition.access_level = x['access_modifier']
	definition.nl = x['nl']
	cdef = definition

	ty = do_type(x['type'])

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

	if ty.is_record():
		cmodule.records.append(nt)

	cdef = None
	return definition



def def_const(x):
	#global cdef
	global cmodule
	global global_prefix

	nv = do_const(x)
	iv = nv.init_value

	if not isinstance(iv, ValueUndef):
		if not (iv.isImmediate() or iv.linktime):
			error("expected immediate value", iv.ti)

	nv.id.prefix = global_prefix

	is_public = x['access_modifier'] == 'public'
	cmodule_value_add(nv.id.str, nv, is_public=is_public)

	definition = StmtDefConst(nv.id, nv, iv, x['ti'])
	definition.parent = cmodule
	definition.module = cmodule
	definition.access_level = x['access_modifier']
	definition.nl = x['nl']

	nv.parent = cmodule
	nv.definition = definition

	return definition


#if iv.isBad():
	#	# check if identifier is free (in current block)
	#	already = ctx_value_get_shallow(id.str)
	#	if already != None:
	#		error("redefinition of '%s'" % id.str, id.ti)
	#		return StmtBad(x)

def do_const(x):
	id = Id(x['id'])

	log("do_const: %s" % id.str)

	# check if identifier is free
	pre_exist = ctx_value_get(id.str, shallow=True)
	if pre_exist != None:
		error("redefinition of '%s'" % id.str, id.ti)

	iv = do_rvalue(x['init_value'])

	#mass
	t = None
	if x['type'] != None:
		t = Type.copy(do_type(x['type']))
		#type.att = []
		iv = value_cons_implicit_check(t, iv)

	if t == None:
		t = Type.copy(iv.type)
		t.att = []

	const_value = ValueConst(t, id, init_value=iv, ti=id.ti)

	if iv.isImmediate():
		const_value.immediate = True
		cp_immediate(const_value, iv)

	return const_value



def def_var(x):
	global cdef
	global global_prefix

	id = Id(x['id'])
	log("def_var %s" % id.str)
	id.prefix = global_prefix

	# already defined? (check identifier)
	already = ctx_value_get(id.str)
	if already != None:
		error("redefinition of '%s'" % id.str, id.ti)

	definition = StmtDefVar(id, None, None, x['ti'])
	definition.module = cmodule
	definition.parent = cmodule
	definition.access_level = x['access_modifier']
	if definition.access_level == 'public':
		if settings['public_vars_forbidden']:
			error("public variables are forbidden", x['ti'])

	definition.nl = x['nl']
	cdef = definition

	t = None
	if x['type'] != None:
		t = do_type(x['type'])
	v = do_rvalue(x['init_value'])

	tu = t == None
	vu = v.isUndef()

	# error: no type, no init valuetu = type_is_incompleted(t)
	if tu == True and vu == True:
		# ERROR: type & value undefined
		ctx_value_add(id.str, ValueBad(x['ti']))
		return StmtBad(x)

	elif tu == True and vu == False:
		# type undef, value ok

		#Type.update(nt, v.type)
		v = value_cons_default(v)
		t = Type.copy(v.type)

	elif tu == False and vu == False:
		# type ok, value ok

		if t.is_open_array():
			if v.type.is_string():
				# for case:
				# var arrayFromString: []Char8 = "abc"
				str_length = len(v.asset)
				volume = value_number_create(str_length)
				t = TypeArray(t.of, volume, ti=x['ti'])
			elif v.type.is_array():
				# for case:
				# var a: []*Str8 = ["Ab", "aB", "AAb"]

				volume = value_number_create(v.type.volume.asset)
				t = TypeArray(t.of, volume, ti=x['ti'])
				#v = value_cons_default(v)
				#t = Type.copy(v.type)

		v = value_cons_implicit_check(t, v)

	elif tu == False and vu == True:
		# type ok, value undef
		# пропишем тип для v
		v.type = t

	init_value = v

	var_value = ValueVar(t, id, init_value=init_value, ti=id.ti)
	cmodule_value_add(id.str, var_value, is_public=x['access_modifier'] == 'public')


	definition.value = var_value
	definition.init_value = init_value
	var_value.parent = cmodule
	var_value.definition = definition
	cdef = None
	return definition



def def_func(x):
	global cdef
	global cfunc
	global cmodule
	global global_prefix

	log('def_func: %s' % x['id']['str'])

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
		return fn.definition

	context_push()  # create params context

	prev_cfunc = cfunc
	cfunc = fn

	params = fn.type.params

	#if len(params) > 0:
	#	p0 = params[0]
	#	if p0.id.str == 'self':
	#		info("SELF", p0.ti)

	i = 0
	while i < len(params):
		param = params[i]
		param_value = ValueConst(param.type, param.id, init_value=ValueUndef(param.type), ti=param.ti)
		param_value.addAttribute('local')
		param_value.addAttribute('param')
		ctx_value_add(param.id.str, param_value)
		i += 1

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
			elif not isinstance(stmts[-1], StmtReturn):
				warning("expected return operator at end", stmt.ti)

	fn.definition.stmt = stmt

	context_pop()  # remove params context
	cfunc = prev_cfunc
	cdef = None

	return fn.definition



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



def do_import(x):
	global modules
	global cmodule

	import_expr = do_value_immediate_string(x['expr'])

	if import_expr.isBad():
		return None

	# Literal string to python string
	impline = import_expr.asset

	_as = None
	if x['as'] != None:
		_as = x['as']['str']
	else:
		_as = impline.split("/")[-1]

	#info("AS %s" % _as, x['ti'])

	abspath = get_import_abspath(impline, ext='.m')

	log('do_import("%s")' % impline)

	if abspath == None:
		error("module %s not found" % impline, import_expr.ti)
		return None

	m = None

	# Seek in global modules pool
	if abspath in modules:
		m = modules[abspath]

	if m == None:
		is_import = False
		#is_import = not x['include']
		m = translate(abspath, is_import=is_import, is_include=x['include'])
		modules[abspath] = m

		mid = impline.split("/")[-1]

		if m == None:
			fatal("cannot import module")

		if m.hasAttribute('c_no_print'):
			for xx in m.defs:
				xx['att'].append('c_no_print')

	if x['include']:
		# INCLUDE
		# забираем публичные символы
		# и забираем все определения (исключая дубликаты!)
		if x['access_modifier']:
			# public include
			cmodule.symtab_public.extend(m.symtab_public)

			# копируем все c_include из импортированного модуля себе
			# это костыль, но пока так
			for d in m.defs:
				if isinstance(d, StmtDirectiveCInclude):
					cmodule.defs.append(d)

		cmodule.included_modules.append(m)
		return

	y = StmtImport(impline, _as, module=m, ti=x['ti'], include=x['include'])
	cmodule.imports[_as] = y
	return y



def do_directive(x):
	global cmodule
	global global_prefix
	#info("directive %s" % x['kind'], x['ti'])
	if x['kind'] == 'pragma':
		args = x['args']
		s0 = args[0]
		if s0 == 'do_not_include':
			#print("ADD do_not_include to %s" % cmodule.id)
			cmodule.att.append('do_not_include')
		elif s0 == 'module_nodecorate':
			cmodule.att.append('nodecorate')
		elif s0 == 'c_include':
			return StmtDirectiveCInclude(args[1])
		elif s0 == 'c_no_print':
			cmodule.att.append('c_no_print')
		elif s0 == 'feature':
			feature_add(args[0])
		elif s0 == 'unsafe':
			feature_add('unsafe')
		elif s0 == 'insert':
			print("-INSERT " + args[1])
			return StmtDirectiveInsert(args[1], x['ti'])
		elif s0 == 'append_prefix':
			prefix = args[1]
			#print('append_prefix = %s' % prefix)
			global_prefix = prefix
			pass
		elif s0 == 'remove_prefix':
			prefix = args[1]
			#print('remove_prefix = %s' % prefix)
			global_prefix = global_prefix.removesuffix(prefix)

	return None



def translate(abspath, is_import=False, is_include=False):
	log(">>>> TRANSLATE(\"%s\")" % abspath)
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
		m = process_module(idStr, ast, is_import=is_import, is_include=is_include)
		m.prefix = m.id
		m.source_abspath = abspath

	env_current_file_dir = prev_env_current_file_dir

	log_pop()
	log("<<<< END-TRANSLATE(\"%s\")\n" % abspath)
	return m



def process_module(idStr, ast, is_import=False, is_include=False):
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

	cmodule = Module(idStr, ast, symtab_public, symtab_private)

	# 0. do imports & directives
	while len(ast) > 0:
		x = ast[0]
		isa = x['isa']
		y = None
		if isa == 'ast_import':
			y = do_import(x)
		elif isa == 'ast_directive':
			y = do_directive(x)
		elif isa == 'ast_comment':
			y = do_stmt_comment(x)
		else:
			break

		ast = ast[1:]

		if y != None:
			cmodule.defs.append(y)
			y.parent = cmodule


	if is_import:
		pre_imp(ast)
	else:
		pre_def(ast, is_include=is_include)
		def_def(ast, is_include=is_include)

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



def pre_imp(ast):
	global cmodule

	# 1. Проходим по всем типам, создаем их undefined "прототипы".
	# 2. Проходим по всем функциям, создаем их undefined "прототипы".
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if isa == 'ast_definition':
			is_public = x['access_modifier'] == 'public'
			id = Id(x['id'])
			ti = id.ti

			if kind == 'type':
				t = Type(x['ti'])  # Incomplete type (!)
				t.id = id
				t.parent = cmodule
				ctx_type_add(id.str, t, is_public=is_public)

			elif kind == 'func':
				# Create function value with incomplete type
				t = Type(x['ti'])  # Incomplete type (!)
				v = ValueFunc(t, id, x['ti'])
				v.parent = cmodule
				cmodule_value_add(id.str, v, is_public=is_public)

			elif kind == 'const':
				t = Type(x['ti'])  # Incomplete type (!)
				iv = ValueUndef(ti=x['ti'])
				v = ValueConst(t, id, init_value=iv, ti=x['ti'])
				v.parent = cmodule
				cmodule_value_add(id.str, v, is_public=is_public)

			elif kind == 'var':
				t = Type(x['ti'])  # Incomplete type (!)
				iv = ValueUndef(ti=x['ti'])
				v = ValueVar(t, id, init_value=iv, ti=x['ti'])
				v.parent = cmodule
				cmodule_value_add(id.str, v, is_public=is_public)


def pre_def(ast, is_include=False):
	global cmodule

	# 1. Проходим по всем типам, создаем их undefined "прототипы".
	# 2. Проходим по всем функциям, создаем их undefined "прототипы".
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if isa == 'ast_definition':
			is_public = x['access_modifier'] == 'public'
			id = x['id']
			ti = id['ti']

			if kind == 'type':
				t = Type(x['ti'])  # Incomplete type (!)
				if not is_include:
					t.parent = cmodule
				cmodule_type_add(id['str'], t, is_public=is_public)

			elif kind == 'func':
				# Create function value with incomplete type
				t = Type(x['ti'])  # Incomplete type (!)
				v = ValueFunc(t, Id(x['id']), x['ti'])

				definition = StmtDefFunc(v.id, v, None, x['ti'])
				definition.id = v.id
				definition.parent = cmodule
				definition.module = cmodule
				definition.access_level = x['access_modifier']
				definition.nl = x['nl']
				v.definition = definition

				if not is_include:
					v.parent = cmodule
				cmodule_value_add(id['str'], v, is_public=is_public)


def def_def(ast, is_include=False):
	# 3. Далее идем по всем элементам с самого начала и определяем их.
	#   - Если элемент использует undefined - заносим его в список зависимостей эл-та
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if isa == 'ast_definition':
			df = None
			if kind == 'type':
				df = def_type(x)
			elif kind == 'const':
				df = def_const(x)
			elif kind == 'func':
				df = def_func(x)
			elif kind == 'var':
				df = def_var(x)

			if df != None:
				df = add_spices_def(df, x['atts'])
				if not is_include:
					df.parent = cmodule

				is_public = x['access_modifier'] == 'public'
				cmodule.defs.append(df)

		elif isa == 'ast_comment':
			comment = do_stmt_comment(x)
			cmodule.defs.append(comment)

		elif isa == 'ast_directive':
			if x['kind'] == 'pragma':
				df = do_directive(x)

	return



imp_paths = []


# получает строку импорта (и неявно глобальный контекст)
# и возвращает полный путь к модулю
def get_import_abspath(s, ext='.m'):
	s = s + ext

	is_local = s[0:2] == './' or s[0:3] == '../'

	full_name = ''

	local_name = env_current_file_dir + '/' + s
	if is_local:
		full_name = local_name

	elif os.path.exists(local_name):
		full_name = local_name

	else:
		# imp_paths or lib_path

		# ищем в imp_paths
		for imp_path in imp_paths:
			p = imp_path + '/' + s
			if os.path.exists(p):
				full_name = p
				break

		if full_name == '':
			full_name = settings['lib'] + '/' + s

	if not os.path.exists(full_name):
		print("%s not exist" % full_name)
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

		if kind == 'set':
			args = a['args']
			key = args[0]['value']['str']
			val = args[1]['value']['str']
			setObjAttrByPath(x, key, val)

			if key[-4:] == 'id.c':
				add_att(x, 'id:nodecorate')

		elif kind == 'llalias':
			val = a['args'][0]['value']['str']
			setObjAttrByPath(x, "id.llvm", val)
			add_att(x, 'id:nodecorate')
		elif kind == 'calias':
			val = a['args'][0]['value']['str']
			setObjAttrByPath(x, "id.c", val)
			add_att(x, 'id:nodecorate')
		elif kind == 'alias':
			val = a['args'][0]['value']['str']
			setObjAttrByPath(x, "id.c", val)
			setObjAttrByPath(x, "id.cm", val)
			setObjAttrByPath(x, "id.llvm", val)
			add_att(x, 'id:nodecorate')
		elif kind == 'used':
			# TODO: not implemented in LLVM (!)
			add_att(x, 'used')
		elif kind == 'unused':
			add_att(x, 'unused')
		elif kind == 'packed':
			add_att(x, 'packed')
		elif kind == 'noinline':
			add_att(x, 'noinline')
		elif kind == 'inlinehint':
			add_att(x, 'inlinehint')
		elif kind == 'inline':
			#add_att(x, 'static')
			add_att(x, 'inline')
		elif kind == 'extern':
			add_att(x, "extern")
			args = a['args']
			if len(args) > 0:
				arg = args[0]['value']['str']
				if arg == 'C':
					add_att(x, 'id:nodecorate')
		elif kind == 'alignment':
			val = int(a['args'][0]['value']['str'])
			setObjAttrByPath(x, 'alignment', val)
		elif kind == 'section':
			val = a['args'][0]['value']['str']
			setObjAttrByPath(x, 'section', val)
		elif kind == 'nonstatic':
			add_att(x, 'nonstatic')
		elif kind == 'nodecorate':
			add_att(x, 'id:nodecorate')
		elif kind == 'c_no_print':
			add_att(x, "c_no_print")
		elif kind == 'info':
			msg = str(a['args'][0]['value']['str'])
			info(msg, x.ti)
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

		if arg.isBad():
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

	to.immediate = _from.immediate
	to.immutable = _from.immutable
	return



"""if kind == 'if':
	prev_production = production
	c = do_value_immediate(args[0])

	if c.isBad():
		return None

	if not Type. is_bool(c['type']):
		error("expected bool value", c.ti)
		return None

	cond = c.asset != 0

	production = cond
	if cond:
		prev_skipp = skipp
		skipp = True  # skip another branches

elif kind == 'elseif':
	production = False
	c = do_value_immediate(args[0])

	if c.isBad():
		return None

	if not Type. is_bool(c['type']):
		error("expected bool value", c.ti)
		return None

	cond = c.asset != 0

	if cond and not skipp:
		production = True
		skipp = True  # skip another branches

elif kind == 'else':
	production = not skipp

elif kind == 'endif':
	skipp = prev_skipp  # do not skip branches (for new if)
	production = prev_production

elif kind == 'info':
	v = do_value_immediate_string(args[0])

	if v.isBad():
		fatal("unsuitable value", x['ti'])

	msg = v.asset
	info(msg, x['ti'])

elif kind == 'warning':
	v = do_value_immediate_string(args[0])

	if v.isBad():
		fatal("unsuitable value", x['ti'])

	msg = v.asset
	warning(msg, x['ti'])

elif kind == 'error':
	v = do_value_immediate_string(args[0])

	if v.isBad():
		fatal("unsuitable value", x['ti'])

	msg = v.asset
	error(msg, x['ti'])
	exit(-1)

elif kind == 'undef':
	v = do_value_immediate_string(args[0])
	if v.isBad():
		fatal("unsuitable value", x['ti'])
	id_str = v.asset
	cmodule.symtab_public.ValueUndef(id_str)
	cmodule.symtab_public.type_undef(id_str)

el"""
