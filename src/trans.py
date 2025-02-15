
import os

import copy

from error import *

from lexer import CmLexer
from parser import Parser

from util import get_item_by_id
from main import settings
import type as htype
from hlir.hlir import *

import foundation

from value.bool import value_bool_create
from value.integer import value_integer_create
from value.float import value_float_create
from value.array import value_array_create, value_array_add
from value.string import value_string_create, value_string_add
from value.record import value_record_create


import decimal
# max number of signs after .
# decimal operation precision
decimal.getcontext().prec = settings.get('precision')


lexer = CmLexer()
parser = Parser()


# сущность из текущего модуля
def is_local_entity(x):
	global cmodule
	if hasattr(x, 'definition'):
		return x.definition.parent == cmodule
	return True


# значение глобально (неважно из какого модуля)
def is_global_value(x):
	return x.hasAttribute('global_entity')


def is_local_context():
	global cfunc
	return cfunc != None


from value.value import *
from value.cons import value_cons_implicit, value_cons_implicit_check, value_cons_explicit, value_cons_default


from symtab import Symtab
from util import nbits_for_num, nbytes_for_bits




production = True
prev_production = True  # TODO: это бред, сделай стек!


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



# TODO: attribute 'unsafe' for cast operation
unsafe_mode = False
def is_unsafe_mode():
	return unsafe_mode


# тепреь вызывается только из конструктора строки (value)
def module_strings_add(v):
	global cmodule
	cmodule.strings.append(v)



def module_type_add_public(m, id_str, t):
	#print("module %s type_add_public %s" % (m['id'], id_str))
	m.symtab_public.type_add(id_str, t)
	#t['module'] = m
	t.att.append('global_entity')

def module_value_add_public(m, id_str, v):
	#print("module %s value_add_public %s" % (m['id'], id_str))
	m.symtab_public.value_add(id_str, v)
	#v['module'] = m
	v.addAttribute('global_entity')


def module_type_add_private(m, id_str, t):
	#print("module %s type_add_private %s" % (m['id'], id_str))
	m.symtab_private.type_add(id_str, t)
	#t['module'] = m
	t.att.append('global_entity')

def module_value_add_private(m, id_str, v):
	#print("module %s value_add_private %s" % (m['id'], id_str))
	m.symtab_private.value_add(id_str, v)
	#v['module'] = m
	v.addAttribute('global_entity')




# public

# search type in module
def module_type_get_public(m, id_str):
	return m.symtab_public.type_get(id_str)

# search value in module
def module_value_get_public(m, id_str):
	return m.symtab_public.value_get(id_str)

# private

# search type in module
def module_type_get_private(m, id_str):
	return m.symtab_private.type_get(id_str)

# search value in module
def module_value_get_private(m, id_str):
	return m.symtab_private.value_get(id_str)



def module_type_add(m, id_str, t, is_public=False):
	#print('module_type_add (%s, isPublic=%d)' % (id_str, is_public))
	if is_public:
		module_type_add_public(m, id_str, t)
	else:
		module_type_add_private(m, id_str, t)

	#t['module'] = m


def module_value_add(m, id_str, v, is_public=False):
	#print('module_value_add (%s, isPublic=%d)' % (id_str, is_public))
	if is_public:
		module_value_add_public(m, id_str, v)
	else:
		module_value_add_private(m, id_str, v)

	#v['module'] = m


def cmodule_value_add(id_str, v, is_public=False):
	global cmodule
	module_value_add(cmodule, id_str, v, is_public=is_public)


def cmodule_type_add(id_str, t, is_public=False):
	global cmodule
	module_type_add(cmodule, id_str, t, is_public=is_public)


def module_type_get(m, id_str, only_public=False):
	#print("module_type_get: " + id_str)

	t = m.symtab_public.type_get(id_str)
	if t != None:
		return t

	if only_public:
		return None

	t = m.symtab_private.type_get(id_str)
	if t != None:
		return t

	#
	for included_module in m.included_modules:
		t = included_module.symtab_public.type_get(id_str)
		if t != None:
			return t

	return None


# search value in module
def module_value_get(m, id_str, only_public=False):
	#print("module_value_get: " + id_str)

	v = m.symtab_public.value_get(id_str)
	if v != None:
		return v

	if only_public:
		return None

	v = m.symtab_private.value_get(id_str)
	if v != None:
		return v

	#
	for included_module in m.included_modules:
		v = included_module.symtab_public.value_get(id_str)
		if v != None:
			return v

	return None





# ONLY FOR LOCALS:

def ctx_type_add(id_str, t):
	global context
	context.type_add(id_str, t)

def ctx_value_add(id_str, v):
	global context
	context.value_add(id_str, v)



def ctx_type_get(id_str):
	#print("ctx_type_get %s" % id_str)
	global context
	x = context.type_get(id_str)
	if x != None:
		return x
	global cmodule
	return module_type_get(cmodule, id_str)

def ctx_value_get(id_str):
	#print("ctx_value_get %s" % id_str)
	global context
	x = context.value_get(id_str)
	if x != None:
		return x
	global cmodule
	return module_value_get(cmodule, id_str)



# искать ТОЛЬКО внутри текущего контекста (блока)
def ctx_value_get_shallow(id_str):
	global cmodule
	return cmodule.symtab_public.value_get(id_str, recursive=False)



def module_append(definition, to_export=False):
	if definition == None:
		return

	global cmodule

	cmodule.defs.append(definition)
	definition.parent = cmodule



def context_push():
	global context
	context = context.branch(domain='local')

def context_pop():
	global context
	context = context.parent_get()



properties = {}


# used in metadirs
# add 'properties' to entity descriptor
def property_add(id, value):
	global properties
	properties[id] = value



