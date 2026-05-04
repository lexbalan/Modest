
from hlir import *
from error import info
#from .common import *
from util import str_fractional




import os

f = None


nl_symbol = "\n"
indent_symbol = "\t"

indent_level = 0



def output_open(fname):
	global f
	dirname = os.path.dirname(fname)
	if dirname != '':
		os.makedirs(dirname, exist_ok=True)
	f = open(fname, "w")


def output_close():
	global f
	f.close()


def out(s):
	global f
	f.write(str(s))




def indent_up():
	global indent_level
	indent_level = indent_level + 1


def indent_down():
	global indent_level
	indent_level = indent_level - 1



def set_nl_symbol(x):
	global nl_symbol
	nl_symbol = x


def str_newline(n=1):
	return nl_symbol * n


def str_indent():
	global indent_level
	global indent_symbol
	return indent_symbol * indent_level


def str_nl_indent(nl=1):
	s = nl_symbol * nl
	if nl > 0:
		s += str_indent()
	return s



SHOW_ANY_CONS = True


def get_id_str(x):
	if not hasattr(x, 'id'):
		return None

	if x.id == None:
		return None

	return x.id.cm


cmodule = None





def str_stmt_comment(x):
	#return "//comment"
	if isinstance(x, StmtCommentLine):
		return str_stmt_comment_line(x)
	elif isinstance(x, StmtCommentBlock):
		return str_stmt_comment_block(x)
	return ""


def str_stmt_comment_block(x):
	return "/*%s*/" % x.text


def str_stmt_comment_line(x):
	lines = x.lines
	i = 0
	n = len(lines)
	s = ''
	while i < n:
		line = lines[i]
		s += "//%s" % line
		i = i + 1
		if i < n:
			s += str_nl_indent()
	return s



def str_TypeNat(t):
	return get_id_str(t)


def str_TypeInt(t):
	return get_id_str(t)


def str_type_array(t):
	s = ""
	s += "["
	if not t.volume.is_value_undefined():
		s += str_value(t.volume)
	s += "]"
	s += str_type(t.of)
	return s


def str_type_pointer(t):
	if Type.is_free_pointer(t):
		return "Ptr"
	return "*" + str_type(t.to)


def str_field(x):
	s = get_id_str(x) + ": " + str_type(x.type)
	if not x.init_value.is_value_undefined():
		s += " = " + str_value(x.init_value)
	return s


def str_type_record(t):
	s = ""

	#if t.hasAttribute('packed'):
	#	s += "@layout("packed") "

	is_public = t.hasAttribute('public')

	s += "{"
	indent_up()

	prev_nl = 1
	nl_end_e = 0
	for field in t.fields:
		if prev_nl == 0:
			s += ", "

		# print comments
		if field.comments:
			for comment in field.comments:
				s += str_nl_indent(comment.nl)
				s += str_stmt_comment(comment)

		if field.nl > 0:
			nl_end_e = 1

		s += str_nl_indent(field.nl)
		prev_nl = field.nl

		if is_public:
			if field.access_level == HLIR_ACCESS_LEVEL_PRIVATE:
				s += "private "
		else:
			if field.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
				s += "public "

		s += str_field(field)

		if field.line_comment:
			s += '  ' + str_stmt_comment(field.line_comment)

	indent_down()
	s += str_nl_indent(nl_end_e)
	s += "}"
	return s


def str_type_func(t, extra_args=False):
	s = '('
	fields = t.params
	i = 0
	n = len(fields)
	while i < n:
		if i > 0:
			s += ", "
		s += str_field(fields[i])
		i = i + 1

	if extra_args:
		s += ", ..."

	s += ') -> '
	s += str_type(t.to)
	return s


def str_type(t):
	if t.definition == None:
		atts = []
		attributes = t.attributes
		for a in attributes:
			atts.append(str_annotation(a, params=attributes[a]))
		aa = ' '.join(atts)
		if aa != '':
			return  aa + ' ' + str_type2(t)

	return str_type2(t)


