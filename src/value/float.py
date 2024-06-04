
import settings
from error import info, warning, error
import hlir.type as type
from hlir.type import hlir_type_float, type_print
from .value import value_terminal, value_cons_immediate, value_is_immediate



def value_float_create(num, ti=None):
	flt_width = int(settings.get('float_width'))
	typ = hlir_type_float(width=flt_width, ti=ti)
	typ['generic'] = True
	v = value_terminal(typ, num, ti)
	v['immediate'] = True
	return v


def _value_float_cons_immediate(t, v, method, ti):
	nv = value_cons_immediate(t, v, method, ti)
	nv['asset'] = _float_value_pack(float(nv['asset']), t['width'])
	nv['immediate'] = True
	return nv


def _do_cons_float(t, v, method, ti):
	if value_is_immediate(v):
		return _value_float_cons_immediate(t, v, method, ti)
	return value_cons_node(t, v, method, ti=ti)




def float_can(to, from_type, method):
	if type.type_is_generic(from_type):
		return type.type_is_integer(from_type) or type.type_is_float(from_type)

	if method == 'implicit':
		return False

	if type.type_is_integer(from_type):
		return True
	elif type.type_is_float(from_type):
		return True

	return False



def value_float_cons(t, v, method, ti):
	from_type = v['type']

	if float_can(t, from_type, method):
		return _do_cons_float(t, v, method, ti=ti)

	return None



# получаем 32 или 64 битное представление числа
def _float_value_pack(f_num, width):
	import struct
	z = 0
	if width == 32:
		z = struct.unpack('<f', struct.pack('<f', f_num))[0]
	elif width == 64:
		z = struct.unpack('<d', struct.pack('<d', f_num))[0]
	else:
		fatal("too big float, _float_value_pack not implemented")

	return z


