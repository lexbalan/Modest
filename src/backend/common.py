
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



def ind(symbol):
	out(str_indent())



def print_list_by(items, method, separator=', '):
	i = 0
	while i < len(items):
		if i > 0:
			out(separator)
		item = items[i]
		method(item)
		i = i + 1