attributes = []

def attribute_add(at):
	global attributes
	#print("attribute_add " + at)
	if isinstance(at, list):
		attributes.extend(at)
	else:
		attributes.append(at)


def attributes_get():
	global attributes
	attributes2 = attributes
	attributes = []
	return attributes2



def insert(s):
	#global cmodule
	directive_insert = {
		'isa': 'directive',
		'kind': 'insert',
		'str': s,
		'att': [],
		'nl': 1,
		'ti': None
	}
	module_append(directive_insert)


def feature_add(s):
	from main import features
	features.set(s)


lib_path = ""

typeSysChar = None
typeSysInt = None
typeSysNat = None
typeSysFloat = None
typeSysStr = None

valueNil = None
valueTrue = None
valueFalse = None

foundation_module = None



def init():
	global foundation_module, lib_path
	lib_path = settings.get('lib')

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
	valueNil = value_integer_create(0, typ=foundation.typeNil)
	valueTrue = value_bool_create(1)
	valueFalse = value_bool_create(0)

	root_symtab.value_add('nil', valueNil)
	root_symtab.value_add('true', valueTrue)
	root_symtab.value_add('false', valueFalse)


	target_name = str(settings.get('target_name'))
	char_width = int(settings.get('char_width'))
	int_width = int(settings.get('integer_width'))
	flt_width = int(settings.get('float_width'))
	pointer_width = int(settings.get('pointer_width'))

	global typeSysInt, typeSysNat, typeSysFloat, typeSysChar, typeSysStr

	typeSysChar = foundation.type_select_char(char_width)
	typeSysInt = foundation.type_select_int(int_width)
	typeSysNat = foundation.type_select_nat(int_width)
	typeSysFloat = foundation.typeFloat64

	undefinedVolume = ValueUndefined(typeSysNat, ti=None)
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
	compilerVersionMajor = value_integer_create(0, typ=foundation.typeNat32)
	compilerVersionMinor = value_integer_create(7, typ=foundation.typeNat32)

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

	target_name = str(settings.get('target_name'))
	char_width = int(settings.get('char_width'))
	int_width = int(settings.get('integer_width'))
	flt_width = int(settings.get('float_width'))
	pointer_width = int(settings.get('pointer_width'))


	__targetName = value_string_create(target_name)
	__targetCharWidth = value_integer_create(char_width, typ=foundation.typeNat32)
	__targetIntWidth = value_integer_create(int_width, typ=foundation.typeNat32)
	__targetFloatWidth = value_integer_create(flt_width, typ=foundation.typeNat32)
	__targetPointerWidth = value_integer_create(pointer_width, typ=foundation.typeNat32)

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
	id = Id(x['id'])
	if id.str[0].isupper():
		error("field id must starts with small letter", id.ti)

	t = do_type(x['type'])

	iv = None
	if x['init_value'] != None:
		iv = do_value(x['init_value'])

	f = Field(id, t, init_value=iv, ti=x['ti'])
	f.nl = x['nl']
	f.access_level = x['access_modifier']
	add_spices(f, ast_atts=x['attributes'])
	return f


#
# Do Type
#

def do_type_name(x):
	global cmodule
	id = x['id']
	id_str = id['str']

	t = None
	if 'module' in x:
		m_id = x['module']['str']
		imp = cmodule.imports[m_id]
		if imp == None:
			error("unknown module", x['module']['ti'])
			return TypeBad(t['ti'])
		t = module_type_get_public(imp.module, id_str)

		if t.is_incompleted():
			t = type_update_incompleted(imp.module, t, id_str)
	else:
		t = module_type_get(cmodule, id_str)

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

	if Value.isBad(volume):
		return TypeArray(of, volume, ti=x['ti'])

	if not Value.isUndefined(volume):
		if not volume.isImmediate():
			#info("VLA", t['ti'])
			if is_local_context():
				global cfunc
				cfunc.addAttribute('stacksave')
			else:
				error("non local VLA", t.size.ti)

		#if not (Type.is_integer(volume['type']) or volume.type.is_number()):
		#if volume.type.is_signed():
		#	error("required value with Number or Integer type", volume.ti)

	# closed arrays of closed arrays are denied NOW
#	if of.is_closed_array():
#		error("closed arrays of closed arrays are denied", t.ti)
#		return TypeBad(t)

	assert(volume != None)

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

		if 'comments' in field:
			f.comments = []
			for comment in field['comments']:
				f.comments.append(do_stmt_comment(comment))

		fields.append(f)

	rec = TypeRecord(fields, ti=x['ti'])
	rec.nl_end = x['nl_end']
	rec.uid = uid

	# add anon record (before)
	anon_tag = '__anonymous_struct_%d' % uid
	rec.c_anon_id = anon_tag

	cmodule.anon_recs.append(rec)
	return rec


def do_type_enum(x):
	enum_type = htype.type_enum(x['ti'])

	i = 0
	for item in x.items:
		id = item['id']
		enum_type.items.append({
			'isa': 'enum_item',
			'id': id,
			'number': i,
			'ti': item['ti']
		})

		# add enum item to global context
		item_val = ValueLiteral(enum_type, item['ti'])
		item_val.asset = i

		item_val['id'] = id
		global cmodule
		module_value_add_public(cmodule, id.str, item_val)
		i += 1

	return enum_type



def do_type_func(x, func_id="_"):
	# check params
	params = []
	for _param in x['params']:
		param = do_field(_param)
		if param != None:
			params.append(param)

	to = foundation.typeUnit
	if x['to'] != None:
		to = do_type(x['to'])

	return TypeFunc(params, to, x['arghack'], ti=x['ti'])



