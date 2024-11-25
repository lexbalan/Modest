
import os

from error import *

from lexer import CmLexer
from parser import Parser

from util import get_item_with_id
from main import settings
from hlir.type import select_common_type
from hlir.hlir import hlir_initializer

import foundation

from value.bool import value_bool_create
from value.integer import value_integer_create
from value.float import value_float_create
from value.array import value_array_create
from value.string import value_string_create
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

	if to_export:
		cmodule['defs_public'].append(definition)
	else:
		#print("module %s append %s" % (module['id'], definition['isa']))
		cmodule['defs_private'].append(definition)

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

	hlir_init()

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

	root_symtab.type_add('VA_List', foundation.typeVA_List)



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
	typeSysStr = hlir_type.hlir_type_pointer(hlir_type.hlir_type_array(typeSysChar))

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


	"""import platform
	__platformSystem = value_string_create(platform.system())
	root_symtab.value_add('__platformSystem', __platformSystem)
	__platformRelease = value_string_create(platform.release())
	root_symtab.value_add('__platformRelease', __platformRelease)

	target_system_initializers = [
		hlir_initializer(hlir_id('name'), compilerName),
		hlir_initializer(hlir_id('version'), compilerVersion),
	]
	target_system = value_record_create(target_system_initializers)
	"""

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

	nl = 1
	if 'nl' in x:
		nl = x['nl']
	f['nl'] = nl

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
			tx = hlir_type.hlir_type_bad(t)
			return tx

	else:
		tx = ctx_type_get(id_str)

	if tx == None:
		predefinition(id)
		tx = ctx_type_get(id_str)
		if tx != None:
			return tx

		error("undeclared type '%s'" % id_str, t['ti'])
		# create fake alias for unknown type
		tx = hlir_type.hlir_type_bad(t)
		root_symtab.type_add(id_str, tx)
	return tx



def do_type_pointer(t):
	to = do_type(t['to'])
	return hlir_type.hlir_type_pointer(to, ti=t['ti'])


def do_type_array(t):
	of = do_type(t['of'])

	volume_expr = None
	if t['size'] != None:
		#volume_expr = do_value_immediate(t['size'])
		volume_expr = do_value(t['size'])
		if value_is_bad(volume_expr):
			return hlir_type.hlir_type_array(of, volume=None, ti=t['ti'])

		if not hlir_type.type_is_integer(volume_expr['type']):
			volume_expr = None
			error("required value with integer type", t['size']['ti'])

		elif not value_is_immediate(volume_expr):
			info("VLA", t['ti'])
			volume_expr = None
			#print(volume_expr['isa'])
			#print(volume_expr['kind'])
			if is_local_context():
				global cfunc
				cfunc['att'].append('stacksave')
			else:
				error("non local VLA", t['size'])

	# closed arrays of closed arrays are denied NOW
	if volume_expr != None:
		if hlir_type.type_is_closed_array(of):
			error("closed arrays of closed arrays are denied", t['ti'])
			return hlir_type.hlir_type_bad(t)

	return hlir_type.hlir_type_array(of, volume=volume_expr, ti=t['ti'])



#exclude_record = []

anon_rec_cnt = 0
def do_type_record(x):
	global anon_rec_cnt
	fields = []

	for field in x['fields']:
		f = do_field(field)

		# redefinition?
		field_id_str = f['id']['str']
		field_already_exist = get_item_with_id(fields, field_id_str)
		if field_already_exist != None:
			error("redefinition of '%s' field" % field_id_str, field['ti'])
			continue

		if 'comments' in field:
			f.update({'comments': field['comments']})

		fields.append(f)

	anon_rec_cnt = anon_rec_cnt + 1
	rec = hlir_type.hlir_type_record(fields, ti=x['ti'])
	rec['end_nl'] = x['end_nl']
	# add anon record (before)

	anon_tag = '__anonymous_struct_%d' % anon_rec_cnt
	rec['c_anon_id'] = anon_tag

	#rec['att'].append('anonymous_record') # remove this!
	cmodule['anon_recs'].append(rec)
	return rec


def do_type_enum(t):
	enum_type = hlir_type.hlir_type_enum(t['ti'])

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
		item_val = value_terminal(enum_type, i, item['ti'])

		item_val['id'] = id
		global cmodule
		module_value_add_public(cmodule, id['str'], item_val)

		i = i + 1

	return enum_type



def do_type_func(t, func_id="_"):
	# check params
	#var_args = False
	#va_list_id = None
	params = []
	for _param in t['params']:
		param = do_field(_param)

		if param == None:
			continue

		pt = param['type']

		#if var_args:
		#	error("VA_List must be last paramter", _param)

		#if hlir_type.type_is_va_list(pt):
		#	var_args = True
		#	va_list_id = param['id']
		#	continue

		if hlir_type.type_is_array(pt):
			#info("array as function parameter", _param)
			nt = hlir_type.type_copy(pt)
			pt['att'].append('wrapped_array_type')
			pt['wrapped_id'] = 'struct ' + func_id + '_' + param['id']['str']
			param['type'] = pt

		params.append(param)


	to = foundation.typeUnit
	if t['to'] != None:
		to = do_type(t['to'])

		if hlir_type.type_is_array(to):
			#info("array as function return value", t['to'])
			to = hlir_type.type_copy(to)
			to['att'].append('wrapped_array_type')
			to['wrapped_id'] = 'struct ' + func_id + '_' + 'retval'

	return hlir_type.hlir_type_func(params, to, t['arghack'], '_', ti=t['ti'])



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
	else: t = bad_type(x['ti'])

	t['ti'] = x['ti']

	return t


