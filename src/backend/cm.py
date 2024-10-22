
import hlir.type as hlir_type
from error import info
from .common import *
from value.value import value_is_zero, value_is_immediate, value_attribute_check, value_print
from util import get_item_with_id


INDENT_SYMBOL = "\t"


def init():
	pass


def newline(n=1):
	nl_str = '\n'
	out(nl_str * n)


def indent():
	ind(INDENT_SYMBOL)


def nl_indent(nl=1):
	newline(nl)
	if nl > 0:
		indent()


def get_id_str(x):
	id_str = ""
	if not 'cm' in x:
		id_str = x['id']['str']
	else:
		id_str = x['id']['cm']
	return id_str


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
	['positive', 'negative', 'not', 'cons', 'ref', 'deref', 'sizeof', 'alignof', 'offsetof', 'lengthof'], #10
	['call', 'index', 'access', 'access_module', 'slice'], #11
	['num', 'var', 'func', 'str', 'enum', 'record', 'array'] #12
]

precedenceMax = len(aprecedence) - 1

# приоритет операции
def precedence(x):
	k = x['kind']

	i = 0
	while i < precedenceMax + 1:
		if k in aprecedence[i]:
			break
		i = i + 1

	return i



def print_id(x):
	out(get_id_str(x))


def print_comment(x):
	k = x['kind']
	if k == 'line':
		print_comment_line(x)
	elif k == 'block':
		print_comment_block(x)


def print_comment_block(x):
	nl_indent(x['nl'])
	out("/*%s*/" % x['text'])


def print_comment_line(x):
	newline(x['nl'])
	lines = x['lines']
	i = 0
	n = len(lines)
	while i < n:
		line = lines[i]
		indent()
		out("//%s" % line['str'])
		i = i + 1
		if i < n:
			newline()



def print_type_integer(t):
	out(get_type_id(t))


def print_type_array(t):
	out("[")
	if t['volume'] != None:
		print_value(t['volume'])
	out("]")
	print_type(t['of'])


def print_type_pointer(t):
	if hlir_type.type_is_free_pointer(t):
		out("Ptr")
	else:
		out("*"); print_type(t['to'])


def print_field(x):
	print_id(x)
	out(": ")
	print_type(x['type'])


def print_type_record(t):
	out("record {")
	indent_up()

	prev_nl = 1
	for field in t['fields']:
		if prev_nl == 0:
			out(", ")

		# print comments
		if 'comments' in field:
			for comment in field['comments']:
				newline(comment['nl'])
				print_comment(comment)

		nl_indent(field['nl'])
		prev_nl = field['nl']
		print_field(field)

	indent_down()
	nl_indent(t['end_nl'])
	out("}")


def print_type_enum(t):
	out("enum {")
	items = t['items']
	i = 0
	while i < len(items):
		item = items[i]
		out(NL_INDENT)
		print_id(item)
		i = i + 1
	out("\n}")


def print_type_func(t, extra_args=False):
	out('(')
	fields = t['params']
	i = 0
	n = len(fields)
	while i < n:
		if i > 0: out(", ")
		print_field(fields[i])
		i = i + 1

	if extra_args:
		#out(", va_list: VA_List")
		out(", ...")

	out(') -> ')
	print_type(t['to'])


def get_type_id(t):
	if 'id' in t:
		if 'cm' in t['id']:
			return t['cm']
		return t['id']['str']

	return None


def print_type(t):
	k = t['kind']

	# Если тип связан с идентификатором - распечатаем его
	id_str = get_type_id(t)
	if id_str != None:
		out(id_str)
		return

	# Если у типа нет связанного идентификатора
	# распечатаем полное выражение типа
	if hlir_type.type_is_integer(t): print_type_integer(t)
	elif hlir_type.type_is_func(t): print_type_func(t)
	elif hlir_type.type_is_array(t): print_type_array(t)
	elif hlir_type.type_is_record(t): print_type_record(t)
	elif hlir_type.type_is_enum(t): print_type_enum(t)
	elif hlir_type.type_is_pointer(t): print_type_pointer(t)
	elif k == 'undefined': pass
	else: out("<type:" + str(t) + ">")