def do_type(x):
	for a in x['attributes']:
		do_attribute(a)

	t = None
	k = x['kind']
	if k == 'name': t = do_type_name(x)
	elif k == 'func': t = do_type_func(x)
	elif k == 'pointer': t = do_type_pointer(x)
	elif k == 'array': t = do_type_array(x)
	elif k == 'record': t = do_type_record(x)
	elif k == 'enum': t = do_type_enum(x)
	else: t = bad_type(x['ti'])

	t.ti = x['ti']

	return t



def do_value_shift(x):
	op = x['kind']  # 'shl' | 'shr'
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	type_result = l.type

	if not l.type.is_word():
		error("expected word value", x['left'])

	if r.type.is_signed():
		error("expected natural value", x['right'])

	if op == 'shl':
		nv = ValueShl(l, r, ti=x['ti'])
	else:
		nv = ValueShr(l, r, ti=x['ti'])

	if l.isImmediate() and r.isImmediate():
		asset = l.asset
		if op == 'shl':
			asset = asset << r.asset
		else:
			asset = asset >> r.asset
		nv.asset = int(asset)
		nv.immediate = True
		return nv

	if l.type.is_generic():
		error("expected non-generic value", l.ti)
		return ValueBad(x['ti'])

	return nv


def do_value_bin(x):
	op = x['kind']
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	ti = x['ti']

	if Value.isBad(l) or Value.isBad(r):
		return ValueBad(ti)

	# Ops with different types
	if op == 'add':
		# массивы могут быть разной длины (то есть с разными типами)
		# поэтому сложение массивов (only immediate) требует обхода проверок типа ниже
		if l.type.is_array() and r.type.is_array():
			return value_array_add(l, r, ti)
		# у string вообще всегда одинакоывый тип и нет смысла приводить их
		elif l.type.is_string() and r.type.is_string():
			return value_string_add(l, r, ti)

	# Check type is valid for the operation

	if not op in l.type.ops:
		error("unsuitable value type for '%s' operation" % op, l.ti)
		return ValueBad(ti)

	if not op in r.type.ops:
		error("unsuitable value type for '%s' operation" % op, r.ti)
		return ValueBad(ti)

	#
	# Now and further types must be equal (!)
	#

	t = htype.select_common_type(l.type, r.type)
	if t.is_bad():
		error("different types in operation", x['ti'])
		return ValueBad(ti)

	l = value_cons_implicit(t, l)
	r = value_cons_implicit(t, r)

	if not Type.eq(l.type, r.type, ti):
		error("different types in '%s' operation" % x['kind'], ti)
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

	nv = ValueBin(t, op, l, r, ti=ti)

	# if left & right are immediate, we can fold const
	# and append field .asset to bin_value
	if l.isImmediate() and r.isImmediate():
		ops = {
			'logic_or': lambda a, b: a or b,
			'logic_and': lambda a, b: a and b,
			'or': lambda a, b: a | b,
			'and': lambda a, b: a & b,
			'xor': lambda a, b: a ^ b,
			'lt': lambda a, b: a < b,
			'gt': lambda a, b: a > b,
			'le': lambda a, b: a <= b,
			'ge': lambda a, b: a >= b,
			'add': lambda a, b: a + b,
			'sub': lambda a, b: a - b,
			'mul': lambda a, b: a * b,
			'rem': lambda a, b: a % b,
		}

		asset = 0
		if op == 'div':
			if not t.is_float():
				asset = l.asset // r.asset
			else:
				asset = l.asset / r.asset
		else:
			asset = ops[op](l.asset, r.asset)

		if t.is_number():
			# (для операций типа 1 + 2)
			# Пересматриваем generic тип для нового значения
			nv.type = htype.type_number_for(asset, signed=asset < 0, ti=ti)

		nv.asset = asset
		nv.immediate = True

	return nv


def do_value_not(x):
	v = do_rvalue(x['value'])

	if Value.isBad(v):
		return v

	vtype = v.type

	if not 'not' in vtype.ops:
		error("unsuitable type", v.ti)
		return ValueBad(x['ti'])

	op = 'not'
	if vtype.is_bool():
		op = 'logic_not'

	nv = ValueUn(vtype, op, v, ti=x['ti'])

	if v.isImmediate():
		# because: ~(1) = -1 (not 0) !
		if vtype.is_bool():
			nv.asset = not v.asset
		else:
			nv.asset = ~v.asset

		nv.immediate = True

	return nv



def do_value_neg(x):
	v = do_rvalue(x['value'])

	if Value.isBad(v):
		return v

	vtype = v.type

	if not vtype.is_generic():
		if not vtype.is_signed():
			error("expected value with signed type", v.ti)
	else:
		vtype.signed = True

	nv = ValueUn(vtype, 'neg', v, ti=x['ti'])

	if v.isImmediate():
		nv.asset = -v.asset
		nv.immediate = True

		if nv.type.is_generic():
			nv.type = htype.type_number_for(v.asset, signed=True, ti=x['ti'])

	return nv



def do_value_pos(x):
	v = do_rvalue(x['value'])

	if Value.isBad(v):
		return v

	vtype = v.type

	if not vtype.is_signed():
		error("expected value with signed type", v.ti)

	nv = ValueUn(vtype, 'pos', v, ti=x['ti'])

	if v.isImmediate():
		nv.asset = +v.asset
		nv.immediate = True

		if nv.type.is_generic():
			nv.type = htype.type_number_for(v.asset, signed=True, ti=x['ti'])

	return nv