def str_type2(t):
	assert(isinstance(t, Type))

	# Если тип связан с идентификатором - распечатаем его
	id_str = get_id_str(t)
	if id_str != None:
		return id_str

	# Если у типа нет связанного идентификатора
	# распечатаем полное выражение типа
	if Type.is_func(t):
		return str_type_func(t)
	elif Type.is_array(t):
		return str_type_array(t)
	elif Type.is_record(t):
		return str_type_record(t)
	elif Type.is_pointer(t):
		return str_type_pointer(t)
	elif Type.is_string(t):
		return "String(length=%d)" % t.length
	elif isinstance(t, TypeInteger):
		return "Integer(%d)" % t.width
	elif isinstance(t, TypeRational):
		return "Rational"
	elif isinstance(t, TypeUndefined):
		return "Undefined"
	else:
		#1/0
		return str(t)


bin_ops = {
	HLIR_VALUE_OP_EQ: '==',
	HLIR_VALUE_OP_NE: '!=',
	HLIR_VALUE_OP_LT: '<',
	HLIR_VALUE_OP_GT: '>',
	HLIR_VALUE_OP_LE: '<=',
	HLIR_VALUE_OP_GE: '>=',
	HLIR_VALUE_OP_ADD: '+',
	HLIR_VALUE_OP_SUB: '-',
	HLIR_VALUE_OP_MUL: '*',
	HLIR_VALUE_OP_DIV: '/',
	HLIR_VALUE_OP_REM: '%',
	HLIR_VALUE_OP_LOGIC_AND: 'and',
	HLIR_VALUE_OP_LOGIC_OR: 'or',
	HLIR_VALUE_OP_SHL: '<<',
	HLIR_VALUE_OP_SHR: '>>',
	HLIR_VALUE_OP_BITWISE_OR: '|',
	HLIR_VALUE_OP_BITWISE_XOR: '^',
	HLIR_VALUE_OP_BITWISE_AND: '&',
	HLIR_VALUE_OP_STRCAT: '+',
	HLIR_VALUE_OP_ARRCAT: '+'
}


def str_value_bin(x, ctx):
	s = ''
	s += str_value(x.left, parent_expr=x)
	s += ' %s ' % bin_ops[x.op]
	s += str_value(x.right, parent_expr=x)
	return s


def str_value_shl(x, ctx):
	s = ''
	s += str_value(x.left, parent_expr=x)
	s += ' << '
	s += str_value(x.right, parent_expr=x)
	return s


def str_value_shr(x, ctx):
	s = ''
	s += str_value(x.left, parent_expr=x)
	s += ' >> '
	s += str_value(x.right, parent_expr=x)
	return s


un_ops = {
	HLIR_VALUE_OP_REF: '&',
	HLIR_VALUE_OP_DEREF: '*',
	HLIR_VALUE_OP_POS: '+',
	HLIR_VALUE_OP_NEG: '-',
	HLIR_VALUE_OP_BITWISE_NOT: '~',
	HLIR_VALUE_OP_LOGIC_NOT: 'not'
}


def str_value_ref(x, ctx):
	return '&' + str_value(x.value, parent_expr=x)


def str_value_deref(x, ctx):
	return '*' + str_value(x.value, parent_expr=x)


def str_value_not(x, ctx):
	return 'not ' + str_value(x.value, parent_expr=x)


def str_value_neg(x, ctx):
	return '-' + str_value(x.value, parent_expr=x)


def str_value_pos(x, ctx):
	return '+' + str_value(x.value, parent_expr=x)