bin_ops = {
	'or': 'or', 'xor': 'xor', 'and': 'and', 'shl': '<<', 'shr': '>>',
	'eq': '==', 'ne': '!=', 'lt': '<', 'gt': '>', 'le': '<=', 'ge': '>=',
	'add': '+', 'sub': '-', 'mul': '*', 'div': '/', 'rem': '%',
	'logic_and': 'and', 'logic_or': 'or'
}

def print_value_bin(x, ctx):
	op = x['kind']
	left = x['left']
	right = x['right']

	need_wrap_left = precedence(left) < precedence(x)
	need_wrap_right = precedence(right) < precedence(x)

	print_value(left, need_wrap=need_wrap_left)
	out(' %s ' % bin_ops[op])
	print_value(right, need_wrap=need_wrap_right)



un_ops = {
	'ref': '&', 'deref': '*',
	'positive': '+', 'negative': '-',
	'not': 'not', 'logic_not': 'not'
}


def print_value_un(v, ctx):
	op = v['kind']
	value = v['value']
	need_wrap = precedence(value) < precedence({'kind': op})
	out(un_ops[op]); print_value(value, need_wrap=need_wrap)


def print_value_call(v, ctx):
	print_value(v['func'])
	out("(")
	i = 0
	args = v['args']
	n = len(args)
	while i < n:
		arg = args[i]
		if i > 0: out(", ")

		if arg['isa'] == 'value':
			# just paramter value
			print_value(arg)
		else: #if arg['isa'] == 'initializer':
			# named parameter
			out("%s = " % get_id_str(arg))
			print_value(arg['value'])

		i = i + 1
	out(")")


def print_value_index(v, ctx):
	array = v['array']
	need_wrap = precedence(array) < precedence({'kind': 'index'})
	print_value(array, need_wrap=need_wrap)
	out("["); print_value(v['index']); out("]")


def print_value_slice(x, ctx):
	left = x['left']
	need_wrap = precedence(left) < precedence({'kind': 'index'})
	print_value(left, need_wrap=need_wrap)
	out("[")
	print_value(x['index_from'])
	out(":")
	if x['index_to'] != None:
		print_value(x['index_to'])
	out("]")


def print_value_access(v, ctx):
	left = v['record']
	need_wrap = precedence(left) < precedence({'kind': 'access'})
	print_value(left, need_wrap=need_wrap)
	out(".")
	print_id(v['field'])


def print_value_access_module(v, ctx):
	left = v['left']
	id_str = get_id_str(v['right'])
	out("%s.%s" % (left['id'], id_str))


def print_cast(t, v, ctx=[]):
	need_wrap = precedence(v) < precedence({'kind': 'cons'})
	print_type(t)
	out(" ")
	print_value(v, ctx=ctx, need_wrap=need_wrap)


def print_value_cons(v, ctx):
	value = v['value']
	from_type = value['type']
	to_type = v['type']

	if v['method'] == 'implicit':
		print_value(value)
		return

	# NO need cast ptr to *void
	if hlir_type.type_is_pointer(from_type):
		if hlir_type.type_is_free_pointer(to_type):
			print_value(v['value'])
			return

	# NO need cast *void to ptr
	if hlir_type.type_is_free_pointer(from_type):
		if hlir_type.type_is_pointer(to_type):
			print_value(v['value'])
			return

	print_cast(v['type'], v['value'], ctx)



def is_zero_tail(values, i, n):
	# если это значание - zero, проверим все остальные справа
	# и если они тоже zero - их можно не печатать (zero tail)
	# ex: {'a', 'b', '\0', '\0', '\0'} -> {'a', 'b', '\0'}
	while i < n:
		v = values[i]
		if not value_is_zero(v):
			return False
		i = i + 1
	return True


