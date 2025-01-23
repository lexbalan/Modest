
import type as htype
from error import info
from .common import *
from hlir.hlir import *
from util import get_item_by_id
import foundation

INDENT_SYMBOL = "\t"


def init():
	pass


def newline(n=1):
	out('\n' * n)


def indent():
	ind(INDENT_SYMBOL)


def nl_indent(nl=1):
	newline(nl)
	if nl > 0:
		indent()


def get_id_str(x):
	id = x.id

	if id.cm:
		id_str = id.cm

	return id.str


aprecedence = [
	['logic_or'], #0
	['logic_and'], #1
	['or'], #2
	['xor'], #3
	['and'], #4
	['eq', 'ne'], #5
	['lt', 'le', 'gt', 'ge'], #6
	['shl', 'shr'], #7
	['add', 'sub'], #8
	['mul', 'div', 'rem'], #9
	['pos', 'neg', 'not', 'logic_not', 'cons', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof', 'lengthof'], #10
	['call', 'index', 'access', 'access_module'], #11
	['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1


# приоритет операции
def precedence(x):
	i = 0
	if isinstance(x, ValueBin) or isinstance(x, ValueUn):
		k = x.op
		while i < precedenceMax + 1:
			if k in aprecedence[i]:
				break
			i = i + 1
	else:
		if isinstance(x, ValueSizeofValue): i = 10
		elif isinstance(x, ValueCall): i = 11
		elif isinstance(x, ValueIndex): i = 11
		elif isinstance(x, ValueAccessRecord): i = 11
		elif isinstance(x, ValueShl): i = 7
		elif isinstance(x, ValueShr): i = 7
		else: i = 12

	return i



def print_id_for(x):
	out(get_id_str(x))


def print_stmt_comment(x):
	if isinstance(x, StmtCommentLine):
		print_stmt_comment_line(x)
	elif isinstance(x, StmtCommentBlock):
		print_stmt_comment_block(x)


def print_stmt_comment_block(x):
	out("/*%s*/" % x.text)


def print_stmt_comment_line(x):
	lines = x.lines
	i = 0
	n = len(lines)
	while i < n:
		line = lines[i]
		out("//%s" % line['str'])
		i = i + 1
		if i < n:
			newline()
			indent()



def print_TypeInt(t):
	out(get_type_id(t))


def print_type_array(t):
	out("[")
	if not Value.isUndefined(t.volume):
		print_value(t.volume)
	out("]")
	print_type(t.of)


def print_type_pointer(t):
	if Type.is_free_pointer(t):
		out("Ptr")
	else:
		out("*"); print_type(t.to)


def print_field(x):
	print_id_for(x)
	out(": ")
	print_type(x.type)


def print_type_record(t):
	out("record {")
	indent_up()

	prev_nl = 1
	for field in t.fields:
		if prev_nl == 0:
			out(", ")

		# print comments
		if field.comments:
			for comment in field.comments:
				nl_indent(comment.nl)
				print_stmt_comment(comment)

		nl_indent(field.nl)
		prev_nl = field.nl

		if field.access_level == 'public':
			out("public ")
		print_field(field)

	indent_down()
	nl_indent(t.nl_end)
	out("}")


def print_type_enum(t):
	out("enum {")
	items = t.items
	i = 0
	while i < len(items):
		item = items[i]
		out(NL_INDENT)
		print_id_for(item)
		i = i + 1
	out("\n}")


def print_type_func(t, extra_args=False):
	out('(')
	fields = t.params
	i = 0
	n = len(fields)
	while i < n:
		if i > 0: out(", ")
		print_field(fields[i])
		i = i + 1

	if extra_args:
		#out(", va_list: __VA_List")
		out(", ...")

	out(') -> ')
	print_type(t.to)


def get_type_id(t):
	if hasattr(t, 'id'):
		if t.id.cm:
			return t.cm
		return t.id.str

	return None


def print_type(t):
	assert(isinstance(t, Type))

	# Если тип связан с идентификатором - распечатаем его
	id_str = get_type_id(t)
	if id_str != None:
		out(id_str)
		return

	# Если у типа нет связанного идентификатора
	# распечатаем полное выражение типа
	if Type.is_integer(t): print_TypeInt(t)
	elif Type.is_func(t): print_type_func(t)
	elif Type.is_array(t): print_type_array(t)
	elif Type.is_record(t): print_type_record(t)
	elif Type.is_pointer(t): print_type_pointer(t)
	#elif Type.is_enum(t): print_type_enum(t)
	elif k == 'undefined': pass
	else: out("<type:" + str(t) + ">")



bin_ops = {
	'or': 'or', 'xor': 'xor', 'and': 'and', 'shl': '<<', 'shr': '>>',
	'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
	'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
	'logic_and': 'and', 'logic_or': 'or'
}


def print_value_bin(x, ctx):
	print_value(x.left, parent_expr=x)
	out(' %s ' % bin_ops[x.op])
	print_value(x.right, parent_expr=x)


def print_value_shl(x, ctx):
	print_value(x.left, parent_expr=x)
	out(' << ')
	print_value(x.right, parent_expr=x)


def print_value_shr(x, ctx):
	print_value(x.left, parent_expr=x)
	out(' >> ')
	print_value(x.right, parent_expr=x)



un_ops = {
	'ref': '&', 'deref': '*',
	'pos': '+', 'neg': '-',
	'not': 'not', 'logic_not': 'not'
}


def print_value_ref(x, ctx):
	out('&')
	print_value(x.value, parent_expr=x)


def print_value_deref(x, ctx):
	out('*')
	print_value(x.value, parent_expr=x)


def print_value_un(x, ctx):
	out(un_ops[x.op]); print_value(x.value, parent_expr=x)


def print_ValueCall(x, ctx):
	print_value(x.func)
	out("(")
	i = 0
	args = x.args
	n = len(args)
	while i < n:
		arg = args[i]
		if i > 0: out(", ")


		if isinstance(arg, Initializer):
			# named parameter
			out("%s = " % get_id_str(arg))
			print_value(arg.value)
		else:
			print_value(arg)


		i = i + 1
	out(")")


def print_value_index(x, ctx):
	print_value(x.left, parent_expr=x)
	out("["); print_value(x.index); out("]")


def print_value_slice(x, ctx):
	left = x.left
	print_value(left, parent_expr=x)
	out("[")
	print_value(x.index_from)
	out(":")
	if not isinstance(x.index_to, ValueUndefined):
		print_value(x.index_to)
	out("]")


def print_value_access(x, ctx):
	print_value(x.left, parent_expr=x)
	out(".")
	print_id_for(x.field)


def print_value_access_module(x, ctx):
	left = x.left
	id_str = get_id_str(x.right)
	out("%s.%s" % (left.id, id_str))


def print_cast(t, v, ctx=[]):
	print_type(t)
	out(" ")
	print_value(v, ctx=ctx)


def print_value_cons(x, ctx):
	value = x.value
	from_type = value.type
	to_type = x.type

	if x.method == 'implicit':
		print_value(value)
		return

	# NO need cast ptr to *void
	if Type.is_pointer(from_type):
		if Type.is_free_pointer(to_type):
			print_value(value)
			return

	# NO need cast *void to ptr
	if Type.is_free_pointer(from_type):
		if Type.is_pointer(to_type):
			print_value(value)
			return

	print_cast(to_type, value, ctx)



def is_zero_tail(values, i, n):
	# если это значание - zero, проверим все остальные справа
	# и если они тоже zero - их можно не печатать (zero tail)
	# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
	while i < n:
		v = values[i]
		if not v.isZero():
			return False
		i = i + 1
	return True


# print Array literal
def print_value_array(v, ctx):

	#?
	if Type.is_array_of_char(v.type):
		print_value_str(v, ctx=[])
		return

	out("[")
	indent_up()

	values = v.items
	i = 0
	n = len(values)
	while i < n:
		a = values[i]

		if a.isZero():
			if is_zero_tail(values, i, n):
				break

		nl = a.nl
		if nl > 0:
			newline(nl)
			indent()
		else:
			if i > 0:
				out(', ')

		print_value(a, ctx=ctx)

		i = i + 1


	indent_down()

	if v.nl_end > 0:
		newline(v.nl_end)
		indent()

	out("]")



def code_to_char(cc):
	if cc < 0x20:
		if cc == 0x07: return "\\a" # bell
		elif cc == 0x08: return "\\b" # backspace
		elif cc == 0x09: return "\\t" # horizontal tab
		elif cc == 0x0A: return "\\n" # line feed
		elif cc == 0x0B: return "\\v" # vertical tab
		elif cc == 0x0C: return "\\f" # form feed
		elif cc == 0x0D: return "\\r" # carriage return
		elif cc == 0x1B: return "\\e" # escape
		else: return "\\x%X" % cc

	elif cc <= 0x7E :
		sym = chr(cc)
		if sym == '\\': return '\\\\'
		elif sym == '"': return '\\"'
		else: return sym

	elif cc != 0:
		return chr(cc)


# print Array of Char literal
def print_value_str(x, ctx):
	asset = x.asset

	char_codes = []
	i = 0
	while i < len(x.asset):
		cc = x.asset[i].asset
		char_codes.append(cc)
		i = i + 1
	print_str_literal(char_codes)


# print value with type String
def print_strx(string):
	char_codes = []
	for c in string.asset:
		cc = ord(c)
		char_codes.append(cc)
	print_str_literal(char_codes)


# print Array of Char codes literal
def print_str_literal(char_codes):
	out("\"")
	for cc in char_codes:
		out(code_to_char(cc))
	out("\"")


# print Record literal
def print_value_record(v, ctx):
	multiline = not 'oneline' in ctx

	out("{")

	indent_up()

	nitems = len(v.items)
	i = 0
	while i < nitems:
		item = v.type.fields[i]
		field_str = get_id_str(item)

		ini = get_item_by_id(v.items, field_str)

		nl = ini.nl
		if nl > 0:
			newline(nl)
			indent()
		else:
			if i > 0:
				out(" ")

		out("%s = " % field_str)
		print_value(ini.value, ctx)

		if nl == 0:
			if i < (nitems - 1):
				out(",")

		i = i + 1

	indent_down()

	if v.nl_end > 0:
		newline(v.nl_end)
		indent()

	out("}")


# print Bool literal
def print_value_bool_create(x, ctx):
	if x.asset:
		out('true')
	else:
		out('false')


# print Char literal
def print_value_char_create(x, ctx):
	num = x.asset
	if num >= 0x20:
		out("\"%s\"" % chr(num))
	else:
		out("\"\\x%x\"" % num)


# print Int literal
def print_value_integer(x, ctx):
	num = x.asset

	nsigns = 0
	if hasattr(x, 'nsigns'):
		nsigns = x.nsigns

	spec = 'd'
	pre = ''
	if x.hasAttribute('hexadecimal'):
		spec = 'X'
		pre = '0x'

	fmt = "%s%%0%d%s" % (pre, nsigns, spec)
	out(fmt % num)



# print Float literal
def print_value_float(x, ctx):
	out('{0:f}'.format(x.asset))



# print Pointer literal
def print_value_ptr(x, ctx):
	if x.asset == 0:
		out("nil")
	else:
		print_type(x['type'])
		out(" 0x%08X" % x.asset)


# print Zero literal
def print_ValueZero(x, ctx):
	t = x.type
	if Type.is_array(t): out("[]")
	elif Type.is_record(t): out("{}")
	else: out("0")


def print_value_enum(x, ctx):
	print_id_for(x)


def print_value_by_id(x, ctx):
	print_id_for(x)



# Сделал отдельный метод печати строк и есть отдельный для печати
def print_value_string(x, ctx):
	char_codes = []
	for char in x.asset:
		cc = ord(char)
		char_codes.append(cc)
	print_str_literal(char_codes)


def print_value_literal(x, ctx):
	t = x.type
	if Type.is_number(t): print_value_integer(x, ctx)
	elif Type.is_integer(t): print_value_integer(x, ctx)
	elif Type.is_float(t): print_value_float(x, ctx)
	elif Type.is_string(t): print_value_string(x, ctx)
	elif Type.is_record(t): print_value_record(x, ctx)
	elif Type.is_array(t): print_value_array(x, ctx)
	elif Type.is_pointer(t): print_value_ptr(x, ctx)
	elif Type.is_bool(t): print_value_bool_create(x, ctx)
	elif Type.is_char(t): print_value_char_create(x, ctx)
	elif Type.is_enum(t): print_value_integer(x, ctx)
	#elif Type.is_byte(t): print_value_integer(x, ctx)
	return


def print_value_sizeof_value(x, ctx):
	out("sizeof ")
	print_value(x.of)


def print_value_sizeof_type(x, ctx):
	out("sizeof(")
	print_type(x.of)
	out(")")


def print_value_alignof(x, ctx):
	out("alignof(")
	print_type(x.of)
	out(")")

def print_value_lengthof(x, ctx):
	out("lengthof(")
	print_value(x.value)
	out(")")

def print_value_offsetof(x, ctx):
	out("offsetof(")
	print_type(x.of)
	out('.%s' % x.field.str)
	out(")")

def print_value_va_start(x, ctx):
	out("__va_start(")
	print_value(x.va_list)
	out(", ")
	print_value(x.last_param)
	out(")")


def print_value_va_arg(x, ctx):
	out("__va_arg(")
	print_value(x.va_list)
	out(", ")
	print_type(x.type)
	out(")")


def print_value_va_end(x, ctx):
	out("__va_end(")
	print_value(x.va_list)
	out(")")


def print_value_va_copy(x, ctx):
	out("__va_copy(")
	print_value(x.dst)
	out(", ")
	print_value(x.src)
	out(")")


def print_value(x, ctx=[], parent_expr=None, print_just_id=True):

	need_wrap = False
	if parent_expr != None:
		need_wrap = precedence(x) < precedence(parent_expr)

	assert(isinstance(x, Value))

	if need_wrap:
		out("(")

	if isinstance(x, ValueLiteral): print_value_literal(x, ctx)
	elif isinstance(x, ValueBin): print_value_bin(x, ctx)
	elif isinstance(x, ValueShl): print_value_shl(x, ctx)
	elif isinstance(x, ValueShr): print_value_shr(x, ctx)
	elif isinstance(x, ValueUn): print_value_un(x, ctx)
	elif isinstance(x, ValueRef): print_value_ref(x, ctx)
	elif isinstance(x, ValueDeref): print_value_deref(x, ctx)
	elif isinstance(x, ValueConst): print_value_by_id(x, ctx)
	elif isinstance(x, ValueFunc): print_value_by_id(x, ctx)
	elif isinstance(x, ValueVar): print_value_by_id(x, ctx)
	elif isinstance(x, ValueCons): print_value_cons(x, ctx)
	elif isinstance(x, ValueCall): print_ValueCall(x, ctx)
	elif isinstance(x, ValueIndex): print_value_index(x, ctx)
	elif isinstance(x, ValueAccessRecord): print_value_access(x, ctx)
	elif isinstance(x, ValueAccessModule): print_value_access_module(x, ctx)
	elif isinstance(x, ValueSlice): print_value_slice(x, ctx)
	elif isinstance(x, ValueSizeofValue): print_value_sizeof_value(x, ctx)
	elif isinstance(x, ValueSizeofType): print_value_sizeof_type(x, ctx)
	elif isinstance(x, ValueAlignof): print_value_alignof(x, ctx)
	elif isinstance(x, ValueOffsetof): print_value_offsetof(x, ctx)
	elif isinstance(x, ValueLengthof): print_value_lengthof(x, ctx)
	elif isinstance(x, ValueVaArg): print_value_va_arg(x, ctx)
	elif isinstance(x, ValueVaStart): print_value_va_start(x, ctx)
	elif isinstance(x, ValueVaEnd): print_value_va_end(x, ctx)
	elif isinstance(x, ValueVaCopy): print_value_va_copy(x, ctx)
	elif isinstance(x, ValueUndefined): out("/*U*/")
	else: out("<%s>" % 'k')

	if need_wrap:
		out(")")



def print_stmt_type(x):
	out("type ")
	print_id_for(x)
	out(" ")
	print_type(x.original_type)


def print_stmt_const(x, operator='const'):
	out("%s " % operator)
	print_id_for(x)
	out(" = ")
	print_value(x.init_value, print_just_id=False)


def print_stmt_var(x):
	out("var ")
	print_id_for(x.value)
	out(": ")
	print_type(x.value.type)
	iv = x.init_value
	if not Value.isUndefined(iv):
		out(" = ")
		print_value(iv)


def print_stmt_func(x):
	if x.stmt == None:
		return
	func = x.value
	ft = func.type
	out('func ')
	print_id_for(func)
	print_type_func(ft, extra_args=ft.extra_args)
	print_stmt_block(x.stmt)


def print_stmt_block(s):
	out(" {")
	indent_up()
	for stmt in s.stmts:
		print_stmt(stmt)
	indent_down()
	nl_indent(s.nl_end)
	out("}")


def print_stmt_if(x):
	out("if ")
	print_value(x.cond)
	print_stmt_block(x.then)

	e = x.els
	if e != None:
		if isinstance(e, StmtIf):
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
	print_list_by(args, print_asm_pair)
	out(']')


def print_stmt_asm(x):
	out('__asm(')
	print_strx(x.text)

	if len(x.outputs) > 0:
		out(', ')
		print_asm_pairs(x.outputs)

	if len(x.inputs) > 0:
		out(', ')
		print_asm_pairs(x.inputs)

	if len(x.clobbers) > 0:
		out(', [')
		print_list_by(x.clobbers, print_value)
		out(']')

	out(")")
	return


def print_stmt(x):
	assert(isinstance(x, Stmt))
	nl_indent(x.nl)
	if isinstance(x, StmtBlock): print_stmt_block(x)
	elif isinstance(x, StmtValueExpression): print_stmt_value(x)
	elif isinstance(x, StmtAssign): print_stmt_assign(x)
	elif isinstance(x, StmtReturn): print_stmt_return(x)
	elif isinstance(x, StmtIf): print_stmt_if(x)
	elif isinstance(x, StmtWhile): print_stmt_while(x)
	elif isinstance(x, StmtDefVar): print_stmt_var(x)
	elif isinstance(x, StmtDefConst): print_stmt_const(x, operator='let')
	elif isinstance(x, StmtBreak): print_stmt_break(x)
	elif isinstance(x, StmtAgain): print_stmt_again(x)
	elif isinstance(x, StmtComment): print_stmt_comment(x)
	elif isinstance(x, StmtAsm): print_stmt_asm(x)
	else: lo("<stmt %s>" % str(x))



def print_import(x):
	if not x.include:
		out("import \"%s\"" % x.impline)
	else:
		out("include \"%s\"" % x.impline)



def print_directive(x):
	if isinstance(x, StmtDirectiveImport):
		print_import(x)
	elif isinstance(x, StmtDirectiveCInclude):
		out("@c_include \"%s\"" % x.c_name)



def printTopLevelStmt(x):
	assert(isinstance(x, Stmt))

	newline(n=x.nl)

	if isinstance(x, StmtDef):
		if x.access_level == 'public':
			out("public ")

	if isinstance(x, StmtDefVar): print_stmt_var(x)
	elif isinstance(x, StmtDefConst): print_stmt_const(x)
	elif isinstance(x, StmtDefFunc): print_stmt_func(x)
	elif isinstance(x, StmtDefType): print_stmt_type(x)
	elif isinstance(x, StmtComment): print_stmt_comment(x)
	elif isinstance(x, StmtDirective): print_directive(x)



def run(module, outname, options):
	output_open(outname + '.m')
	for x in module.defs:
		printTopLevelStmt(x)
	out("\n\n")
	output_close()



