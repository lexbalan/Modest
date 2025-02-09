
import os

f = None


indent_level = 0

def indent_up():
	global indent_level
	indent_level = indent_level + 1


def indent_down():
	global indent_level
	indent_level = indent_level - 1


def indent_str(symbol):
	global indent_level
	return symbol * indent_level


def indentation(symbol):
	global indent_level
	return symbol * indent_level


def nl_indentation(n, symbol='\t'):
	global indent_level
	return "\n" + symbol * indent_level


def ind(symbol):
	f.write(indentation(symbol))



def out(s):
	global f
	f.write(str(s))


def output_open(fname):
	global f
	dirname = os.path.dirname(fname)
	if dirname != '':
		os.makedirs(dirname, exist_ok=True)
	f = open(fname, "w")


def output_close():
	global f
	f.close()


def print_list_by(items, method, separator=', '):
	i = 0
	while i < len(items):
		if i > 0:
			out(separator)
		item = items[i]
		method(item)
		i = i + 1




