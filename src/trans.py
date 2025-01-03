
import os

from error import *

from lexer import CmLexer
from parser import Parser

from util import get_item_by_id
from main import settings
import type as htype
from hlir.hlir import hlir_initializer

import foundation

from value.value import value_eq, value_print
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
	if 'definition' in x:
		return x['definition']['module'] == cmodule
	return True


# значение глобально (неважно из какого модуля)
def is_global_value(x):
	return 'global_entity' in x['att']


def is_local_context():
	global cfunc
	return cfunc != None


from value.value import *
from value.cons import value_cons_implicit, value_cons_implicit_check, value_cons_explicit, value_cons_default

from symtab import Symtab
from util import nbits_for_num, nbytes_for_bits

from hlir.field import hlir_field
from hlir.stmt import *
from hlir.hlir import *



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
	cmodule['strings'].append(v)



def module_type_add_public(m, id_str, t):
	#print("module %s type_add_public %s" % (m['id'], id_str))
	m['symtab_public'].type_add(id_str, t)
	#t['module'] = m
	t['att'].append('global_entity')

def module_value_add_public(m, id_str, v):
	#print("module %s value_add_public %s" % (m['id'], id_str))
	m['symtab_public'].value_add(id_str, v)
	#v['module'] = m
	v['att'].append('global_entity')


def module_type_add_private(m, id_str, t):
	#print("module %s type_add_private %s" % (m['id'], id_str))
	m['symtab_private'].type_add(id_str, t)
	#t['module'] = m
	t['att'].append('global_entity')

def module_value_add_private(m, id_str, v):
	#print("module %s value_add_private %s" % (m['id'], id_str))
	m['symtab_private'].value_add(id_str, v)
	#v['module'] = m
	v['att'].append('global_entity')




# public

# search type in module
def module_type_get_public(m, id_str):
	return m['symtab_public'].type_get(id_str)

# search value in module
def module_value_get_public(m, id_str):
	return m['symtab_public'].value_get(id_str)

# private

# search type in module
def module_type_get_private(m, id_str):
	return m['symtab_private'].type_get(id_str)

# search value in module
def module_value_get_private(m, id_str):
	return m['symtab_private'].value_get(id_str)



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

	t = m['symtab_public'].type_get(id_str)
	if t != None:
		return t

	if only_public:
		return None

	t = m['symtab_private'].type_get(id_str)
	if t != None:
		return t

	#
	for included_module in m['included_modules']:
		t = included_module['symtab_public'].type_get(id_str)
		if t != None:
			return t

	return None


# search value in module
def module_value_get(m, id_str, only_public=False):
	#print("module_value_get: " + id_str)

	v = m['symtab_public'].value_get(id_str)
	if v != None:
		return v

	if only_public:
		return None

	v = m['symtab_private'].value_get(id_str)
	if v != None:
		return v

	#
	for included_module in m['included_modules']:
		v = included_module['symtab_public'].value_get(id_str)
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
	return cmodule['symtab_public'].value_get(id_str, recursive=False)



def module_append(definition, to_export=False):
	if definition == None:
		return

	global cmodule

	cmodule['defs'].append(definition)
	definition['module'] = cmodule



def context_push():
	global context
	context = context.branch(domain='local')

def context_pop():
	global context
	context = context.parent_get()




# used in metadirs
def c_include(s):
	#global cmodule
	local = s[0:2] == './'
	inc = {
		'isa': 'directive',
		'kind': 'c_include',
		'c_name': s,
		'local': local,
		'att': [],
		'nl': 1,
		'ti': None
	}
	#module_append(inc)
	return inc


properties = {}


# used in metadirs
# add 'properties' to entity descriptor
def property_add(id, value):
	global properties
	properties[id] = value


def output_id(id):
	property_add()




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

	undefinedVolume = value_undefined(typeSysNat, ti=None)
	typeSysStr = htype.type_pointer(htype.type_array(typeSysChar, undefinedVolume))

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
		hlir_initializer(hlir_id('major'), compilerVersionMajor),
		hlir_initializer(hlir_id('minor'), compilerVersionMinor)
	]
	compilerVersion = value_record_create(compiler_version_initializers)

	# '__compiler' record
	compiler_initializers = [
		hlir_initializer(hlir_id('name'), compilerName),
		hlir_initializer(hlir_id('version'), compilerVersion),
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
		hlir_initializer(hlir_id('name'), __targetName),
		hlir_initializer(hlir_id('charWidth'), __targetCharWidth),
		hlir_initializer(hlir_id('intWidth'), __targetIntWidth),
		hlir_initializer(hlir_id('floatWidth'), __targetFloatWidth),
		hlir_initializer(hlir_id('pointerWidth'), __targetPointerWidth),
	]
	target = value_record_create(target_initializers)
	root_symtab.value_add('__target', target)



# last fiels of record can be zero size array (!)
# (only with -funsafe key)
# pos - position no
# offset - real offset (address inside container struct)
def do_field(x):
	id = x['id']
	if id['str'][0].isupper():
		error("field id must starts with small letter", id['ti'])

	t = do_type(x['type'])
	f = hlir_field(id, t, ti=x['ti'])
	f['nl'] = x['nl']

	f['access_level'] = x['access_modifier']

	add_spices(f, ast_atts=x['attributes'])
	return f


#
# Do Type
#

def do_type_id(t):
	id = t['ids'][0]
	id_str = id['str']

	tx = None
	if len(t['ids']) > 1:
		ns_id = id_str
		id_str = t['ids'][1]['str']
		#print(">>>>>>>>>>>>>>>>>>>>>> GET TYPE %s FROM: %s" % (id_str, ns_id))
		global cmodule
		if ns_id in cmodule['imports']:
			submodule = cmodule['imports'][ns_id]
			tx = module_type_get_public(submodule, id_str)
		else:
			error("unknown namespace '%s'" % ns_id, t['ti'])
			tx = htype.type_bad(t)
			return tx

	else:
		tx = ctx_type_get(id_str)

	# tmp
	if tx == None:
		error("undefined type", t['ti'])
		tx = htype.type_undefined(t['ti'])

	# если дело происходит в определении типа и пришел undefined тип
	#htype.type_is_incomplete
	if htype.type_is_undefined(tx):
		if cdef['isa'] != 'def_type':
			#print(cdef['isa'])
			error("forward references to non-struct type", t['ti'])
		cdef['deps'].append(tx)

	return tx



def do_type_pointer(t):
	to = do_type(t['to'])
	return htype.type_pointer(to, ti=t['ti'])


def do_type_array(t):
	of = do_type(t['of'])

	volume = do_value(t['size'])

	if value_is_bad(volume):
		return htype.type_array(of, volume, ti=t['ti'])

	if not value_is_undefined(volume):
		if not value_is_immediate(volume):
			info("VLA", t['ti'])
			if is_local_context():
				global cfunc
				cfunc['att'].append('stacksave')
			else:
				error("non local VLA", t['size'])

		#if not (htype.type_is_integer(volume['type']) or htype.type_is_number(volume['type'])):
		if htype.type_is_signed(volume['type']):
			error("required value with number or integer type", t['size']['ti'])

	# closed arrays of closed arrays are denied NOW
