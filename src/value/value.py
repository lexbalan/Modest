import copy
from error import info, warning, error
from hlir.id import hlir_id
from hlir.hlir import *
from util import get_item_with_id
import hlir.type as hlir_type


def value_is_bad(x):
	return x['kind'] == 'bad'


def value_is_immediate(x):
	return x['immediate']


# Any immediate value are immutable,
# but not any immutable value are immediate
def value_is_immutable(x):
	return x['immutable']


def value_is_lvalue(x):
	return x['kind'] in ['var', 'access', 'index', 'slice', 'deref']


def value_is_generic_immediate(x):
	return value_is_immediate(x) and hlir_type.type_is_generic(x['type'])


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

	if hlir_type.type_is_array(x['type']):
		return _value_is_zero_array(x)
	if hlir_type.type_is_record(x['type']):
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




def value_bad(x):
	ti = None
	if 'ti' in x:
		ti = x['ti']
	return {
		'isa': 'value',
		'kind': 'bad',
		'id': hlir_id('_', ti=ti),
		'type': hlir_type.hlir_type_bad({'ti': ti}),
		'immutable': False,
		'immediate': False,
		'att': [],
		'ast_value': x,
		'expr_ti': ti,
		'ti': ti
	}


def value_terminal(t, asset, ti):
	return {
		'isa': 'value',
		'kind': 'literal',
		'type': t,
		'items': [],
		# Literal - не всегда immediate!
		# Литерал композитного типа может быть не immediate
		# (см: do_value_record, do_value_array)
		'immutable': False,
		'immediate': True,
		'asset': asset,
		'att': [],
		'nl_end': 0,
		'nl': 0,
		'expr_ti': ti,
		'ti': ti
	}


def value_zero(t, ti):
	nv = value_terminal(t, 0, ti)

	if hlir_type.type_is_array(t):
		nv['items'] = []
	elif hlir_type.type_is_record(t):
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
		'expr_ti': ti,
		'ti': ti
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
		'expr_ti': ti,
		'ti': ti
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
		'expr_ti': ti,
		'ti': ti
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
		'expr_ti': ti,
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
		'expr_ti': ti,
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
		'expr_ti': ti,
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
		'expr_ti': ti,
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
		'expr_ti': ti,
		'ti': ti
	}


def value_access_record(record, type, field, ti):
	return {
		'isa': 'value',
		'kind': 'access',
		'record': record,
		'field': field,
		'record_type': type,
		'type': field['type'],
		'immediate': False,
		'immutable': False,
		'att': [],
		'expr_ti': ti,
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
		'expr_ti': ti,
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



def value_sizeof(of, ti):
	size = hlir_type.type_get_size(of)
	type = hlir_type.hlir_type_generic_int_for(size, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'sizeof',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': size,
		'att': [],
		'expr_ti': ti,
		'ti': ti
	}


def value_alignof(of, ti):
	align = hlir_type.type_get_align(of)
	type = hlir_type.hlir_type_generic_int_for(align, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'alignof',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': align,
		'att': [],
		'expr_ti': ti,
		'ti': ti
	}


def value_offsetof(of, field_id, ti):
	field = hlir_type.record_field_get(of, field_id['str'])
	if field == None:
		error("undefined field '%s'" % field_id['str'], field_id['ti'])
		return value_bad({'ti': ti})

	offset = field['offset']
	type = hlir_type.hlir_type_generic_int_for(offset, signed=False, ti=ti)
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
		'expr_ti': ti,
		'ti': ti
	}


def value_lengthof(value, ti):
	length = value['type']['volume']['asset']
	type = hlir_type.hlir_type_generic_int_for(length, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'lengthof',
		'value': value,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': length,
		'att': [],
		'expr_ti': ti,
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
		'expr_ti': ti,
		'ti': ti
	}

def value_va_arg(va_list, type, ti):
	return {
		'isa': 'value',
		'kind': 'va_arg',
		'va_list': va_list,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': 0,
		'att': [],
		'expr_ti': ti,
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
		'expr_ti': ti,
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
		'expr_ti': ti,
		'ti': ti
	}



def value_print(x, msg="value_print"):
	assert(x['isa'] == 'value')
	print("\n\nvalue_print:")

	if 'expr_ti' in x:
		info(msg, x['expr_ti'])
	else:
		info(msg, x['ti'])

	print("isa: " + str(x['isa']))
	print("kind: " + str(x['kind']))
	print("type: ", end=""); hlir_type.type_print(x['type']); print()
	print("att: " + str(x['att']))


	if 'immediate' in x:
		print('immediate = ' + str(x['immediate']))

	if 'immutable' in x:
		print('immutable = ' + str(x['immutable']))

	print("additional fields:")

	for prop in x:
		if not prop in ['isa', 'kind', 'type', 'att', 'ti', 'immediate', 'immutable', 'expr_ti']:
			print(" - %s" % prop)

	print()