# print Array literal
def print_value_array(v, ctx):

	#?
	if hlir_type.type_is_array_of_char(v['type']):
		print_value_str(v, ctx=[])
		return

	out("[")
	indent_up()

	values = v['asset']
	i = 0
	n = len(values)
	while i < n:
		a = values[i]

		if value_is_zero(a):
			if is_zero_tail(values, i, n):
				break

		nl = 0
		if 'nl' in a:
			nl = a['nl']

		if nl > 0:
			newline(nl)
			indent()
		else:
			if i > 0:
				out(', ')

		print_value(a, ctx=ctx)

		i = i + 1


	indent_down()

	if v['nl_end'] > 0:
		newline(v['nl_end'])
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
	asset = x['asset']

	char_codes = []
	i = 0
	while i < len(x['asset']):
		cc = x['asset'][i]['asset']
		char_codes.append(cc)
		i = i + 1
	print_str_literal(char_codes)


# print value with type String
def print_strx(string):
	char_codes = []
	for c in string['asset']:
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

	initializers = v['fields']
	nitems = len(initializers)
	i = 0
	while i < nitems:
		item = v['type']['fields'][i]
		field_str = get_id_str(item)

		ini = get_item_with_id(initializers, field_str)

		nl = 0
		if 'nl' in ini:
			nl = ini['nl']

		if nl > 0:
			newline(nl)
			indent()
		else:
			if i > 0:
				out(" ")

		out("%s = " % field_str)
		print_value(ini['value'], ctx)

		if nl == 0:
			if i < (nitems - 1):
				out(",")

		i = i + 1

	indent_down()

	if v['nl_end'] > 0:
		newline(v['nl_end'])
		indent()

	out("}")


# print Bool literal
def print_value_bool_create(x, ctx):
	if x['asset']:
		out('true')
	else:
		out('false')


# print Char literal
def print_value_char_create(x, ctx):
	num = x['asset']
	if num >= 0x20:
		out("\"%s\"" % chr(num))
	else:
		out("\"\\x%x\"" % num)


# print Int literal
def print_value_integer(x, ctx):
	num = x['asset']

	nsigns = 0
	if 'nsigns' in x:
		nsigns = x['nsigns']

	spec = 'd'
	pre = ''
	if value_attribute_check(x, 'hexadecimal'):
		spec = 'X'
		pre = '0x'

	fmt = "%s%%0%d%s" % (pre, nsigns, spec)
	out(fmt % num)



# print Float literal
def print_value_float(x, ctx):
	out('{0:f}'.format(x['asset']))



# print Pointer literal
def print_value_ptr(x, ctx):
	if x['asset'] == 0:
		out("nil")
	else:
		print_type(x['type'])
		out(" 0x%08X" % x['asset'])


# print Zero literal
def print_value_zero(x, ctx):
	t = x['type']
	if hlir_type.type_is_array(t): out("[]")
	elif hlir_type.type_is_record(t): out("{}")
	else: out("0")


def print_value_enum(x, ctx):
	print_id(x)


def print_value_by_id(x, ctx):
	print_id(x)



# Сделал отдельный метод печати строк и есть отдельный для печати
def print_value_string2(x, ctx):
	char_codes = []
	for char in x['asset']:
		cc = ord(char)
		char_codes.append(cc)
	print_str_literal(char_codes)


def print_value_terminal(x, ctx):
	t = x['type']
	if hlir_type.type_is_integer(t): print_value_integer(x, ctx)
	elif hlir_type.type_is_float(t): print_value_float(x, ctx)
	elif hlir_type.type_is_string(t): print_value_string2(x, ctx)
	elif hlir_type.type_is_record(t): print_value_record(x, ctx)
	elif hlir_type.type_is_array(t): print_value_array(x, ctx)
	elif hlir_type.type_is_pointer(t): print_value_ptr(x, ctx)
	elif hlir_type.type_is_bool(t): print_value_bool_create(x, ctx)
	elif hlir_type.type_is_char(t): print_value_char_create(x, ctx)
	elif hlir_type.type_is_enum(t): print_value_integer(x, ctx)
	elif hlir_type.type_is_byte(t): print_value_integer(x, ctx)
	return


