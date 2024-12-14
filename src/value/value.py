import copy
from error import info, warning, error
from hlir.id import hlir_id
from hlir.hlir import *
from util import get_item_with_id
import type as htype


def value_is_bad(x):
	return x['kind'] == 'bad'

def value_is_undefined(x):
	return x['kind'] == 'undefined'

def value_is_incomplete(x):
	return htype.type_is_incomplete(x['type'])

def value_is_immediate(x):
	return x['immediate']

def value_is_param(x):
	return 'param' in x['att']

# Any immediate value are immutable,
# but not any immutable value are immediate
def value_is_immutable(x):
	return x['immutable']


def value_is_lvalue(x):
	return x['kind'] in ['var', 'access', 'index', 'slice', 'deref']


def value_is_generic_immediate(x):
	return value_is_immediate(x) and htype.type_is_generic(x['type'])


def _value_is_zero_array(x):
	if not value_is_immediate(x):
		return False
	for item in x['items']:
		if not value_is_zero(item):
			return False
	return True


def _value_is_zero_record(x):
	if not value_is_immediate(x):
		return False
	for item in x['fields']:
		if not value_is_zero(item['value']):
			return False
	return True


# Only for immediate value (!)
def value_is_zero(x):
	if not value_is_immediate(x):
		return False

	if htype.type_is_array(x['type']):
		return _value_is_zero_array(x)
	if htype.type_is_record(x['type']):
		return _value_is_zero_record(x)

	return x['asset'] == 0



def value_attribute_add(v, a):
	v['att'].append(a)


def value_attribute_check(v, a):
	return a in v['att']



def value_load(x):
	"""if x['kind'] == 'var':
		x['att'].append('load')
		pass
	elif x['kind'] == 'index':
		x['att'].append('load')
		pass
	elif x['kind'] == 'access':
		x['att'].append('load')
		pass
	elif x['kind'] == 'deref':
		x['att'].append('load')
		pass"""

	return x




def value_bad(ti):
	return {
		'isa': 'value',
		'kind': 'bad',
		'id': hlir_id('_', ti=ti),
		'type': htype.type_bad({'ti': ti}),
		'immutable': False,
		'immediate': False,
		'att': [],
		'ti': ti
	}


# его получают по умолчанию локальные переменные
# в случае если не указан инициализатор
def value_undefined(t, ti):
	return {
		'isa': 'value',
		'kind': 'undefined',
		'type': t,

		'immutable': True,
		'immediate': True,

		'items': [],
		'fields': [],
		'asset': 0,  # generic string also goes here  (!)

		'att': [],
		'nl_end': 0,
		'nl': 0,
		'ti': ti
	}


def value_terminal(t, ti):
	v = value_undefined(t, ti)
	v['kind'] = 'literal'
	v['immutable'] = True
	v['immediate'] = True
	return v



def value_zero(t, ti):
	nv = value_terminal(t, ti)

	if htype.type_is_array(t):
		nv['items'] = []
	elif htype.type_is_record(t):
		nv['fields'] = []
	else:
		nv['asset'] = 0

	return nv




def value_var(id, type, ti):
	return {
		'isa': 'value',
		'kind': 'var',
		'id': id,
		'type': type,
		'usecnt': 0,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti_decl': ti,
	}


# hlir_const is an immutable value
# (not necessary immediate)
def value_const(id, type, value, ti):
	return {
		'isa': 'value',
		'kind': 'const',
		'id': id,
		'type': type,
		'value': value,
		'usecnt': 0,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti_def': ti,
	}


def value_func(id, type, ti):
	return {
		'isa': 'value',
		'kind': 'func',
		'id': id,
		'type': type,
		'usecnt': 0,
		'immediate': False,
		'immutable': True,
		'pure': True,
		'att': [],
		'deps': [],
		'ti_def': ti,
	}


def value_un(k, value, type, ti):
	return {
		'isa': 'value',
		'kind': k,
		'value': value,
		'type': type,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti': ti
	}


def value_bin(op, l, r, t, ti):
	return {
		'isa': 'value',
		'kind': op,
		'left': l,
		'right': r,
		'type': t,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti': ti
	}


def value_call(func, rettype, args, ti):
	return {
		'isa': 'value',
		'kind': 'call',
		'func': func,
		'args': args,
		'type': rettype,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti': ti
	}


def value_index_array(array, type, index, ti):
	return {
		'isa': 'value',
		'kind': 'index',
		'array': array,
		'index': index,
		'type': type,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti': ti
	}




def value_slice_array(left, type, index_from, index_to, ti):
	return {
		'isa': 'value',
		'kind': 'slice',
		'left': left,
		'index_from': index_from,
		'index_to': index_to,
		'type': type,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti': ti
	}


def value_access_module(type, left, right, value, ti):
	return {
		'isa': 'value',
		'kind': 'access_module',
		'left': left,
		'right': right,
		'value': value,
		'type': type,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti': ti
	}


def value_access_record(type, record, field, ti):
	return {
		'isa': 'value',
		'kind': 'access',
		'record': record,
		'field': field,
		'type': type,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti': ti
	}


