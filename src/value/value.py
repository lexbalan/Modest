
from hlir import *
from value.array import value_array_eq
from value.record import value_record_eq


def value_imm_literal_create(type, asset=None, ti=None):
	return ValueLiteral(type, asset, ti)



def value_eq(l, r, op, ti):
	assert(isinstance(l, Value))
	assert(isinstance(r, Value))
	assert(op in [HLIR_VALUE_OP_EQ, HLIR_VALUE_OP_NE])

	if l.type.is_array():
		return value_array_eq(l, r, op, ti)
	elif l.type.is_record():
		return value_record_eq(l, r, op, ti)

	# scalar
	nv = ValueBin(typeBool, op, l, r, ti=ti)
	nv.stage = HLIR_VALUE_STAGE_RUNTIME

	if l.isValueImmediate() and r.isValueImmediate():
		eq_result = False
		if op == HLIR_VALUE_OP_EQ:
			eq_result = l.asset == r.asset
		else:
			eq_result = l.asset != r.asset

		nv.asset = int(eq_result)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME

	return nv


