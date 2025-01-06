import copy
from error import info, warning, error
from hlir import *
from util import get_item_by_id
import type as htype


def value_is_bad(x):
	return isinstance(x, ValueBad)


def value_is_undefined(x):
	return isinstance(x, ValueUndefined)


def value_is_literal(x):
	return isinstance(x, ValueLiteral)


def value_is_immediate(x):
	return x.immediate



# Any immediate value are immutable,
# but not any immutable value are immediate
def value_is_immutable(x):
	return x.immutable


"""
def value_is_lvalue(x):
	isinstance(x, ValueVar)
	isinstance(x, ValueAccessRecord)
	isinstance(x, ValueIndexArray)
	isinstance(x, ValueSliceArray)
	isinstance(x, ValueDeref)
	return x['kind'] in ['var', 'access', 'index', 'slice', 'deref']
"""

def value_is_generic_immediate(x):
	return value_is_immediate(x) and htype.type_is_generic(x.type)


# Only for immediate value (!)
def value_is_zero(x):
	if not value_is_immediate(x):
		return False

	if htype.type_is_array(x.type):
		if x.items == None:
			print("SADAMW:DAW:<DLA<W:LD<AW:LD")
			value_print(x)
			1/ 0
		for item in x.items:
			if not value_is_zero(item):
				return False
		return True

	if htype.type_is_record(x.type):
		for initializer in x.items:
			if not value_is_zero(initializer.value):
				return False
		return True

	return x.asset == 0



def value_attribute_add(v, a):
	v.att.append(a)


def value_attribute_check(v, a):
	return a in v.att



class Value():
	def __init__(self, type, ti=None):
		self.type = type
		self.id = None
		self.immutable = False  #TODO: True
		self.immediate = False  #TODO: True
		self.items = None  #!
		self.asset = None  #!
		self.att = []
		self.ti = ti
		self.nl = 0
		self.nl_end = 0  # ??


class ValueBad(Value):
	def __init__(self, ti=None):
		super().__init__(type=htype.type_bad({'ti': ti}), ti=ti)
		self.id = Id().fromStr('_')
		

class ValueUndefined(Value):
	def __init__(self, type, ti=None):
		super().__init__(type=type, ti=ti)
#		self.asset = 0 #!
#		self.items = [] #!
		self.immutable = True # ??
		self.immediate = False # ??