#
# Do Statement
#

def do_value_shift(x):
	op = x['kind']  # 'shl', 'shr'
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])

	if not hlir_type.type_is_word(l['type']):
		error("expected word value", x['left'])

	if not hlir_type.type_is_integer(r['type']):
		error("expected integer value", x['right'])

	if value_is_immediate(l) and value_is_immediate(r):
		return bin_imm(op, l['type'], l, r, x['ti'])

	if hlir_type.type_is_generic(l['type']):
		error("expected non-generic value", l)
		return value_bad(x)

	return value_bin(op, l, r, l['type'], ti=x['ti'])



def bin_imm(op, type_result, l, r, ti):
	ops = {
		'logic_or': lambda a, b: a or b,
		'logic_and': lambda a, b: a and b,
		'or': lambda a, b: a | b,
		'and': lambda a, b: a & b,
		'xor': lambda a, b: a ^ b,
		'eq': lambda a, b: a == b,
		'ne': lambda a, b: a != b,
		'lt': lambda a, b: a < b,
		'gt': lambda a, b: a > b,
		'le': lambda a, b: a <= b,
		'ge': lambda a, b: a >= b,
		'add': lambda a, b: a + b,
		'sub': lambda a, b: a - b,
		'mul': lambda a, b: a * b,
		'div': lambda a, b: a / b,
		'rem': lambda a, b: a % b,
		'shl': lambda a, b: a << b,
		'shr': lambda a, b: a >> b,
	}

	asset = 0
	items = []
	if hlir_type.type_is_array(l['type']):
		if op == 'add':
			items = l['items'] + r['items']
			length = len(items)
			str_array_volume = value_integer_create(length)
			item_type = select_common_type(l['type']['of'], r['type']['of'])

			from value.cons import implicit_cast_list
			# неявно приводим все элементы к общему типу
			items = implicit_cast_list(items, item_type)

			assert(item_type != None)
			type_result = hlir_type.hlir_type_array(item_type, volume=str_array_volume, ti=ti)
			type_result['generic'] = True  # FIXIT!

		elif op in ['eq', 'ne']:
			asset = value_eq_arrays(l, r, ti)
			if op == 'ne':
				asset = not asset


	elif hlir_type.type_is_string(l['type']):
		if op == 'add':
			asset = l['asset'] + r['asset']
			max_char_width = max(l['type']['width'], r['type']['width'])
			type_result = hlir_type.hlir_type_string(max_char_width, len(asset), ti)
		elif op in ['eq', 'ne']:
			asset = l['asset'] == r['asset']
			if op == 'ne':
				asset = not asset

		if hlir_type.type_is_array(l['type']):
			info("eq_arrays", ti)


	elif hlir_type.type_is_record(l['type']):
		if op in ['eq', 'ne']:
			info("eq_records", ti)
			asset = value_eq_records(l, r, ti)
			if op == 'ne':
				asset = not asset

	else:
		asset = ops[op](l['asset'], r['asset'])


	if hlir_type.type_is_generic(type_result) and not hlir_type.type_is_float(type_result) and not hlir_type.type_is_string(type_result) and not hlir_type.type_is_array(type_result):
		# (для операций типа 1 + 2)
		# Пересматриваем generic тип для нового значения
		type_result = hlir_type.hlir_type_generic_int_for(asset, signed=False, ti=ti)

	if hlir_type.type_is_integer(l['type']):
		asset = int(asset)

	nv = value_bin(op, l, r, type_result, ti=ti)
	nv['asset'] = asset
	if items != []:
		nv['items'] = items

	nv['immediate'] = True
	return nv



def value_eq_immediate(a, b, ti):
	if isinstance(a, dict) and isinstance(b, dict):
		if not hlir_type.type_eq(a['type'], b['type']):
			return False

		# eq composite values
		if hlir_type.type_is_array(a['type']):
			return value_eq_arrays(a, b, ti)
		elif hlir_type.type_is_record(a['type']):
			return value_eq_records(a, b, ti)

	return a['asset'] == b['asset']


# FIXIT: it is generic arrays EQ!
def value_eq_arrays(a, b, ti):
	#info("value_eq_arrays", ti)
	avolume = a['type']['volume']
	bvolume = b['type']['volume']
	if value_is_immediate(avolume) and value_is_immediate(bvolume):
		if avolume['asset'] != bvolume['asset']:
			return False
	else:
		fatal("dynamic immediate array volume not implemented", ti)

	for ax, bx in zip(a['items'], b['items']):
		if not value_eq_immediate(ax, bx, ti):
			return False

	return True


def value_eq_records(l, r, ti):
	fatal("value_eq_records() not implemented!", ti)
	return False # TODO!



