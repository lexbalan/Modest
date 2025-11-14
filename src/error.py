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
COLOR_WARNING = BLUE #MAGENTA
COLOR_ERROR = RED


preColor = BOLD


SIMPLE_MARK = True

#
TABSTOP = 4


def getline(ti):
	file = ti.source
	start = get_ti_start(ti)
	lineno = start.line
	f = open(file, 'r')
	lin = f.read().split("\n")[lineno - 1]
	f.close()
	return lin


def left_start_pos(ti):
	#return left_start_pos(ti.start)
	return get_ti_start(ti).pos


# length of token
def tilen(ti):
	x = get_ti_end(ti)
	if isinstance(x, dict):
		print(x)
	return get_ti_end(ti).pos - get_ti_start(ti).pos


def right_end_pos(ti):
	#if 'end' in ti:
	#return right_end_pos
	return get_ti_start(ti).pos - tilen(ti)# - 1


def color_code(color):
	return '\033[%dm' % color


def colorize(text, color):
	#return '\033[%dm%s\033[0m' % (color, text)
	return color_code(color) + text + color_code(ENDC)
	return '\033[%dm%s\033[0m' % (color, text)


def mark(pos, color):
	print(" " * pos, end='')
	print(colorize('^', color))


def himark(lpos, offset, lenc, rpos, color):
	if SIMPLE_MARK:
		mark(offset, color)
		return

	llen = offset - lpos  # длина подчеркивания слева
	rlen = rpos - offset  # длина подчеркивания справа

	print(" " * lpos, end='')
	print(colorize('-' * llen, color), end='')
	print(colorize('^' * lenc, color), end='')
	print(colorize('-' * rlen, color))


def highlight(ti, color, offset):
	start = get_ti_start(ti)
	pos = start.spaces + offset
	tabpos = start.tabs
	offset = pos + start.tabs * TABSTOP

	start = left_start_pos(ti) + offset
	end = right_end_pos(ti) + offset
	himark(start, offset, tilen(ti), end - 1, color)


def get_ti_start(ti):
	return ti

def get_ti_end(ti):
	return ti



def common_message(mg, color, s, ti=None):
	pre = ''

	if ti != None:
		start = get_ti_start(ti)
		pre = '\n%s:%d:%d:\n' % (ti.source, start.line, start.pos)

	print(colorize(pre, preColor) + colorize(mg, color) + s)

	if ti != None:
		start = get_ti_start(ti)
		prelin = "%d |" % start.line
		line = getline(ti)
		line = line.replace('\t', ' ' * TABSTOP)
		print(prelin + line)
		highlight(ti, color, offset=len(prelin))




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
	if 'paranoid' in features:
		error(s, ti)
		return
	printNote(s, ti)


def info(s, ti=None):
	if 'paranoid' in features:
		printWarning(s, ti)
		return

	printInfo(s, ti)


def warning(s, ti=None):
	if 'paranoid' in features:
		error(s, ti)
		return
	printWarning(s, ti)



def printNote(s, ti):
	common_message('note: ', COLOR_NOTE, s, ti)


def printInfo(s, ti):
	if not show_info:
		return
	common_message('info: ', COLOR_INFO, s, ti)


def printWarning(s, ti):
	global warncnt
	warncnt = warncnt + 1

	common_message('warning: ', COLOR_WARNING, s, ti)


def error(s, ti=None):
	global errcnt
	errcnt = errcnt + 1
	#print(ti)
	common_message('error: ', COLOR_ERROR, s, ti)
	if errcnt >= MAX_ERRORS:
		exit(1)


def fatal(s, ti=None):
	#print('\033[91m' + 'fatal error: ' + '\033[0m' + s)
	common_message('fatal error: ', 91, s, ti)
	exit(1)