def do_value_ref(x):
	v = do_value(x['value'])

	if Value.isBad(v):
		return v

	ti = x['ti']
	op = x['kind']
	vtype = v.type

	if v.isImmutable():
		if not vtype.is_func() or vtype.is_incompleted():
			error("expected mutable value or function", v.ti)
			return ValueBad(x['ti'])

	nv = ValueRef(v, ti=ti)

	if is_global_value(v):
		nv.immediate = True
		# не можно поставить 0 тк иначе значение будет трактоваться как zero
		# и LLVM printer его не всунет в композитны тип (пропустит insertelement)
		# поэтому временно заткнул единицей, но вообще нужно будет обдумать
		nv.asset = 1
		nv.addAttribute('ptr_to_glb_val')

	return nv


def do_value_new(x):
	v = do_value(x['value'])
	return ValueNew(v)


def do_value_deref(x):
	v = do_rvalue(x['value'])

	if Value.isBad(v):
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
	is_open_array_ptr =  to.is_open_array()
	if is_func_ptr or is_free_ptr or is_open_array_ptr:
		error("unsuitable type", v.ti)

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

	if not arg.type.is_array():
		error("expected value with array type", x['value'])
		return ValueBad({'ti': ti})

	# for C backend, because C cannot do lengthof(x)
	if not 'use_lengthof' in cmodule.att:
		cmodule.att.append('use_lengthof')

	return ValueLengthof(arg, ti)


def do_value_va_start(x):
	args = x['values']
	ti = x['ti']
	va_list = do_value(args[0])
	last_param = do_rvalue(args[1])
	return ValueVaStart(va_list, last_param, ti)


def do_value_va_arg(x):
	va_list = do_value(x['va_list'])
	type = do_type(x['type'])
	return ValueVaArg(type, va_list, x['ti'])


def do_value_va_end(x):
	ti = x['ti']
	va_list = do_value(x['value'])
	return ValueVaEnd(va_list, ti)


def do_value_va_copy(x):
	args = x['values']
	ti = x['ti']
	va_list0 = do_value(args[0])
	va_list1 = do_value(args[1])
	return ValueVaCopy(va_list0, va_list1, ti)


def do_value___defined_type(x):
	t = ctx_type_get(x['type']['id'].str)
	return t != None


def do_value___defined_value(x):
	v = ctx_value_get(x['value']['id'].str)
	return v != None



def do_value_call(x):
	fn = do_rvalue(x['left'])

	if Value.isBad(fn):
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


		if not Value.isBad(arg):
			arg = value_cons_implicit_check(param.type, arg)

			if not arg.isImmediate():
				imm_args = False

			if a['key'] != None:
				id = Id(a['key'])
				args.append(Initializer(id, arg))
			else:
				args.append(arg)

		i += 1

	#
	# extra args
	#

	extra_args = []

	i_before_extra = i

	# extra_args rest args
	while i < nargs:
		a = x['args'][i]['value']
		argval = do_rvalue(a)

		if not Value.isBad(argval):
			if argval.type.is_generic():
				warning("extra argument with generic type", a['ti'])
				argval = value_cons_default(argval)

			if not argval.isImmediate():
				imm_args = False

			extra_args.append(argval)

		i += 1


	"""if fn.id:
		func_id_str = fn.id.str
		if func_id_str in ['print', 'scanf', 'print']:
			expected_pointers = func_id_str == 'scanf'
			first_arg = x['args'][0]['value']
			if first_arg['kind'] in ['string', 'string_concat']:
				specs = get_cspecs(first_arg['str'])
				extra_args_check(specs, extra_args, expected_pointers)
			else:
				error("expected literal string argument", first_arg['ti'])"""

	rv = ValueCall(ftype.to, fn, args + extra_args, ti=x['ti'])
	return rv



def do_value_index(x):
	left = do_rvalue(x['left'])

	if Value.isBad(left):
		return ValueBad(x['ti'])

	left_typ = left.type

	via_pointer = left_typ.is_pointer()

	array_typ = left_typ
	if via_pointer:
		array_typ = left_typ.to

	if not array_typ.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])

	# Can index *[]AnyNonArrayType
	# Can't index *[][]AnyType
	if array_typ.is_array_of_open_array():
		error("cannot index array of open array", x['ti'])
		return ValueBad(x['ti'])

	index = do_rvalue(x['index'])

	if Value.isBad(index):
		return ValueBad(x['ti'])

	if not (index.type.is_integer() or index.type.is_number()):
		error("expected integer value", x['index'])
		return ValueBad(x['ti'])

	if index.type.is_generic():
		index = value_cons_implicit_check(typeSysInt, index)

	nv = ValueIndex(array_typ.of, left, index, ti=x['ti'])

	if not via_pointer:
		nv.immutable = left.immutable

		if left.isImmediate():
			if index.isImmediate():
				#info("immediate index", x['ti'])
				index_imm = index.asset

				if index_imm >= array_typ.volume.asset:
					error("array index out of bounds", x['index'])
					return ValueBad(x['ti'])

				if index_imm < len(left.items):
					item = left.items[index_imm]
				else:
					item = ValueZero(array_typ.of, x['ti'])

				nv.immediate = True
				cp_immediate(nv, item)

	return nv