#	if htype.type_is_closed_array(of):
#		error("closed arrays of closed arrays are denied", t['ti'])
#		return htype.type_bad(t)

	return htype.type_array(of, volume, ti=t['ti'])



anon_rec_cnt = 0
def do_type_record(x):
	global anon_rec_cnt
	fields = []

	for field in x['fields']:
		f = do_field(field)

		# redefinition?
		field_id_str = f['id']['str']
		field_already_exist = get_item_by_id(fields, field_id_str)
		if field_already_exist != None:
			error("redefinition of '%s' field" % field_id_str, field['ti'])
			continue

		if 'comments' in field:
			f.update({'comments': field['comments']})

		fields.append(f)

	anon_rec_cnt = anon_rec_cnt + 1
	rec = htype.type_record(fields, ti=x['ti'])
	rec['end_nl'] = x['end_nl']
	# add anon record (before)

	anon_tag = '__anonymous_struct_%d' % anon_rec_cnt
	rec['c_anon_id'] = anon_tag

	#rec['att'].append('anonymous_record') # remove this!
	cmodule['anon_recs'].append(rec)
	return rec


def do_type_enum(t):
	enum_type = htype.type_enum(t['ti'])

	i = 0
	for item in t['items']:
		id = item['id']
		enum_type['items'].append({
			'isa': 'enum_item',
			'id': id,
			'number': i,
			'ti': item['ti']
		})

		# add enum item to global context
		item_val = value_terminal(enum_type, item['ti'])
		item_val['asset'] = i

		item_val['id'] = id
		global cmodule
		module_value_add_public(cmodule, id['str'], item_val)
		i += 1

	return enum_type



def do_type_func(t, func_id="_"):
	# check params
	params = []
	for _param in t['params']:
		param = do_field(_param)
		if param != None:
			params.append(param)

	to = foundation.typeUnit
	if t['to'] != None:
		to = do_type(t['to'])

	return htype.type_func(params, to, t['arghack'], ti=t['ti'])



def do_type_undefined(x):
	return htype.type_undefined(x['ti'])


def do_type(x):
	for a in x['attributes']:
		do_attribute(a)

	t = None
	k = x['kind']
	if k == 'id': t = do_type_id(x)
	elif k == 'func': t = do_type_func(x)
	elif k == 'pointer': t = do_type_pointer(x)
	elif k == 'array': t = do_type_array(x)
	elif k == 'record': t = do_type_record(x)
	elif k == 'enum': t = do_type_enum(x)
	elif k == 'undefined': t = do_type_undefined(x)
	else: t = bad_type(x['ti'])

	t['ti'] = x['ti']

	return t




def do_value_shift(x):
	op = x['kind']  # 'shl', 'shr'
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	type_result = l['type']

#	if not htype.type_is_word(l['type']):
#		error("expected word value", x['left'])

	if htype.type_is_signed(r['type']):
		error("expected natural value", x['right'])

	if value_is_immediate(l) and value_is_immediate(r):
		asset = l['asset']
		if op == 'shl': asset = asset << r['asset']
		else: asset = asset >> r['asset']

		nv = value_bin(op, l, r, type_result, ti=x['ti'])
		nv['asset'] = int(asset)
		nv['immediate'] = True
		return nv

	if htype.type_is_generic(l['type']):
		error("expected non-generic value", l)
		return value_bad(x['ti'])

	return value_bin(op, l, r, type_result, ti=x['ti'])


def do_value_bin(x):
	op = x['kind']
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	ti = x['ti']

	if value_is_bad(l) or value_is_bad(r):
		return value_bad(ti)

	# Ops with different types
	if op == 'add':
		# массивы могут быть разной длины (то есть с разными типами)
		# поэтому сложение массивов (only immediate) требует обхода проверок типа ниже
		if htype.type_is_array(l['type']) and htype.type_is_array(r['type']):
			return value_array_add(l, r, ti)
		# у string вообще всегда одинакоывый тип и нет смысла приводить их
		elif htype.type_is_string(l['type']) and htype.type_is_string(r['type']):
			return value_string_add(l, r, ti)


	# Check type is valid for the operation

	if not op in l['type']['ops']:
		error("unsuitable value type for '%s' operation" % op, l['ti'])
		return value_bad(ti)

	if not op in r['type']['ops']:
		error("unsuitable value type for '%s' operation" % op, r['ti'])
		return value_bad(ti)

	#
	# Now and further types must be equal (!)
	#

	t = htype.select_common_type(l['type'], r['type'])
	if htype.type_is_bad(t):
		error("different types in operation", x['ti'])
		return value_bad(ti)

	l = value_cons_implicit(t, l)
	r = value_cons_implicit(t, r)

	if not htype.type_eq(l['type'], r['type'], ti):
		error("different types in '%s' operation" % x['kind'], ti)

		# print: @@ <left_type> & <right_type> @@
		print(color_code(CYAN), end='')
		print('@@ ', end='')
		htype.type_print(l['type'])
		print(" & ", end='')
		htype.type_print(r['type'])
		print(' @@', end='')
		print(color_code(ENDC), end='')
		print("\n")

		return value_bad(ti)


	if op in ['eq', 'ne']:
		return value_eq(l, r, op, ti)

	if htype.type_eq(t, foundation.typeBool):
		if op == 'or': op = 'logic_or'
		elif op == 'and': op = 'logic_and'

	if op in (htype.EQ_OPS + htype.RELATIONAL_OPS):
		t = foundation.typeBool

	nv = value_bin(op, l, r, t, ti=ti)

	# if left & right are immediate, we can fold const
	# and append field ['asset'] to bin_value
	if value_is_immediate(l) and value_is_immediate(r):
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
			if not htype.type_is_float(t):
				asset = l['asset'] // r['asset']
			else:
				asset = l['asset'] / r['asset']
		else:
			asset = ops[op](l['asset'], r['asset'])


		if htype.type_is_number(t):
			# (для операций типа 1 + 2)
			# Пересматриваем generic тип для нового значения
			nv['type'] = htype.type_number_for(asset, signed=asset < 0, ti=ti)

		nv['asset'] = asset
		nv['immediate'] = True

	return nv



def do_value_ref(x):
	v = do_value(x['value'])

	if value_is_bad(v):
		return v

	ti = x['ti']
	op = x['kind']
	vtype = v['type']

	if value_is_immutable(v):
		if not htype.type_is_func(vtype) or htype.type_is_undefined(vtype):
			error("expected mutable value or function", v)
			return value_bad(x['ti'])

	vt = htype.type_pointer(vtype, ti=ti)
	nv = value_un('ref', v, vt, ti=ti)

	if htype.type_is_func(vtype):
		nv['immediate'] = True
		# TODO:
		# не можно поставить 0 тк иначе значение будет трактоваться как zero
		# и LLVM printer его не всунет в композитны тип (пропустит insertelement)
		# временно заткнул единицей, но вообще нужно будет обдумать
		nv['asset'] = 1

	return nv