def str_value_call(x, ctx):
	s = str_value(x.func)
	s += "("
	i = 0
	args = x.args
	need_sk = False
	n = len(args)
	while i < n:
		arg = args[i]

		if arg.nl > 0:
			need_sk = True
			indent_up()
			s += str_nl_indent(args[i].nl)
			indent_down()
		elif i > 0:
			s += ", "

		if arg.named:
			if arg.nl > 0:
				s += "%s = " % get_id_str(arg)
			else:
				s += "%s=" % get_id_str(arg)
		s += str_value(arg.value)

		i = i + 1

	if need_sk:
		s += str_nl_indent()

	s += ")"
	return s


def str_value_index(x, ctx):
	s = str_value(x.left, parent_expr=x)
	s += "[" + str_value(x.index) + "]"
	return s


def str_value_slice(x, ctx):
	left = x.left
	s = str_value(left, parent_expr=x)
	s += "["
	s += str_value(x.index_from)
	s += ":"
	if not x.index_to.is_value_undefined():
		s += str_value(x.index_to)
	s += "]"
	return s


def str_value_access(x, ctx):
	s = str_value(x.left, parent_expr=x)
	s += "."
	s += get_id_str(x.field)
	return s


def str_value_access_module(x, ctx):
	sstr = ""
	for p in x.imp:
		sstr += p.str + '.'
	return "%s%s" % (sstr, x.id.str)



def str_value_cons(x, ctx):
	value = x.value
	from_type = value.type
	to_type = x.oftype

	if SHOW_ANY_CONS:
		if x.method in ['implicit', 'default']:
			return str_value(value)

	s = ""
	if x.method == 'unsafe':
		s += 'unsafe '

	s += str_type(to_type)
	s += " "
	s += str_value(value, ctx=ctx)
	return s



def is_zero_tail(values, i, n):
	# если это значание - zero, проверим все остальные справа
	# и если они тоже zero - их можно не печатать (zero tail)
	# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
	while i < n:
		v = values[i]
		if not v.isValueZero():
			return False
		i = i + 1
	return True


# print Array literal
def str_value_array(v, ctx):

	if v.isValueImmediate():
		if Type.is_array_of_char(v.type):
			return str_value_str(v, ctx=[])

	s = ""
	indent_up()
	nl_end_e = 0
	values = v.asset
	i = 0
	n = len(values)
	while i < n:
		a = values[i]

		if a.isValueZero():
			if is_zero_tail(values, i, n):
				break

		nl = a.nl
		if nl > 0:
			nl_end_e = 1
			s += str_nl_indent(nl)
		else:
			if i > 0:
				s += ', '

		s += str_value(a, ctx=ctx)

		i = i + 1

	indent_down()

	if nl_end_e > 0:
		s += str_nl_indent(nl_end_e)

	return "[%s]" % s



def code_to_char(cc):
	if cc < 0x20:
		if cc == 0x07: return "\\a"    # bell
		elif cc == 0x08: return "\\b"  # backspace
		elif cc == 0x09: return "\\t"  # horizontal tab
		elif cc == 0x0A: return "\\n"  # line feed
		elif cc == 0x0B: return "\\v"  # vertical tab
		elif cc == 0x0C: return "\\f"  # form feed
		elif cc == 0x0D: return "\\r"  # carriage return
		elif cc == 0x1B: return "\\e"  # escape
		else: return "\\x%X" % cc

	elif cc <= 0x7E :
		sym = chr(cc)
		if sym == '\\': return '\\\\'
		elif sym == '"': return '\\"'
		else: return sym

	elif cc != 0:
		return chr(cc)


# print Array of Char literal
def str_value_str(x, ctx):
	asset = x.asset

	char_codes = []
	i = 0
	while i < len(x.asset):
		cc = x.asset[i].asset
		char_codes.append(cc)
		i = i + 1
	return str_literal_string(char_codes)


# print value with type String
def str_strx(string):
	char_codes = []
	for c in string.asset:
		cc = ord(c)
		char_codes.append(cc)
	return str_literal_string(char_codes)


# print Array of Char codes literal
def str_literal_string(char_codes):
	s = ''
	for cc in char_codes:
		s += code_to_char(cc)
	return '"%s"' % s