def do_value_slice(x):
	#info("do_value_slice", x['ti'])
	left = do_value(x['left'])
	index_from = do_rvalue(x['index_from'])
	index_to = None
	ti = x['ti']

	if x['index_to'] != None:
		index_to = do_rvalue(x['index_to'])
		if Value.isBad(index_to):
			return ValueBad(x['ti'])

	if Value.isBad(left) or Value.isBad(index_from):
		return ValueBad(x['ti'])

	left_type = left.type
	via_pointer = left_type.is_pointer()
	array_type = left_type
	if via_pointer:
		array_type = left_type.to

	if not array_type.is_array():
		error("expected array or pointer to array", left.ti)
		return ValueBad(x['ti'])


	# получаем размер слайса
	slice_volume = None  # asg_value

	# строим выражения для C бекенда в частности
	# тк volume of array должен быть выражением
	# а для слайса [a:b] это (b - a)
	if index_from != None and index_to != None:
		de = {
			'isa': 'ast_value',
			'kind': 'sub',
			'left': x['index_to'],
			'right': x['index_from'],
			'ti': ti
		}

		slice_volume = do_value(de)

		slice_len = 0  # len as integer
		if slice_volume.isImmediate():
			slice_len = slice_volume.asset

			if slice_len < 0:
				error("wrong slice direction", x['ti'])
				return ValueBad(x['ti'])

	if slice_volume == None:
		slice_volume = ValueUndefined(typeSysNat, x['ti'])

	if index_to == None:
		index_to = ValueUndefined(typeSysInt)

	type = TypeArray(array_type.of, slice_volume, generic=False, ti=x['ti'])
	nv = ValueSlice(type, left, index_from, index_to, x['ti'])

	if not via_pointer:
		nv.immutable = left.immutable

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

	v = module_value_get_public(submodule, iname)
	if v == None:
		v = module_value_get_private(submodule, iname)
		if v != None:
			error("access to module private item", ti)

	if v.type.is_incompleted():
		v = value_update_incompleted_type(submodule, v, iname)

	if v == None:
		error("module '%s' does not have value '%s'" % (mname, iname), x['ti'])
		return ValueBad(x['ti'])

	return v



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

	if Value.isBad(left):
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

	# PROBLEM: у анонимных структур нет поля 'definition'
	# и непонятно как с этимм быть. Можно добавить module
	# в каждую сущность, но...
#	if record_type['definition']['module'] != cmodule:
#		if not 'public' in field['att']:
#			error("access to private field", x['ti'])


	if field.type.is_bad():
		return ValueBad(x.ti)


	# Check access permissions

	# не у всех типов есть 'definition' (его нет у анонимных записей например)
	if not is_local_entity(record_type):
		if field.access_level == 'private':
			error("access to private field of record", x['right']['ti'])


	nv = ValueAccessRecord(field.type, left, field, ti=x['ti'])
	if not via_pointer:
		nv.immutable = left.immutable

		# access to immediate object
		if left.isImmediate():
			initializer = get_item_by_id(left.items, field_id.str)

			# (!) #asset of immediate index & access contains VALUE (!)
			nv.immediate = True
			cp_immediate(nv, initializer.value)

	return nv



def do_value_cons(x):
	v = do_rvalue(x['value'])
	t = do_type(x['type'])
	if Value.isBad(v) or t.is_bad():
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
	if v.type.is_incompleted():
		v = value_update_incompleted_type(cmodule, v, v.id.str)

		if v == None:
			error("use of incomplete value", x['ti'])
			return ValueBad(x['ti'])

		cdef.deps.append(v)

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
	v.nl_end = x['nl_end']
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
	v.nl_end = x['nl_end']
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
		if not 'use_bigint' in cmodule.att:
			cmodule.att.append('use_bigint')

	v = value_integer_create(num, ti=x['ti'])
	v.nsigns = num_string_len

	if base == 16:
		v.addAttribute('hexadecimal')

	return v



def do_value_float(x):
	# in compile time floats stores as decimal (!)
	fval = decimal.Decimal(x['str'])
	fv = value_float_create(fval, ti=x['ti'])
	return fv


def do_value_sizeof_type(x):
	t = do_type(x['type'])
	nv = ValueSizeofType(t, ti=x['ti'])
	if t.is_vla():
		nv.immediate = False
	return nv


def do_value_sizeof_value(x):
	v = do_value(x['value'])
	nv = ValueSizeofValue(v, ti=x['ti'])
	if v.type.is_vla():
		nv.immediate = False
	return nv



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

	if Value.isBad(v):
		return v

	if not v.isImmediate():
		if allow_ptr_to_str:
			if v.type.is_pointer_to_array_of_char():
				return v
		error("expected immediate value", x['ti'])
		return ValueBad(x['ti'])

	return v


def do_value_immediate_string(x):
	v = do_value_immediate(x)

	if Value.isBad(v):
		return v

	if not v.type.is_string():
		error("expected string value", x['ti'])

	return v



def do_value_unsafe(x):
	#info("do_value_unsafe", ti)
	ti = x['ti']
	from main import features
	if not features.get('unsafe'):
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
	return ValueUndefined(t, x['ti'])



def do_rvalue(x):
	#v = do_value(x)
	#return value_load(v)
	return do_value(x)


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
	elif k == 'bad': v = do_value_bad(x['ti'])

	assert(v != None)
	v.ti = x['ti']

	return v


#
# Do Statement
#


def do_stmt_const(x):
	global cfunc
	v = do_const(x)

	if v.init_value.type.is_generic():
		# generic immediate в C печатается как #define
		# и его надо манглить иначе возникает куча проблем
		v.id.c = '__' + v.id.str

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
	vu = Value.isUndefined(v)

	# error: no type, no init valuetu = type_is_incompleted(t)
	if tu == True and vu == True:
		# type & value undefined
		ctx_value_add(var_id.str, ValueBad(x['ti']))
		return StmtBad(x)

	if tu == True and vu == False:
		# type undef, value ok
		#Type.update(nt, v.type)
		if v.type.is_generic():
			v = value_cons_default(v)
		t = Type.copy(v.type)

	#if not t.is_incompleted():
	#	if t.is_bad():
	#		ctx_value_add(var_id.str, ValueBad(x['ti']))
	#		return StmtBad(x)
	#
		if t.is_forbidden_var():
			error("unsuitable type1", x['type']['ti'])

	# type & init value present
	if t != None and not Value.isUndefined(v):
		v = value_cons_implicit_check(t, v)

	if t == None:
		if v.type.is_generic():
			v = value_cons_default(v)

		t = Type.copy(v.type)

	# check if identifier is free (in current block)
	already = ctx_value_get_shallow(var_id.str)
	if already != None:
		error("local id redefinition", x['id'].ti)
		info("firstly defined here", already['id'].ti)
		return StmtBad(x)

	var_value = add_local_var(var_id, t, var_id.ti)
	definition = StmtDefVar(var_id, var_value, v, ti=x['ti'])
	definition.parent = cfunc
	return definition



