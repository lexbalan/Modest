
from error import info, warning, error
import type as type
from .value import ValueCons, value_cons_immediate


def _value_word_cons_immediate(t, v, method, ti):
	if v.type['width'] > t['width']:
		error("word overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def word_can(to, from_type, method):
	if type.type_is_number(from_type):
		return from_type['width'] <= to['width']

	if method == 'implicit':
		return False

	c = type.type_is_number(from_type)
	c0 = type.type_is_word(from_type)
	c1 = type.type_is_integer(from_type)
	c2 = type.type_is_char(from_type)
	c3 = type.type_is_bool(from_type)

	if c or c0 or c1 or c2 or c3:
		if method == 'unsafe':
			return True
		return from_type['width'] <= to['width']

	return False



def value_word_cons(t, v, method, ti):
	if v.isImmediate():
		return _value_word_cons_immediate(t, v, method, ti)
	return ValueCons(t, v, method, ti=ti)