# print Record literal
def str_value_record(v, ctx):
	multiline = not 'oneline' in ctx

	s = ''

	indent_up()
	nl_end_e = 0
	nitems = len(v.asset)
	i = 0
	while i < nitems:
		item = v.type.fields[i]
		field_str = get_id_str(item)
		ini = get_item_by_id(v.asset, field_str)

		nl = ini.nl
		if nl > 0:
			nl_end_e = 1
			s += str_nl_indent(nl)
		else:
			if i > 0:
				s += " "

		s += "%s = " % field_str
		s += str_value(ini.value, ctx)

		if nl == 0:
			if i < (nitems - 1):
				s += ","

		i = i + 1

	indent_down()

	if nl_end_e > 0:
		s += str_nl_indent(nl_end_e)

	return "{%s}" % s


# print Bool literal
def str_value_bool_create(x, ctx):
	if x.asset:
		return 'true'
	else:
		return 'false'


# print Char literal
def str_value_char_create(x, ctx):
	cc = x.asset
	if cc < 0x20:
		return "\"\\x%x\"" % cc
	return "\"%s\"" % chr(cc)


# print Int literal
def str_value_integer(x, ctx):
	num = x.asset
	as_hex = x.hasAttribute('hexadecimal')

	nsigns = 0
	if hasattr(x, 'nsigns'):
		nsigns = x.nsigns

	spec = 'd'
	pre = ''
	if as_hex:
		spec = 'X'
		pre = '0x'

	fmt = "%s%%0%d%s" % (pre, nsigns, spec)
	return fmt % num



def str_value_rational(v, ctx):
	return str_fractional(v.asset)


# print Pointer literal
def str_value_ptr(x, ctx):
	if x.asset == 0:
		return "nil"

	return str_type(x['type']) + " 0x%08X" % x.asset


def str_value_enum(x, ctx):
	return get_id_str(x)


def str_value_by_id(x, ctx):
	return get_id_str(x)


def str_value_new(x, ctx):
	return "new " + str_value(x.value)


# Сделал отдельный метод печати строк и есть отдельный для печати
def str_value_string(x, ctx):
	char_codes = []
	for char in x.asset:
		cc = ord(char)
		char_codes.append(cc)
	return str_literal_string(char_codes)


def str_value_literal(x, ctx):
	t = x.type
	if Type.is_integer(t):
		return str_value_integer(x, ctx)
	elif Type.is_rational(t):
		return str_value_rational(x, ctx)
	elif Type.is_string(t):
		return str_value_string(x, ctx)
	elif Type.is_int(t) or Type.is_nat(t):
		return str_value_integer(x, ctx)
	elif Type.is_record(t):
		return str_value_record(x, ctx)
	elif Type.is_pointer(t):
		return str_value_ptr(x, ctx)
	elif Type.is_bool(t):
		return str_value_bool_create(x, ctx)
	elif Type.is_char(t):
		return str_value_char_create(x, ctx)
	elif Type.is_word(t):
		return str_value_integer(x, ctx)
	return "<str_value_literal:%s>" % str(x)


def str_value_sizeof_value(x, ctx):
	return "sizeof " + str_value(x.ofvalue)

def str_value_sizeof_type(x, ctx):
	return "sizeof(" + str_type(x.oftype) + ')'

def str_value_alignof_type(x, ctx):
	return "alignof(" + str_type(x.oftype) + ")"

def str_value_alignof_value(x, ctx):
	return "alignof(" + str_value(x.value) + ")"

def str_value_lengthof_type(x, ctx):
	return "lengthof(" + str_type(x.oftype) + ")"

def str_value_lengthof_value(x, ctx):
	return "lengthof(" + str_value(x.value) + ")"

def str_value_offsetof(x, ctx):
	return "offsetof(" + str_type(x.oftype) + '.' + x.field.str + ')'