def do_stmt_if(x):
	cond = do_rvalue(x['cond'])

	if Value.isBad(cond):
		return StmtBad(x)

	if not cond.type.is_bool():
		error("expected bool value", cond.ti)
		return StmtBad(x)

	_then = do_stmt(x['then'])

	if isinstance(_then, StmtBad):
		return StmtBad(x)

	_else = None
	if x['else'] != None:
		_else = do_stmt(x['else'])
		if isinstance(_else, StmtBad):
			return StmtBad(x['else'])

	return StmtIf(cond, _then, _else, ti=x['ti'])



def do_stmt_while(x):
	cond = do_rvalue(x['cond'])

	if Value.isBad(cond):
		return StmtBad(x)

	if not cond.type.is_bool():
		error("expected bool value", cond.ti)
		return StmtBad(x)

	block = do_stmt(x['stmt'])

	if isinstance(block, StmtBad):
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
		if not Value.isBad(rv):
			retval = value_cons_implicit_check(func_ret_type, rv)

	return StmtReturn(retval, ti=x['ti'])


def do_stmt_type(x):
	fatal("do_stmt_type() not implemented")


def do_stmt_again(x):
	return StmtAgain(x['ti'])


def do_stmt_break(x):
	return StmtBreak(x['ti'])



def add_local_var(id, typ, ti):
	iv = ValueUndefined(typ)
	var_value = ValueVar(typ, id, init_value=iv, ti=ti)
	var_value.addAttribute('local')
	ctx_value_add(id.str, var_value)
	return var_value





def do_stmt_assign(x):
	l = do_value(x['left'])
	r = do_rvalue(x['right'])

	if Value.isBad(l) or Value.isBad(r):
		return StmtBad(x)

	if not l.isLvalue():
		error("expected lvalue", l.ti)
		return StmtBad(x)

	if l.isImmutable():
		error("expected mutable value", l.ti)
		return StmtBad(x)

	r = value_cons_implicit_check(l.type, r)
	return StmtAssign(l, r, ti=x['ti'])



def do_stmt_incdec(x, op='add'):
	v = do_value(x['value'])

	if Value.isBad(v):
		return StmtBad(x)

	if v.isImmutable():
		error("expected mutable value", v.ti)
		return StmtBad(x)

	if not v.type.is_integer():
		error("expected value with integer type", v.ti)
		return StmtBad(x)

	one = value_integer_create(1, typ=v.type, ti=x['ti'])
	nv = ValueBin(v.type, op, v, one, ti=x['ti'])
	return StmtAssign(v, nv, ti=x['ti'])



def do_stmt_value(x):
	v = do_rvalue(x['value'])

	if Value.isBad(v):
		return StmtBad(x)

	if not v.type.is_unit():
		if not v.type.hasAttribute('dispensable'):
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

	if not 'nl' in x:
		print(x['kind'])
	s.nl = x['nl']

	return s



def do_stmt_block(x, parent=None):
	context_push()

	block = StmtBlock([], ti=x['ti'], nl_end=x['nl_end'])
	block.parent = parent

	stmts = []
	for stmt in x['stmts']:
		s = do_stmt(stmt)
		if not isinstance(s, StmtBad):
			s.parent = block
			block.stmts.append(s)

	context_pop()

	return block



"""def symbol_const(id, init_value, is_public=False):
	const_value = ValueConst(init_value.type, id, init_value, id.ti)
	const_value.att.extend(init_value.att)

	# Now let can be immediate!
	if init_value.isImmediate():
		const_value.immediate = True
		cp_immediate(const_value, init_value)

	global cmodule
	cmodule_value_add(id.str, const_value, is_public=is_public)
	#module_value_add_public(cmodule, id.str, const_value)
	return const_value"""



def def_type(x):
	global cmodule
	global cdef

	id = Id(x['id'])
	log("def_type: %s" % id.str)

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


	if not ('do_not_include' in cmodule.att):
		# В случае когда не печатаем typedef явно (!)
		# Убираем алиасы которые висели на оригинальном типе
		#if 'c' in nt['id']:
		#	nt.pop('c')
		#if 'llvm_alias' in nt['id']:
		#	nt.pop('llvm_alias')
		pass

	if ty.is_record():
		cmodule.records.append(nt)

	cdef = None
	return definition



def def_const(x):
	#global cdef
	global cmodule

	const_value = do_const(x)

	is_public = x['access_modifier'] == 'public'
	cmodule_value_add(const_value.id.str, const_value, is_public=is_public)

	definition = StmtDefConst(const_value.id, const_value, const_value.init_value, x['ti'])
	definition.parent = cmodule
	definition.module = cmodule
	definition.access_level = x['access_modifier']
	definition.nl = x['nl']

	const_value.parent = cmodule
	const_value.definition = definition

	return definition



#	if Value.isBad(init_value):
#		module_value_add_public(cmodule, id.str, init_value)
#		return DefConst(id, init_value, init_value, x['ti'])

#	t = do_type(x['type'])
#	if not t.is_incompleted():
#		if not t.is_bad():
#			init_value = value_cons_implicit_check(t, init_value)