def print_value_sizeof_value(x, ctx):
	out("sizeof ")
	print_value(x['of'])

def print_value_sizeof_type(x, ctx):
	out("sizeof(")
	print_type(x['of'])
	out(")")


def print_value_alignof(x, ctx):
	out("alignof(")
	print_type(x['of'])
	out(")")

def print_value_lengthof(x, ctx):
	out("lengthof(")
	print_value(x['value'])
	out(")")

def print_value_offsetof(x, ctx):
	out("offsetof(")
	print_type(x['of'])
	out('.%s' % x['field']['str'])
	out(")")

def print_value_va_start(x, ctx):
	out("__va_start(")
	print_value(x['va_list'])
	out(", ")
	print_value(x['last_param'])
	out(")")


def print_value_va_arg(x, ctx):
	out("__va_arg(")
	print_value(x['va_list'])
	out(", ")
	print_type(x['type'])
	out(")")


def print_value_va_end(x, ctx):
	out("__va_end(")
	print_value(x['va_list'])
	out(")")


def print_value_va_copy(x, ctx):
	out("__va_copy(")
	print_value(x['dst'])
	out(", ")
	print_value(x['src'])
	out(")")


def print_value(x, ctx=[], need_wrap=False, print_just_id=True):
	if need_wrap:
		out("(")

	k = x['kind']

	if k == 'literal': print_value_terminal(x, ctx)
	elif k in bin_ops: print_value_bin(x, ctx)
	elif k in un_ops: print_value_un(x, ctx)
	elif k in ['const', 'func', 'var']: print_value_by_id(x, ctx)
	elif k == 'cons': print_value_cons(x, ctx)
	elif k == 'call': print_value_call(x, ctx)
	elif k == 'index': print_value_index(x, ctx)
	elif k == 'access': print_value_access(x, ctx)
	elif k == 'access_module': print_value_access_module(x, ctx)
	elif k == 'slice': print_value_slice(x, ctx)
	elif k == 'sizeof_value': print_value_sizeof_value(x, ctx)
	elif k == 'sizeof_type': print_value_sizeof_type(x, ctx)
	elif k == 'alignof': print_value_alignof(x, ctx)
	elif k == 'offsetof': print_value_offsetof(x, ctx)
	elif k == 'lengthof': print_value_lengthof(x, ctx)
	elif k == 'va_arg': print_value_va_arg(x, ctx)
	elif k == 'va_start': print_value_va_start(x, ctx)
	elif k == 'va_end': print_value_va_end(x, ctx)
	elif k == 'va_copy': print_value_va_copy(x, ctx)
	else: out("<%s>" % k)

	if need_wrap:
		out(")")



def print_stmt_if(x):
	out("if ")
	print_value(x['cond'])
	print_stmt_block(x['then'])

	e = x['else']
	if e != None:
		if e['kind'] == 'if':
			out(" else ")
			print_stmt_if(e)
		else:
			out(" else")
			print_stmt_block(e)


def print_stmt_while(x):
	out("while ")
	print_value(x['cond'])
	print_stmt_block(x['stmt'])


def print_stmt_return(x):
	out("return")
	if x['value'] != None:
		out(" ")
		print_value(x['value'])


def print_stmt_var(x):
	init_value = x['init_value']
	out('var ')

	print_field(x['var'])

	if init_value != None:
		out(" = ")
		print_value(init_value)


def print_stmt_let(x):
	out("let ")
	print_id(x)
	out(" = ")
	print_value(x['init_value'], print_just_id=False)


def print_stmt_assign(x):
	print_value(x['left'])
	out(" = ")
	print_value(x['right'])

	if hlir_type.type_is_array(x['right']['type']):
		if value_is_zero(x['right']):
			out("  // right size = %d" % x['right']['type']['size'])


