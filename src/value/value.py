import copy
from error import info, warning, error
from hlir.hlir import *
from util import get_item_by_id
import type as htype


"""
def value_is_lvalue(x):
	isinstance(x, ValueVar)
	isinstance(x, ValueAccessRecord)
	isinstance(x, ValueIndexArray)
	isinstance(x, ValueSliceArray)
	isinstance(x, ValueDeref)
	return x['kind'] in ['var', 'access', 'index', 'slice', 'deref']
"""



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

	nv.nl_end = v.nl_end

	return nv


