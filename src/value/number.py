
from error import error
from hlir.value import ValueLiteral, ValueCons
import type as htype
from util import nbits_for_num


def value_number_create(num, typ=None, ti=None):
	if typ == None:
		typ = htype.type_number_for(num, signed=num < 0, ti=ti)
	else:
		nbits = nbits_for_num(num)

		if nbits > typ.width:
			from error import error
			error("value size not corresponded type size", ti)
			return ValueBad(ti)

	v = ValueLiteral(typ, ti)
	v.asset = num
	v.nsigns = 0
	v.immediate = True
	return v



def number_can(to, from_type, method, ti):
	return type_is_number(from_type)


def value_number_cons(t, v, method, ti):
	from_type = v.type
	if number_can(t, from_type, method):
		nv = ValueCons(t, v, method, ti=ti)
		nv.immediate = v.immediate
		nv.asset = v.asset
		return nv

	return None


