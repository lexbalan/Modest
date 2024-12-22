
from error import info, warning, error
from util import nbits_for_num
import type as htype
from type import type_print
from .value import value_terminal, value_is_immediate, value_cons_node, value_cons_immediate



def value_integer_create(num, typ=None, ti=None):
	if typ == None:
		signed = None
		if num < 0:
			signed = True
		typ = htype.type_generic_int_for(num, signed=signed, ti=ti)
	else:
		nbits = nbits_for_num(num)

		if nbits > typ['width']:
			from error import error
			error("value size not corresponded type size", ti)
			return value_bad(ti)

	v = value_terminal(typ, ti)
	v['asset'] = num
	v['nsigns'] = 0
	v['immediate'] = True
	return v



warning_cast_data_loss = True


def _check_width(from_type, t, method, ti):
	rv = True

	if htype.type_is_float(from_type):
		return True

	if from_type['width'] > t['width']:
		#info("%s" % method, ti)
		if method != 'unsafe':
			error("value cons with potential data loss", ti)
			rv = False

		elif warning_cast_data_loss:
			from trans import is_unsafe_mode
			if not (is_unsafe_mode() or features.get('unsafe-downcast')):
				warning("value cons with potential data loss", ti)

	if not rv:
		print("attempt to construct ", end='')
		type_print(t)
		print(" from ", end='')
		type_print(from_type)
		print()

	return rv



def _value_integer_cons_immediate(t, v, method, ti):
	#info("value_cons_int_immediate", ti)
	width = t['width']
	need_width = nbits_for_num(v['asset'])

	if need_width > width:
		error("integer overflow", ti)

	return value_cons_immediate(t, v, method, ti)



def integer_can(to, from_type, method):
	if htype.type_is_generic_integer(from_type):
		return from_type['width'] <= to['width']

	if method == 'implicit':
		return False

	if htype.type_is_float(from_type):
		return True

	# explicit or unsafe cons method
	c = htype.type_is_number(from_type)
	c0 = htype.type_is_integer(from_type)
	c1 = htype.type_is_char(from_type)
	c2 = htype.type_is_word(from_type)
	c3 = htype.type_is_bool(from_type)
	if c or c0 or c1 or c2 or c3:
		if method == 'unsafe':
			return True
		return to['width'] >= from_type['width']

	if method != 'unsafe':
		return False

	if htype.type_is_pointer(from_type):
		from main import settings
		return to['width'] >= int(settings.get('pointer_width'))

	return False




def value_integer_cons(t, v, method, ti):
	_check_width(v['type'], t, method, ti)

	if value_is_immediate(v):
		_check_width(v['type'], t, method, ti)

		if not t['signed']:
			if v['asset'] < 0:
				return None

		if method != 'implicit':
			nv = value_cons_node(t, v, method, ti=ti)
			nv['asset'] = int(v['asset'])  # here can be float
			nv['immediate'] = True
			return nv
		return _value_integer_cons_immediate(t, v, method, ti)

	return value_cons_node(t, v, method, ti=ti)