def do_const(x):
	id = Id(x['id'])

	log("do_const: %s" % id.str)

	# check if identifier is free
	pre_exist = ctx_value_get_shallow(id.str)
	if pre_exist != None:
		error("redefinition of '%s'" % id.str, id.ti)

	type = None
	if x['type'] != None:
		type = do_type(x['type'])

	init_value = do_rvalue(x['init_value'])

	#if init_value.isBad():
	#	# check if identifier is free (in current block)
	#	already = ctx_value_get_shallow(id.str)
	#	if already != None:
	#		error("redefinition of '%s'" % id.str, id.ti)
	#		return StmtBad(x)

	if type != None:
		init_value = value_cons_implicit_check(type, init_value)
	else:
		type = init_value.type

	const_value = ValueConst(type, id, init_value=init_value, ti=id.ti)

	if init_value.isImmediate():
		const_value.immediate = True
		cp_immediate(const_value, init_value)

	return const_value



def def_var(x):
	global cdef

	id = Id(x['id'])
	log("def_var %s" % id.str)

	# already defined? (check identifier)
	already = ctx_value_get(id.str)
	if already != None:
		error("redefinition of '%s'" % id.str, id.ti)

	definition = StmtDefVar(id, None, None, x['ti'])
	definition.module = cmodule
	definition.parent = cmodule
	definition.access_level = x['access_modifier']
	definition.nl = x['nl']
	cdef = definition

	t = None
	if x['type'] != None:
		t = do_type(x['type'])
	v = do_rvalue(x['init_value'])

	tu = t == None
	vu = Value.isUndefined(v)

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
				length = len(v.asset)
				volume = value_integer_create(length)
				t = TypeArray(t.of, volume, ti=x['ti'])
			elif v.type.is_array():
				# for case:
				# var a: []*Str8 = ["Ab", "aB", "AAb"]
				v = value_cons_default(v)
				t = Type.copy(v.type)

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



def def_func(x, dostmt=True):
	global cdef
	global cfunc
	global cmodule

	func_id = Id(x['id'])
	log('def_func: %s' % func_id.str)

	# значение функции уже существует, (возможно - undefined)
	# тк мы ранее сделали проход
	fn = ctx_value_get(func_id.str)

	definition = StmtDefFunc(func_id, fn, None, x['ti'])
	definition.parent = cmodule
	definition.module = cmodule
	definition.access_level = x['access_modifier']
	definition.nl = x['nl']
	cdef = definition

	fn.definition = definition

	if fn.type.is_incompleted():
		fn.type = do_type_func(x['type'])
		if fn.type.is_incompleted():
			return None

	if fn.type.is_bad():
		return None

	if func_id.str == 'main':
		fn.att.append('nodecorate')

	if x['stmt'] == None:
		return definition

	context_push()  # create params context

	prev_cfunc = cfunc
	cfunc = fn

	params = fn.type.params

	i = 0
	while i < len(params):
		param = params[i]
		param_value = ValueConst(param.type, param.id, init_value=ValueUndefined(param.type), ti=param.ti)
		param_value.addAttribute('local')
		param_value.addAttribute('param')
		ctx_value_add(param.id.str, param_value)
		i += 1

	# for C backend, for #include <stdarg.h>
	if fn.type.extra_args:
		if not 'use_va_arg' in cmodule.att:
			cmodule.att.append('use_va_arg')

	# check unuse
	#for param in params:
	#	check_unuse(param)

	stmt = None

	if dostmt:
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

	definition.stmt = stmt

	context_pop()  # remove params context
	cfunc = prev_cfunc
	cdef = None

	return definition



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



def is_nodecorate(x):
	for a in x['attributes']:
		if a['kind'] == 'nodecorate':
			return True
	return False


# пропускать остальные ветви (elseif & else) условной директивы
# тк основная ветвь была выполнена
skipp = False
prev_skipp = False

def do_attribute(x):
	global skipp, prev_skipp, production, prev_production
	kind = x['kind']
	args = x['args']

	if kind == 'attribute':
		attribute_add(args[0]['str'])

	elif kind == 'property':
		k = args[1]['kind']

		if args[0]['kind'] != 'string':
			error("expected String literal", args[0]['ti'])
			return

		if not k in ['string', 'number', 'id']:
			error("expected String, Number or Id literal in property value", args[1]['ti'])
			return

		# propertp can be:
		# @property("type.uuu", true)
		# @property("type.vvv", false)
		# @property("type.xxx", 123)
		# @property("type.yyy", "abc")
		# @property("type.zzz", nil)

		value = args[1]['str']
		if k == 'string':
			pass
		elif k == 'id':
			value = args[1]['str']
			if value == 'true':
				value = True
			elif value == 'false':
				value = False
			elif value == 'nil':
				value = None
		elif k == 'number':
			value = eval(value)

		property_add(args[0]['str'], value)

	elif kind == 'inline':
		attribute_add('static')
		attribute_add('inline')
	elif kind == 'extern':
		attribute_add('extern')
	elif kind == 'volatile':
		attribute_add('volatile')
	elif kind == 'packed':
		attribute_add('packed')
	elif kind == 'unused_result':
		attribute_add("value.type.to:dispensable")
	else:
		attribute_add(kind)

	return None



def do_import(x):
	global modules
	global cmodule

	import_expr = do_value_immediate_string(x['expr'])

	if Value.isBad(import_expr):
		return None

	# Literal string to python string
	impline = import_expr.asset

	_as = None
	if x['as'] != None:
		_as = x['as']['str']
	else:
		_as = impline.split("/")[-1]

	#info("AS %s" % _as, x['ti'])

	abspath = import_abspath(impline, ext='.m')

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

		if 'c_no_print' in m.att:
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
					module_append(d)

		cmodule.included_modules.append(m)
		return

	y = StmtImport(impline, _as, module=m, ti=x['ti'], include=x['include'])
	cmodule.imports[_as] = y
	return y