def print_stmt_value(x):
	print_value(x['value'])


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
	print_strx(x['text'])

	# print 'out' pairs
	if len(x['outputs']) > 0:
		out(', ')
		print_asm_pairs(x['outputs'])

	# print 'in' pairs
	if len(x['inputs']) > 0:
		out(', ')
		print_asm_pairs(x['inputs'])

	# print clobber list
	if len(x['clobbers']) > 0:
		out(', [')
		print_list_by(x['clobbers'], print_value)
		out(']')

	out(")")
	return


def print_stmt(x):
	k = x['kind']

	if not k in ['block', 'comment-line', 'comment-block']:
		nl_indent(x['nl'])

	if k == 'block': print_stmt_block(x)
	elif k == 'value': print_stmt_value(x)
	elif k == 'assign': print_stmt_assign(x)
	elif k == 'return': print_stmt_return(x)
	elif k == 'if': print_stmt_if(x)
	elif k == 'while': print_stmt_while(x)
	elif k == 'var': print_stmt_var(x)
	elif k == 'let': print_stmt_let(x)
	elif k == 'break': print_stmt_break(x)
	elif k == 'again': print_stmt_again(x)
	elif k == 'comment-line': print_comment_line(x)
	elif k == 'comment-block': print_comment_block(x)
	elif k == 'asm': print_stmt_asm(x)
	else: out("<stmt %s>" % str(x))



def print_stmt_block(s):
	out(" {")

	indent_up()

	for stmt in s['stmts']:
		print_stmt(stmt)

	indent_down()

	endnl = s['end_nl']
	newline(endnl)
	if endnl:
		indent()
	out("}")



"""
def print_decl_func(x):
	func = x['value']
	out('func ')
	print_id(func)
	print_type(func['type'])
"""

def print_def_func(x):
	if x['stmt'] == None:
		return
	func = x['value']
	ft = func['type']
	if x['access_level'] == 'public':
		out("public ")
	out('func ')
	print_id(func)
	print_type_func(ft, extra_args=ft['extra_args'])
	print_stmt_block(x['stmt'])


def print_decl_type(x):
	if x['access_level'] == 'public':
		out("public ")
	out("type ")
	out(get_type_id(x['type']))



def print_def_type(x):
	if x['access_level'] == 'public':
		out("public ")
	out("type ")
	print_id(x)
	out(" ")
	print_type(x['original_type'])


def print_def_var(x):
	if x['access_level'] == 'public':
		out("public ")
	out("var ")
	var = x['value']
	print_field(var)
	iv = x['init_value']
	if iv != None:
		out(" = ")
		print_value(iv)


def print_def_const(x):
	if x['access_level'] == 'public':
		out("public ")
	out("const ")
	print_id(x)
	out(" = ")
	print_value(x['init_value'], ctx=['oneline'], print_just_id=False)


def print_import(x):
	if not x['include']:
		out("import \"%s\"" % x['str'])
	else:
		out("include \"%s\"" % x['str'])


def print_directive(x):
	if x['kind'] == 'import': print_import(x)
	elif x['kind'] == 'c_include': out("@c_include \"%s\"" % x['c_name'])


def print_def(x):
	isa = x['isa']

	if isa != 'comment':
		newline(n=x['nl'])

	if isa == 'def_var': print_def_var(x)
	elif isa == 'def_const': print_def_const(x)
	elif isa == 'def_func': print_def_func(x)
	elif isa == 'def_type': print_def_type(x)
	elif isa == 'directive': print_directive(x)
	elif isa == 'comment': print_comment(x)


def run(module, outname):
	from main import features
	#is_header = features.get('header')

	output_open(outname + '.m')

	for x in module['defs_private']:
		print_def(x)

	for x in module['defs_public']:
		print_def(x)

	out("\n\n")
	output_close()



