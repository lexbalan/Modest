import copy
from error import info, warning, error
from hlir.hlir import *
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





# cons immediate такой же cons
# но поскольку у него value immediate, мы можем его asset
# привести и взять себе; Таким образом мы идем как литерал нода
# и в то же время как cons нода
def value_cons_immediate(t, v, method, ti):
	assert(method in ['implicit', 'explicit', 'unsafe'])
	nv = ValueCons(t, v, method, ti)

	nv.asset = v.asset
	nv.immediate = True

	if 'hexadecimal' in v.att:
		nv.att.append('hexadecimal')

	#if 'nl_end' in v:
#	nv.nl_end = v.nl_end

	return nv



def value_scalar_eq(l, r, op, ti):
	from foundation import typeBool
	nv = ValueBin(op, l, r, typeBool, ti=ti)

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