def value_cons_node(type, value, method, ti):
	assert(method in ['implicit', 'explicit', 'unsafe'])
	assert(value['isa'] == 'value')
	assert(type['isa'] == 'type')
	nv = {
		'isa': 'value',
		'kind': 'cons',
		'value': value,
		'type': type,
		'immediate': False,
		'immutable': True,
		'att': [],
		'method': method,
		'ti': ti
	}

	if 'nl_end' in value:
		nv['nl_end'] = value['nl_end']

	return nv



# cons immediate такой же cons
# но поскольку у него value immediate, мы можем его asset
# привести и взять себе; Таким образом мы идем как литерал нода
# и в то же время как cons нода
def value_cons_immediate(t, v, method, ti):
	assert(method in ['implicit', 'explicit', 'unsafe'])
	nv = value_cons_node(t, v, method, ti)

	nv['kind'] = 'cons'
	nv['asset'] = v['asset']
	nv['immediate'] = True

	if 'hexadecimal' in v['att']:
		nv['att'].append('hexadecimal')

	if 'nl_end' in v:
		nv['nl_end'] = v['nl_end']

	return nv



def value_sizeof_type(of, ti):
	size = htype.type_get_size(of)
	type = htype.type_generic_int_for(size, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'sizeof_type',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': size,
		'att': [],
		'ti': ti
	}

def value_sizeof_value(of, ti):
	size = htype.type_get_size(of['type'])
	type = htype.type_generic_int_for(size, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'sizeof_value',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': size,
		'att': [],
		'ti': ti
	}


def value_alignof(of, ti):
	align = htype.type_get_align(of)
	type = htype.type_generic_int_for(align, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'alignof',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': align,
		'att': [],
		'ti': ti
	}


def value_offsetof(of, field_id, ti):
	field = htype.record_field_get(of, field_id['str'])
	if field == None:
		error("undefined field '%s'" % field_id['str'], field_id['ti'])
		return value_bad({'ti': ti})

	offset = field['offset']
	type = htype.type_generic_int_for(offset, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'offsetof',
		'of': of,
		'field': field_id,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': offset,
		'att': [],
		'ti': ti
	}


def value_lengthof(value, ti):
	length = value['type']['volume']['asset']
	type = htype.type_generic_int_for(length, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'lengthof',
		'value': value,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': length,
		'att': [],
		'ti': ti
	}


def value_va_start(va_list, last_param, ti):
	from foundation import typeUnit
	return {
		'isa': 'value',
		'kind': 'va_start',
		'va_list': va_list,
		'last_param': last_param,
		'type': typeUnit,
		'immutable': True,
		'immediate': True,
		'asset': 0,
		'att': [],
		'ti': ti
	}

def value_va_arg(va_list, type, ti):
	return {
		'isa': 'value',
		'kind': 'va_arg',
		'va_list': va_list,
		'type': type,
		'immutable': True,
		'immediate': False,
		'asset': 0,
		'att': [],
		'ti': ti
	}

def value_va_end(va_list, ti):
	from foundation import typeUnit
	return {
		'isa': 'value',
		'kind': 'va_end',
		'va_list': va_list,
		'type': typeUnit,
		'immutable': True,
		'immediate': True,
		'asset': 0,
		'att': [],
		'ti': ti
	}


def value_va_copy(dst, src, ti):
	from foundation import typeUnit
	return {
		'isa': 'value',
		'kind': 'va_copy',
		'src': src,
		'dst': dst,
		'type': typeUnit,
		'immutable': True,
		'immediate': True,
		'asset': 0,
		'att': [],
		'ti': ti
	}



def value_scalar_eq(l, r, op, ti):
	from foundation import typeBool
	nv = value_bin(op, l, r, typeBool, ti=ti)

	if value_is_immediate(l) and value_is_immediate(r):
		eq_result = False
		if op == 'eq':
			eq_result = l['asset'] == r['asset']
		else:
			eq_result = l['asset'] != r['asset']

		nv['asset'] = int(eq_result)
		nv['immediate'] = True

	return nv



# op = 'eq' | 'ne
def value_eq(l, r, op, ti):
	assert(l['isa'] == 'value')
	assert(r['isa'] == 'value')
	assert(op in ['eq', 'ne'])

	if htype.type_is_array(l['type']):
		from value.array import value_array_eq
		return value_array_eq(l, r, op, ti)
	elif htype.type_is_record(l['type']):
		from value.record import value_record_eq
		return value_record_eq(l, r, op, ti)

	return value_scalar_eq(l, r, op, ti)





def value_print(x, msg="value_print:"):
	assert(x['isa'] == 'value')

	# can be 'ti_def', but no 'ti'!
	if 'ti' in x:
		info(msg, x['ti'])
	if 'def_ti' in x:
		info(msg, x['def_ti'])

	print("isa: " + str(x['isa']))
	print("kind: " + str(x['kind']))
	print("type: ", end=""); htype.type_print(x['type']); print()
	print("att: " + str(x['att']))


	if 'immediate' in x:
		print('immediate = ' + str(x['immediate']))

	if 'immutable' in x:
		print('immutable = ' + str(x['immutable']))

	print("additional fields:")

	for prop in x:
		if not prop in ['isa', 'kind', 'type', 'att', 'ti', 'immediate', 'immutable']:
			print(" - %s" % prop)

	print()


