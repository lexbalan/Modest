# error.py

from common import features
from hlir import TokenInfo

warncnt = 0
errcnt = 0


MAX_ERRORS = 10

verbose_mode = False
show_info = True


ENDC = 0
BOLD = 1
RED = 91
GREEN = 92
YELLOW = 93
BLUE = 94
MAGENTA = 95
CYAN = 96


COLOR_NOTE = BOLD
COLOR_INFO = CYAN
COLOR_WARNING = BLUE
COLOR_ERROR = RED


TABSTOP = 4




def read_line(file, offset):
	f = open(file, 'r')
	f.seek(offset)
	s = ''
	while True:
		c = f.read(1)
		if c == '\n' or c == None:
			break
		s += c
	f.close()
	return s




def color_code(color):
	return '\033[%dm' % color


def colorize(text, color):
	#return '\033[%dm%s\033[0m' % (color, text)
	return color_code(color) + text + color_code(ENDC)
	return '\033[%dm%s\033[0m' % (color, text)


def mark(pos, len, color):
	print(" " * pos, end='')
	print(colorize('^'*len, color))


def highlight(ti, color, offset):
	offset += ti.spaces + ti.tabs * TABSTOP
	length = 1 #ti.length
	mark(offset, length, color)


def print_common_message(mg, color, s, ti):
	pre = ''

	if ti != None:
		npos = ti.spaces + ti.tabs
		pre = '\n%s:%d:%d:\n' % (ti.source, ti.line, npos)

	print(colorize(pre, BOLD) + colorize(mg, color) + s)

	if ti != None:
		margin = "%d |" % ti.line
		line = read_line(ti.source, ti.fpos)
		line = line.replace('\t', ' ' * TABSTOP)
		print(margin + line)
		highlight(ti, color, offset=len(margin))



log_ind = 0
def log_push():
	global log_ind
	log_ind = log_ind + 1

def log_pop():
	global log_ind
	log_ind = log_ind - 1

def log(s):
	global log_ind
	if verbose_mode:
		print(('  ' * log_ind) + s)



def note(s, ti=None):
	print_common_message('note: ', COLOR_NOTE, s, ti)


def info(s, ti=None):
	if 'paranoid' in features:
		printWarning(s, ti)
		return
	if not show_info:
		return
	print_common_message('info: ', COLOR_INFO, s, ti)


def warning(s, ti=None):
	if 'paranoid' in features:
		error(s, ti)
		return
	global warncnt
	warncnt = warncnt + 1
	print_common_message('warning: ', COLOR_WARNING, s, ti)


def error(s, ti=None):
	global errcnt
	errcnt = errcnt + 1
	print_common_message('error: ', COLOR_ERROR, s, ti)
	if errcnt >= MAX_ERRORS:
		exit(1)


def fatal(s, ti=None):
	print_common_message('fatal error: ', 91, s, ti)
	exit(1)