def str_value_va_start(x, ctx):
	s = "__va_start("
	s += str_value(x.va_list)
	s += ", "
	s += str_value(x.last_param)
	s += ")"
	return s


def str_value_va_arg(x, ctx):
	s = "__va_arg("
	s += str_value(x.va_list)
	s += ", "
	s += str_type(x.type)
	s += ")"
	return s


def str_value_va_end(x, ctx):
	return "__va_end(" + str_value(x.va_list) + ")"


def str_value_va_copy(x, ctx):
	s = "__va_copy("
	s += str_value(x.dst)
	s += ", "
	s += str_value(x.src)
	s += ")"
	return s


def str_value_subexpr(x, ctx):
	return "(" + str_value(x.value) + ")"


def str_value(x, ctx=[], parent_expr=None):
	assert(isinstance(x, Value))

	if x.isValueLiteral(): return str_value_literal(x, ctx)
	elif x.isValueArray(): return str_value_array(x, ctx)
	elif x.isValueRecord(): return str_value_record(x, ctx)
	elif x.isValueBin(): return str_value_bin(x, ctx)
	elif x.isValueShl(): return str_value_shl(x, ctx)
	elif x.isValueShr(): return str_value_shr(x, ctx)
	elif x.isValueRef(): return str_value_ref(x, ctx)
	elif x.isValueDeref(): return str_value_deref(x, ctx)
	elif x.isValueConst(): return str_value_by_id(x, ctx)
	elif x.isValueFunc(): return str_value_by_id(x, ctx)
	elif x.isValueVar(): return str_value_by_id(x, ctx)
	elif x.isValueCons(): return str_value_cons(x, ctx)
	elif x.isValueCall(): return str_value_call(x, ctx)
	elif x.isValueIndex(): return str_value_index(x, ctx)
	elif x.isValueAccessModule(): return str_value_access_module(x, ctx)
	elif x.isValueAccessRecord(): return str_value_access(x, ctx)
	elif x.isValueSlice(): return str_value_slice(x, ctx)
	elif x.isValueSubexpr(): return str_value_subexpr(x, ctx)
	elif x.isValueNot(): return str_value_not(x, ctx)
	elif x.isValueNeg(): return str_value_neg(x, ctx)
	elif x.isValuePos(): return str_value_pos(x, ctx)
	elif x.isValueNew(): return str_value_new(x, ctx)
	elif x.isValueSizeofValue(): return str_value_sizeof_value(x, ctx)
	elif x.isValueSizeofType(): return str_value_sizeof_type(x, ctx)
	elif x.isValueAlignofType(): return str_value_alignof_type(x, ctx)
	elif x.isValueAlignofValue(): return str_value_alignof_value(x, ctx)
	elif x.isValueOffsetof(): return str_value_offsetof(x, ctx)
	elif x.isValueLengthofValue(): return str_value_lengthof_value(x, ctx)
	elif x.isValueLengthofType(): return str_value_lengthof_type(x, ctx)
	elif x.isValueVaArg(): return str_value_va_arg(x, ctx)
	elif x.isValueVaStart(): return str_value_va_start(x, ctx)
	elif x.isValueVaEnd(): return str_value_va_end(x, ctx)
	elif x.isValueVaCopy(): return str_value_va_copy(x, ctx)
	elif x.is_value_undefined(): return "<undef>"
	else: return "%s" % str(x.__class__)

	#if need_wrap:
	#	out(")")




def str_annotation(a, params):
	if a in ['const', 'zarray']:
		return ''

	sstr = ""
	if not params in [None, {}, []]:
		sstr += '('
		if isinstance(params, dict):
			pass
		else:
			pass
			#sstr += str_value(params)
		sstr += ')'
	return "@" + a + sstr


def str_stmt_type(x):
	#if atts != []:
	#	return "type %s = %s %s" % (get_id_str(x), ' '.join(atts), str_type(x.original_type))

	return "type %s = %s" % (get_id_str(x), str_type(x.original_type))



