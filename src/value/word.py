
from error import info, warning, error
import type as type
from value.value import value_is_immediate
from .value import value_cons_node, value_cons_immediate


def _value_word_cons_immediate(t, v, method, ti):
	if v['type']['width'] > t['width']:
		error("word overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def width_ok(to, from_type, method):
	if method == 'unsafe':
		return True
	return from_type['width'] <= to['width']


def word_can(to, from_type, method):
	if type.type_is_generic_integer(from_type):
		return from_type['width'] <= to['width']

	if method == 'implicit':
		return False

	c0 = type.type_is_word(from_type)
	c1 = type.type_is_integer(from_type)
	c2 = type.type_is_char(from_type)
	c3 = type.type_is_bool(from_type)

	if c0 or c1 or c2 or c3:
		return width_ok(to, from_type, method)

	return False


def value_word_cons(t, v, method, ti):
	if value_is_immediate(v):
		return _value_word_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)