def do_value_bin(x):
	op = x['kind']
	l = do_rvalue(x['left'])
	r = do_rvalue(x['right'])
	ti = x['ti']

	if value_is_bad(l) or value_is_bad(r):
		return value_bad(x)


	if op == 'add':
		if hlir_type.type_is_array(l['type']) and 	hlir_type.type_is_array(r['type']):
			return _bin(op, None, l, r, ti)


	if op in ['eq', 'ne']:
		# можно сравнивать указатели
		if hlir_type.type_is_pointer(l['type']):
			if hlir_type.type_is_generic_pointer(l['type']):
				l = value_cons_implicit(r['type'], l)
			elif hlir_type.type_is_generic_pointer(r['type']):
				r = value_cons_implicit(l['type'], r)
			return value_bin(op, l, r, foundation.typeBool, ti)


	ct = select_common_type(l['type'], r['type'])

	if ct != None:
		l = value_cons_implicit(ct, l)
		r = value_cons_implicit(ct, r)

	# Check type is valid for the operation

	if not op in l['type']['ops']:
		error("unsuitable value type for '%s' operation" % op, l)
		return value_bad(x)

	if not op in r['type']['ops']:
		error("unsuitable value type for '%s' operation" % op, r)
		return value_bad(x)


	# types must be equal
	if not hlir_type.type_eq(l['type'], r['type'], x['ti']):
		error("different types in '%s' operation" % x['kind'], x['ti'])

		# print: @@ <left_type> & <right_type> @@
		print(color_code(CYAN), end='')
		print('@@ ', end='')
		hlir_type.type_print(l['type'])
		print(" & ", end='')
		hlir_type.type_print(r['type'])
		print(' @@', end='')
		print(color_code(ENDC), end='')
		print("\n")

		return value_bad(x)

	if hlir_type.type_eq(ct, foundation.typeBool):
		if op == 'or': op = 'logic_or'
		elif op == 'and': op = 'logic_and'

	result_type = ct
	if op in (hlir_type.EQ_OPS + hlir_type.RELATIONAL_OPS):
		result_type = foundation.typeBool

	return _bin(op, result_type, l, r, ti)




def _bin(op, type_result, l, r, ti=None):
	# if left & right are immediate, we can fold const
	# and append field ['asset'] to bin_value
	if value_is_immediate(l) and value_is_immediate(r):
		return bin_imm(op, type_result, l, r, ti)

	return value_bin(op, l, r, type_result, ti=ti)



def do_value_ref(x):
	v = do_value(x['value'])

	if value_is_bad(v):
		return v

	ti = x['ti']
	op = x['kind']
	vtype = v['type']

	if value_is_immutable(v):
		if not hlir_type.type_is_func(vtype):
			error("expected mutable value or function", v)
			return value_bad(x)

	vt = hlir_type.hlir_type_pointer(vtype, ti=ti)
	nv = value_un('ref', v, vt, ti=ti)

	# HOTFIX, BADFIX
	# считаем указатель на глоб переменную/функцию immediate значением
	if is_global_value(v):
		nv['immediate'] = True
		nv['asset'] = None
		nv['items'] = []

	return nv