def str_stmt_def(x, operator='const'):

#	if x.hasAttribute('used'):
#		out("@used\n")
#
#	if x.hasAttribute('unused'):
#		out("@unused\n")
#
#	if x.hasAttribute('extern'):
#		out("@extern\n")
#
#	if hasattr(x, 'section'):
#		out("@section(\"%s\")\n" % x.section)
#
#	if hasattr(x, 'alignment'):
#		out("@alignment(%d)\n" % x.alignment)

	ss = []

	ss.append("%s %s" % (operator, get_id_str(x)))

	if not x.value.type.is_generic():
		if not (x.init_value.isValueCons() and x.init_value.method == 'explicit'):
			ss.append(": ")
			ss.append(str_type(x.value.type))

	if not x.init_value.is_value_undefined():
		ss.append(" = ")
		ss.append(str_value(x.init_value))
	return ''.join(ss)


def str_stmt_func(x):
	if x.stmt == None:
		return

#	if x.hasAttribute('inlinehint'):
#		ss.append("@inlinehint\n")
#	if x.hasAttribute('inline'):
#		ss.append("@inline\n")
#	if x.hasAttribute('noinline'):
#		ss.append("@noinline\n")

	func = x.value
	ft = func.type
	ss = []
	ss.append("func ")
	ss.append(get_id_str(func))
	ss.append(" ")
	ss.append(str_type_func(ft, extra_args=ft.extra_args))
	ss.append(" ")
	ss.append(str_stmt_block(x.stmt))
	return ''.join(ss)


def str_stmt_block(s):
	nl_end_e = 1
	ss = []
	ss.append("{")
	indent_up()
	for stmt in s.stmts:
		ss.append(str_stmt(stmt))
	indent_down()
	ss.append(str_nl_indent(nl_end_e))
	ss.append("}")
	return ''.join(ss)


def str_stmt_if(x):
	ss = []
	ss.append("if ")
	ss.append(str_value(x.cond))
	ss.append(" ")
	ss.append(str_stmt_block(x.then))

	e = x.els
	if e != None:
		if e.is_stmt_if():
			ss.append(" else ")
			ss.append(str_stmt_if(e))
		else:
			ss.append(" else ")
			ss.append(str_stmt_block(e))
	return ''.join(ss)


def str_stmt_while(x):
	return "while %s %s" % (str_value(x.cond), str_stmt_block(x.stmt))


def str_stmt_return(x):
	ss = []
	ss.append("return")
	rv = x.value
	if rv != None:
		ss.append(" ")
		ss.append(str_value(rv))
	return ''.join(ss)


def str_stmt_assign(x):
	return "%s = %s" % (str_value(x.left), str_value(x.right))


def str_stmt_value(x):
	return str_value(x.value)


def str_stmt_break(x):
	return "break"


def str_stmt_again(x):
	return "again"





# for str_stmt_asm:
# prints pairs: <specifier> <value>
def print_asm_pairs(args):
	pairs = []
	for arg in args:
		pairs.append("[%s, %s]" % (str_value(arg[0]), str_value(arg[1])))
	return '[%s]' % ', '.join(pairs)


def str_stmt_asm(x):
	ss = []
	ss.append('__asm(')
	ss.append(str_strx(x.text))

	if len(x.outputs) > 0:
		ss.append(', ')
		ss.append(print_asm_pairs(x.outputs))

	if len(x.inputs) > 0:
		ss.append(', ')
		ss.append(print_asm_pairs(x.inputs))

	if len(x.clobbers) > 0:
		ss.append(', [')
		for c in x.clobbers:
			ss.append(str_value(c))
		ss.append(']')

	ss.append(")")
	return ''.join(ss)


def str_stmt(x):
	assert(isinstance(x, Stmt))

	ss = []
	if x.comment != None:
		ss.append(str_nl_indent(x.comment.nl))
		ss.append(str_stmt_comment(x.comment))

	if x.nl > 0:
		ss.append(str_nl_indent(x.nl))
	else:
		ss.append("; ")

	ss.append(str_stmt2(x))
	return ''.join(ss)