def do_value_not(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']

	if not 'not' in vtype['ops']:
		error("unsuitable type", v)
		return value_bad(x['ti'])

	op = 'not'
	if htype.type_is_bool(vtype):
		op = 'logic_not'

	nv = value_un(op, v, vtype, ti=x['ti'])

	if value_is_immediate(v):
		# because: ~(1) = -1 (not 0) !
		if htype.type_is_bool(vtype):
			nv['asset'] = not v['asset']
		else:
			nv['asset'] = ~v['asset']

		nv['immediate'] = True

	return nv



def do_value_neg(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']

	if not htype.type_is_generic(vtype):
		if not htype.type_is_signed(vtype):
			error("expected value with signed type", v)
	else:
		vtype['signed'] = True

	nv = value_un('neg', v, vtype, ti=x['ti'])

	if value_is_immediate(v):
		nv['asset'] = -v['asset']
		nv['immediate'] = True

		if htype.type_is_generic(nv['type']):
			nv['type'] = htype.type_number_for(v['asset'], signed=True, ti=x['ti'])

	return nv



def do_value_pos(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']

	if not htype.type_is_signed(vtype):
		error("expected value with signed type", v)

	nv = value_un('pos', v, vtype, ti=x['ti'])

	if value_is_immediate(v):
		nv['asset'] = +v['asset']
		nv['immediate'] = True

		if htype.type_is_generic(nv['type']):
			nv['type'] = htype.type_number_for(v['asset'], signed=True, ti=x['ti'])

	return nv



def do_value_deref(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']
	if not htype.type_is_pointer(vtype):
		error("expected pointer value", v)
		return value_bad(x['ti'])

	to = vtype['to']

	# you can't deref:
	#   - pointer to Unit
	#   - pointer to function
	#   - pointer to open array
	is_func_ptr = htype.type_is_func(to)
	is_free_ptr = htype.type_is_free_pointer(to)
	is_open_array_ptr =  htype.type_is_open_array(to)
	if is_func_ptr or is_free_ptr or is_open_array_ptr:
		error("unsuitable type", v)

	nv = value_un('deref', v, to, ti=x['ti'])
	nv['immutable'] = False
	return nv



def sort_args(params, args):
	# выходной вектор в котором лежат отсортированные аргументы
	# в порядке их реальной преедачи в функцию
	outvec = []

	# получаем направляющий вектор
	vec0=[]
	for param in params:
		vec0.append(param['id']['str'])

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

	if not htype.type_is_array(arg['type']):
		error("expected array value", args[0]['ti'])
		return value_bad({'ti': ti})

	# for C backend, because C cannot do lengthof(x)
	if not 'use_lengthof' in cmodule['att']:
		cmodule['att'].append('use_lengthof')

	return value_lengthof(arg, ti)


def do_value_va_start(x):#args, ti):
	args = x['values']
	ti = x['ti']
	va_list = do_value(args[0])
	last_param = do_rvalue(args[1])
	return value_va_start(va_list, last_param, ti)


def do_value_va_arg(x):
	va_list = do_value(x['va_list'])
	type = do_type(x['type'])
	return value_va_arg(va_list, type, x['ti'])


def do_value_va_end(x):
	ti = x['ti']
	va_list = do_value(x['value'])
	return value_va_end(va_list, ti)


def do_value_va_copy(x):
	args = x['values']
	ti = x['ti']
	va_list0 = do_value(args[0])
	va_list1 = do_value(args[1])
	return value_va_copy(va_list0, va_list1, ti)


def do_value___defined_type(x):
	t = ctx_type_get(x['type']['id']['str'])
	return t != None


def do_value___defined_value(x):
	v = ctx_value_get(x['value']['id']['str'])
	return v != None



def do_value_call(x):
	fn = do_rvalue(x['left'])

	if value_is_bad(fn):
		#error("undefined value 2", fn)
		return value_bad(x['ti'])


	ftype = fn['type']

	# pointer to function?
	if htype.type_is_pointer(ftype):
		ftype = ftype['to']

	if not htype.type_is_func(ftype):
		error("expected function or pointer to function", x)

	params = ftype['params']
	args = x['args']

	npars = len(params)
	nargs = len(args)

	if nargs < npars:
		error("not enough args", x)
		return value_bad(x['ti'])

	if nargs > npars:
		if not ftype['extra_args']:
			error("too many args", x)
			return value_bad(x['ti'])

	sorted_args = sort_args(params, x['args'])


	imm_args = True  # all arguments are immediate?

	args = []

	# normal args
	i = 0
	while i < npars:
		param = params[i]
		param_id_str = param['id']['str']
		a = sorted_args[i]

		# check param name (if assigned)
		if a['key'] != None:
			tasrget_param_id_str = a['key']['str']
			if tasrget_param_id_str != param_id_str:
				error("bad parameter id", a['key']['ti'])

		arg = do_rvalue(a['value'])


		if not value_is_bad(arg):
			arg = value_cons_implicit_check(param['type'], arg)

			if not value_is_immediate(arg):
				imm_args = False

			if a['key'] != None:
				args.append(hlir_initializer(a['key'], arg))
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

		if not value_is_bad(argval):
			if htype.type_is_generic(argval['type']):
				warning("extra argument with generic type", a['ti'])
				argval = value_cons_default(argval)

			if not value_is_immediate(argval):
				imm_args = False

			extra_args.append(argval)

		i += 1


	if 'id' in fn:
		func_id_str = fn['id']['str']
		if func_id_str in ['print', 'scanf', 'print']:
			expected_pointers = func_id_str == 'scanf'
			first_arg = x['args'][0]['value']
			if first_arg['kind'] in ['string', 'string_concat']:
				specs = get_cspecs(first_arg['str'])
				extra_args_check(specs, extra_args, expected_pointers)
			else:
				error("expected literal string argument", first_arg['ti'])

	rv = value_call(fn, ftype['to'], args + extra_args, ti=x['ti'])
	return rv



def do_value_index(x):
	left = do_rvalue(x['left'])

	if value_is_bad(left):
		return value_bad(x['ti'])

	left_typ = left['type']

	via_pointer = htype.type_is_pointer(left_typ)

	array_typ = left_typ
	if via_pointer:
		array_typ = left_typ['to']


	if not htype.type_is_array(array_typ):
		error("expected array or pointer to array", left)
		return value_bad(x['ti'])


	index = do_rvalue(x['index'])

	if value_is_bad(index):
		return value_bad(x['ti'])

	if not (htype.type_is_integer(index['type']) or htype.type_is_number(index['type'])):
		error("expected integer value", x['index'])
		return value_bad(x['ti'])

	if htype.type_is_generic(index['type']):
		index = value_cons_implicit_check(typeSysInt, index)

	nv = value_index_array(left, array_typ['of'], index, ti=x['ti'])

	if not via_pointer:
		nv['immutable'] = left['immutable']

		if value_is_immediate(left):
			if value_is_immediate(index):
				#info("immediate index", x['ti'])
				index_imm = index['asset']

				if index_imm >= array_typ['volume']['asset']:
					error("array index out of bounds", x['index'])
					return value_bad(x['ti'])

				item = left['items'][index_imm]

				nv['immval'] = item
				#nv['items'] = item['items']
				nv['immediate'] = item['immediate']

	return nv


def do_value_slice(x):
	#info("do_value_slice", x['ti'])
	left = do_value(x['left'])
	index_from = do_rvalue(x['index_from'])
	index_to = None
	ti = x['ti']

	if x['index_to'] != None:
		index_to = do_rvalue(x['index_to'])
		if value_is_bad(index_to):
			return value_bad(x['ti'])

	if value_is_bad(left) or value_is_bad(index_from):
		return value_bad(x['ti'])

	left_type = left['type']
	via_pointer = htype.type_is_pointer(left_type)
	array_type = left_type
	if via_pointer:
		array_type = left_type['to']

	if not htype.type_is_array(array_type):
		error("expected array or pointer to array", left)
		return value_bad(x['ti'])


	# получаем размер слайса
	slice_volume = None  # asg_value

	"""known_volume = False
	if index_from != None and index_to != None:
		known_volume = value_is_immediate(index_from) and value_is_immediate(index_to)

	if known_volume:"""
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
		"""un = {
			'isa': 'ast_value',
			'kind': 'number',
			'numstr': '1',
			'att': [],
			'ti': ti
		}
		le = {
			'isa': 'ast_value',
			'kind': 'add',
			'left': de,
			'right': un,
			'ti': ti
		}"""

		slice_volume = do_value(de)

		slice_len = 0  # len as integer
		if value_is_immediate(slice_volume):
			slice_len = slice_volume['asset']

			if slice_len < 0:
				error("wrong slice direction", x['ti'])
				return value_bad(x['ti'])


#	if htype.type_is_closed_array(array_type):
#		if slice_volume == None:
#			error("expected immediate value", index_from)
#
#		# TODO: конкретно тут есть что исправить!
#		if slice_len > array_type['volume']['asset']:
#			error("slice is too big", x['ti'])


	if slice_volume == None:
		slice_volume = value_undefined(typeSysNat, x['ti'])

	type = htype.type_array(array_type['of'], slice_volume, x['ti'])
	nv = value_slice_array(left, type, index_from, index_to, x['ti'])

	if not via_pointer:
		nv['immutable'] = left['immutable']

	return nv





def is_submodule_name(id_str):
	return id_str in cmodule['imports']


def submodule_access(x):
	global cmodule

	mname = x['left']['str']
	iname = x['right']['str']
	ti = x['ti']

	submodule = cmodule['imports'][mname]

	v = module_value_get_public(submodule, iname)
	if v == None:
		v = module_value_get_private(submodule, iname)
		if v != None:
			error("access to module private item", ti)

	if v == None:
		return value_bad(x['ti'])

	y = value_access_module(v['type'], submodule, v, v, x['ti'])
	cp_immediate(y, v)
	return y



def do_value_access(x):
	# access to submodule?
	if x['left']['kind'] == 'id':
		if is_submodule_name(x['left']['str']):
			return submodule_access(x)

	#
	# access to object
	#

	left = do_rvalue(x['left'])

	if value_is_bad(left):
		return value_bad(x['ti'])

	field_id = x['right']

	# доступ через переменную-указатель
	via_pointer = htype.type_is_pointer(left['type'])

	record_type = left['type']
	if via_pointer:
		record_type = left['type']['to']

	# check if is record
	if not htype.type_is_record(record_type):
		error("expected record or pointer to record", x)
		return value_bad(x['ti'])

	field = htype.record_field_get(record_type, field_id['str'])

	# if field not found
	if field == None:
		error("undefined field '%s'" % field_id['str'], x)
		return value_bad(x['ti'])

	# PROBLEM: у анонимных структур нет поля 'definition'
	# и непонятно как с этимм быть. Можно добавить module
	# в каждую сущность, но...
#	if record_type['definition']['module'] != cmodule:
#		if not 'public' in field['att']:
#			error("access to private field", x['ti'])


	if htype.type_is_bad(field['type']):
		return value_bad(x['ti'])


	# Check access permissions

	# не у всех типов есть 'definition' (его нет у анонимных записей например)
	if not is_local_entity(record_type):
		if field['access_level'] == 'private':
			error("access to private field of record", x['right']['ti'])


	nv = value_access_record(field['type'], left, field, ti=x['ti'])
	if not via_pointer:
		nv['immutable'] = left['immutable']

		# access to immediate object
		if value_is_immediate(left):
			initializer = get_item_by_id(left['items'], field_id['str'])

			# (!) #asset of immediate index & access contains VALUE (!)
			nv['immediate'] = True
			nv['immval'] = initializer['value']
			cp_immediate(nv, initializer['value'])

	return nv



def do_value_cons(x):
	v = do_rvalue(x['value'])
	t = do_type(x['type'])
	if value_is_bad(v) or htype.type_is_bad(t):
		return value_bad(x['ti'])
	return value_cons_explicit(t, v, x['ti'])



def do_value_id(x):
	id_str = x['str']
	v = ctx_value_get(id_str)

	if v == None:
		error("undefined value '%s'" % id_str, x)
		# чтобы не генерил ошибки дальше
		# создадим bad value и пропишем его глобально (wrong!)
		v = value_bad(x['ti'])
		value_attribute_add(v, 'unknown')
		ctx_value_add(id_str, v)
		return v


	global cdef
	if htype.type_is_incomplete(v['type']):
		cdef['deps'].append(v)
		v = update_func_type(v['id']['str'])
		if v == None:
			error("call undefined func", x['ti'])
			return value_bad(x['ti'])


	if 'usecnt' in v:
		v['usecnt'] = v['usecnt'] + 1

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
			item_value['nl'] = item['nl']
			items.append(item_value)

	v = value_array_create(items, ti=x['ti'])
	v['nl_end'] = x['nl_end']
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
			p = hlir_initializer(
				item['key'],
				item_value,
				ti=item['ti'],
				nl=item['nl']
			)
			initializers.append(p)

	v = value_record_create(initializers, ti=x['ti'])
	v['nl_end'] = x['nl_end']
	return v



def do_value_number(x):
	if '.' in x['numstr']:
		return do_value_float(x)

	return do_value_integer(x)



def do_value_integer(x):
	num_string_len = len(x['numstr'])
	base = 10
	if num_string_len > 2:
		if x['numstr'][0] == '0':
			if x['numstr'][1] == 'x':
				num_string_len = num_string_len - 2
				base = 16

	num = int(x['numstr'], base)
	v = value_integer_create(num, ti=x['ti'])
	v['nsigns'] = num_string_len

	if base == 16:
		value_attribute_add(v, 'hexadecimal')

	return v



def do_value_float(x):
	# in compile time floats stores as decimal (!)
	fval = decimal.Decimal(x['numstr'])
	fv = value_float_create(fval, ti=x['ti'])
	return fv


def do_value_sizeof_type(x):
	t = do_type(x['type'])
	return value_sizeof_type(t, ti=x['ti'])


def do_value_sizeof_value(x):
	v = do_value(x['value'])
	return value_sizeof_value(v, ti=x['ti'])



def do_value_alignof(x):
	of = do_type(x['type'])
	return value_alignof(of, ti=x['ti'])


def do_value_offsetof(x):
	of = do_type(x['type'])
	field_id = x['field']
	return value_offsetof(of, field_id, ti=x['ti'])



bin_ops = [
	'or', 'xor', 'and',
	'eq', 'ne', 'lt', 'gt', 'le', 'ge',
	'add', 'sub', 'mul', 'div', 'rem'
]


def do_value_immediate(x, allow_ptr_to_str=False):
	v = do_value(x)

	if value_is_bad(v):
		return v

	if not value_is_immediate(v):
		if allow_ptr_to_str:
			if htype.type_is_pointer_to_array_of_char(v['type']):
				return v
		error("expected immediate value", x['ti'])
		return value_bad(x['ti'])

	return v


def do_value_immediate_string(x):
	v = do_value_immediate(x)

	if value_is_bad(v):
		return v

	if not htype.type_is_string(v['type']):
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
	return value_bad(x['ti'])


def do_value_undefined(x):
	t = htype.type_undefined(x['ti'])
	return value_undefined(t, x['ti'])



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
	elif k == 'bad': v = do_value_bad(x['ti'])
	elif k == 'undefined': v = do_value_undefined(x)

	assert(v != None)
	v['ti'] = x['ti']
	return v


#
# Do Statement
#

def do_stmt_if(x):
	cond = do_rvalue(x['cond'])

	if value_is_bad(cond):
		return hlir_stmt_bad(x)

	if not htype.type_is_bool(cond['type']):
		error("expected bool value", cond)
		return hlir_stmt_bad(x)

	_then = do_stmt(x['then'])

	if hlir_stmt_is_bad(_then):
		return hlir_stmt_bad(x)

	_else = None
	if x['else'] != None:
		_else = do_stmt(x['else'])
		if hlir_stmt_is_bad(_else):
			return hlir_stmt_bad(x['else'])

	return hlir_stmt_if(cond, _then, _else, ti=x['ti'])



def do_stmt_while(x):
	cond = do_rvalue(x['cond'])

	if value_is_bad(cond):
		return hlir_stmt_bad(x)

	if not htype.type_is_bool(cond['type']):
		error("expected bool value", cond)
		return hlir_stmt_bad(x)

	block = do_stmt(x['stmt'])

	if hlir_stmt_is_bad(block):
		return hlir_stmt_bad(x)

	return hlir_stmt_while(cond, block, ti=x['ti'])



def do_stmt_return(x):
	global cfunc

	func_ret_type = cfunc['type']['to']

	is_no_ret_func = htype.type_is_unit(func_ret_type)
	ret_val_present = x['value'] != None

	# если забыли вернуть значение
	# или возвращаем его там, где оно не ожидется
	if ret_val_present == is_no_ret_func:
		if ret_val_present:
			error("unexpected return value", x['value']['ti'])
		else:
			error("expected return value", x['ti'])
		return hlir_stmt_bad(x)

	# (!) in return statement retval can be None (!)
	retval = None
	if ret_val_present:
		rv = do_rvalue(x['value'])
		if not value_is_bad(rv):
			retval = value_cons_implicit_check(func_ret_type, rv)

	return hlir_stmt_return(retval, ti=x['ti'])


def do_stmt_type(x):
	fatal("do_stmt_type() not implemented")


def do_stmt_again(x):
	return hlir_stmt_again(x['ti'])


def do_stmt_break(x):
	return hlir_stmt_break(x['ti'])


def do_stmt_var(x):
	var_id = x['id']

	t = do_type(x['type'])
	v = do_rvalue(x['init_value'])

	tu = htype.type_is_undefined(t)
	vu = value_is_undefined(v)

	# error: no type, no init valuetu = type_is_undefined(t)
	if tu == True and vu == True:
		# type & value undefined
		ctx_value_add(var_id['str'], value_bad(x['ti']))
		return hlir_stmt_bad(x)

	if tu == True and vu == False:
		# type undef, value ok
		#type_update(nt, v['type'])
		if htype.type_is_generic(v['type']):
			v = value_cons_default(v)
		t = v['type']

	#if not htype.type_is_undefined(t):
	#	if htype.type_is_bad(t):
	#		ctx_value_add(var_id['str'], value_bad(x['ti']))
	#		return hlir_stmt_bad(x)
	#
		if htype.type_is_forbidden_var(t):
			error("unsuitable type1", x['type']['ti'])

	# type & init value present
	if not htype.type_is_undefined(t) and not value_is_undefined(v):
		v = value_cons_implicit_check(t, v)

	if htype.type_is_undefined(t):
		if htype.type_is_generic(v['type']):
			v = value_cons_default(v)

		t = v['type']

	# check if identifier is free (in current block)
	already = ctx_value_get_shallow(var_id['str'])
	if already != None:
		error("local id redefinition", x['id']['ti'])
		info("firstly defined here", already['id']['ti'])
		return hlir_stmt_bad(x)

	var_value = add_local_var(var_id, t, var_id['ti'])
	return hlir_stmt_def_var(var_id, var_value, v, ti=x['ti'])



def add_local_var(id, typ, ti):
	var_value = value_var(id, typ, ti)
	var_value['att'].extend(['local'])
	ctx_value_add(id['str'], var_value)
	return var_value



def do_stmt_let(x):
	id = x['id']

	# check if identifier is free (in current block)
	already = ctx_value_get_shallow(id['str'])
	if already != None:
		error("redefinition of '%s'" % id['str'], id['ti'])
		return hlir_stmt_bad(x)

	if id['str'][0].isupper():
		error("value id must starts with small letter", id['ti'])
		pass

	v = do_rvalue(x['value'])

	if value_is_bad(v):
		ctx_value_add(id['str'], value_bad(x['ti']))
		return hlir_stmt_bad(x)

	const_value = value_const(id, v['type'], value=v, ti=x['id']['ti'])
	# не знаю правильно ли это, но перносим аттрибуты значения-инициализатора
	# на константу. ---Пока это необходимо для 'wrapped_array' (!)---
	const_value['att'].extend(v['att'])
	const_value['att'].append('local') # need for LLVM printer (!)

	# Now let can be immediate!
	if value_is_immediate(v):
		const_value['immediate'] = True
		cp_immediate(const_value, v)

		if htype.type_is_generic(v['type']):
			# generic immediate в C печатается как #define
			# и его надо манглить иначе возникает куча проблем
			const_value['id']['c'] = '__' + const_value['id']['str']

	ctx_value_add(id['str'], const_value)

	return hlir_stmt_def_const(id, const_value, v, ti=x['ti'])



def do_stmt_assign(x):
	l = do_value(x['left'])
	r = do_rvalue(x['right'])

	if value_is_bad(l) or value_is_bad(r):
		return hlir_stmt_bad(x)

	if not value_is_lvalue(l):
		error("expected lvalue", l)
		return hlir_stmt_bad(x)

	if value_is_immutable(l):
		error("expected mutable value", l)
		return hlir_stmt_bad(x)

	r = value_cons_implicit_check(l['type'], r)
	return hlir_stmt_assign(l, r, ti=x['ti'])



def do_stmt_incdec(x, op='add'):
	v = do_value(x['value'])

	if value_is_bad(v):
		return hlir_stmt_bad(x)

	if value_is_immutable(v):
		error("expected mutable value", v)
		return hlir_stmt_bad(x)

	if not htype.type_is_integer(v['type']):
		error("expected integer value", v)
		return hlir_stmt_bad(x)

	one = value_integer_create(1, typ=v['type'], ti=x['ti'])
	nv = value_bin(op, v, one, v['type'], ti=x['ti'])
	return hlir_stmt_assign(v, nv, ti=x['ti'])



def do_stmt_value(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return hlir_stmt_bad(x)

	if not htype.type_is_unit(v['type']):
		if not 'dispensable' in v['type']['att']:
			warning("unused result of %s expression" % x['value']['kind'], v['ti'])

	return hlir_stmt_value(v, ti=x['ti'])



def do_stmt_comment_line(x):
	return {
		'isa': 'stmt',
		'kind': 'comment-line',
		'lines': x['lines'],
		'nl': x['nl'],
		'ti': x['ti']
	}


def do_stmt_comment_block(x):
	return {
		'isa': 'stmt',
		'kind': 'comment-block',
		'text': x['text'],
		'nl': x['nl'],
		'ti': x['ti']
	}


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

	return hlir_stmt_asm(asm_text, outputs, inputs, clobbers, x['ti'])



def do_stmt(x):
	s = None

	k = x['kind']
	if k == 'value': s = do_stmt_value(x)
	elif k == 'assign': s = do_stmt_assign(x)
	elif k == 'let': s = do_stmt_let(x)
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
	else: s = hlir_stmt_bad(x)

	assert(s != None)

	if not 'nl' in x:
		print(x['kind'])
	s['nl'] = x['nl']

	return s



def do_stmt_block(x):
	context_push()

	stmts = []
	for stmt in x['stmts']:
		s = do_stmt(stmt)
		if not hlir_stmt_is_bad(s):
			stmts.append(s)

	context_pop()

	return hlir_stmt_block(stmts, ti=x['ti'], end_nl=x['end_nl'])



def symbol_const(id, init_value, is_public=False):
	const_value = value_const(id, init_value['type'], init_value, id['ti'])
	const_value['att'].extend(init_value['att'])

	# Now let can be immediate!
	if value_is_immediate(init_value):
		const_value['immediate'] = True
		cp_immediate(const_value, init_value)

	global cmodule
	cmodule_value_add(id['str'], const_value, is_public=is_public)
	#module_value_add_public(cmodule, id['str'], const_value)
	return const_value



# нужно добавлять префикс к сущности
# наличие поля prefix дает принтеру знать что нужно декорировать имя
def need_decoration(x):
	return not is_nodecorate(x) and not ('module_nodecorate' in cmodule['att']) and not x['access_modifier'] == 'private'



def type_update(dst, src):
	dst.clear()
	dst.update(src)
	dst['att'] = copy.copy(src['att'])


def def_type(x):
	global cmodule
	global cdef

	id = x['id']
	log("def_type: %s" % id['str'])

	nt = ctx_type_get(id['str'])

	if not htype.type_is_undefined(nt):
		error("type redefinition", x['ti'])
		return None

	definition = hlir_def_type(id, nt, None, x['ti'])
	definition['module'] = cmodule
	definition['access_level'] = x['access_modifier']
	definition['nl'] = x['nl']
	cdef = definition

	ty = do_type(x['type'])

	if htype.type_is_bad(ty):
		return None

	definition['original_type'] = ty

	# поскольку этот тип здесь связывается с идентификатором
	# он уже не анонимный
	if ty in cmodule['anon_recs']:
		cmodule['anon_recs'].remove(ty)

	# Замещаем внутренности undefined типа на тип справа
	# НО! имя даем новое
	deps = nt['deps']
	type_update(nt, ty)
	nt['deps'] = deps
	nt['id'] = id # need for  @property("type.id.c", "int")
#	nt['id']['c'] = id['str']   # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	nt['definition'] = definition
	nt['module'] = cmodule  # добавляем заново тк очистили его выше!
	nt['ti_def'] = id['ti']

	if need_decoration(x):
		nt['id']['prefix'] = cmodule['prefix']

	if not ('do_not_include' in cmodule['att']):
		# В случае когда не печатаем typedef явно (!)
		# Убираем алиасы которые висели на оригинальном типе
#		if 'c' in nt['id']:
#			nt.pop('c')
		if 'llvm_alias' in nt['id']:
			nt.pop('llvm_alias')

	if htype.type_is_record(ty):
		cmodule['records'].append(nt)

	cdef = None
	return definition



def def_const(x):
	global cdef
	global cmodule
	id = x['id']

	log("def_const: %s" % id['str'])

	# check if identifier is free
	pre_exist = ctx_value_get_shallow(id['str'])
	if pre_exist != None:
		error("redefinition of '%s'" % id['str'], id['ti'])

	definition = hlir_def_const(id, None, None, x['ti'])
	definition['module'] = cmodule
	definition['access_level'] = x['access_modifier']
	definition['nl'] = x['nl']
	cdef = definition

	init_value = do_value_immediate(x['value'], allow_ptr_to_str=True)


	if value_is_bad(init_value):
		module_value_add_public(cmodule, id['str'], init_value)
		return hlir_def_const(id, init_value, init_value, x['ti'])

	t = do_type(x['type'])
	if not htype.type_is_undefined(t):
		if not htype.type_is_bad(t):
			init_value = value_cons_implicit_check(t, init_value)

	definition['init_value'] = init_value


	const_value = symbol_const(id, init_value, is_public=x['access_modifier'] == 'public')
	const_value['definition'] = definition

	if need_decoration(x):
		const_value['id']['prefix'] = cmodule['prefix']

	definition['value'] = const_value

	cdef = None
	return definition



def def_var(x):
	global cdef

	id = x['id']
	log("def_var %s" % id['str'])

	# already defined? (check identifier)
	already = ctx_value_get(id['str'])
	if already != None:
		error("redefinition of '%s'" % id['str'], id['ti'])


	definition = hlir_def_var(id, None, None, x['ti'])
	definition['module'] = cmodule
	definition['access_level'] = x['access_modifier']
	definition['nl'] = x['nl']
	cdef = definition

	t = do_type(x['type'])
	v = do_rvalue(x['init_value'])

	tu = htype.type_is_undefined(t)
	vu = value_is_undefined(v)

	# error: no type, no init valuetu = type_is_undefined(t)
	if tu == True and vu == True:
		# ERROR: type & value undefined
		ctx_value_add(id['str'], value_bad(x['ti']))
		return hlir_stmt_bad(x)

	elif tu == True and vu == False:
		# type undef, value ok

		#type_update(nt, v['type'])
		v = value_cons_default(v)
		t = v['type']

	elif tu == False and vu == False:
		# type ok, value ok

		# only for case:
		# var arrayFromString: var s: []Char8 = "abc"
		if htype.type_is_open_array(t):
			length = 0
			if htype.type_is_string(v['type']):
				length = len(v['asset'])
			elif htype.type_is_array(v['type']):
				length = v['type']['volume']['asset']
			else:
				#info("???????", x['ti'])
				pass

			volume = value_integer_create(length)
			t = htype.type_array(t['of'], volume, x['ti'])
		#

		v = value_cons_implicit_check(t, v)

	elif tu == False and vu == True:
		# type ok, value undef
		# пропишем тип для v, тк там сейчас type_undefined
		v['type'] = t


	init_value = v

	var_value = value_var(id, t, id['ti'])
	cmodule_value_add(id['str'], var_value, is_public=x['access_modifier'] == 'public')

	definition['var_value'] = var_value
	definition['init_value'] = init_value
	var_value['definition'] = definition
	cdef = None
	return definition



def def_func(x, dostmt=True):
	global cdef
	global cfunc
	global cmodule

	func_id = x['id']
	log('def_func: %s' % func_id['str'])

	# значение функции уже существует, (возможно - undefined)
	# тк мы ранее сделали проход
	fn = ctx_value_get(func_id['str'])

	definition = hlir_def_func(func_id, fn, None, x['ti'])
	definition['module'] = cmodule
	definition['access_level'] = x['access_modifier']
	definition['nl'] = x['nl']
	cdef = definition

	fn['definition'] = definition

	if htype.type_is_incomplete(fn['type']):
		fn['type'] = do_type_func(x['type'])
		if htype.type_is_incomplete(fn['type']):
			return None

	if htype.type_is_bad(fn['type']):
		return None

	if x['id']['str'] != 'main':
		if need_decoration(x):
			fn['id']['prefix'] = cmodule['prefix']

	if x['stmt'] == None:
		return definition

	context_push()  # create params context

	prev_cfunc = cfunc
	cfunc = fn

	params = fn['type']['params']

	i = 0
	while i < len(params):
		param = params[i]
		param_type = param['type']
		param_id = param['id']

		param_value = value_const(param_id, param_type, None, param['ti'])
		param_value['att'].append('local')
		param_value['att'].append('param')
		ctx_value_add(param_id['str'], param_value)
		i += 1

	# for C backend, for #include <stdarg.h>
	if fn['type']['extra_args']:
		if not 'use_va_arg' in cmodule['att']:
			cmodule['att'].append('use_va_arg')

	# check unuse
	for param in params:
		check_unuse(param)

	stmt = None

	if dostmt:
		if x['stmt'] != None:
			stmt = do_stmt_block(x['stmt'])
			check_block(stmt)

			# check if return present
			if not htype.type_is_unit(fn['type']['to']):
				stmts = stmt['stmts']
				if len(stmts) == 0:
					warning("expected return operator at end", stmt['ti'])
				elif stmts[-1]['kind'] != 'return':
					warning("expected return operator at end", stmt['ti'])

	definition['stmt'] = stmt

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

	id_str = v['id']['str']
	info("value '%s' defined but not used" % id_str, v['ti'])



# check block for unused vars
def check_block(block):
	for stmt in block['stmts']:
		check_stmt(stmt)



def check_stmt(stmt):
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



def do_comment(x):
	if x['kind'] == 'line':
		return comm_line(x)
	elif x['kind'] == 'block':
		return comm_block(x)
	return None


def comm_line(x):
	return {
		'isa': 'comment',
		'kind': 'line',
		'lines': x['lines'],
		'nl': 1,
		'att': [],
		'ti': x['ti']
	}


def comm_block(x):
	return {
		'isa': 'comment',
		'kind': 'block',
		'text': x['text'],
		'nl': 1,
		'att': [],
		'ti': x['ti']
	}



# пропускать остальные ветви (elseif & else) условной директивы
# тк основная ветвь была выполнена
skipp = False
prev_skipp = False

def do_attribute(x):
	global skipp, prev_skipp, production, prev_production
	kind = x['kind']
	args = x['args']

	#info("do_attribute('%s')" % kind, x['ti'])

	if kind == 'attribute':
		attribute_add(args[0]['str'])
	elif kind == 'property':
		property_add(args[0]['str'], args[1]['str'])
	elif kind == 'inline':
		attribute_add('static')
		attribute_add('inline')
	elif kind == 'extern':
		attribute_add('extern')
	elif kind == 'packed':
		attribute_add('type:packed')
		# так делать вообще-то нельзя, но пока делаю так
		attribute_add('original_type:packed')
	elif kind == 'unused_result':
		attribute_add("value.type.to:dispensable")
	else:
		attribute_add(kind)

	return None



def do_import(x):
	global modules
	global cmodule

	import_expr = do_value_immediate_string(x['expr'])

	if value_is_bad(import_expr):
		return None

	# Literal string to python string
	impline = import_expr['asset']
	abspath = import_abspath(impline, ext='.m')

	log('do_import("%s")' % impline)

	if abspath == None:
		error("module %s not found" % impline, import_expr)
		return None

	m = None

	# Seek in global modules pool
	if abspath in modules:
		m = modules[abspath]

	if m == None:
		m = translate(abspath, nodef=not x['include'])
		modules[abspath] = m

		#if 'as' in x:
		#	m['id'] = x['as']['str'] # todo
		m['id'] = impline.split("/")[-1]

		#print("IMP_ID = " + impline)

		if m == None:
			fatal("cannot import module")

		if 'c_no_print' in m['att']:
			for xx in m['defs']:
				xx['att'].append('c_no_print')


	if not x['include']:
		m_id = '<$>'
		if x['as'] != None:
			m_id = x['as']['str']
		else:
			m_id = m['id']
		cmodule['imports'][m_id] = m
	else:
		# INCLUDE
		# забираем публичные символы
		# и забираем все определения (исключая дубликаты!)
		if x['access_modifier']:
			# public include
			cmodule['symtab_public'].extend(m['symtab_public'])

			# копируем все c_include из импортированного модуля себе
			# это костыль, но пока так
			for private_def in m['defs']:
				if private_def['isa'] == 'directive':
					if private_def['kind'] == 'c_include':
						module_append(private_def)

		cmodule['included_modules'].append(m)

	y = import_directive(impline, x['ti'], include=x['include'])
	y['import_module'] = m
	return y



def do_directive(x):
	#info("directive %s" % x['kind'], x['ti'])
	global cmodule
	if x['kind'] == 'pragma':
		args = x['args']
		s0 = args[0]
		if s0 == 'do_not_include':
			cmodule['att'].append('do_not_include')
		elif s0 == 'module_nodecorate':
			cmodule['att'].append('module_nodecorate')
		elif s0 == 'c_include':
			return c_include(args[1])
		elif s0 == 'c_no_print':
			cmodule['att'].append('c_no_print')
		elif s0 == 'feature':
			feature_add(args[0])
		elif s0 == 'unsafe':
			feature_add('unsafe')
		#elif s0 == 'noprefix':
		#	feature_add('noprefix')
			pass
	return None


	"""if kind == 'if':
		prev_production = production
		c = do_value_immediate(args[0])

		if value_is_bad(c):
			return None

		if not htype.type_is_bool(c['type']):
			error("expected bool value", c)
			return None

		cond = c['asset'] != 0

		production = cond
		if cond:
			prev_skipp = skipp
			skipp = True  # skip another branches

	elif kind == 'elseif':
		production = False
		c = do_value_immediate(args[0])

		if value_is_bad(c):
			return None

		if not htype.type_is_bool(c['type']):
			error("expected bool value", c)
			return None

		cond = c['asset'] != 0

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

		if value_is_bad(v):
			fatal("unsuitable value", x['ti'])

		msg = v['asset']
		info(msg, x['ti'])

	elif kind == 'warning':
		v = do_value_immediate_string(args[0])

		if value_is_bad(v):
			fatal("unsuitable value", x['ti'])

		msg = v['asset']
		warning(msg, x['ti'])

	elif kind == 'error':
		v = do_value_immediate_string(args[0])

		if value_is_bad(v):
			fatal("unsuitable value", x['ti'])

		msg = v['asset']
		error(msg, x['ti'])
		exit(-1)

	elif kind == 'undef':
		v = do_value_immediate_string(args[0])
		if value_is_bad(v):
			fatal("unsuitable value", x['ti'])
		id_str = v['asset']
		cmodule['symtab_public'].value_undef(id_str)
		cmodule['symtab_public'].type_undef(id_str)

	el"""


def import_directive(impline, ti, include=False):
	imp = {
		'isa': 'directive',
		'kind': 'import',
		'include': include,
		'str': impline,
		'import_module': None,
		'att': [],
		'nl': 1,
		'ti': ti,
	}
	return imp



def translate(abspath, nodef=False):
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
		m = process_module(idStr, ast, nodef=nodef)
		m['prefix'] = m['id']
		m['source_abspath'] = abspath

	env_current_file_dir = prev_env_current_file_dir

	log_pop()
	log("<<<< END-TRANSLATE(\"%s\")\n" % abspath)
	return m



def process_module(idStr, ast, nodef=False):
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

	cmodule = {
		'isa': 'module',
		
		'ast': ast,

		# defined after
		'id': idStr,
		'prefix': None,

		'strings': [],    # for LLVM backend
		'records': [],    # for C backend
		'anon_recs': [],  # anonymous records for C backend

		'imports': {},    # '<import_id>' => {'isa': 'module'}
		'included_modules': [],

		'symtab_public': symtab_public,
		'symtab_private': symtab_private,

		'defs': [],

		'att': []
 	}

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


	pre_def(ast, fdecl=nodef)  # process in normal mode

	m = cmodule

	cmodule = prev_module
	context = prev_context

	return m



def update_func_type(idStr):
	#print("update_func_type(%s)" % idStr)

	for x in cmodule['ast']:
		y = None
		if x['isa'] != 'ast_definition':
			continue
		if x['kind'] != 'func':
			continue
		if x['id']['str'] != idStr:
			continue

		fn = ctx_value_get(idStr)

		ftype = do_type_func(x['type'])
		type_update(fn['type'], ftype)
		return fn



def pre_def(ast, fdecl=False):
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
				t = htype.type_undefined(x['ti'])
				cmodule_type_add(id['str'], t, is_public=is_public)

			elif kind == 'func':
				# Create incomplete function value

				#type_func incomplete!
				f_to = htype.type_undefined(x['ti'])
				t = htype.type_func([], f_to, False, x['ti'])
				t['att'].append('incomplete')
				#t = htype.type_undefined(x['ti'])
				v = value_func(x['id'], t, x['ti'])
				# And bound it with the id
				cmodule_value_add(id['str'], v, is_public=is_public)


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
				module_append(y, to_export=x['access_modifier'] == 'public')
		elif isa == 'ast_comment':
			comment = do_comment(x)
			module_append(comment)

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



def set_att(obj, path, att):
	if len(path) == 1:
		p = path[0]
		if p in obj:
			obj[p]['att'].append(att)
		else:
			error("attribute error: field '%s' not found" % p, obj['ti'])
			for field in obj:
				print("-- " + str(field))

	elif len(path) > 1:
		set_att(obj[path[0]], path[1:], att)

	else:
		assert(False)


# directive '@attribute'
def add_attributes(obj):
	atts = attributes_get()
	for att in atts:
		lr = att.split(":")
		if len(lr) == 1:
			att = lr[0]
			obj['att'].append(att)
		elif len(lr) > 1:
			att = lr[1]
			path = lr[0].split(".")
			#print([path, att])
			set_att(obj, path, att)



def set_prop(obj, path, val):
	if len(path) == 1:
		f = path[0]
		obj[f] = val

	elif len(path) > 1:
		if path[0] in obj:
			set_prop(obj[path[0]], path[1:], val)
		else:
			error("property error: field '%s' not found" % path[0], obj['ti'])

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
		arg_type = arg['type']

		if value_is_bad(arg):
			i += 1
			continue

		spec = specs[i]

		if expected_pointers:
			if not htype.type_is_pointer(arg_type):
				warning("expected pointer", arg)
				i += 1
				continue

			arg_type = arg_type['to']


		if spec in ['i', 'd']:
			if htype.type_is_integer(arg_type):
				if not htype.type_is_signed(arg_type):
					warning("expected signed integer value", arg)
			else:
				warning("expected integer value2", arg)

		elif spec == 'x':
			if not htype.type_is_integer(arg_type):
				warning("expected integer value3", arg)

		elif spec == 'u':
			if htype.type_is_integer(arg_type):
				if htype.type_is_signed(arg_type):
					warning("expected unsigned integer value", arg)
			else:
				warning("expected integer value4", arg)

		elif spec == 's':
			if not htype.type_is_pointer_to_array_of_char(arg_type):
				warning("expected pointer to string", arg)

		elif spec == 'f':
			if not htype.type_is_float(arg_type):
				warning("expected float value", arg)

		elif spec == 'c':
			if not htype.type_is_char(arg_type):
				warning("expected char value", arg)

		elif spec == 'p':
			if not htype.type_is_pointer(arg_type):
				warning("expected pointer value", arg)

		i += 1
	return



def cp_immediate(to, _from):
	if 'asset' in _from:
		to['asset'] = _from['asset']
	if 'items' in _from:
		to['items'] = _from['items']

	to['immediate'] = _from['immediate']
	to['immutable'] = _from['immutable']
	return


