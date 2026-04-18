
from hlir import *
from error import info
from .common import *
from util import str_fractional


def get_id_str(x):
	if not hasattr(x, 'id'):
		return None

	if x.id == None:
		return None

	return x.id.cm


cmodule = None



def print_stmt_comment(x):
	out(str_stmt_comment(x))


def str_stmt_comment(x):
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
	assert(isinstance(t, Type))

	#s = ""

	#if t.hasAttribute('branded'):
	#	s += "@branded "

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
		return "String"
	elif isinstance(t, TypeNumber):
		return "Number"
	else:
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
	HLIR_VALUE_OP_BITWISE_AND: '&'
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


def print_value(x):
	return out(str_value(x))




def str_annotation(a, params):
	mass = ""
	if params != {}:
		mass += '('
		if isinstance(params, dict):
			pass
		else:
			mass += str_value(params)
		mass += ')'
	return "@" + a + mass


def print_stmt_type(x):
	out("type ")
	out(get_id_str(x))
	out(" = ")
	attributes = x.original_type.attributes
	for a in attributes:
		out(str_annotation(a, params=attributes[a]) + " ")
	out(str_type(x.original_type))


# принимает StmtConst / StmtVar
# возвращает true если в нем нужно явно аннотировать тип
def needTypeAnno(x):
	if x.value.type.is_generic():
		return False
	return not (x.init_value.isValueCons() and x.init_value.method == 'explicit')


def print_stmt_def(x, operator='const'):

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

	out("%s %s" % (operator, get_id_str(x)))

	if needTypeAnno(x):
		out(": ")
		out(str_type(x.value.type))

	if not x.init_value.is_value_undefined():
		out(" = ")
		out(str_value(x.init_value))


def print_stmt_func(x):
	if x.stmt == None:
		return

#	if x.hasAttribute('inlinehint'):
#		out("@inlinehint\n")
#	if x.hasAttribute('inline'):
#		out("@inline\n")
#	if x.hasAttribute('noinline'):
#		out("@noinline\n")

	func = x.value
	ft = func.type
	out("func ")
	out(get_id_str(func))
	out(" ")
	out(str_type_func(ft, extra_args=ft.extra_args))
	print_stmt_block(x.stmt)


def print_stmt_block(s):
	nl_end_e = 1
	out(" {")
	indent_up()
	for stmt in s.stmts:
		print_stmt(stmt)
	indent_down()
	out(str_nl_indent(nl_end_e))
	out("}")


def print_stmt_if(x):
	out("if ")
	print_value(x.cond)
	print_stmt_block(x.then)

	e = x.els
	if e != None:
		if e.is_stmt_if():
			out(" else ")
			print_stmt_if(e)
		else:
			out(" else")
			print_stmt_block(e)


def print_stmt_while(x):
	out("while ")
	print_value(x.cond)
	print_stmt_block(x.stmt)


def print_stmt_return(x):
	out("return")
	rv = x.value
	if rv != None:
		out(" ")
		print_value(rv)


def print_stmt_assign(x):
	print_value(x.left)
	out(" = ")
	print_value(x.right)


def print_stmt_value(x):
	print_value(x.value)


def print_stmt_break(x):
	out("break")


def print_stmt_again(x):
	out("again")



def print_asm_pair(pair):
	out('[')
	print_value(pair[0])
	out(', ')
	print_value(pair[1])
	out(']')



# for print_stmt_asm:
# prints pairs: <specifier> <value>
def print_asm_pairs(args):
	out('[')
	for arg in args:
		print_asm_pair(arg)
	out(']')


def print_stmt_asm(x):
	out('__asm(')
	out(str_strx(x.text))

	if len(x.outputs) > 0:
		out(', ')
		print_asm_pairs(x.outputs)

	if len(x.inputs) > 0:
		out(', ')
		print_asm_pairs(x.inputs)

	if len(x.clobbers) > 0:
		out(', [')
		for c in x.clobbers:
			print_value(c)
		out(']')

	out(")")
	return


def print_stmt(x):
	assert(isinstance(x, Stmt))

	if x.comment != None:
		out(str_nl_indent(x.comment.nl))
		print_stmt_comment(x.comment)

	if x.nl > 0:
		out(str_nl_indent(x.nl))
	else:
		out("; ")

	if x.is_stmt_block(): print_stmt_block(x)
	elif x.is_stmt_value_expr(): print_stmt_value(x)
	elif x.is_stmt_assign(): print_stmt_assign(x)
	elif x.is_stmt_return(): print_stmt_return(x)
	elif x.is_stmt_if(): print_stmt_if(x)
	elif x.is_stmt_while(): print_stmt_while(x)
	elif x.is_stmt_def_var(): print_stmt_def(x, operator='var')
	elif x.is_stmt_def_const(): print_stmt_def(x, operator='let')
	elif x.is_stmt_break(): print_stmt_break(x)
	elif x.is_stmt_again(): print_stmt_again(x)
	elif x.is_stmt_comment(): print_stmt_comment(x)
	elif x.is_stmt_asm(): print_stmt_asm(x)
	elif x.is_stmt_def_type(): print_stmt_type(x)
	else: lo("<stmt %s>" % str(x))



def print_import(x):
	if not x.include:
		out("import \"%s\"" % x.impline)
		if x.name != None:
			out(" as %s" % x.name)
	else:
		out("include \"%s\"" % x.impline)



def print_directive(x):
	if isinstance(x, StmtDirectiveInsert):
		out('\npragma insert "%s"' % x.text)

	#if x.is_stmt_import():
	#	m = m.module
	#	out('import "%s"' % m.)
	#if isinstance(x, StmtDirectiveCInclude):
	#	out("@c_include \"%s\"" % x.c_name)



def printTopLevelStmt(x):
	assert(isinstance(x, Stmt))

	if x.comment != None:
		out(str_newline(n=x.comment.nl))
		print_stmt_comment(x.comment)

	if not x.is_stmt_directive():
		out(str_newline(n=x.nl))

	for a in x.attributes:
		v = x.attributes[a]
		out(str_annotation(a, v))
		out("\n")

	if isinstance(x, StmtDef):
		if x.access_level == HLIR_ACCESS_LEVEL_PUBLIC:
			out("public ")

	if x.is_stmt_def_var(): print_stmt_def(x, operator='var')
	elif x.is_stmt_def_const(): print_stmt_def(x, operator='const')
	elif x.is_stmt_def_func(): print_stmt_func(x)
	elif x.is_stmt_def_type(): print_stmt_type(x)
	elif x.is_stmt_comment(): print_stmt_comment(x)
	elif x.is_stmt_import(): print_import(x)
	elif x.is_stmt_directive(): print_directive(x)



def init(settings):
	pass



def run(module, outname):
	global cmodule
	cmodule = module
	output_open(outname + '.m')

	for x in module.imports_private:
		stmt_import = module.imports_private[x]
		out('private import "%s"\n' % (stmt_import.impline))

	for x in module.imports_public:
		stmt_import = module.imports_public[x]
		out('import "%s"\n' % (stmt_import.impline))

	for x in module.included_modules:
		out('include "%s"\n' % (str(x.id)))

	for x in module.defs:
		printTopLevelStmt(x)

	out("\n\n")
	output_close()