def str_stmt2(x):
	if x.is_stmt_block(): return str_stmt_block(x)
	elif x.is_stmt_value_expr(): return str_stmt_value(x)
	elif x.is_stmt_assign(): return str_stmt_assign(x)
	elif x.is_stmt_return(): return str_stmt_return(x)
	elif x.is_stmt_if(): return str_stmt_if(x)
	elif x.is_stmt_while(): return str_stmt_while(x)
	elif x.is_stmt_def_var(): return str_stmt_def(x, operator='var')
	elif x.is_stmt_def_const(): return str_stmt_def(x, operator='let')
	elif x.is_stmt_break(): return str_stmt_break(x)
	elif x.is_stmt_again(): return str_stmt_again(x)
	elif x.is_stmt_comment(): return str_stmt_comment(x)
	elif x.is_stmt_asm(): return str_stmt_asm(x)
	elif x.is_stmt_def_type(): return str_stmt_type(x)

	return "<stmt %s>" % str(x)



def print_import(x):
	ss = []
	if not x.include:
		ss.append("import \"%s\"" % x.impline)
		if x.name != None:
			ss.append(" as %s" % x.name)
	else:
		ss.append("include \"%s\"" % x.impline)
	return ''.join(ss)



def print_directive(x):
	if isinstance(x, StmtDirectiveInsert):
		return '\npragma insert "%s"' % x.text
	elif isinstance(x, StmtDirectiveCInclude):
		#return '\npragma c_include "%s"' % x.c_name
		return ""

	return "\n// directive: %s" % str(x)
	#if x.is_stmt_import():
	#	m = m.module
	#	ss.append('import "%s"' % m.)
	#if isinstance(x, StmtDirectiveCInclude):
	#	ss.append("@c_include \"%s\"" % x.c_name)



def str_top_level_stmt2(x):
	assert(isinstance(x, Stmt))

	ss = []
	if x.comment != None:
		ss.append(str_newline(n=x.comment.nl))
		ss.append(str_stmt_comment(x.comment))

	if not x.is_stmt_directive():
		ss.append(str_newline(n=x.nl))

	for a in x.attributes:
		v = x.attributes[a]
		ss.append(str_annotation(a, v))
		ss.append("\n")

	if isinstance(x, StmtDef):
		if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
			ss.append("public ")

	ss.append(str_top_level_stmt(x))
	str(ss)
	return ''.join(ss)


def str_top_level_stmt(x):
	if x.is_stmt_def_var(): return str_stmt_def(x, operator='var')
	elif x.is_stmt_def_const(): return str_stmt_def(x, operator='const')
	elif x.is_stmt_def_func(): return str_stmt_func(x)
	elif x.is_stmt_def_type(): return str_stmt_type(x)
	elif x.is_stmt_comment(): return str_stmt_comment(x)
	elif x.is_stmt_import(): return print_import(x)
	elif x.is_stmt_directive(): return print_directive(x)
	return "<unknown stmt>"



def init(settings):
	pass



def run(module, fname):
	global cmodule
	cmodule = module

	ss = []

	for x in module.imports_private:
		stmt_import = module.imports_private[x]
		ss.append('private import "%s"\n' % (stmt_import.impline))

	for x in module.imports_public:
		stmt_import = module.imports_public[x]
		ss.append('import "%s"\n' % (stmt_import.impline))

	for x in module.included_modules:
		ss.append('include "%s"\n' % (str(x.id)))

	for x in module.defs:
		ss.append(str_top_level_stmt2(x))

	dirname = os.path.dirname(fname)
	if dirname != '':
		os.makedirs(dirname, exist_ok=True)
	file = open(fname+'.m', "w")

	for s in ss:
		file.write(s)
	file.write("\n\n")

	file.close()