def do_value_not(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']

	if not 'not' in vtype['ops']:
		error("unsuitable type", v)
		return value_bad(x)

	nv = value_un('not', v, vtype, ti=x['ti'])

	if value_is_immediate(v):
		# because: ~(1) = -1 (not 0) !
		if hlir_type.type_is_bool(vtype):
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

	if not hlir_type.type_is_signed(vtype):
		error("expected value with signed type", v)

	nv = value_un('negative', v, vtype, ti=x['ti'])

	if value_is_immediate(v):
		nv['asset'] = -v['asset']
		nv['immediate'] = True

		if hlir_type.type_is_generic(nv['type']):
			nv['type'] = hlir_type.hlir_type_generic_int_for(v['asset'], signed=True, ti=x['ti'])

	return nv



def do_value_pos(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']

	if not hlir_type.type_is_signed(vtype):
		error("expected value with signed type", v)

	nv = value_un('positive', v, vtype, ti=x['ti'])

	if value_is_immediate(v):
		nv['asset'] = +v['asset']
		nv['immediate'] = True

		if hlir_type.type_is_generic(nv['type']):
			nv['type'] = hlir_type.hlir_type_generic_int_for(v['asset'], signed=True, ti=x['ti'])

	return nv



def do_value_deref(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return v

	vtype = v['type']
	if not hlir_type.type_is_pointer(vtype):
		error("expected pointer value", v)
		return value_bad(x)

	to = vtype['to']

	# you can't deref:
	#   - pointer to Unit
	#   - pointer to function
	#   - pointer to open array
	is_func_ptr = hlir_type.type_is_func(to)
	is_free_ptr = hlir_type.type_is_free_pointer(to)
	is_open_array_ptr =  hlir_type.type_is_open_array(to)
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
				if item['id'] != None:
					if item['id']['str'] == param_id_str:
						k = i
						break
			i = i + 1

		j = 0
		if k >= 0:
			j = k

		arg = vec1[j]
		vec1.pop(j)
		#vec1[j] = None
		outvec.append(arg)

	return outvec



def do_value_lengthof_value(x):
	ti = x['ti']
	arg = do_rvalue(x['value'])

	if not hlir_type.type_is_array(arg['type']):
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
		error("undefined value 2", fn)
		return value_bad(x)


	ftype = fn['type']

	# pointer to function?
	if hlir_type.type_is_pointer(ftype):
		ftype = ftype['to']

	if not hlir_type.type_is_func(ftype):
		error("expected function or pointer to function", x)

	params = ftype['params']
	args = x['args']

	npars = len(params)
	nargs = len(args)

	if nargs < npars:
		error("not enough args", x)
		return value_bad(x)

	if nargs > npars:
		if not ftype['extra_args']:
			error("too many args", x)
			return value_bad(x)

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
		if a['id'] != None:
			tasrget_param_id_str = a['id']['str']
			if tasrget_param_id_str != param_id_str:
				error("bad parameter id", a['id']['ti'])

		arg = do_rvalue(a['value'])


		if not value_is_bad(arg):
			arg = value_cons_implicit_check(param['type'], arg)

			if not value_is_immediate(arg):
				imm_args = False

			if a['id'] != None:
				args.append(hlir_initializer(a['id'], arg))
			else:
				args.append(arg)

		i = i + 1

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
			if hlir_type.type_is_generic(argval['type']):
				warning("extra argument with generic type", a['ti'])
				argval = value_cons_default(argval)

			if not value_is_immediate(argval):
				imm_args = False

			extra_args.append(argval)

		i = i + 1


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

	#TODO: Func#pure
	#if 'pure' in fn:
	#	if f['pure'] and imm_args:
	#		rv = ct_call(rv)

	# for C backend only (maybe mv to C?)
	if hlir_type.type_is_closed_array(fn['type']['to']):
		rv['att'].append('wrapped_array')

	return rv



def do_value_index(x):
	left = do_rvalue(x['left'])

	if value_is_bad(left):
		return value_bad(x)

	left_typ = left['type']

	via_pointer = hlir_type.type_is_pointer(left_typ)

	array_typ = left_typ
	if via_pointer:
		array_typ = left_typ['to']


	if not hlir_type.type_is_array(array_typ):
		error("expected array or pointer to array", left)
		return value_bad(x)


	index = do_rvalue(x['index'])

	if value_is_bad(index):
		return value_bad(x)

	if not hlir_type.type_is_integer(index['type']):
		error("expected integer value", x['index'])
		return value_bad(x)

	if hlir_type.type_is_generic(index['type']):
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
					return value_bad(x)

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
			return value_bad(x)

	if value_is_bad(left) or value_is_bad(index_from):
		return value_bad(x)

	left_type = left['type']
	via_pointer = hlir_type.type_is_pointer(left_type)
	array_type = left_type
	if via_pointer:
		array_type = left_type['to']

	if not hlir_type.type_is_array(array_type):
		error("expected array or pointer to array", left)
		return value_bad(x)


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
				return value_bad(x)


#	if hlir_type.type_is_closed_array(array_type):
#		if slice_volume == None:
#			error("expected immediate value", index_from)
#
#		# TODO: конкретно тут есть что исправить!
#		if slice_len > array_type['volume']['asset']:
#			error("slice is too big", x['ti'])

	type = hlir_type.hlir_type_array(array_type['of'], slice_volume, x['ti'])
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
		return value_bad(x)

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
		return value_bad(x)

	field_id = x['right']

	# доступ через переменную-указатель
	via_pointer = hlir_type.type_is_pointer(left['type'])

	record_type = left['type']
	if via_pointer:
		record_type = left['type']['to']

	# check if is record
	if not hlir_type.type_is_record(record_type):
		error("expected record or pointer to record", x)
		return value_bad(x)

	field = hlir_type.record_field_get(record_type, field_id['str'])

	# if field not found
	if field == None:
		error("undefined field '%s'" % field_id['str'], x)
		return value_bad(x)

	# PROBLEM: у анонимных структур нет поля 'definition'
	# и непонятно как с этимм быть. Можно добавить module
	# в каждую сущность, но...
#	if record_type['definition']['module'] != cmodule:
#		if not 'public' in field['att']:
#			error("access to private field", x['ti'])


	if hlir_type.type_is_bad(field['type']):
		return value_bad(x)


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
			initializers = left['fields']
			initializer = get_item_with_id(initializers, field_id['str'])

			# (!) #asset of immediate index & access contains VALUE (!)
			nv['immediate'] = True
			nv['immval'] = initializer['value']
			cp_immediate(nv, initializer['value'])

	return nv



def do_value_cons(x):
	v = do_rvalue(x['value'])
	t = do_type(x['type'])
	if value_is_bad(v) or hlir_type.type_is_bad(t):
		return value_bad(x)
	return value_cons_explicit(t, v, x['ti'])



def do_value_id(x):
	id_str = x['str']
	v = ctx_value_get(id_str)

	if v == None:
		predefinition(x)
		vx = ctx_value_get(id_str)
		if vx != None:
			return vx

		error("undefined value '%s'" % id_str, x)

		# чтобы не генерил ошибки дальше
		# создадим bad value и пропишем его глобально
		v = value_bad(x)
		value_attribute_add(v, 'unknown')
		ctx_value_add(id_str, v)
		return v

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
		if item['isa'] == 'ast_comment':
			continue
		item_value = do_rvalue(item)
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
		if item['isa'] == 'ast_comment':
			continue

		item_value = do_rvalue(item['value'])
		p = hlir_initializer(
			item['id'],
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
			if hlir_type.type_is_pointer_to_array_of_char(v['type']):
				return v
		error("expected immediate value", x['ti'])
		return value_bad(x)

	return v


def do_value_immediate_string(x):
	v = do_value_immediate(x)

	if value_is_bad(v):
		return v

	if not hlir_type.type_is_string(v['type']):
		error("expected string value", x['ti'])

	return v


def do_value_unsafe(x):
	#info("do_value_unsafe", ti)
	ti = x['ti']
	# for use 'unsafe' operator
	# required -funsafe option
	from main import features
	if not features.get('unsafe'):
		error("for use 'unsafe' operator required -funsafe option", ti)

	global unsafe_mode
	prev_unsafe_mode = unsafe_mode
	unsafe_mode = True

	rv = do_rvalue(x['value'])

	unsafe_mode = prev_unsafe_mode
	return rv




def do_rvalue(x):
	v = do_value(x)
	return value_load(v)


def do_value(x):
	assert(x['isa'] == 'ast_value')

	k = x['kind']

	v = None

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
	elif k == 'negative': v = do_value_neg(x)
	elif k == 'positive': v = do_value_pos(x)
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
	elif k == 'bad': v = value_bad(x)

	assert(v != None)

	#if not 'ti' in v:
		#print("add TI to %s" % v['kind'])
	v['ti'] = x['ti']

	return v



#
# Do Statement
#

def do_stmt_if(x):
	cond = do_rvalue(x['cond'])

	if value_is_bad(cond):
		return hlir_stmt_bad(x)

	if not hlir_type.type_is_bool(cond['type']):
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

	if not hlir_type.type_is_bool(cond['type']):
		error("expected bool value", cond)
		return hlir_stmt_bad(x)


	block = do_stmt(x['stmt'])

	if hlir_stmt_is_bad(block):
		return hlir_stmt_bad(x)

	return hlir_stmt_while(cond, block, ti=x['ti'])



def do_stmt_return(x):
	global cfunc

	func_ret_type = cfunc['type']['to']

	is_no_ret_func = hlir_type.type_is_unit(func_ret_type)
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
	print("do_stmt_type\n")


def do_stmt_again(x):
	return hlir_stmt_again(x['ti'])


def do_stmt_break(x):
	return hlir_stmt_break(x['ti'])


def do_stmt_var(x):
	var_id = x['id']

	t = None
	v = None

	if x['type'] == None and x['value'] == None:
		pass # error

	if x['type'] != None:
		t = do_type(x['type'])

	v = None
	if x['value'] != None:
		v = do_rvalue(x['value'])
		if value_is_bad(v):
			v = None

	# error: no type, no init value
	if t == None and v == None:
		ctx_value_add(var_id['str'], value_bad(x))
		return hlir_stmt_bad(x)

	if t != None:
		if hlir_type.type_is_bad(t):
			ctx_value_add(var_id['str'], value_bad(x))
			return hlir_stmt_bad(x)

		if hlir_type.type_is_forbidden_var(t):
			error("unsuitable type1", x['type']['ti'])

	# type & init value present
	if t != None and v != None:
		v = value_cons_implicit_check(t, v)

	if t == None:
		if hlir_type.type_is_generic(v['type']):
			v = value_cons_default(v)

		t = v['type']

	if v == None:
		v = value_undefined(t, var_id['ti'])

	# check if identifier is free (in current block)
	already = ctx_value_get_shallow(var_id['str'])
	if already != None:
		error("local id redefinition", x['id']['ti'])
		return hlir_stmt_bad(x)

	var_value = add_local_var(var_id, t, var_id['ti'])
	return hlir_stmt_def_var(var_value, v, ti=x['ti'])



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
		ctx_value_add(id['str'], value_bad(x))
		return hlir_stmt_bad(x)

	const_value = value_const(id, v['type'], value=v, ti=x['id']['ti'])
	# не знаю правильно ли это, но перносим аттрибуты значения-инициализатора
	# на константу. Пока это необходимо для 'wrapped_array' (!)
	const_value['att'].extend(v['att'])
	const_value['att'].append('local') # need for LLVM printer (!)

	# Now let can be immediate!
	if value_is_immediate(v):
		const_value['immediate'] = True
		cp_immediate(const_value, v)

		if hlir_type.type_is_generic(v['type']):
			# generic immediate в C печатается как #define
			# и его надо манглить иначе возникает куча проблем
			const_value['id']['c'] = '__' + const_value['id']['str']

	ctx_value_add(id['str'], const_value)

	return hlir_stmt_let(id, const_value, v, ti=x['ti'])



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

	if not hlir_type.type_is_integer(v['type']):
		error("expected integer value", v)
		return hlir_stmt_bad(x)

	one = value_integer_create(1, typ=v['type'], ti=x['ti'])
	v_plus = _bin(op, v['type'], v, one, x['ti'])

	return hlir_stmt_assign(v, v_plus, ti=x['ti'])



def do_stmt_value(x):
	v = do_rvalue(x['value'])

	if value_is_bad(v):
		return hlir_stmt_bad(x)

	if not hlir_type.type_is_unit(v['type']):
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
	xargs = x['args']

	asm_text = do_rvalue(xargs[0]['value'])

	xoutputs = xargs[1]['value']
	xinputs = xargs[2]['value']
	xclobbers = xargs[3]['value']

	outputs = []
	for x in xoutputs['items']:
		items = x['items']
		spec = do_rvalue(items[0])
		val = do_rvalue(items[1])
		pair = (spec, val)
		outputs.append(pair)

	inputs = []
	for x in xinputs['items']:
		items = x['items']
		spec = do_rvalue(items[0])
		val = do_rvalue(items[1])
		pair = (spec, val)
		inputs.append(pair)

	clobbers = []
	for x in xclobbers['items']:
		spec = do_rvalue(x)
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

	if s == None:
		return hlir_stmt_bad(x)

	if 'nl' in x:
		s['nl'] = x['nl']

	return s



def do_stmt_block(x):
	#global cmodule
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
	return not is_nodecorate(x) and not ('module_nodecorate' in cmodule['att'])


def def_type(x):
	global cmodule
	id = x['id']
	log("def_type: %s" % id['str'])

	if id['str'][0].islower():
		error("type id must starts with big letter", id['ti'])

	pre_exist = ctx_type_get(id['str'])

	# check if identifier is free
	already_declared = pre_exist != None

	if already_declared:
		nt = pre_exist
		#if hlir_type.type_is_defined(pre_exist):
		#	error("redefinition of '%s'" % x['id']['str'], x['id']['ti'])
	else:
		nt = hlir_type.hlir_type_undefined(x['ti'])
		cmodule_type_add(id['str'], nt, is_public=x['access_modifier'] == 'public')

	# только теперь обрабатываем поля,
	# тк там могут быть указатели на саму себя
	# а мы к этому заранее подготовлись
	ty = do_type(x['type'])

	if hlir_type.type_is_bad(ty):
		return None

	# поскольку этот тип здесь связывается с идентификатором
	# он уже не анонимный
	if ty in cmodule['anon_recs']:
		cmodule['anon_recs'].remove(ty)

	# Замещаем внутренности undefined типа на тип справа
	# НО! имя даем новое
	nt.clear()
	nt.update(ty)
	nt['id'] = id # need for  @property("type.id.c", "int")
	nt['att'] = copy.copy(ty['att'])
	nt['ti_def'] = id['ti']
	nt['module'] = cmodule  # добавляем заново тк очистили его выше!


	if need_decoration(x):
		nt['id']['prefix'] = cmodule['prefix']

	if not ('do_not_include' in cmodule['att']):
		# В случае когда не печатаем typedef явно (!)
		# Убираем алиасы которые висели на оригинальном типе
		if 'c' in nt['id']:
			nt.pop('c')
		if 'llvm_alias' in nt['id']:
			nt.pop('llvm_alias')

	if hlir_type.type_is_record(ty):
		cmodule['records'].append(nt)

	definition = hlir_def_type(id, nt, ty, x['ti'])
	definition['module'] = cmodule
	definition['nl'] = x['nl']
	definition['access_level'] = x['access_modifier']

	nt['definition'] = definition

	return definition



def def_const(x):
	id = x['id']

	log("def_const: %s" % id['str'])

	# check if identifier is free
	pre_exist = ctx_value_get_shallow(id['str'])
	if pre_exist != None:
		error("redefinition of '%s'" % id['str'], id['ti'])

	if id['str'][0].isupper():
		error("value id must starts with small letter", id['ti'])
		pass

	init_value = do_value_immediate(x['value'], allow_ptr_to_str=True)



	if value_is_bad(init_value):
		global cmodule
		module_value_add_public(cmodule, id['str'], init_value)
		return hlir_def_const(id, init_value, init_value, x['ti'])

	if x['type'] != None:
		t = do_type(x['type'])
		if not hlir_type.type_is_bad(t):
			init_value = value_cons_implicit_check(t, init_value)


	const_value = symbol_const(id, init_value, is_public=x['access_modifier'] == 'public')

	definition = hlir_def_const(id, const_value, init_value, x['ti'])
	if need_decoration(x):
		const_value['id']['prefix'] = cmodule['prefix']
	definition['access_level'] = x['access_modifier']
	const_value['definition'] = definition
	const_value['module'] = cmodule
	definition['module'] = cmodule
	return definition



def def_var(x):
	id = x['id']
	log("def_var %s" % id['str'])

	# already defined? (check identifier)
	already = ctx_value_get(id['str'])
	if already != None:
		error("redefinition of '%s'" % id['str'], id['ti'])

	t = None
	if x['type'] != None:
		t = do_type(x['type'])
		#if hlir_type.type_is_bad(t):
		#	return None

	init_value = None
	if x['value'] != None:
		init_value = do_rvalue(x['value'])

		if t != None:
			# for case like:
			# var a: Int[] = [1, 2, 3] // -> Int[3]
			if hlir_type.type_is_open_array(t):
				length = 0
				if hlir_type.type_is_string(init_value['type']):
					length = len(init_value['asset'])
				elif hlir_type.type_is_array(init_value['type']):
					length = init_value['type']['volume']['asset']

				volume = value_integer_create(length)
				t = hlir_type.hlir_type_array(t['of'], volume, x['ti'])

			init_value = value_cons_implicit_check(t, init_value)
		else:
			init_value = value_cons_default(init_value)
			t = init_value['type']

		if hlir_type.type_is_generic(init_value['type']):
			error("cannot cons variable", x['ti'])

	var_value = value_var(id, t, id['ti'])
	cmodule_value_add(id['str'], var_value, is_public=x['access_modifier'] == 'public')

	definition = hlir_def_var(id, var_value, init_value, x['ti'])
	definition['module'] = cmodule
	var_value['definition'] = definition
	definition['access_level'] = x['access_modifier']
	return definition


def def_func(x, dostmt=True):
	global cfunc
	global cmodule

	func_id = x['id']
	log('def_func: %s' % func_id['str'])

	# значение функции уже существует, тк мы ранее сделали проход
	fn = ctx_value_get(func_id['str'])



	if x['stmt'] == None:
		#print("DECL: "+fn['id']['str'])
		definition = hlir_def_func(func_id, fn, None, x['ti'])
		definition['access_level'] = x['access_modifier']
		fn['definition'] = definition
		return definition


	context_push()  # create params context

	if hlir_type.type_is_bad(fn['type']):
		return None


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

		# for C backend only (maybe mv to C?)
		if hlir_type.type_is_closed_array(param_type):
			param_value['att'].append('wrapped_array')

		ctx_value_add(param_id['str'], param_value)
		i = i + 1

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
			if not hlir_type.type_is_unit(fn['type']['to']):
				stmts = stmt['stmts']
				if len(stmts) == 0:
					warning("expected return operator at end", stmt['ti'])
				elif stmts[-1]['kind'] != 'return':
					warning("expected return operator at end", stmt['ti'])

	context_pop()  # remove params context

	cfunc = prev_cfunc

	definition = hlir_def_func(func_id, fn, stmt, x['ti'])

	#print(x['id']['str'])
	# Префика
	"""
	y['prefix'] = ''
	if x['id']['str'] != 'main':
		if need_decoration(x):
			y['prefix'] = cmodule['prefix']
	"""

	definition['access_level'] = x['access_modifier']
	fn['definition'] = definition
	definition['module'] = cmodule
	return definition



def check_unuse(v):
	#return  # Off

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


def do_func_value(x, export):
	global cmodule
	func_id = x['id']
	func_ti = func_id['ti']
	func_type = do_type_func(x['type'], func_id=func_id['str'])
	fn = value_func(func_id, func_type, ti=func_ti)

	if func_id['str'] != 'main':
		if export:
			if need_decoration(x):
				fn['id']['prefix'] = cmodule['prefix']

	return fn





def comm_line(x):
	return {
		'isa': 'comment',
		'kind': 'line',
		'lines': x['lines'],
		'att': []
	}


def comm_block(x):
	return {
		'isa': 'comment',
		'kind': 'block',
		'text': x['text'],
		'att': []
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
		attribute_add('c_static')
		attribute_add('inline')
	elif kind == 'extern':
		attribute_add('c_extern')
	elif kind == 'packed':
		attribute_add('type:packed')
		# так делать вообще-то нельзя, но пока делаю так
		attribute_add('original_type:packed')
	elif kind == 'unused_result':
		attribute_add("value.type.to:dispensable")
	else:
		attribute_add(kind)

	return None



# находит сущность по имени и определяет ее
def predefinition(id):
	id_str = id['str']
	print("predefinition(\"%s\")" % id_str)
	global cmodule
	y = None

	found = False
	for x in cmodule['ast']:
		if not 'id' in x:
			continue

		if x['id']['str'] == id_str:
			kind = x['kind']
			if kind == 'type':
				found = True
				y = def_type(x)
			elif kind == 'const':
				found = True
				y = def_const(x)
			elif kind == 'func':
				found = True
				fn = do_func_value(x, x['access_modifier'] == 'public')
				cmodule_value_add(fn['id']['str'], fn, is_public=x['access_modifier'] == 'public')

			x['defined'] = True  # mark as DEFINED

			if y != None:
				module_append(y, to_export=x['access_modifier'] == 'public')
	if not found:
		error("unknown identifier '%s'" % id['str'], id['ti'])
	#return y


"""# расширить текущий модуль определениями
def cmodule_extend(y, do_not_def):
	global cmodule
	cmodule['symtab_public'].extend(y['symtab_public'])
	cmodule['symtab_private'].extend(y['symtab_private'])

	if not do_not_def:
		cmodule['defs_private'].extend(y['defs_private'])
		cmodule['defs_public'].extend(y['defs_public'])
"""

def do_import(x):
	global modules
	global cmodule

	import_expr = do_value_immediate_string(x['expr'])

	if value_is_bad(import_expr):
		return None

	# Literal string to python string
	impline = import_expr['asset']

	#print('do_import("%s")' % impline)
	log('do_import("%s")' % impline)

	abspath = import_abspath(impline, ext='.m')

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
			for xx in m['defs_private']:
				xx['att'].append('c_no_print')
			for xx in m['defs_public']:
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
			for private_def in m['defs_private']:
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
			pass
	return None


	"""if kind == 'if':
		prev_production = production
		c = do_value_immediate(args[0])

		if value_is_bad(c):
			return None

		if not hlir_type.type_is_bool(c['type']):
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

		if not hlir_type.type_is_bool(c['type']):
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
		m = process_module(ast, nodef=nodef)
		m['id'] = abspath.split('/')[-1][:-2]
		m['prefix'] = m['id']
		m['source_abspath'] = abspath

	env_current_file_dir = prev_env_current_file_dir

	log_pop()
	log("<<<< END-TRANSLATE(\"%s\")\n" % abspath)
	return m




def process_module(ast, nodef=False):
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
		'id': '<moduleId>',
		'prefix': None,

		'strings': [],    # for LLVM backend
		'records': [],    # for C backend
		'anon_recs': [],  # anonymous records for C backend

		'imports': {},    # '<import_id>' => {'isa': 'module'}
		'included_modules': [],

		'symtab_public': symtab_public,
		'symtab_private': symtab_private,

		'defs_private': [],
		'defs_public': [],

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


	pre_def(ast, fdecl=nodef)    # process in normal mode

	m = cmodule

	cmodule = prev_module
	context = prev_context

	return m



# создает символы для всех функций в модуле
# если они имеют неизвестную зависимость -
# удовлетворяет ее посредством predefinition(id_str)
def pre_def(ast, fdecl=False):
	global cmodule

	# 1. def types
	# (and const if need for type!)
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if isa == 'ast_definition':
			if kind == 'type':
				if not 'defined' in x:
					y = def_type(x)

					add_spices(y, ast_atts=x['attributes'])
					module_append(y, to_export=x['access_modifier'] == 'public')

	# 2. def vars & consts
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if isa == 'ast_definition':
			y = None
			if kind == 'const':
				if not 'defined' in x:
					y = def_const(x)

			elif kind == 'var':
				y = def_var(x)

			if y != None:
				add_spices(y, ast_atts=x['attributes'])
			module_append(y, to_export=x['access_modifier'] == 'public')


	# 3. scan funcs
	for x in ast:
		isa = x['isa']
		kind = x['kind']

		if kind == 'func':
			fn = ctx_value_get(x['id']['str'])
			if fn == None:
				fn = do_func_value(x, x['access_modifier'] == 'public')
				cmodule_value_add(fn['id']['str'], fn, is_public=x['access_modifier'] == 'public')


	# 4. def funcs
	for x in ast:
		isa = x['isa']
		kind = x['kind']
		if isa == 'ast_definition':
			if kind == 'func':
				y = def_func(x, dostmt=not fdecl)


				if y != None:
					add_spices(y, ast_atts=x['attributes'])
					module_append(y, to_export=x['access_modifier'] == 'public')

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
			i = i + 1
			c = s[i]
			specs.append(c)
		i = i + 1
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
			i = i + 1
			continue

		spec = specs[i]

		if expected_pointers:
			if not hlir_type.type_is_pointer(arg_type):
				warning("expected pointer", arg)
				i = i + 1
				continue

			arg_type = arg_type['to']


		if spec in ['i', 'd']:
			if hlir_type.type_is_integer(arg_type):
				if not hlir_type.type_is_signed(arg_type):
					warning("expected signed integer value", arg)
			else:
				warning("expected integer value2", arg)

		elif spec == 'x':
			if not hlir_type.type_is_integer(arg_type):
				warning("expected integer value3", arg)

		elif spec == 'u':
			if hlir_type.type_is_integer(arg_type):
				if hlir_type.type_is_signed(arg_type):
					warning("expected unsigned integer value", arg)
			else:
				warning("expected integer value4", arg)

		elif spec == 's':
			if not hlir_type.type_is_pointer_to_array_of_char(arg_type):
				warning("expected pointer to string", arg)

		elif spec == 'f':
			if not hlir_type.type_is_float(arg_type):
				warning("expected float value", arg)

		elif spec == 'c':
			if not hlir_type.type_is_char(arg_type):
				warning("expected char value", arg)

		elif spec == 'p':
			if not hlir_type.type_is_pointer(arg_type):
				warning("expected pointer value", arg)

		i = i + 1
	return



def cp_immediate(to, _from):
	if 'asset' in _from:
		to['asset'] = _from['asset']
	if 'items' in _from:
		to['items'] = _from['items']
	if 'fields' in _from:
		to['fields'] = _from['fields']

	to['immediate'] = _from['immediate']
	to['immutable'] = _from['immutable']
	return



"""
# удаляет hlir_node по isa & id_str
def module_remove_node(m, isa, id_str):
	#print(f"module_remove_node: {id_str}")

	for submodule in m['imports']:
		module_remove_node(submodule, isa, id_str)

	for x in m['defs_private']:
		if x['isa'] == isa:
			if 'id' in x:
				if x['id']['str'] == id_str:
					#print("REMOVE: " + id_str)
					m['defs_private'].remove(x)
					break
	return

"""