class ValueLiteral(Value):
	def __init__(self, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.nsigns=0


class ValueZero(Value):
	def __init__(self, type, ti=None):
		super().__init__(type=type, ti=ti)
		if htype.type_is_composite(type):
			self.items = []
		else:
			self.asset = 0
		
		self.att.append('zero')


#TODO: onl value as arg (undefined if not init_value, but type from it)
class ValueVar(Value):
	def __init__(self, id, type, init_value=None, ti=None):
		super().__init__(type=type, ti=ti)
		self.id = id
		self.init_value = init_value
		self.usecnt = 0
		self.definition = None


class ValueConst(Value):
	def __init__(self, id, type, value, ti=None):
		super().__init__(type=type, ti=ti)
		self.id = id
		self.value = value
		self.immutable = True
		self.usecnt = 0
		self.definition = None


class ValueFunc(Value):
	def __init__(self, id, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.id = id
		self.immutable = True
		self.usecnt = 0
		self.definition = None


#TODO: maybe without op?
#TODO: value, type -> only value
class ValueUn(Value):
	def __init__(self, op, value, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.op = op
		self.value = value
		self.immutable = True


#TODO: maybe without op?
#TODO: value, type -> only value
class ValueBin(Value):
	def __init__(self, op, left, right, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.op = op
		self.left = left
		self.right = right
		self.immutable = True



#TODO: get type from value ret type
class ValueCall(Value):
	def __init__(self, func, type, args, ti=None):
		super().__init__(type=type, ti=ti)
		self.func = func
		self.args = args
		self.immutable = True



#TODO: get type from array element type
class ValueIndexArray(Value):
	def __init__(self, left, type, index, ti=None):
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index = index
		#self.immutable = True


#TODO: get type from array type
class ValueSliceArray(Value):
	def __init__(self, left, type, index_from, index_to, ti=None):
		super().__init__(type=type, ti=ti)
		self.left = left
		self.index_from = index_from
		self.index_to = index_to
		#self.immutable = True


class ValueAccessModule(Value):
	def __init__(self, type, left, right, value, ti=None):
		super().__init__(type=type, ti=ti)
		self.left = left
		self.right = right
		self.value = value


class ValueAccessRecord(Value):
	def __init__(self, type, value, field, ti=None):
		super().__init__(type=type, ti=ti)
		self.value = value
		self.field = field


class ValueCons(Value):
	def __init__(self, type, value, method, ti=None):
		assert(method in ['implicit', 'explicit', 'unsafe'])
		assert(type['isa'] == 'type')
		#assert(value['isa'] == 'value')
		super().__init__(type=type, ti=ti)
		self.value = value
		self.method = method
		self.immutable = True
		self.nl_end = value.nl_end


class ValueSizeofType(Value):
	def __init__(self, of, ti=None):
		size = of['size']
		type = htype.type_number_for(size, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = type
		self.asset = size
		self.immutable = True
		self.immediate = True


class ValueSizeofValue(Value):
	def __init__(self, value, ti=None):
		value_size = value.type['size']
		type = htype.type_number_for(value_size, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = value
		self.asset = value_size
		self.immutable = True
		self.immediate = True



class ValueAlignof(Value):
	def __init__(self, of, ti=None):
		align = of['align']
		type = htype.type_number_for(align, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.of = of
		self.asset = align
		self.immutable = True
		self.immediate = True


class ValueOffsetof(Value):
	def __init__(self, record, field_id, ti=None):
		field = htype.record_field_get(of, field_id['str'])
		if field == None:
			error("undefined field '%s'" % field_id['str'], field_id.ti)
			return value_bad({'ti': ti})

		offset = field['offset']
		type = htype.type_number_for(offset, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.field = field_id
		self.asset = offset
		self.immutable = True
		self.immediate = True


class ValueLengthof(Value):
	def __init__(self, value, ti=None):
		length = value.type['volume'].asset
		type = htype.type_number_for(length, signed=False, ti=ti)
		super().__init__(type=type, ti=ti)
		self.value = value
		self.asset = length
		self.immutable = True
		self.immediate = True


class ValueVaStart(Value):
	def __init__(self, vaList, lastParam, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.va_list = vaList
		self.last_param = lastParam
		self.immutable = True
		self.immediate = True


class ValueVaArg(Value):
	def __init__(self, vaList, type, ti=None):
		super().__init__(type=type, ti=ti)
		self.va_list = vaList
		self.immutable = True
		self.immediate = False


class ValueVaEnd(Value):
	def __init__(self, vaList, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.va_list = vaList
		self.immutable = True
		self.immediate = True



class ValueVaCopy(Value):
	def __init__(self, dst, src, ti=None):
		from foundation import typeUnit
		super().__init__(type=typeUnit, ti=ti)
		self.dst = dst
		self.src = src
		self.immutable = True
		self.immediate = True








# cons immediate такой же cons
# но поскольку у него value immediate, мы можем его asset
# привести и взять себе; Таким образом мы идем как литерал нода
# и в то же время как cons нода
def value_cons_immediate(t, v, method, ti):
	assert(method in ['implicit', 'explicit', 'unsafe'])
	nv = value_cons_node(t, v, method, ti)

	nv.asset = v.asset
	nv.immediate = True

	if 'hexadecimal' in v.att:
		nv.att.append('hexadecimal')

	#if 'nl_end' in v:
#	nv.nl_end = v.nl_end

	return nv



def value_scalar_eq(l, r, op, ti):
	from foundation import typeBool
	nv = value_bin(op, l, r, typeBool, ti=ti)

	if value_is_immediate(l) and value_is_immediate(r):
		eq_result = False
		if op == 'eq':
			eq_result = l.asset == r.asset
		else:
			eq_result = l.asset != r.asset

		nv.asset = int(eq_result)
		nv.immediate = True

	return nv


# op = 'eq' | 'ne
def value_eq(l, r, op, ti):
	assert(isinstance(l, Value))
	assert(isinstance(r, Value))
	assert(op in ['eq', 'ne'])

	if htype.type_is_array(l.type):
		from value.array import value_array_eq
		return value_array_eq(l, r, op, ti)
	elif htype.type_is_record(l.type):
		from value.record import value_record_eq
		return value_record_eq(l, r, op, ti)

	return value_scalar_eq(l, r, op, ti)




def value_print(x, msg="value_print:"):
	assert(isinstance(x, Value))

	# can be 'ti_def', but no 'ti'!
	#if 'ti' in x:
	info(msg, x.ti)
	#if 'def_ti' in x:
	#	info(msg, x['def_ti'])

	#print("isa: " + str(x['isa']))
	print("kind: " + str(x.__class__.__name__))
	print("type: ", end=""); htype.type_print(x.type); print()
	print("att: " + str(x.att))

	print('immediate = ' + str(x.immediate))
	print('immutable = ' + str(x.immutable))
	
	if x.immediate:
		if x.items != None:
			print("items_len = %d" % len(x.items))
			print("items[0] = ")
			print(x.items[0])

	"""print("additional fields:")

	for prop in x:
		if not prop in ['isa', 'kind', 'type', 'att', 'ti', 'immediate', 'immutable']:
			print(" - %s" % prop)"""

	print()



	
	
	
	
	
	
	
def value_bad(ti):
	return ValueBad(ti=ti)

# его получают по умолчанию локальные переменные
# в случае если не указан инициализатор
def value_undefined(t, ti):
	return ValueUndefined(t, ti)


def value_terminal(t, ti):
	return ValueLiteral(t, ti)
	"""v = value_undefined(t, ti)
	v['kind'] = 'literal'
	v.immutable = True
	v.immediate = True
	return v"""


def value_zero(t, ti):
	return ValueZero(t, ti)
	"""nv = value_terminal(t, ti)

	if htype.type_is_composite(t):
		nv.items = []
	else:
		nv.asset = 0

	# LETIT: for debugging!
	nv.att.append('zero')
	return nv"""

def value_var(id, type, ti):
	return ValueVar(id, type, ti)
	"""return {
		'isa': 'value',
		'kind': 'var',
		'id': id,
		'type': type,
		'usecnt': 0,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti_decl': ti,
	}"""

# hlir_const is an immutable value
# (not necessary immediate)
def value_const(id, type, value, ti):
	return ValueConst(id, type, value, value)
	"""return {
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
	}"""

def value_func(id, type, ti):
	return ValueFunc(id, type, ti)
	"""return {
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
	}"""

def value_un(k, value, type, ti):
	return ValueUn(k, value, type, ti)
	"""return {
		'isa': 'value',
		'kind': k,
		'value': value,
		'type': type,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti': ti
	}"""

def value_bin(op, l, r, t, ti):
	return ValueBin(op, l, r, t, ti)
	"""return {
		'isa': 'value',
		'kind': op,
		'left': l,
		'right': r,
		'type': t,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti': ti
	}"""


def value_call(func, rettype, args, ti):
	return ValueCall(func, rettype, args, ti)
	"""return {
		'isa': 'value',
		'kind': 'call',
		'func': func,
		'args': args,
		'type': rettype,
		'immediate': False,
		'immutable': True,
		'att': [],
		'ti': ti
	}"""

def value_index_array(array, type, index, ti):
	return ValueIndexArray(array, type, index, ti)
	"""return {
		'isa': 'value',
		'kind': 'index',
		'left': array,
		'index': index,
		'type': type,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti': ti
	}"""
def value_slice_array(left, type, index_from, index_to, ti):
	return ValueSliceArray(left, type, index_from, index_to, ti)
	"""return {
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
	}"""
def value_access_module(type, left, right, value, ti):
	return ValueAccessModule(type, left, right, value, ti)
	"""return {
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
	}"""
def value_access_record(type, value, field, ti):
	return ValueAccessRecord(type, value, field, ti)
	"""return {
		'isa': 'value',
		'kind': 'access',
		'value': value,
		'field': field,
		'type': type,
		'immediate': False,
		'immutable': False,
		'att': [],
		'ti': ti
	}"""

def value_cons_node(type, value, method, ti):
	return ValueCons(type, value, method, ti)
	"""nv = {
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

	return nv"""

def value_sizeof_type(of, ti):
	return ValueSizeofType(of, ti)
	"""type_size = of['size']
	type = htype.type_number_for(type_size, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'sizeof_type',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': type_size,
		'att': [],
		'ti': ti
	}"""
def value_sizeof_value(of, ti):
	return ValueSizeofValue(of, ti)
	"""value_size = of['type']['size']
	type = htype.type_number_for(value_size, signed=False, ti=ti)
	return {
		'isa': 'value',
		'kind': 'sizeof_value',
		'of': of,
		'type': type,
		'immutable': True,
		'immediate': True,
		'asset': value_size,
		'att': [],
		'ti': ti
	}"""
	
def value_alignof(of, ti):
	return ValueAlignof(of, ti)
	"""align = of['align']
	type = htype.type_number_for(align, signed=False, ti=ti)
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
	}"""

def value_offsetof(of, field_id, ti):
	return ValueOffsetof(of, field_id, ti)
	"""
	field = htype.record_field_get(of, field_id['str'])
	if field == None:
		error("undefined field '%s'" % field_id['str'], field_id.ti)
		return value_bad({'ti': ti})

	offset = field['offset']
	type = htype.type_number_for(offset, signed=False, ti=ti)
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
	}"""


def value_lengthof(value, ti):
	return ValueLengthof(value, ti)
	"""length = value.type['volume'].asset
	type = htype.type_number_for(length, signed=False, ti=ti)
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
	}"""

def value_va_start(va_list, last_param, ti):
	return ValueVaStart(va_list, last_param, ti)
	"""from foundation import typeUnit
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
	}"""


def value_va_arg(va_list, type, ti):
	return ValueVaArg(va_list, type, ti)
	"""return {
		'isa': 'value',
		'kind': 'va_arg',
		'va_list': va_list,
		'type': type,
		'immutable': True,
		'immediate': False,
		'asset': 0,
		'att': [],
		'ti': ti
	}"""
def value_va_end(va_list, ti):
	return ValueVaEnd(va_list, ti)
	"""from foundation import typeUnit
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
	}"""


def value_va_copy(dst, src, ti):
	return ValueVaCopy(dst, src, ti)
	"""from foundation import typeUnit
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
	}"""
