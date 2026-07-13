
from hlir import *
from error import info, warning, error


def value_variant_create(val, ti=None):
	return ValueLiteral(typeBool, val, ti)


def variant_can(to, from_type, method, ti):
	can = to.getVariantId(from_type) != None
	#info("variant_can ? %d" % can, ti)
	return can


def value_variant_cons(t, v, method, ti):
	#info("value_variant_cons", ti)
	nv = ValueCons(t, t, v, method, ti=ti)
	nv.set_asset(v.asset)
	return nv



