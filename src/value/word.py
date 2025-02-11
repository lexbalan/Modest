
from error import info, warning, error
import type as type
from hlir.value import ValueCons



def _value_word_cons_immediate(t, v, method, ti):
	if v.type.width > t.width:
		error("word overflow", ti)

	from .cons import value_cons_immediate
	return value_cons_immediate(t, v, method, ti)



def word_can(to, from_type, method, ti):
	if from_type.is_number():
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	c = from_type.is_number()
	c0 = from_type.is_word()
	c1 = from_type.is_integer()
	c2 = from_type.is_char()
	c3 = from_type.is_bool()
	c4 = from_type.is_pointer()

	if c or c0 or c1 or c2 or c3 or c4:
		if method == 'unsafe':
			return True
		return from_type.width <= to.width

	return False



def value_word_cons(t, v, method, ti):
	if v.isImmediate():
		return _value_word_cons_immediate(t, v, method, ti)
	return ValueCons(t, v, method, ti=ti)