def do_directive(x):
	#info("directive %s" % x['kind'], x['ti'])
	global cmodule
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
	global skipp, production, prev_production

	global properties
	properties = {}
	global attributes
	attributes = []

	global cmodule
	prev_module = cmodule

	symtab_public = root_symtab.branch()
	symtab_private = Symtab()

	global context
	prev_context = context
	context = symtab_public

	cmodule = Module(idStr, ast, symtab_public, symtab_private)

	# 0. do imports & directives
	for x in ast:
		isa = x['isa']
		y = None
		if isa == 'ast_import':
			y = do_import(x)

		elif isa == 'ast_directive':
			y = do_directive(x)

		if y != None:
			module_append(y)

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

		#cmodule.lldeps.append(t)
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

		#cmodule.lldeps.append(v)
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
				cmodule_type_add(id.str, t, is_public=is_public)

			elif kind == 'func':
				# Create function value with incomplete type
				t = Type(x['ti'])  # Incomplete type (!)
				v = ValueFunc(t, id, x['ti'])
				v.parent = cmodule
				cmodule_value_add(id.str, v, is_public=is_public)

			elif kind == 'const':
				t = Type(x['ti'])  # Incomplete type (!)
				iv = ValueUndefined(ti=x['ti'])
				v = ValueConst(t, id, init_value=iv, ti=x['ti'])
				v.parent = cmodule
				cmodule_value_add(id.str, v, is_public=is_public)

			elif kind == 'var':
				t = Type(x['ti'])  # Incomplete type (!)
				iv = ValueUndefined(ti=x['ti'])
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
			y = None
			if kind == 'type':
				y = def_type(x)
			elif kind == 'const':
				y = def_const(x)
			elif kind == 'func':
				y = def_func(x)
			elif kind == 'var':
				y = def_var(x)

			if y != None:
				add_spices(y, ast_atts=x['attributes'])
				if not is_include:
					y.parent = cmodule
				module_append(y, to_export=x['access_modifier'] == 'public')
		elif isa == 'ast_comment':
			comment = do_stmt_comment(x)
			module_append(comment)

		elif isa == 'ast_directive':
			y = do_directive(x)

	return



imp_paths = []


# получает строку импорта (и неявно глобальный контекст)
# и возвращает полный путь к модулю
def import_abspath(s, ext='.hm'):
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
			full_name = lib_path + '/' + s

	if not os.path.exists(full_name):
		print("%s not exist" % full_name)
		return None

	return os.path.abspath(full_name)



# directive '@attribute'
def add_attributes(obj):
	atts = attributes_get()
	for att in atts:
		lr = att.split(":")
		if len(lr) == 1:
			att = lr[0]
			obj.addAttribute(att)
		elif len(lr) > 1:
			set_att(obj, lr[0].split('.'), lr[1])



def set_att(obj, path, att):
	if len(path) == 1:
		x = getattr(obj, path[0])
		x.addAttribute(att)

	elif len(path) > 1:
		f = path[0]
		o = getattr(obj, f)
		set_att(o, path[1:], att)
	else:
		assert(False)



def set_prop(obj, path, val):
	if len(path) == 1:
		f = path[0]
		setattr(obj, f, val)

	elif len(path) > 1:
		a = getattr(obj, path[0])
		set_prop(a, path[1:], val)

	else:
		assert(False)



# directive '@property'
def add_properties(obj):
	global properties
	props = properties
	properties = {}

	for prop in props:
		k = prop
		v = props[prop]
		path_array = prop.split(".")
		set_prop(obj, path_array, v)



def add_spices(obj, ast_atts=None):
	global attributes
	global properties

	attributes = []
	properties = {}

	if obj == None:
		return

	if ast_atts!=None:
		for a in ast_atts:
			do_attribute(a)

	add_properties(obj)
	add_attributes(obj)



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

		if Value.isBad(arg):
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
			if arg_type.is_integer():
				if not arg_type.is_signed():
					warning("expected signed integer value", arg.ti)
			else:
				warning("expected integer value2", arg.ti)

		elif spec == 'x':
			if not arg_type.is_integer():
				warning("expected integer value3", arg.ti)

		elif spec == 'u':
			if arg_type.is_integer():
				if arg_type.is_signed():
					warning("expected unsigned integer value", arg.ti)
			else:
				warning("expected integer value4", arg.ti)

		elif spec == 's':
			if not arg_type.is_pointer_to_array_of_char():
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
	if _from.items != None:
		to.items = _from.items

	to.immediate = _from.immediate
	to.immutable = _from.immutable
	return



"""if kind == 'if':
	prev_production = production
	c = do_value_immediate(args[0])

	if Value.isBad(c):
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

	if Value.isBad(c):
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

	if Value.isBad(v):
		fatal("unsuitable value", x['ti'])

	msg = v.asset
	info(msg, x['ti'])

elif kind == 'warning':
	v = do_value_immediate_string(args[0])

	if Value.isBad(v):
		fatal("unsuitable value", x['ti'])

	msg = v.asset
	warning(msg, x['ti'])

elif kind == 'error':
	v = do_value_immediate_string(args[0])

	if Value.isBad(v):
		fatal("unsuitable value", x['ti'])

	msg = v.asset
	error(msg, x['ti'])
	exit(-1)

elif kind == 'undef':
	v = do_value_immediate_string(args[0])
	if Value.isBad(v):
		fatal("unsuitable value", x['ti'])
	id_str = v.asset
	cmodule.symtab_public.ValueUndef(id_str)
	cmodule.symtab_public.type_undef(id_str)

el"""
