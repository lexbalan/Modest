
from hlir.value import ValueLiteral


def value_imm_literal_create(type, asset=None, ti=None):
	v = ValueLiteral(type, ti)
	v.asset = asset
	v.immediate = True
	return v


